#============================================================================
# Author      : Muhammad Bilal Saleem
# Date        : March 3, 2023
# Copyright   : (c) Reserved
# Description : UNIX Recycle Bin Scripts
#============================================================================
#!/bin/bash

# check if filename is provided
if [ -z "$1" ]; then
  echo "Error: No filename provided."
  exit 1
fi

# check if file exists in recyclebin
if ! [ -f "$HOME/recyclebin/$1" ]; then
  echo "Error: File does not exist in recyclebin."
  exit 1
fi

# get original path from restore.info
original_path=$(grep "$1" "$HOME/.restore.info" | cut -d' ' -f2)

# check if original path exists
if ! [ -d "$(dirname "$original_path")" ]; then
  # recreate directory if necessary
  echo "Recreating directory: $(dirname "$original_path")"
  mkdir -p "$(dirname "$original_path")"
fi

# check if file already exists in target directory
if [ -f "$original_path" ]; then
  read -p "File already exists. Do you want to overwrite? (y/n) " overwrite
  if ! [[ "$overwrite" =~ ^[Yy].* ]]; then
    echo "File not restored."
    exit 0
  fi
fi

# restore file to original location
mv "$HOME/recyclebin/$1" "$original_path"

# remove entry from restore.info
sed -i "/$1/d" "$HOME/.restore.info"

echo "File has been restored to: $original_path"

