#============================================================================
# Author      : Muhammad Bilal Saleem
# Date        : March 3, 2023
# Copyright   : (c) Reserved
# Description : UNIX Recycle Bin Scripts
#============================================================================
#!/bin/bash

# Create the recycle bin directory if it doesn't exist
RECYCLE_BIN=$HOME/recyclebin
if [ ! -d "$RECYCLE_BIN" ]; then
    mkdir "$RECYCLE_BIN"
fi

# Function to check if file exists
function file_exists {
    if [ ! -e "$1" ]; then
        echo "recycle: cannot remove '$1': No such file or directory"
        exit 1
    fi
}

# Function to prompt for confirmation
function prompt_confirm {
    read -r -p "recycle: remove regular file '$1'? " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Function to move file to recycle bin and record info in restore.info
function move_to_recycle_bin {
    FILENAME=$(basename "$1")
    INODE=$(ls -i "$1" | awk '{print $1}')
    mv "$1" "$RECYCLE_BIN/$FILENAME"_"$INODE"
    echo "$FILENAME"_"$INODE:${PWD}/$1" >> "$HOME/.restore.info"
}

# Function to remove file or directory
function remove_file_or_directory {
    if [ -f "$1" ]; then
        if [ "$VERBOSE" = true ]; then
            echo "recycle: removing '$1'"
        fi
        if [ "$INTERACTIVE" = true ]; then
            prompt_confirm "$1" || return
        fi
        move_to_recycle_bin "$1"
    elif [ -d "$1" ]; then
        if [ "$VERBOSE" = true ]; then
            echo "recycle: removing directory '$1'"
        fi
        if [ "$INTERACTIVE" = true ]; then
            prompt_confirm "$1" || return
        fi
        for file in "$1"/*; do
            if [ -e "$file" ]; then
                remove_file_or_directory "$file"
            fi
        done
        rmdir "$1"
    else
        echo "recycle: cannot remove '$1': Not a directory or regular file"
        exit 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]
do
    case "$1" in
        -i|--interactive)
            INTERACTIVE=true
            ;;
        -v|--verbose)
            VERBOSE=true
            ;;
        -r|--recursive)
            RECURSIVE=true
            ;;
        -*)
            echo "recycle: invalid option -- '$1'"
            exit 1
            ;;
        *)
            if [ "$RECURSIVE" = true ]; then
                remove_file_or_directory "$1"
            else
                file_exists "$1"
                remove_file_or_directory "$1"
                break
            fi
            ;;
    esac
    shift
done

# If no arguments were provided, display error message
if [ $# -eq 0 ]; then
    echo "recycle: missing operand"
    exit 1
fi

