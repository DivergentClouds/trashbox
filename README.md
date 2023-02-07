# Trashbox

Trashbox is set of simple trash management functions written in POSIX shell
script. Trashbox is not compliant with the FreeDesktop.org specification.

## Installation

Source `trashbox.sh` in your shell rc file.

## Usage

### Commands

- `trashbox-put <path ...>`
  - Move 1 or more files to the trashbox.
- `trashbox-restore <source relative to the trashbox> <destination>`
  - Restore a file or directory from the trashbox.
- `trashbox-remove <path relative to the trashbox>`
  - Prompt to remove the given files or directories from the trashbox.
- `trashbox-empty`
  - Prompt to remove all files and directories from the trashbox.
- `trashbox-list`
  - List the paths relative to the trashbox of all files and directories in the
    trashbox.

