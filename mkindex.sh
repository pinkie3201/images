#!/bin/bash

# Set the base URL
BASE_URL="https://images.jointheleague.org"

# Set the directory to scan
DIRECTORY="."

# Create the top-level README.md file
TOP_LEVEL_README="README.md"

# Function to list image files in a directory and create a README.md file
list_images() {
  local DIR=$1
  local REL_DIR=$2

  # Create the directory-specific README.md file
  local README_FILE="$DIR/README.md"

  echo "# Images in ${REL_DIR:-Root Directory}" > $README_FILE
  echo "" >> $README_FILE
  echo "<!-- This README lists all image files in the ${REL_DIR:-root} directory -->" >> $README_FILE
  echo "<table>" >> $README_FILE
  echo "  <tr>" >> $README_FILE
  echo "    <th>Link</th>" >> $README_FILE
  echo "    <th>Image</th>" >> $README_FILE
  echo "  </tr>" >> $README_FILE

  local FILE_COUNT=0
  for FILE in "$DIR"/*; 
  do
    if [ -f "$FILE" ]; then
      case "$FILE" in
        *.png|*.jpg|*.jpeg|*.gif|*.bmp|*.tiff)
          local REL_PATH="$REL_DIR/$(basename "$FILE")"
          local URL="$BASE_URL$REL_PATH"
          echo "  <tr>" >> $README_FILE
          echo "    <td><a href=\"$URL\">${REL_PATH##*/}</a></td>" >> $README_FILE
          echo "    <td><img src=\"$URL\" alt=\"${REL_PATH##*/}\" style=\"max-width:200px; max-height:200px;\"></td>" >> $README_FILE
          echo "  </tr>" >> $README_FILE
          FILE_COUNT=$((FILE_COUNT+1))
          ;;
      esac
    fi
  done

  if [ $FILE_COUNT -gt 0 ]; then
    echo "</table>" >> $README_FILE
    echo "" >> $README_FILE
  else
    # Remove the README.md file if no image files were found
    rm $README_FILE
  fi

  # Add to top-level README table of contents if a README.md was created
  if [ -f "$README_FILE" ]; then
    local TOC_LINK="[${REL_DIR:-Root Directory}](${REL_DIR:-.}/README.md)"
    echo "- $TOC_LINK" >> toc.tmp
  fi
}

# Function to recursively process directories
process_directories() {
  local DIR=$1
  local REL_DIR=$2

  list_images "$DIR" "$REL_DIR"

  for SUB_DIR in "$DIR"/*; 
  do
    if [ -d "$SUB_DIR" ]; then
      process_directories "$SUB_DIR" "$REL_DIR/$(basename "$SUB_DIR")"
    fi
  done
}

# Ensure the toc.tmp file is empty
> toc.tmp

# Start processing directories from the initial directory
 awk '/<!-- start generated content -->/ {exit} {print}' README.md > readme_top.md
 echo "<!-- start generated content -->" >> readme_top.md
 echo "" >> readme_top.md
 
process_directories "$DIRECTORY" ""

#echo "" >> $TOP_LEVEL_README
cat readme_top.md toc.tmp >> $TOP_LEVEL_README
rm toc.tmp
rm readme_top.md

echo "README.md files have been created successfully."

git commit -a -m'Update'
git push
