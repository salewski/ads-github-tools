use std::io::BufRead;

pub type Macro = (String, String);
pub type Host = (String, Machine);

#[derive(Debug, Default)]
pub struct Machine {
    pub login: String,
    pub password: Option<String>,
    pub account: Option<String>,
    pub port: Option<u16>,
}

#[derive(Debug, Default)]
pub struct Netrc {
    pub hosts: Vec<Host>,
    pub default: Option<Machine>,
    pub macros: Vec<Macro>,
}

#[derive(Debug)]
pub enum Error {
    Io(std::io::Error),
    Parse(String, usize),
}

pub type Result<A> = std::result::Result<A, Error>;

impl Netrc {
    /// Parse a `Netrc` object from byte stream.
    ///
    /// # Examples
    ///
    /// ```
    /// use netrc::Netrc;
    /// use std::io::Cursor;
    ///
    /// let input: Cursor<&[u8]> =
    ///   Cursor::new(b"machine example.com login foo password bar");
    /// let netrc = Netrc::parse(input).unwrap();
    /// ```
    pub fn parse<A: BufRead>(buf: A) -> Result<Netrc> {
        let mut netrc: Netrc = Default::default();
        let mut lexer = Lexer::new(buf);
        let mut current_machine = MachineRef::Nothing;
        loop {
            match lexer.next_word() {
                None         => break,
                Some(Err(e)) => return Err(e),
                Some(Ok(w))  => current_machine = try! {
                    netrc.parse_entry(&mut lexer, &w, current_machine)
                },
            }
        }
        Ok(netrc)
    }

    fn parse_entry<A: BufRead>(&mut self,
                               lexer: &mut Lexer<A>,
                               item: &str,
                               current_machine: MachineRef) -> Result<MachineRef> {
        macro_rules! with_current_machine {
            ($entry: expr, $machine: ident, $body: block) => {
                match self.find_machine(&current_machine) {
                    Some($machine) => {
                        $body;
                        Ok(current_machine)
                    }
                    None =>
                        Err(Error::Parse(format!("No machine defined for {}",
                                                 $entry),
                                         lexer.lnum)),
                }
            }
        }

        match item {
            "machine" => {
                let host_name = try!(lexer.next_word_or_err());
                self.hosts.push((host_name, Default::default()));
                Ok(MachineRef::Host(self.hosts.len() - 1))
            }
            "default" => {
                self.default = Some(Default::default());
                Ok(MachineRef::Default)
            }
            "login" => with_current_machine!("login", m, {
                m.login = try!(lexer.next_word_or_err());
            }),
            "password" => with_current_machine!("password", m, {
                m.password = Some(try!(lexer.next_word_or_err()));
            }),
            "account" => with_current_machine!("account", m, {
                m.account = Some(try!(lexer.next_word_or_err()));
            }),
            "port" => with_current_machine!("port", m, {
                let port = try!(lexer.next_word_or_err());
                match port.parse() {
                    Ok(port) => m.port = Some(port),
                    Err(_)   => {
                        let msg = format!("Unable to parse port number `{}'",
                                          port);
                        return Err(Error::Parse(msg, lexer.lnum));
                    }
                }
            }),
            "macdef" => {
                let name = try!(lexer.next_word_or_err());
                let cmds = try!(lexer.next_subcommands());
                self.macros.push((name, cmds));
                Ok(MachineRef::Nothing)
            }
            _ => Err(Error::Parse(format!("Unknown entry `{}'", item),
                                  lexer.lnum)),
        }
    }

    fn find_machine(&mut self,
                    reference: &MachineRef) -> Option<&mut Machine> {
        match *reference {
            MachineRef::Nothing => None,
            MachineRef::Default => self.default.as_mut(),
            MachineRef::Host(n) => Some(&mut self.hosts[n].1),
        }
    }
}

enum MachineRef {
    Nothing,
    Default,
    Host(usize),
}

struct Tokens {
    buf: String,
    cur: usize,
}

impl Tokens {
    fn new(buf: String) -> Tokens {
        Tokens { buf: buf, cur: 0 }
    }

    fn empty() -> Tokens {
        Tokens::new("".to_string())
    }

    fn remaining(&self) -> &str {
        &self.buf[self.cur..]
    }

    fn next(&mut self) -> Option<String> {
        let mut cur = self.cur;
        for _ in self.remaining().chars().take_while(|c| c.is_whitespace()) {
            cur += 1;
        }
        self.cur = cur;
        if cur < self.buf.len() {
            let mut s = String::new();
            for c in self.remaining().chars().take_while(|c| !c.is_whitespace()) {
                cur += 1;
                s.push(c);
            }
            self.cur = cur;
            Some(s)
        } else {
            None
        }
    }
}

struct Lexer<A> {
    buf: A,
    line: Tokens,
    lnum: usize,
}

impl<A: BufRead> Lexer<A> {
    fn new(buf: A) -> Lexer<A> {
        Lexer { buf: buf, line: Tokens::empty(), lnum: 0 }
    }

    fn read_line(&mut self, buf: &mut String) -> Result<usize> {
        let r = self.buf.read_line(buf).map_err(Error::Io);
        for &n in r.iter() {
            if n > 0 { self.lnum += 1 };
        }
        r
    }

    fn refill(&mut self) -> Result<usize> {
        let mut line = String::new();
        let n = try!(self.read_line(&mut line));
        self.line = Tokens::new(line);
        Ok(n)
    }

    fn next_word(&mut self) -> Option<Result<String>> {
        loop {
            match self.line.next() {
                Some(w) => return Some(Ok(w)),
                None    => match self.refill() {
                    Ok(0)  => return None,
                    Ok(_)  => (),
                    Err(e) => return Some(Err(e)),
                },
            }
        }
    }

    fn next_word_or_err(&mut self) -> Result<String> {
        match self.next_word() {
            Some(w) => w,
            None    => Err(Error::Parse("Unexpected end of file".to_string(),
                                        self.lnum)),
        }
    }

    fn next_subcommands(&mut self) -> Result<String> {
        let mut cmds = self.line.remaining().to_string();
        self.line = Tokens::empty();
        loop {
            match self.read_line(&mut cmds) {
                Ok(0...1) => return Ok(cmds),
                Ok(_)     => (),
                Err(e)    => return Err(e),
            }
        }
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use std::io::BufReader;

    #[test]
    fn parse_simple() {
        let input = "machine example.com
                             login test
                             password p@ssw0rd
                             port 42";
        let input = BufReader::new(input.as_bytes());
        let netrc = Netrc::parse(input).unwrap();
        assert_eq!(netrc.hosts.len(), 1);
        assert!(netrc.macros.is_empty());
        let (ref name, ref mach) = netrc.hosts[0];
        assert_eq!(name, "example.com");
        assert_eq!(mach.login, "test");
        assert_eq!(mach.password.as_ref().unwrap(), "p@ssw0rd");
        assert_eq!(mach.port, Some(42));
        assert_eq!(mach.account, None);
    }

    #[test]
    fn parse_macdef() {
        let input = "machine host1.com login login1
                     macdef uploadtest
                            cd /pub/tests
                            bin
                            put filename.tar.gz
                            quit

                     machine host2.com login login2";
        let input = BufReader::new(input.as_bytes());
        let netrc = Netrc::parse(input).unwrap();
        assert_eq!(netrc.hosts.len(), 2);
        for host in netrc.hosts.iter().enumerate() {
            let (i, &(ref name, ref mach)) = host;
            let i = i + 1;
            assert_eq!(name, &format!("host{}.com", i));
            assert_eq!(mach.login, format!("login{}", i));
        }
        assert_eq!(netrc.macros.len(), 1);
        let (ref name, ref cmds) = netrc.macros[0];
        assert_eq!(name, "uploadtest");
        assert_eq!(cmds.trim(), "cd /pub/tests
                            bin
                            put filename.tar.gz
                            quit");
    }

    #[test]
    fn parse_default() {
        let input = "machine example.com login test
                     default login def";
        let input = BufReader::new(input.as_bytes());
        let netrc = Netrc::parse(input).unwrap();
        assert_eq!(netrc.hosts.len(), 1);
        let (ref name, ref mach) = netrc.hosts[0];
        assert_eq!(name, "example.com");
        assert_eq!(mach.login, "test");
        let def_mach = netrc.default.unwrap();
        assert_eq!(def_mach.login, "def");
    }

    #[test]
    fn parse_error_unknown_entry() {
        let input = "machine foobar.com
                             foo";
        let input = BufReader::new(input.as_bytes());
        match Netrc::parse(input).unwrap_err() {
            Error::Parse(msg, lnum) => {
                assert_eq!(msg, "Unknown entry `foo'");
                assert_eq!(lnum, 2);
            }
            e => panic!("Wrong Error type: {:?}", e),
        }
    }

    #[test]
    fn parse_error_unexpected_eof() {
        let input = "machine foobar.com
                             password quux
                             login";
        let input = BufReader::new(input.as_bytes());
        match Netrc::parse(input).unwrap_err() {
            Error::Parse(msg, lnum) => {
                assert_eq!(msg, "Unexpected end of file");
                assert_eq!(lnum, 3);
            }
            e => panic!("Wrong Error type: {:?}", e),
        }
    }

    #[test]
    fn parse_error_no_machine() {
        let input = "password quux login foo";
        let input = BufReader::new(input.as_bytes());
        match Netrc::parse(input).unwrap_err() {
            Error::Parse(msg, lnum) => {
                assert_eq!(msg, "No machine defined for password");
                assert_eq!(lnum, 1);
            }
            e => panic!("Wrong Error type: {:?}", e),
        }
    }

    #[test]
    fn parse_error_port() {
        let input = "machine foo.com login bar port quux";
        let input = BufReader::new(input.as_bytes());
        match Netrc::parse(input).unwrap_err() {
            Error::Parse(msg, lnum) => {
                assert_eq!(msg, "Unable to parse port number `quux'");
                assert_eq!(lnum, 1);
            }
            e => panic!("Wrong Error type: {:?}", e),
        }
    }
}
