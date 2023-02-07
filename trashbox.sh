#!/usr/bin/env sh

export TRASHBOX="${XDG_DATA_HOME:-$HOME}/.trashbox"

# moves 1 or more files or directories to the trashbox
function trashbox-put() { 
  time="$(date +%s.%N | cut -b 1-13)"

  mkdir -p "$TRASHBOX/$time"
  mv $@ "$TRASHBOX/$time/" || rmdir "$TRASHBOX/$time/" ; false
}

# restores a file or directory from the trashbox
function trashbox-restore() {
  mv "$TRASHBOX/$1" "$2" &&
  (rmdir "$TRASHBOX/$(echo "$1" | cut -d / -f 1)" 2> /dev/null || true)
}

# prompts to permanently remove everything from the trashbox
function trashbox-empty() {
  printf "Empty trashbox? (y/N) "

  read answer
  if [ "$answer" != "${answer#[Yy]}" ] ;then
    rm -rf "$TRASHBOX"
    mkdir -p "$TRASHBOX"
  fi
}

# prompts to permanently remove some files or directories from the trashbox
function trashbox-remove() {
  printf "Delete the given files? (y/N) "

  read answer
  if [ "$answer" != "${answer#[Yy]}" ] ;then
    for file in "$@";do
      rm -rf "$TRASHBOX/$1"
      mkdir -p "$TRASHBOX" # in case file is '/'
      rmdir "$TRASHBOX/$(echo "$file" | cut -d / -f 1)" 2> /dev/null || true
    done
  fi
}

# lists all files and directories in the trashbox
function trashbox-list() {
  mkdir -p "$TRASHBOX"
  if find "$TRASHBOX" -mindepth 1 -maxdepth 1 | read; then
    find "$TRASHBOX"/*/* 2> /dev/null | cut -b $(echo "$TRASHBOX " | wc -c)-
  fi
}


