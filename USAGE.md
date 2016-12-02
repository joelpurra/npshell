# np 1 2015-05-12 1.2.0 npshell Usage



## Name

`np` - Command line music queue manager



## Description

Keep a daemon running in the background. Add sounds to a queue. Let the daemon play the sweet music for you. All from the comfort of your own shell.

[npshell repository](https://github.com/joelpurra/npshell/)



## Commands


### `np daemon [--is-running|--stop|--verbose]`

Play sounds in queue as soon as there are any. Can be controlled with `np start` and `np stop`, as well as the rest of the queue commands.

- `--is-running`
  - Check if the daemon process has already started. Exits with `0` if it has, `1` otherwise.
- `--stop`
  - Stop daemon execution. Can be used during system shutdown, but isn't part of everyday usage.
- `--verbose`
  - Output paths to the sounds as they play.


**Examples**

```bash
# Start the daemon, let it run in the background.
# Should be done at user login.
np daemon --is-running || ( np daemon & )
```



### `np notify [--is-running|--stop]`

Show notifications when the track changes, playback is started/stopped or the queue is empty.
If the sound has id3v2 tags, artist/album/title are shown.

- `--is-running`
  - Check if the daemon process has already started. Exits with `0` if it has, `1` otherwise.
- `--stop`
  - Stop notification daemon execution. Can be used during system shutdown, but isn't part of everyday usage.


**Examples**

```bash
# Start the notification daemon, let it run in the background.
# Should be done at user login.
np notify --is-running || ( np notify & )
```



### `np`, `np now`.

Shows the sound currently playing.



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


**Examples**

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



### `np help [command]`

Show general help for `np` usage.

- Command
  - Show help about a specific command.




### `np start`

Let `np daemon` consume the sound queue.



### `np stop`

Don't let `np daemon` consume the sound queue.



### `np startstop`

Toggle playback by alternating between `np start` and `np stop`.



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
