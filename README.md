# [npshell `np` -- command line music queue manager](https://github.com/joelpurra/npshell/)

Keep a daemon running in the background. Add sounds to a queue. Let the daemon play the sweet music for you. All from the comfort of your own shell.


<p align="center">
  <a href="https://github.com/joelpurra/npshell/"><img src="https://cloud.githubusercontent.com/assets/1398544/5836151/b8d8e31e-a171-11e4-8412-d23765b54a25.gif" alt="npshell in action" border="0" /></a>
</p>


- Stricly command line based for extra nerd credits.
- Adds sounds from deep folder structures by default.
- Control music playback daemon from any terminal window.
- Displays song paths relative to `$PWD`.
- Creates cached/index files to handle deep folder structures on network drives.



## Installation

On Mac with [Homebrew](http://brew.sh/):

```bash
brew tap joelpurra/joelpurra
brew install npshell
```

On other systems:

- Clone the code then add a symlink to `npshell/src/np` to your path.
- Run `np daemon &` on system startup to keep the daemon in the background.
- Requirements:
  - One of the music players `afplay`, `mplayer`, `mpg123`, `mpg321`, `play` in your `$PATH`.
  - [`fswatch`](https://github.com/emcrisostomo/fswatch), [`bash`](https://www.gnu.org/software/bash/) 4+.



## Get started

See [USAGE.md for the full list of command and configuration](https://github.com/joelpurra/npshell/blob/master/USAGE.md) with examples.

Everyday usage:

```bash
cd Music/     # Go to a folder with some sounds.
np add 10     # Add 10 shuffled sounds from current folder hierarchy.
np next       # Play next sound.
np            # Display the currently playing sound.
np list       # List sounds in queue.
              # Add an album by folder path.
np add all in-order "Jazz/My Favorite Album/"
```


Convenient aliases:

Save a keystroke or two, at least until tab completion is... completed. Add to your `~/.bash_profile` or similar autoexecuted file of your choice.

```bash
alias npa='np add'
alias npn='np next'
alias npl='np list'
```


---

Copyright (c) 2014, 2015 [Joel Purra](http://joelpurra.com/). Released under [GNU General Public License version 3.0 (GPL-3.0)](https://www.gnu.org/licenses/gpl.html).
