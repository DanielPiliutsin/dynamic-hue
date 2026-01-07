if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting
# Get a list of all image files in the greetingImg directory
set image_files (ls $HOME/.config/fish/assets/greetingImg/*)

# Select a random image from the list
set random_image (random choice $image_files)

# Display the selected image using Kitty's icat
kitty +kitten icat --align left $random_image 