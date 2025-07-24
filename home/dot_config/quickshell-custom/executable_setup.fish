#!/usr/bin/env fish

# Define the target directory
set state_dir "$HOME/.local/state/quickshell"
set wallpaper_dir "$state_dir/wallpaper"

# Check if the directory exists
if not test -d $state_dir
    echo "Creating directory: $state_dir"
    mkdir -p $state_dir
else
    echo "Directory already exists: $state_dir"
end

# Create wallpaper subdirectory if it doesn't exist
if not test -d $wallpaper_dir
    echo "Creating directory: $wallpaper_dir"
    mkdir -p $wallpaper_dir
else 
    echo "Directory already exists: $wallpaper_dir"
end

# Create scheme.json if it doesn't exist
set scheme_file "$state_dir/scheme.json"
if not test -e $scheme_file
    echo "Creating file: $scheme_file"
    echo '{}' > $scheme_file
end

# Create sequences.txt if it doesn't exist
set sequences_file "$state_dir/sequences.txt"
if not test -e $sequences_file
    echo "Creating file: $sequences_file"
    touch $sequences_file
end

# Create wallpaper/path.txt if it doesn't exist
set path_file "$wallpaper_dir/path.txt"
if not test -e $path_file
    echo "Creating file: $path_file"
    touch $path_file
end

echo "Setup complete."
