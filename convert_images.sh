#!/bin/bash

# Define the source folder where the .png files are located
source_folder="./"

# Define the destination folders for different sizes
large_folder="./static/images/large"
medium_folder="./static/images/medium"
small_folder="./static/images/small"

# Use find to locate all .png files in the source folder
find "$source_folder" -maxdepth 1 -type f -name "*.png" | while read -r png_file; do
    # Get the filename without the path
    file_name=$(basename "$png_file")

    # Print the file name and exit
    echo "Processing $file_name"

    # Resize and copy to the large folder (1024x1024)
    sips --resampleWidth 1024 "$png_file" --out "$large_folder/$file_name"
    /Applications/ImageOptim.app/Contents/MacOS/ImageOptim "$large_folder/$file_name" >/dev/null 2>&1
    echo "Wrote $large_folder/$file_name and optimized it"

    # Resize and copy to the medium folder (256x256)
    sips --resampleWidth 256 "$png_file" --out "$medium_folder/$file_name"
    /Applications/ImageOptim.app/Contents/MacOS/ImageOptim "$medium_folder/$file_name" >/dev/null 2>&1
    echo "Wrote $medium_folder/$file_name and optimized it"

    # Resize and copy to the small folder (128x128)
    sips --resampleWidth 128 "$png_file" --out "$small_folder/$file_name"
    /Applications/ImageOptim.app/Contents/MacOS/ImageOptim "$small_folder/$file_name" >/dev/null 2>&1
    echo "Wrote $small_folder/$file_name and optimized it"

    # Delete the original file
    rm "$png_file"
done

echo "Done!"
