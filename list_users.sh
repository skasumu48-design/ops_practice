#!/bin/bash
# list all regular users (UID > 1000)

echo "=== Regular Users on this System  ===="
echo

# Read /etc/passwd line by line
while IFS=: read -r username password uid gid gecos home shell; do
    # Only show users with UID > 1000 and < 65534
    if [ "$uid" -ge 1000 ] 2>/dev/null && [ "$uid" -lt 65534 ] 2>/dev/null; then 
        echo "Username: $username"
        echo " UID: $uid"
        echo " Home: $home"
        echo " Shell: $shell"
        echo
    fi
done < /etc/passwd

echo "=== End of List ===="
