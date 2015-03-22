# Contribute to [npshell](https://github.com/joelpurra/npshell)

List of commands, configuration and other usage of `np`.



## Usage

### `np daemon [--stop]`

Play sounds in queue as soon as there are any.

- `--stop`
  - Stop daemon playback.


#### Examples

```bash
# Start the daemon, let it run in the background.
# Could be done at system startup.
np daemon &
```


### `np`, `np now`.

Shows the sound currently playing, or first in queue if the player isn't started.


### `np list`

See sounds currently in the queue.


### `np next`

Advance to the next sound in the queue.


### `np add [limit] [order] [path ...]`

Add some sounds to the queue.

- Limit
  - Default is 3.
  - You can also use "all".


- Order
  - Default is "shuffle".
 - You can also use "in-order".
- Path
  - Default is `$PWD`.
  - You can use paths
    - to sounds
    - to folders
    - or "-" to read null-delimited paths from stdin.


#### Examples

```bash
# Add the default number of shuffled sounds from the current folder.
np add

# Add a single sound to the queue.
np add path/to/sound.mp3

# Add 25 shuffled sounds from the current folder.
np add 25

# Add the first 2 sounds from the current folder.
np add 2 in-order

# Add shuffled sounds from a folder, hierarchically.
np add path/to/folder/with/sounds/

# Add an album.
np add all in-order "Jazz/My Favorite Album/"

# Add sounds by null-delimited paths from stdin.
find . -iname '*best of*.mp3' -print0 | np add -

# Add 10 shuffled sounds from the combined list of a single sound, stdin and a folder.
find . -iname '*best of*.mp3' -print0 | np add 10 path/to/sound.mp3 - path/to/folder/with/sounds/
```


## More commands


### `np start [limit]`

Start consuming queue by playing back in the current terminal.

- Limit
  - Default is -1, meaning no limit.


### `np clear`

Empty the queue.


### `np clean`

Remove non-existant files from queue.


### `np history`

Show the 999 most recently played sounds.


### `np index [--force|--clean[ --recursive]]`

Create a file with a cached list of all sounds in the current folder, including subfolders.

- `--force`
  - Recreate the index file even if it already exists.
- `--clean`
  - Remove index files.
- `--recursive`
  - Perform the action in subfolders.


### `np doctor`

Display configuration, runtime and status values.


## Configuration

Settings are read from `~/.np/config.sh`. The format is one `setting=value` per line.

### `configNumsounds`

- Default is 3.
- Set the number of sounds `np add` adds unless overridden.

### `configOrder`

- Default is "shuffle".
- The order `np add` adds files in.
- Can also be "in-order".

### `configDebug`

- Default is "false".
- Enable debug output.

### `configUseCache`

- Default is "true".
- Automatically generate index files per folder sounds are loaded from. See `np index`.


