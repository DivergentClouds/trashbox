export TRASHBOX="${XDG_DATA_HOME:-$HOME}/.trashbox"

# moves 1 or more files or directories to the trashbox
trashbox-put() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: trashbox-put <path ...>" 1>&2
    return 1
  fi

  time="$(date +%s.%N | cut -b 1-13)"

  mkdir -p "$TRASHBOX/$time"
  mv $@ "$TRASHBOX/$time/" || rmdir "$TRASHBOX/$time/" ; false
}

# restores a file or directory from the trashbox
trashbox-restore() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: trashbox-restore <source relative to the trashbox> <destination>" 1>&2
    return 1
  fi

  if [ ! -e "$TRASHBOX/$1" ]; then
    return 1
  fi
  mv "$TRASHBOX/$1" "$2" &&
  (rmdir "$TRASHBOX/$(echo "$1" | cut -d / -f 1)" 2> /dev/null || true)
}

# prompts to permanently remove everything from the trashbox
trashbox-empty() {
  if [ "$#" -ne 0 ]; then
    echo "Usage: trashbox-empty" 1>&2
    return 1
  fi

  printf "Empty trashbox? (y/N) "

  read answer
  if [ "$answer" != "${answer#[Yy]}" ]; then
    rm -rf "$TRASHBOX"
    mkdir -p "$TRASHBOX"
  fi
}

# prompts to permanently remove some files or directories from the trashbox
trashbox-remove() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: trashbox-remove <path relative to the trashbox>" 1>&2
    return 1
  fi
  printf "Delete the given files? (y/N) "

  read answer
  if [ "$answer" != "${answer#[Yy]}" ]; then
    for file in "$@";do
      rm -rf "$TRASHBOX/$1"
      mkdir -p "$TRASHBOX" # in case file is '/'
      rmdir "$TRASHBOX/$(echo "$file" | cut -d / -f 1)" 2> /dev/null || true
    done
  fi
}

# lists all files and directories in the trashbox
trashbox-list() {
  if [ "$#" -ne 0 ]; then
    echo "Usage: trashbox-list" 1>&2
    return 1
  fi

  mkdir -p "$TRASHBOX"
  if find "$TRASHBOX" -mindepth 1 -maxdepth 1 | read; then
    find "$TRASHBOX"/*/* 2> /dev/null | cut -b $(echo "$TRASHBOX " | wc -c)-
  fi
}


