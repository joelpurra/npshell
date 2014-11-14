# `play` -- command line music player and queue manager

Keep a daemon running in the background. Add sounds to a queue. Let the daemon play them for you. All from the comfort of your own shell.


# Usage

## Basic commands

```bash
play daemon &
cd Music/
play add 10
play next
play list
play add all in-order "Jazz/My Favorite Album/"
```

### `play daemon`

Play sounds in queue as soon as there are any.

#### `--stop`

- Stop daemon playback.


#### Examples

```bash
# Start the daemon, let it run in the background.
# Could be done at system startup.
play daemon &
```


### `play list`

See sounds currently in the queue.


### `play next`

Advance to the next sound in the queue.


### `play add`

Add some sounds to the queue.

`play add [limit] [order] [path ...]`


#### Limit

- Default is 3.
- You can also use "all".


#### Order

- Default is "random".
- You can also use "in-order".


#### Path

- Default is "$PWD".
- You can use paths
  - to sounds
  - to folders
  - or "-" to read null-delimited paths from stdin.


#### Examples

```bash
# Add the default number of random sounds from the current folder.
play add

# Add a single sound to the queue.
play add path/to/sound.mp3

# Add 25 random sounds from the current folder.
play add 25

# Add the first 2 sounds from the current folder.
play add 2 in-order

# Add random sounds from a folder, hierarchically.
play add path/to/folder/with/sounds/

# Add an album.
play add all in-order "Jazz/My Favorite Album/"

# Add sounds by null-delimited paths from stdin.
find . -iname '*best of*.mp3' -print0 | play add -

# Add 10 random sounds from the combined list of a single sound, stdin and a folder.
find . -iname '*best of*.mp3' -print0 | play add 10 path/to/sound.mp3 - path/to/folder/with/sounds/
```


## More commands


### `play`

Alias for `play start`.


### `play start`

Start consuming queue by playing back in the current terminal.


### `play clear`

Empty the queue.


### `play clean`

Remove non-existant files from queue.


### `play history`

Show the 999 most recently played sounds.


### `play now`

Shows the sound currently playing, or first in queue if the player isn't started.


### `play index`

Create a file with a cached list of all sounds in the current folder, including subfolders.

#### `--force`

Recreate the index file even if it already exists.


# Configuration

Settings are read from `~/.play/config.sh`. The format is `setting=value`; one per line.

## `sharedNumsounds`

- Default is 3.
- Set the number of sounds `play add` adds unless overridden.

## `sharedOrder`

- Default is "random".
- The order `play add` adds files in.
- Can also be "in-order".

## sharedDebug

- Default is "false".
- Enable debug output.

## sharedUseCache

- Default is "true".
- Automatically generate index files per folder sounds are loaded from. See `play index`.


# TODO

- Search the $PWD folder tree backwards for `.playconfig` local configuration files?
- Queue:
  - Add sounds by piping paths into `play add`: `find sounds | play add all in-order`.
  - Add a limit to `play list` (screen size?) or use `less`?
  - Improve `play history` limit.
  - -`play clean` - remove non-existent files from the queue.-
  - -Fix `play add all in-order` so it doesn't add folder paths to the queue.-
  - -Print sound queue number.-
  - `play prev` (`play add --from-history -1`) or similar to add most recently played sound?
  - `play remove #` to remove sound number # in the queue?
  - `play next #` (`play skip #`) to skip a number of sounds in the queue.
  - `play first` - like `play add`, but add sounds to top of queue.
  - Number currently playing sound 0 instead of 1?
- External player:
  - Set up a music player interface to switch out `afplay`.
  - Don't `kill -9 afplay`, use another signal?
  - Find a signal to pause playback?
- `play daemon`:
  - `play daemon --pause` to try to pause/sleep the audio player, make daemon idle?
  - `play daemon --resume` to resume an idle daemon?
  - Save sound playback position upon pause?
  - Maintain play/pause status between `play daemon` executions, so it will resume playing (or not) upon reboot?
- Index/cache files:
  - If not using an index and an action takes too long, display a warning message "Using indexes could speed up `play add`"?
  - Use `.play.cache~` indexes hierachically when building parent indexes?
  - -`play index` to index the current folder.-
  - -`play index --force` to reindex the current folder.-
  - -`play index --clean` to remove `.play.cache~`.-
  - -`play index [--force|--clean] --recursive` to perfom action recursively.-
