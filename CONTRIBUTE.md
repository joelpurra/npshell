# Contribute to [npshell](https://github.com/joelpurra/npshell)



This is experimental software, so feedback is most appreciated!

- You can [open an issue for your problem or suggestion](https://github.com/joelpurra/npshell/issues).



## Development

Please install the `git` `pre-commit` hook to get automatic `man np` page generation from `USAGE.md`. This requires [md2man](https://github.com/sunaku/md2man) (`md2man-roff`) to be installed.

```bash
pushd .git/hooks
ln -s ../../src/shared/githooks/pre-commit.sh pre-commit
popd
```



## TODO

- Test cross-platform support, add common music players.
- Installer in different package managers:
  - ~~[brew](http://brew.sh/)~~
- Command tab completion.
- Search the `$PWD` folder tree backwards for `.npconfig` local configuration files?
- Queue:
  - ~~Add sounds by piping paths into `np add`: `find sounds | np add all in-order`.~~
  - Add a limit to `np list` (screen size?) or use `less`?
  - Improve `np history` limit.
  - ~~`np clean` - remove non-existent files from the queue.~~
  - ~~Fix `np add all in-order` so it doesn't add folder paths to the queue.~~
  - ~~Print sound queue number.~~
  - `np prev` (`np add --from-history -1`) or similar to add most recently played sound?
  - `np remove #` to remove sound number # in the queue?
  - `np next #` (`np skip #`) to skip a number of sounds in the queue.
  - `np first` - like `np add`, but add sounds to top of queue.
  - ~~Number currently playing sound 0 instead of 1?~~
  - `np default <path ...>` mode which reads sounds from <path ...> when the queue is empty.
- External player:
  - ~~Fix unstable/race condition `wait`/`sleep` usage.~~
  - Set up a music player interface to switch out `afplay`.
  - Don't `kill -9 afplay`, use another signal?
  - Find a signal to pause playback?
- `np daemon`:
  - ~~Create a system service wrapper.~~
  - ~~`np daemon --pause` to try to pause/sleep the audio player, make daemon idle?~~
  - ~~`np daemon --resume` to resume an idle daemon?~~
  - Save sound playback position upon pause?
  - ~~Maintain np/pause status between `np daemon` executions, so it will resume playing (or not) upon reboot?~~
- Index/cache files:
  - If not using an index and an action takes too long, display a warning message "Using indexes could speed up `np add`"?
  - Use `.np.cache~` indexes hierachically when building parent indexes?
  - ~~`np index` to index the current folder.~~
  - ~~`np index --force` to reindex the current folder.~~
  - ~~`np index --clean` to remove `.np.cache~`.~~
  - ~~`np index [--force|--clean] --recursive` to perfom action recursively.~~
- Consider using another language for the entire project -- or at least the process control parts.
