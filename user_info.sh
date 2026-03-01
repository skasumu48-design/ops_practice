#!/bin/bash
# Script to gather user information


echo "---- User Information Gathering  -----"
echo

# Get user input
read -p "Enter your name:" name
read -p "Enter your age:" age
read -p "Enter your favourite linux command:" command 


# Display the information 
echo 
echo "========== Summary =========="
echo "Name: $name"
echo "Age: $age"
echo "Favorite command: $command"
echo "You are logged in as: $(whoami)"
echo "Home directory: $HOME"
echo "=============================" 
