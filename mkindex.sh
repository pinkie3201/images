#!/bin/bash

# Set the base URL
BASE_URL="https://league-curriculum.github.io/images"

# Set the directory to scan
DIRECTORY="."

# Create the index.html file
INDEX_FILE="index.html"

# Start the HTML file
echo "<!DOCTYPE html>" > $INDEX_FILE
echo "<html>" >> $INDEX_FILE
echo "<head>" >> $INDEX_FILE
echo "  <title>Site Map</title>" >> $INDEX_FILE
echo "</head>" >> $INDEX_FILE
echo "<body>" >> $INDEX_FILE
echo "  <h1>Site Map</h1>" >> $INDEX_FILE
echo "  <ul>" >> $INDEX_FILE

# Function to recursively list files and create HTML links
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
      echo "    <li><a href=\"$URL\">$REL_PATH</a></li>" >> $INDEX_FILE
    fi
  done
}

# Call the function with the initial directory
list_files "$DIRECTORY" ""

# End the HTML file
echo "  </ul>" >> $INDEX_FILE
echo "</body>" >> $INDEX_FILE
echo "</html>" >> $INDEX_FILE

echo "index.html file has been created successfully."
