# npshell `np` -- command line music player and queue manager

Keep a daemon running in the background. Add sounds to a queue. Let the daemon play them for you. All from the comfort of your own shell.


# Usage

## Basic commands

```bash
np daemon &
cd Music/
np add 10
np
np next
np list
np add all in-order "Jazz/My Favorite Album/"
```

### `np daemon`

Play sounds in queue as soon as there are any.

#### `--stop`

- Stop daemon playback.


#### Examples

```bash
# Start the daemon, let it run in the background.
# Could be done at system startup.
np daemon &
```


### `np list`

See sounds currently in the queue.


### `np next`

Advance to the next sound in the queue.


### `np add`

Add some sounds to the queue.

`np add [limit] [order] [path ...]`


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
np add

# Add a single sound to the queue.
np add path/to/sound.mp3

# Add 25 random sounds from the current folder.
np add 25

# Add the first 2 sounds from the current folder.
np add 2 in-order

# Add random sounds from a folder, hierarchically.
np add path/to/folder/with/sounds/

# Add an album.
np add all in-order "Jazz/My Favorite Album/"

# Add sounds by null-delimited paths from stdin.
find . -iname '*best of*.mp3' -print0 | np add -

# Add 10 random sounds from the combined list of a single sound, stdin and a folder.
find . -iname '*best of*.mp3' -print0 | np add 10 path/to/sound.mp3 - path/to/folder/with/sounds/
```


## More commands


### `np`

Alias for `np now`.


### `np start`

Start consuming queue by playing back in the current terminal.


### `np clear`

Empty the queue.


### `np clean`

Remove non-existant files from queue.


### `np history`

Show the 999 most recently played sounds.


### `np now`

Shows the sound currently playing, or first in queue if the player isn't started.


### `np index`

Create a file with a cached list of all sounds in the current folder, including subfolders.

#### `--force`

Recreate the index file even if it already exists.


# Configuration

Settings are read from `~/.np/config.sh`. The format is `setting=value`; one per line.

## `configNumsounds`

- Default is 3.
- Set the number of sounds `np add` adds unless overridden.

## `configOrder`

- Default is "random".
- The order `np add` adds files in.
- Can also be "in-order".

## configDebug

- Default is "false".
- Enable debug output.

## configUseCache

- Default is "true".
- Automatically generate index files per folder sounds are loaded from. See `np index`.


# TODO

- Search the $PWD folder tree backwards for `.npconfig` local configuration files?
- Queue:
  - Add sounds by piping paths into `np add`: `find sounds | np add all in-order`.
  - Add a limit to `np list` (screen size?) or use `less`?
  - Improve `np history` limit.
  - -`np clean` - remove non-existent files from the queue.-
  - -Fix `np add all in-order` so it doesn't add folder paths to the queue.-
  - -Print sound queue number.-
  - `np prev` (`np add --from-history -1`) or similar to add most recently played sound?
  - `np remove #` to remove sound number # in the queue?
  - `np next #` (`np skip #`) to skip a number of sounds in the queue.
  - `np first` - like `np add`, but add sounds to top of queue.
  - Number currently playing sound 0 instead of 1?
- External player:
  - Set up a music player interface to switch out `afplay`.
  - Don't `kill -9 afplay`, use another signal?
  - Find a signal to pause playback?
- `np daemon`:
  - `np daemon --pause` to try to pause/sleep the audio player, make daemon idle?
  - `np daemon --resume` to resume an idle daemon?
  - Save sound playback position upon pause?
  - Maintain np/pause status between `np daemon` executions, so it will resume playing (or not) upon reboot?
- Index/cache files:
  - If not using an index and an action takes too long, display a warning message "Using indexes could speed up `np add`"?
  - Use `.np.cache~` indexes hierachically when building parent indexes?
  - -`np index` to index the current folder.-
  - -`np index --force` to reindex the current folder.-
  - -`np index --clean` to remove `.np.cache~`.-
  - -`np index [--force|--clean] --recursive` to perfom action recursively.-
