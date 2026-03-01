#!/bin/bash
# Add a new user to the system

read -p "Enter username to create: " username

# Check if user already exists
if grep -q "^$username:" /etc/passwd; then
    echo "User '$username' already exists."
    exit 1
fi

# Create the user with a home directory
sudo useradd -m "$username"

if [ $? -eq 0 ]; then
    echo "User '$username' created successfully."
    sudo passwd "$username"
else
    echo "Failed to create user '$username'."
    exit 1
fi
