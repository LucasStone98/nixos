#!/bin/bash

# Directory for wallpapers
wallpapers_dir="$HOME/wallpapers"

# Function to check if base URL is reachable
check_base_url() {
    local base_url="https://peapix.com"
    if curl --silent --fail "$base_url" >/dev/null; then
        return 0 # URL reachable
    else
        return 1 # URL not reachable
    fi
}

# Function to delete excess wallpapers if more than 5
delete_excess_wallpapers() {
    local num_wallpapers
    num_wallpapers=$(ls -1 "$wallpapers_dir" | wc -l)

    if [ "$num_wallpapers" -gt 5 ]; then
        excess_wallpapers=$((num_wallpapers - 1))
        echo "Deleting $excess_wallpapers excess wallpapers..."

        # Delete excess wallpapers randomly
        for ((i = 1; i <= excess_wallpapers; i++)); do
            random_wallpaper=$(ls "$wallpapers_dir" | shuf -n 1)
            rm "$wallpapers_dir/$random_wallpaper"
        done
    fi
}

# Check if base URL is reachable
if check_base_url; then
    echo "Base URL is reachable."
else
    echo "Base URL is not reachable. Setting wallpaper from local directory..."
    feh --bg-fill "$(ls "$wallpapers_dir" | shuf -n 1)"
    exit 1
fi

# Check and delete excess wallpapers
delete_excess_wallpapers

# Array of country codes
countries=("au" "br" "ca" "cn" "de" "fr" "in" "it" "jp" "es" "gb" "us")

# Function to download image
download_image() {
    local wallpaper_url=$1
    local wallpaper_filename
    wallpaper_filename=$(basename "$wallpaper_url")

    if [ ! -f "$wallpapers_dir/$wallpaper_filename" ]; then
        wget -q "$wallpaper_url" -P "$wallpapers_dir"
    else
        echo "Wallpaper $wallpaper_filename already exists."
        return 1
    fi
}

# Loop to find a unique wallpaper
unique_wallpaper_found=false
while [ "$unique_wallpaper_found" = false ]; do
    # Select a random country code
    random_country=${countries[$RANDOM % ${#countries[@]}]}

    # URL with the random country code
    url="https://peapix.com/bing/feed?country=${random_country}"

    # Fetch the JSON data
    json=$(curl -s "$url")

    # Extract the count of datasets
    count=$(echo "$json" | jq length)

    # Generate a random index within the dataset count
    random_index=$(( RANDOM % count ))

    # Extract the imageUrl using jq
    wallpaper=$(echo "$json" | jq -r ".[$random_index].imageUrl")

    # Download the image if it doesn't exist in the wallpapers directory
    download_image "$wallpaper"

    # Check if the image was successfully downloaded
    if [ $? -eq 0 ]; then
        echo "Downloaded wallpaper: $(basename "$wallpaper")"
        unique_wallpaper_found=true
    fi
done

# Set downloaded image as wallpaper using feh
feh --bg-fill "$wallpapers_dir/$(basename "$wallpaper")"


