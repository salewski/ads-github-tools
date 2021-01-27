// -*- rust -*-

// SPDX-FileCopyrightText: <text> © 2021 Alan D. Salewski <ads@salewski.email> </text>
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

//! Top-level module of the internal library for the **`parse-netrc`**
//! application.


// CAREFUL: macros defined and exported from our 'configure_time' module get
//          exported to the crate root. To use them from our binary crate will
//          require 'use'ing them from the top-level crate name:
//
// Example usage:
//     use parse_netrc::{
//         bld_date,     // bld_date!() macro
//         bld_version,  // bld_version!() macro
//     };
//
#[macro_use]  // bld_date!(), bld_version!()
#[path = "configure-time.rs"]
pub mod configure_time;
