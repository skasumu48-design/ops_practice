#!/bin/bash
# sysadmin_toolkit.sh — Interactive menu-driven system administration toolkit

# ─── Helpers ────────────────────────────────────────────────────────────────

pause() {
    echo
    read -rp "Press Enter to continue..."
}

# ─── User Management ────────────────────────────────────────────────────────

list_users() {
    echo "=== Regular Users on this System ==="
    echo
    while IFS=: read -r username password uid gid gecos home shell; do
        if [ "$uid" -ge 1000 ] 2>/dev/null && [ "$uid" -lt 65534 ] 2>/dev/null; then
            echo "Username: $username"
            echo "  UID:   $uid"
            echo "  Home:  $home"
            echo "  Shell: $shell"
            echo
        fi
    done < /etc/passwd
    echo "=== End of List ==="
}

check_user() {
    read -rp "Enter a username to check: " username
    if grep -q "^$username:" /etc/passwd; then
        echo "User '$username' EXISTS on this system."
        echo
        echo "Details:"
        grep "^$username:" /etc/passwd
        echo "Groups: $(groups "$username")"
    else
        echo "User '$username' does NOT exist."
    fi
}

add_user() {
    read -rp "Enter username to create: " username
    if grep -q "^$username:" /etc/passwd; then
        echo "User '$username' already exists."
        return 1
    fi
    sudo useradd -m "$username"
    if [ $? -eq 0 ]; then
        echo "User '$username' created successfully."
        sudo passwd "$username"
    else
        echo "Failed to create user '$username'."
        return 1
    fi
}

user_management_menu() {
    while true; do
        echo
        echo "--- User Management ---"
        echo "1. List regular users"
        echo "2. Check if user exists"
        echo "3. Add a new user"
        echo "4. Back to main menu"
        echo
        read -rp "Choose an option [1-4]: " choice
        echo
        case "$choice" in
            1) list_users ;;
            2) check_user ;;
            3) add_user ;;
            4) return ;;
            *) echo "Invalid option. Please enter 1–4." ;;
        esac
        pause
    done
}

# ─── System Monitor ─────────────────────────────────────────────────────────

system_monitor() {
    echo "--- System Monitor ---"
    echo

    echo "== CPU Usage =="
    top -bn1 | grep "Cpu(s)"
    echo

    echo "== Memory Usage =="
    free -h
    echo

    echo "== Disk Usage =="
    df -h
    echo

    echo "== System Uptime =="
    uptime
}

# ─── Network Info ───────────────────────────────────────────────────────────

show_ip() {
    echo "== IP Addresses =="
    hostname -I
}

ping_test() {
    read -rp "Enter hostname or IP to ping: " host
    echo
    echo "== Pinging $host (4 packets) =="
    ping -c 4 "$host"
}

open_ports() {
    echo "== Open Ports (listening) =="
    ss -tuln
}

pihole_status() {
    if command -v pihole &>/dev/null; then
        echo "== Pi-hole Status =="
        pihole status
    else
        echo "Pi-hole is not installed on this system."
    fi
}

network_info_menu() {
    while true; do
        echo
        echo "--- Network Info ---"
        echo "1. Show IP address"
        echo "2. Ping test"
        echo "3. Show open ports"
        echo "4. Pi-hole status"
        echo "5. Back to main menu"
        echo
        read -rp "Choose an option [1-5]: " choice
        echo
        case "$choice" in
            1) show_ip ;;
            2) ping_test ;;
            3) open_ports ;;
            4) pihole_status ;;
            5) return ;;
            *) echo "Invalid option. Please enter 1–5." ;;
        esac
        pause
    done
}

# ─── Security Check ─────────────────────────────────────────────────────────

security_check() {
    echo "--- Security Check ---"
    echo

    echo "== Users with sudo Privileges =="
    grep "sudo" /etc/group
    echo

    echo "== Last 10 Logins =="
    if command -v last &>/dev/null; then
        last -n 10
    else
        journalctl -u ssh --no-pager 2>/dev/null \
            | grep -i "accepted\|session opened" \
            | tail -n 10
        if [ $? -ne 0 ]; then
            echo "No login history available."
        fi
    fi
    echo

    echo "== Failed Login Attempts =="
    if [ -r /var/log/auth.log ]; then
        grep "Failed password" /var/log/auth.log | tail -n 20
        if ! grep -q "Failed password" /var/log/auth.log; then
            echo "No failed login attempts found."
        fi
    elif command -v journalctl &>/dev/null; then
        journalctl -u ssh --no-pager 2>/dev/null \
            | grep -i "failed" \
            | tail -n 20
        if ! journalctl -u ssh --no-pager 2>/dev/null | grep -qi "failed"; then
            echo "No failed login attempts found."
        fi
    else
        echo "No method available to read login attempts."
    fi
}

# ─── Main Menu ──────────────────────────────────────────────────────────────

main_menu() {
    while true; do
        echo
        echo "============================="
        echo "   System Admin Toolkit"
        echo "============================="
        echo "1. User Management"
        echo "2. System Monitor"
        echo "3. Network Info"
        echo "4. Security Check"
        echo "5. Exit"
        echo
        read -rp "Choose an option [1-5]: " choice
        echo
        case "$choice" in
            1) user_management_menu ;;
            2) system_monitor; pause ;;
            3) network_info_menu ;;
            4) security_check; pause ;;
            5) echo "Goodbye."; exit 0 ;;
            *) echo "Invalid option. Please enter 1–5." ;;
        esac
    done
}

main_menu
