#!/bin/bash

# Set the base URL
BASE_URL="https://league-curriculum.github.io/images"

# Set the directory to scan
DIRECTORY="."

# Create the README.md file
README_FILE="README.md"

# Start the Markdown file
echo "# Site Map" > $README_FILE
echo "" >> $README_FILE
echo "| Link | Image |" >> $README_FILE
echo "| ---- | ----- |" >> $README_FILE

# Function to recursively list files and create Markdown links
list_files() {
  local DIR=$1
  local REL_DIR=$2

  for FILE in "$DIR"/*; 
  do
    if [ -d "$FILE" ]; then
      list_files "$FILE" "$REL_DIR/$(basename "$FILE")"
    else
      local REL_PATH="$REL_DIR/$(basename "$FILE")"
      local URL="$BASE_URL$REL_PATH"
      echo "| [${REL_PATH##*/}]($URL) | ![${REL_PATH##*/}]($URL){:height=\"200px\" width=\"200px\"} |" >> $README_FILE
    fi
  done
}

# Call the function with the initial directory
list_files "$DIRECTORY" ""

echo "README.md file has been created successfully."
