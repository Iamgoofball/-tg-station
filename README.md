## /tg/station codebase

[![Build Status](https://github.com/tgstation/tgstation/workflows/CI%20Suite/badge.svg)](https://github.com/tgstation/tgstation/actions?query=workflow%3A%22CI+Suite%22)
[![Percentage of issues still open](https://isitmaintained.com/badge/open/tgstation/tgstation.svg)](https://isitmaintained.com/project/tgstation/tgstation "Percentage of issues still open")
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/tgstation/tgstation.svg)](https://isitmaintained.com/project/tgstation/tgstation "Average time to resolve an issue")
![Coverage](https://img.shields.io/badge/coverage---4%25-red.svg)

[![resentment](.github/images/badges/built-with-resentment.svg)](.github/images/comics/131-bug-free.png) [![technical debt](.github/images/badges/contains-technical-debt.svg)](.github/images/comics/106-tech-debt-modified.png) [![forinfinityandbyond](.github/images/badges/made-in-byond.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

| Website             | Link                                                  |
| ------------------- | ----------------------------------------------------- |
| Website             | https://tgstation13.org                               |
| Code                | https://github.com/tgstation/tgstation                |
| Server Config       | https://github.com/tgstation-operations/server-config |
| Wiki                | https://tgstation13.org/wiki/Main_Page                |
| Codedocs            | https://codedocs.tgstation13.org/                     |
| /tg/station Discord | https://tgstation13.org/phpBB/viewforum.php?f=60      |
| Coderbus Discord    | https://discord.gg/Vh8TJp9                            |

This is the codebase for the /tg/station flavoured fork of SpaceStation 13.

Space Station 13 is a paranoia-laden round-based roleplaying game set against the backdrop of a nonsensical, metal death trap masquerading as a space station.

## Development Environment Setup

### Using Nix Flake

1. Install Nix: https://nixos.org/download.html
2. Enable flakes: `echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf`
3. Enter the development environment: `nix develop`
4. Run the screenshot harness: `screenshot_harness.sh`

### Manual Setup

1. Install BYOND: https://www.byond.com/download
2. Install Wine: https://www.winehq.org/
3. Install Xvfb: `sudo apt-get install xvfb` (Ubuntu/Debian)