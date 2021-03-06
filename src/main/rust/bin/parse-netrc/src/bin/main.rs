// -*- rust -*-

// SPDX-FileCopyrightText: <text> © 2020, 2021 Alan D. Salewski <ads@salewski.email> </text>
// SPDX-License-Identifier: GPL-2.0-or-later
//
//     This program is free software; you can redistribute it and/or modify
//     it under the terms of the GNU General Public License as published by
//     the Free Software Foundation; either version 2 of the License, or
//     (at your option) any later version.
//
//     This program is distributed in the hope that it will be useful,
//     but WITHOUT ANY WARRANTY; without even the implied warranty of
//     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//     GNU General Public License for more details.
//
//     You should have received a copy of the GNU General Public License
//     along with this program; if not, write to the Free Software Foundation,
//     Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301,, USA.

//! parse-netrc: command line program to extract ~/.netrc bits
//!
//! The current behavior is limited to emitting just the username for the
//! first matching netrc record found (because that was the itch the author
//! needed to scratch). Could be adapted to extract the other record fields,
//! if needed.
//!
//! Limitations
//! -----------
//! The current implementation has a dependency on version 0.4.1 of the
//! [`netrc`] library. This version of the library is not able to correctly
//! parse all valid netrc files. The aspect of this most likely to affect most
//! users is that it chokes on comments. It is the intent of the `parse-netrc`
//! author to submit a patch to correct that behavior when time permits.
//!
//! [netrc]:     https://crates.io/crates/netrc  "netrc (crates.io)"
//! [netrc-doc]: http://yuhta.github.io/netrc-rs/doc/netrc/index.html
//! [netrc-gh]:  https://github.com/Yuhta/netrc-rs

use std::env;
use std::error;
use std::fmt;
use std::fs::File;
use std::io;
use std::io::BufReader;
use std::path::PathBuf;
use std::process;
use std::string::String;
use std::vec::Vec;

// https://docs.rs/home/0.5.3/home/index.html
// https://github.com/brson/home
use home;

// https://docs.rs/netrc/0.4.1/netrc/index.html
// https://github.com/Yuhta/netrc-rs
use netrc::Netrc;

// Our internal app-specific 'parse_netrc' library.
//
// XXX: Consider moving more of the application logic to the library to allow
//      for easier unit- and integration testing.
use parse_netrc::{
    bld_date,     // bld_date!() macro
    bld_version,  // bld_version!() macro
    configure_time::MAINTAINER,
};

const PROG: &str = "parse-netrc";

const COPYRIGHT_DATES: &str = "2020, 2021";

static RELEASE: &str = concat!(bld_version!(), "  (built: ", bld_date!(), ")");


// These two always emit their message:
//
macro_rules! pr_error   { ($($tts:tt)*) => { eprintln!("{} (error): {}",   PROG, format!($($tts)*)); } }
// macro_rules! pr_warning { ($($tts:tt)*) => { eprintln!("{} (warning): {}", PROG, format!($($tts)*)); } }
//
// These three conditionally emit their message:
//
macro_rules! pr_info  { ($($tts:tt)*) => {
    if BE_VERBOSE() { eprintln!("{} (info):  {}", PROG, format!($($tts)*)); }  // -v
}}
macro_rules! pr_debug { ($($tts:tt)*) => {
    // if DEBUGGING()  { eprintln!("{} (debug): {}", PROG, format!($($tts)*)); }  // -vv
    if DEBUGGING()  { eprintln!("{} (debug): [{}:{}]: {}", PROG, file!(), line!(), format!($($tts)*)); }  // -vv
}}
macro_rules! pr_trace { ($($tts:tt)*) => {
    if TRACING()    { eprintln!("{} (trace): [{}:{}]: {}", PROG, file!(), line!(), format!($($tts)*)); }  // -vvv
}}


#[allow(non_snake_case)]
mod GLOBAL {
    #[allow(non_upper_case_globals)]
    static mut be_verbose_val: bool = false;

    #[allow(non_snake_case)]
    pub fn BE_VERBOSE() -> bool         { unsafe { be_verbose_val } }
    #[allow(non_snake_case)]
    pub fn BE_VERBOSE_set(newval: bool) { unsafe { be_verbose_val = newval /*copy*/ } }

    #[allow(non_upper_case_globals)]
    static mut debugging_val: bool = false;

    #[allow(non_snake_case)]
    pub fn DEBUGGING() -> bool         { unsafe { debugging_val } }
    #[allow(non_snake_case)]
    pub fn DEBUGGING_set(newval: bool) { unsafe { debugging_val = newval /*copy*/ } }

    #[allow(non_upper_case_globals)]
    static mut tracing_val: bool = false;

    #[allow(non_snake_case)]
    pub fn TRACING() -> bool         { unsafe { tracing_val } }
    #[allow(non_snake_case)]
    pub fn TRACING_set(newval: bool) { unsafe { tracing_val = newval /*copy*/ } }
}
use GLOBAL::*;


#[derive(Debug)]
struct Config {
    hostname: String,
    username: Option<String>,
}

#[derive(Debug)]
enum CliSuccess {

    // Indicates that the essential processing for the program is complete.
    ProcessingIsComplete,

    // The command line parameters were all successfully parsed, and used to
    // populate the contained `Config` struct. This will be the common case.
    AdditionalProcessingRequired( Config ),
}


#[derive(Debug)]
enum CliError {

    // No matching netrc file record was found for the provided hostname. This
    // error is possible if only a hostname value is provided by the user.
    NoMatchingNetrcRecord1{ hostname: String },

    // No matching netrc file record was found for the provided hostname and
    // username. This error is possible only when both a hostname and username
    // value are provided by the user.
    NoMatchingNetrcRecord2{ hostname: String, username: String },

    // Indicates a problem with one or more of the command line arguments.
    //
    // When a `BadArgs` error bubbles-up, the provided error message will be
    // displayed (on stderr), and then program's help message will be emitted
    // on stderr, as well.
    BadArgs(String),

    // Arbitrary error message
    Msg(String),

    // Raw io::Error. Allows auto-conversion via the `From` trait.
    IoError(io::Error),

    // io::Error, "wrapped" -- allows a context message to be provided for the
    // location at which the error is being wrapped.
    IoErrorW(String, io::Error),

    // Wraps any netrc::Error emitted by the underlying 'netrc' library. The
    // string member is our app-specific error message, and the netrc::Error
    // member is the wrapped error (the cause).
    NetrcError(String, netrc::Error),
}


impl error::Error for CliError {}

impl fmt::Display for CliError {
    fn fmt(&self, ff: &mut fmt::Formatter<'_>) -> fmt::Result {

        match self {
            CliError::NoMatchingNetrcRecord1{ hostname } =>
                write!(ff, "No matching netrc record found for machine: \"{}\"", &hostname),

            CliError::NoMatchingNetrcRecord2{ hostname , username } =>
                write!(ff, "No matching netrc record found for machine: \"{}\" and user: \"{}\"",
                       &hostname, &username),

              CliError::BadArgs(msg)
            | CliError::Msg(msg) =>
                // We will let the error message speak for itself
                write!(ff, "{}", msg),

            CliError::IoError(err) =>
                write!(ff, "I/O error: {}", err ),

            CliError::IoErrorW(msg, err) =>
                write!(ff, "{}\n    Wrapped I/O error: {}", msg, err ),

            // Produces messages like this:
            // <quote>
            //     parse-netrc (error): Was unable to parse the user's netrc file: "/home/someuser/.netrc-BUSTED"
            //         Wrapped netrc::Error: Parse("Unknown entry `this\'", 1)
            // </quote>
            CliError::NetrcError(msg, err) =>
                write!(ff, "{}\n    Wrapped netrc::Error: {:?}", msg, err ),
        }
    }
}

impl From<io::Error> for CliError {
    fn from(err: io::Error) -> CliError {
        CliError::IoError(err)
    }
}


fn print_help<T: io::Write>(where_to: &mut T) -> Result<(), CliError> {

    write!( where_to,
r###"usage: {} {{ -h | --help }}
  or:  {} {{ -V | --version }}
  or:  {} [OPTION...] {{ -u USER | --user=USER }} [--] HOSTNAME

Extract and print fields from matching netrc record, if any.

Mandatory arguments to long options are mandatory for short options too.

  -h, --help        Print this help message on stdout
  -V, --version     Print the version of the program on stdout
  -u, --user=USER   Require match of USER in matched netrc record
  -v, --verbose     Print program progress messages on stderr. Specify multiple
                      times to increase verbosity: info, debug, and tracing
      --            Signals the end of options and disables further options processing.
                      Any remaining argument(s) will be interpretted as a hostname

Report bugs to {}.
"###,
              PROG, PROG, PROG, MAINTAINER )?;

    Ok(())
}


fn print_version<T: io::Write>(where_to: &mut T) -> Result<(), CliError> {

    write!( where_to,
r###"{} {}

Copyright (C) {} Alan D. Salewski <ads@salewski.email>
License GPLv2+: GNU GPL version 2 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by Alan D. Salewski.
"###,
              PROG, RELEASE, COPYRIGHT_DATES)?;
    Ok(())
}


// Generate a [`str`] that represents the contents of a [`netrc::Machine`]
// that is safe to print on a user's display.
//
fn fmt_netrc_machine(machine: &netrc::Machine) -> String {
    let mut rtn = String::new();

    // Our output is deliberately structured to look similar that produced by
    // default via the netrc::Machine struct's impl for fmt::Display.
    //
    rtn.push_str("Machine { login: ");
    rtn.push_str( &(machine.login)[..] );

    rtn.push_str(", password: ");
    if let Some(_) = &machine.password {
        rtn.push_str("******");
    }
    else {
        rtn.push_str("[None]");
    }

    rtn.push_str(", account: ");
    if let Some(vv) = &machine.account {
        // rtn.push_str( &(machine.account)[..] );
        rtn.push_str( &(vv)[..] );
    }
    else {
        rtn.push_str("[None]");
    }

    rtn.push_str(", port: ");
    if let Some(vv) = &machine.port {
        rtn.push_str( &(vv.to_string())[..] );
    }
    else {
        rtn.push_str("[None]");
    }

    rtn.push_str(" }");

    return rtn;
}


// Parses the provided arguments (presumably the command line arguments
// provided to the program), sanity checks the values, and sets the
// corresponding [`GLOBAL`] flags/values as appropriate.
//
// Some command line options (such as '--help' and '--verbose') are handled as
// soon as they are observed. No further processing is done beyond that point,
// and the CliSuccess instance in our returned result will contain the
// ProcessingIsComplete variant to indicate to the caller that no further
// app-level processing should be performed.
//
// For other instances of successfully parsing the arguments, the CliSuccess
// will contain the AdditionalProcessingRequired( Config ) variant, with the
// parsed values contained therein.
//
fn parse_cli_args( args: &Vec<String>) -> Result<CliSuccess, CliError> {

    pr_trace!("entered: parse_cli_args()");
    pr_trace!("parse_cli_args(): args.len() is: {}",  args.len());

    if args.len() < 2 {
        return Err( CliError::BadArgs( format!("required HOSTNAME parameter not provided; bailing out" )));
    }

    let input_hostname: String;

    let mut input_username = String::new();  // avoid E0381
    let mut have_username = false;

    let mut skip_next_val = false;

    // The index into args of the "current" item being examined. At the end of
    // our args.iter() loop below, it will hold the index of the last
    // successfully handled command line parameter.
    //
    let mut index: i32 = -1;

    pr_trace!("index before: {}", index);

    // avoid .skip(1) -- we're tracking the real index pos
    for (idx, one_opt) in args.iter().enumerate() {

        // We're about to do a potentially unsafe cast from usize to i32, so
        // make sure the value will fit.
        if idx > ( i32::MAX as usize ) {
            return Err( CliError::BadArgs( format!( "maxium number of arguments ({}) exceeded; bailing out", i32::MAX )));
        }

        index = idx as i32;  // copy (from usize)

        pr_trace!("command line args[{}]: {}", idx, one_opt);  // may or may not be an option

        if 0 == idx { continue; }  // program name

        if skip_next_val {
            pr_trace!("args[{}] already processed as an option argument; skipping", idx);
            skip_next_val = false;
            continue;
        }

        match &one_opt[..] {

            "-h" | "--help"    => { print_help(    &mut io::stdout() )?; return Ok(CliSuccess::ProcessingIsComplete); },
            "-V" | "--version" => { print_version( &mut io::stdout() )?; return Ok(CliSuccess::ProcessingIsComplete); },

            "-u" | "--user"    => {
                if have_username {
                    return Err( CliError::BadArgs( format!( "At most one -u (--user=USER) opt may be provided" )));
                }
                input_username = match args.get( idx + 1 ) {
                    None => return Err( CliError::BadArgs( format!( "missing argument for option {}", one_opt ))),
                    Some(optarg) => {
                        pr_trace!("have username from opt: \"{}\", optarg: \"{}\"", one_opt, optarg);
                        optarg.clone()
                    }
                };
                have_username = true;
                skip_next_val = true;  // already consumed (as our optarg)
            },

            "-v" | "--verbose" => {
                // Accumulating 'verbose' opt. A single -v opt simply turns
                // BE_VERBOSE on (enables (additional) info-level messages). Two -v
                // opts turns on $DEBUGGING, which additionally enables debug-level
                // messages. Three or more '-v' opts turns $TRACING on. Note that
                // if you intend to turn tracing on, you'll probably want your -v
                // opts to be the first opts on the command line (so they take
                // effect earlier).
                if TRACING() {
                    pr_trace!("tracing already enabled; ignoring extra \"{}\" arg", one_opt);
                }
                else {
                    if DEBUGGING() {
                        // This is the third '-v' (--verbose) opt we are
                        // seeing, so now we are turning tracing on.
                        TRACING_set( true );
                        pr_trace!("trace-level output enabled");
                    }
                    else {
                        if BE_VERBOSE() {
                            // This is the second '-v' (--verbose) opt we are seeing
                            DEBUGGING_set( true );
                            pr_debug!("debug-level output enabled");
                        }
                        else {
                            // This is the first '-v' (--verbose) opt we are seeing
                            BE_VERBOSE_set( true );
                        }
                    }
                }
            },

            "--" => {
                pr_trace!("pseudo opt \"--\" found; will halt command line opts parsing");
                break;
            }

            _ => {
                if one_opt.starts_with("-") {
                    pr_trace!("Have unrecognized command line option: {}", one_opt);
                    return Err( CliError::BadArgs( format!( "unrecognized option '{}'; bailing out", one_opt )));
                }

                pr_trace!("Looking at the first non-option command line argument: \"{}\"{}",
                          one_opt,
                          "; will stop parsing the command line opts");
                index = index - 1;  // We have taken a peek at it, but this one is not yet handled
                break;
            },
        }
    }

    pr_trace!("index after: {}", index);

    // There should still be a single command line parameter for us to
    // consume: the hostname for which we are to search the netrc file.

    if -1 == index {
        // This should only be possible if the Rust runtime did not put the
        // program name in args[0], as seeing that would have bumped our index
        // value up to zero.
        //
        pr_debug!("index is -1; no command line opts were provided");
        index = 0;  // make safe for our usize comparison below
    }

    // One last cast, to allow us to avoid casting from here on out; we no
    // longer need the signed (negative) value. This cast is safe b/c index
    // here is known to be >= 0, and if greater than zero is a value set from
    // a usize above while parsing the command line opts.
    //
    let index: usize = index as usize;

    // Since index holds the value of the last successfully processed
    // (consumed) command line parameter up until this point, hn_index will
    // hold the index of "the next" index location, which should be the index
    // of our hostname parameter (if it was provided by the user).
    //
    let hn_index = index + 1;

    if hn_index >= args.len()  // hn_index is out-of-bounds for the provided list of params
    {
        return Err( CliError::BadArgs( format!( "required HOSTNAME value not provided; bailing out" )));
    }

    input_hostname = match args.get( hn_index ) {
        None => return Err( CliError::BadArgs( format!( "HOSTNAME argument not at index {}", hn_index ))),
        Some(someval) => someval.clone(),
    };
    pr_trace!("provided hostname: \"{}\"", input_hostname);

    // Complain about any remaining command line params
    //
    match args.get( hn_index + 1 ) {
        None => {},  // no extraneous command line parameters provided -- good.
        Some(ref bogon_hostname) => {
            return Err( CliError::BadArgs( format!( "Only one HOSTNAME may be provided; have \"{}\", but also got \"{}\"",
                                                     input_hostname, bogon_hostname )));
        }
    };

    let mut cfg = Config{
        hostname: input_hostname,  // move ownership
        username: None,
    };

    if have_username {
        cfg.username = Some(input_username);  // move ownership
    }

    Ok(CliSuccess::AdditionalProcessingRequired( cfg ))
}

fn run_app( args: &Vec<String>) -> Result<(), CliError> {

    pr_trace!("entered: run_app()");

    let cfg: Config = match parse_cli_args( &args ) {

        Err(err)  => return Err(err),

        Ok( CliSuccess::ProcessingIsComplete )  => return Ok(()),  // option already handled (e.g., --help)

        // still have work to do here
        Ok( CliSuccess::AdditionalProcessingRequired( config ) ) => config,
    };

    pr_debug!("Successfully parsed command line options");

    // The hostname for the "wanted" entry from the ~/.netrc file (assuming
    // such an entry exists).
    //
    let wanted_hostname = &cfg.hostname;
    pr_debug!( "wanted hostname: {}", wanted_hostname );

    if let Some(ref vv) = cfg.username {
        pr_debug!( "wanted username: {}", vv );
    }
    else {
        pr_debug!( "wanted username: [none provided (okay)]" );
    }

    pr_debug!("Attempting to locate user's home directory");
    let home_dir: PathBuf = match home::home_dir() {
        Some(path) => path,
        None => return Err( CliError::Msg( format!("was unable to obtain $HOME directory; bailing out") )),
    };
    pr_debug!("User's home directory is: {:?}", home_dir );

    {
        pr_trace!("Translating PathBuf to str (for $HOME value)");
        let home_dir_str = home_dir.to_str()
            .ok_or_else(|| CliError::Msg( format!("error translating PathBuf to str; bailing out")))?;

        if 0 == home_dir_str.len() {
            return Err( CliError::Msg( format!("HOME directory name is the empty string; bailing out")));
        }
    }

    pr_trace!("Constructing path to ~/.netrc file in user's $HOME");

    // FIXME: Make this more generic -- use libcurl as a model (support '_netrc', too, etc.).
    //
    let netrc_fpath: PathBuf = home_dir.join(".netrc");

    pr_trace!("Constructed path to ~/.netrc file in user's $HOME is: {:?}", &netrc_fpath );

    pr_debug!("Ensuring that user's ~/.netrc file exists");
    if !netrc_fpath.exists() {
        return Err( CliError::Msg( format!( "file does not exist: {:?}; bailing out", &netrc_fpath )));
    }

    pr_debug!("Ensuring that user's ~/.netrc file is a regular file");
    if !netrc_fpath.is_file() {
        return Err( CliError::Msg( format!( "{:?} exists, but is not a file; bailing out", &netrc_fpath)));
    }

    let netrc_file: File = match File::open( &netrc_fpath ) {
        Ok(opened_file) => opened_file,
        Err(err) => {
            return Err( CliError::IoErrorW( format!( "Was unable to open the user's netrc file: {:?}",
                                                      &netrc_fpath),
                                            err ));
        }
    };

    let netrc_br = BufReader::new( netrc_file );

    pr_debug!("Parsing user's netrc file");
    let netrc_obj = match Netrc::parse( netrc_br ) {
        Ok(parsed_obj) => parsed_obj,
        Err(err) => {
            return Err( CliError::NetrcError( format!( "Was unable to parse the user's netrc file: {:?}",
                                                        &netrc_fpath),
                                              err ));
        }
    };
    pr_debug!("Successfully parsed user's netrc file");

// DEBUG go
    // pr_trace!( "netrc_obj.hosts: {:?}", netrc_obj.hosts );
// DEBUG end

    for (ref one_hostname, ref one_machine) in netrc_obj.hosts {

        // CAREFUL: Do no just print the one_machine (netrc::Machine) struct
        //          because that would show the password field.
        pr_trace!( "one netrc record" );
        pr_trace!( "  one host.name: {}",   one_hostname );
        pr_trace!( "  one host.mach: {:?}", fmt_netrc_machine( &one_machine ) );  // sanitize display

        pr_debug!( "Checking if record hostname (\"{}\") matches wanted hostname (\"{}\")",
                    one_hostname, wanted_hostname);

        // if "api.github.com" == one_hostname {
        if !(wanted_hostname == &one_hostname[..]) {
            pr_debug!( "netrc hostname does not match: {}", one_hostname );
            continue;
        }

        pr_debug!( "netrc hostname matches: {}", one_hostname );

        if let Some(_) = cfg.username {}
        else {
            // No username value was provided to constrain the match, so we've
            // found our match.
            println!("{}", &one_machine.login[..] );
            return Ok(());
        }

        if let Some(ref wanted_username) = cfg.username {

            // A username value was provided, so we need to match that, as well

            pr_debug!( "Checking if record username (\"{}\") matches wanted username (\"{}\")",
                       &one_machine.login[..], wanted_username);

            if wanted_username == &(one_machine.login) {
                pr_debug!( "netrc username matches: {}", &(one_machine.login) );
                println!("{}", &one_machine.login[..] );
                return Ok(());
            }

            pr_debug!( "netrc username does not match: {}", &(one_machine.login) );
            continue;
        }
    }

    // If we are falling through here, then none of the netrc records matched
    // the specified hostname (or hostname, username pair).

    if let Some(ref wanted_username) = &(cfg.username) {
        return Err( CliError::NoMatchingNetrcRecord2{ hostname: wanted_hostname.clone(),
                                                      username: wanted_username.clone() } );
    }

    return Err( CliError::NoMatchingNetrcRecord1{ hostname: wanted_hostname.clone() } );
}

fn main() {

    // FIXME: maybe use OsString, instead, to allow for data in busted encoding on input
    //
    let args: Vec<String> = env::args().collect();

    process::exit( match run_app( &args ) {
        Ok(_) => 0,      // success (match found)
        Err(err) => {
            match err {
                CliError::BadArgs(_) => {
                    pr_error!( "{}", err );
                    // The user provided invalid command line parameters, so we
                    // will emit the program's help message after the error
                    // message already printed above.
                    //
                    print_help( &mut io::stderr() ).unwrap();
                    2  // error
                },

                  CliError::NoMatchingNetrcRecord1{..}
                | CliError::NoMatchingNetrcRecord2{..}
                  => {
                      // This is not necessarily an "error", in the same sense
                      // that a grep(1) pattern that did not find any matching
                      // text is not inherently an "error" -- it depends on
                      // what the caller is trying to do. Therefore, by
                      // default we will not emit any output specifically for
                      // this scenario, but a single '-v' (--verbose) is
                      // enough to get that behavior, if desired.
                      //
                      pr_info!( "{}", err );  // yes, info -- that's not a typo

                      1  // no match found
                },

                _ => {
                      pr_error!( "{}", err );
                      2  // error
                }
            }

        }
    });
}
