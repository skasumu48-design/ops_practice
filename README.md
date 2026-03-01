# ops_practice

A collection of bash scripts for learning Linux system administration basics on a Raspberry Pi.

## Scripts

| Script | Description |
|---|---|
| `hello.sh` | Print current user, directory, and date |
| `list_users.sh` | List all regular users (UID 1000–65533) from `/etc/passwd` |
| `check_user.sh` | Check if a given username exists on the system |
| `user_info.sh` | Interactively gather and display user information |
| `add_user.sh` | Add a new user to the system with a home directory and password |
| `sysadmin_toolkit.sh` | Interactive menu-driven toolkit combining all of the above plus system monitoring, network info, and security checks |

## Usage

```bash
bash hello.sh
bash list_users.sh
bash check_user.sh
bash user_info.sh
bash add_user.sh
```

### Toolkit (recommended entry point)

```bash
bash sysadmin_toolkit.sh
```

The toolkit presents an interactive menu with four sections:

```
===========================
   System Admin Toolkit
===========================
1. User Management
2. System Monitor
3. Network Info
4. Security Check
5. Exit
```

| Section | What it does |
|---|---|
| User Management | List regular users, check if a user exists, add a new user |
| System Monitor | CPU usage, memory usage, disk usage, system uptime |
| Network Info | Show IP address, ping test (prompts for host), open/listening ports |
| Security Check | Users with sudo privileges, last 10 logins, failed login attempts |

> **Note:** Adding a user and reading `/var/log/auth.log` require `sudo` privileges.
