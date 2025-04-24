```
#!/bin/bash

# ==============================
# System Administration Dashboard
# Day 30 Final Project - 30 Days of Bash
# ==============================

touch system_admin.log
log_file="system_admin.log"

# Function to log actions
log_action() {
    echo "$(date) ----> $1" >> $log_file
}


# System Information

get_system_info() {
    echo "===== System Information ====="
    echo "OS Version: $(lsb_release -d | cut -f2)"
    echo "Kernel Version: $(uname -r)"
    echo "CPU Info: $(lscpu | grep 'Model name' | sed 's/Model name:\s*//')"
    echo "Memory Usage:"
    free -h
    echo "Disk Usage:"
    df -h
    log_action "Viewed system information."
}

# ==============================
# User Management
# ==============================
list_users() {
    cut -d: -f1 /etc/passwd
    log_action "Listed all users."
}

add_user() {
    read -p "Enter new username: " username
    sudo adduser "$username"
    log_action "Added user: $username."
}

delete_user() {
    read -p "Enter username to delete: " username
    sudo deluser "$username"
    log_action "Deleted user: $username."
}

modify_user() {
    read -p "Enter username to modify: " username
    echo "1) Change password"
    echo "2) Add to group"
    read -p "Choose an option: " opt
    case $opt in
        1) sudo passwd "$username";;
        2) read -p "Enter group name: " group; sudo usermod -aG "$group" "$username";;
        *) echo "Invalid option";;
    esac
    log_action "Modified user: $username."
}

# ==============================
# Process Management
# ==============================
list_top_processes() {
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 10
    log_action "Listed top CPU-consuming processes."
}

kill_process() {
    read -p "Enter PID or name to kill: " proc
    if [[ $proc =~ ^[0-9]+$ ]]; then
        sudo kill "$proc"
    else
        pkill "$proc"
    fi
    log_action "Killed process: $proc."
}

# ==============================
# Service Management
# ==============================
manage_services() {
    echo "1) List services"
    echo "2) Start service"
    echo "3) Stop service"
    echo "4) Restart service"
    read -p "Choose an option: " opt
    case $opt in
        1) systemctl list-units --type=service;;
        2) read -p "Enter service name: " svc; sudo systemctl start "$svc";;
        3) read -p "Enter service name: " svc; sudo systemctl stop "$svc";;
        4) read -p "Enter service name: " svc; sudo systemctl restart "$svc";;
        *) echo "Invalid option";;
    esac
    log_action "Service management operation performed."
}

# ==============================
# Network Information
# ==============================
display_network_info() {
    echo "IP Configuration:"
    ip a
    echo "Active Connections:"
    ss -tuln
    log_action "Displayed network information."
}

# ==============================
# Log Analysis
# ==============================
view_logs() {
    echo "Recent System Logs:"
    journalctl -n 20
    log_action "Viewed recent system logs."
}

search_logs() {
    read -p "Enter search pattern: " pattern
    journalctl | grep "$pattern"
    log_action "Searched logs for pattern: $pattern."
}

# ==============================
# Backup Utility
# ==============================
create_backup() {
    read -p "Enter directory to backup: " src
    read -p "Enter destination: " dst
    tar -czvf "$dst/backup_$(date +%F).tar.gz" "$src"
    log_action "Created backup of $src to $dst."
}

restore_backup() {
    read -p "Enter backup file path: " backup
    read -p "Enter restore destination: " dst
    tar -xzvf "$backup" -C "$dst"
    log_action "Restored backup from $backup to $dst."
}

# ==============================
# System Update
# ==============================
update_system() {
    echo "Checking for updates..."
    sudo apt update && sudo apt list --upgradable
    read -p "Do you want to apply updates now? (y/n): " choice
    if [[ $choice == "y" ]]; then
        sudo apt upgrade -y
        log_action "System updated."
    else
        echo "Update canceled."
    fi
}

# ==============================
# Main Menu
# ==============================
while true; do
    echo "=============================="
    echo "System Administration Dashboard"
    echo "=============================="
    echo "1) System Information"
    echo "2) User Management"
    echo "3) Process Management"
    echo "4) Service Management"
    echo "5) Network Information"
    echo "6) Log Analysis"
    echo "7) Backup Utility"
    echo "8) System Update"
    echo "9) Exit"
    read -p "Choose an option: " choice

    case $choice in
        1) get_system_info;;
        2)
            echo "a) List users"
            echo "b) Add user"
            echo "c) Delete user"
            echo "d) Modify user"
            read -p "Select sub-option: " sub;
            case $sub in
                a) list_users;;
                b) add_user;;
                c) delete_user;;
                d) modify_user;;
                *) echo "Invalid sub-option";;
            esac
            ;;
        3)
            echo "a) List top processes"
            echo "b) Kill a process"
            read -p "Select sub-option: " sub;
            case $sub in
                a) list_top_processes;;
                b) kill_process;;
                *) echo "Invalid sub-option";;
            esac
            ;;
        4) manage_services;;
        5) display_network_info;;
        6)
            echo "a) View recent logs"
            echo "b) Search logs"
            read -p "Select sub-option: " sub;
            case $sub in
                a) view_logs;;
                b) search_logs;;
                *) echo "Invalid sub-option";;
            esac
            ;;
        7)
            echo "a) Create backup"
            echo "b) Restore backup"
            read -p "Select sub-option: " sub;
            case $sub in
                a) create_backup;;
                b) restore_backup;;
                *) echo "Invalid sub-option";;
            esac
            ;;
        8) update_system;;
        9) echo "Goodbye!"; log_action "Exited script."; exit 0;;
        *) echo "Invalid option, try again.";;
    esac
    echo ""
done
```
