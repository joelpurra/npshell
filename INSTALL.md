# Installation

See [npshell `np` -- command line music queue manager](https://github.com/joelpurra/npshell/)

## Autostart

The npshell daemon is designed to start upon login.


### On Mac with [Homebrew](http://brew.sh/)

```bash
brew tap joelpurra/joelpurra
brew install npshell
brew services start npshell
```

### On other systems

- Clone the code then add a symlink to `npshell/src/np` to your path.
- Add `np daemon --is-running || ( np daemon & )` to your `~/.bash_profile` or similar.
- Requirements:
  - One of the music players `afplay`, `mplayer`, `mpg123`, `mpg321`, `play` in your `$PATH`.
  - [`fswatch`](https://github.com/emcrisostomo/fswatch), [`bash`](https://www.gnu.org/software/bash/) 4+, `shuf` (or `brew` prefixed `gshuf`), `tac` (or `brew` prefixed `gtac`) from [`coreutils`](https://www.gnu.org/software/coreutils/).



## Notifications

The notification system is started separately.

- Add `np notify --is-running || ( np notify & )` to your `~/.bash_profile` or similar.
- Requirements
  - [`terminal-notifier`](https://github.com/alloy/terminal-notifier) or [`growlnotify`](http://growl.info/downloads).



---

Copyright (c) 2014, 2015, 2016 [Joel Purra](https://joelpurra.com/). Released under [GNU General Public License version 3.0 (GPL-3.0)](https://www.gnu.org/licenses/gpl.html).
