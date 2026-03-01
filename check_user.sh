#!/bin/bash
# Check if a user exists on the system


read -p "Enter a username to check: " alice

# Check if user exits in /etc/passwd
if grep -q "^$alice:" /etc/passwd; then 
    echo "User '$alice' EXISTS on this system"
    echo "User details:"
    grep "^$alice:" /etc/passwd
    echo "Groups: $(groups $alice)"
else 
    echo "User '$alice' does NOT exist"
fi 
