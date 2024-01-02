#/usr/bin/bash
cd /home/vnuxa/
file_path="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# file_path="./Documents/test.txt"
# Add your transfer.sh upload logic here
# For example:
# echo --upload-file "$file_path" https://transfer.sh/"$(basename "$file_path")" 
url="https://transfer.sh/"$(basename "$file_path") 
# echo curl --upload-file $file_path $url

upload_url=$(curl --upload-file $file_path $url)
# echo upload url $upload_url
#!/bin/bash
# file_path="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# upload_url=$(curl --progress-bar --upload-file "$file_path" https://transfer.sh/"$(basename "$file_path")")
echo "$upload_url" | wl-copy

# curl --upload-file ./hello.txt 
