#!/bin/bash

#to llaunch this script use this command:
#   bash install_deb.sh


# Function to update package lists
function update_packages 
{
    sudo apt update
}

# Function to display the menu
function show_menu 
{
    # Color codes
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    BOLD='\033[1m'
    NC='\033[0m' # No Color

    # Menu items
    echo -e "${BLUE}${BOLD}Choose what you want to do:${NC}"  # Blue and bold text for the menu title
    echo -e "${YELLOW}${BOLD}1)${NC} Execute all steps"        # Yellow and bold text for menu items
    echo -e "${YELLOW}${BOLD}2)${NC} Add user to sudoers"
    echo -e "${YELLOW}${BOLD}3)${NC} Install system updates and applications (mc, bashtop, glances, bpytop, snap, nmap, mate-system-monitor)"
    echo -e "${YELLOW}${BOLD}4)${NC} Install ${BOLD}Wine${NC}"  # Yellow and bold text for menu items
    echo -e "${YELLOW}${BOLD}5)${NC} Configure SSH server (generate keys, set port 3444)"
    echo -e "${YELLOW}${BOLD}6)${NC} Install LAMB (Apache + MySQL + Email + PHP + domain h2.vladonai.com)"
    echo -e "${YELLOW}${BOLD}7)${NC} Install additional development/administration tools (GCC, Python, Perl, Git, QT Creator, Arduino development tools, visual GIT tools)"
    echo -e "${YELLOW}${BOLD}8)${NC} Configure security (iptables firewall, open ports for mail, 80, 443, ssh, fail2ban)"
    echo -e "${YELLOW}${BOLD}9)${NC} Install VMWare Guest Additions"
    echo -e "${YELLOW}${BOLD}10)${NC} Exit"
}

# Function to execute all steps
function install_step_execute_all 
{
    install_step_add_sudo_user
    update_packages
    install_step_install_apps
    install_step_install_wine
    configure_ssh_server
    install_lamb_stack
    install_additional_tools
    configure_security
}

# Function to add a user to sudoers
function install_step_add_sudo_user 
{
    read -p "Enter the username to add to sudoers: " username

    if [ -z "$username" ]; then
        echo "Error: Username cannot be empty."
        return 1
    fi
    
    if ! id "$username" &>/dev/null; then
        echo "Error: User '$username' does not exist."
        return 1
    fi

    sudo /usr/sbin/usermod -aG sudo $username
    if [ $? -eq 0 ]; then
        echo "User $username added to sudoers."
    else
        echo "Error: Failed to add user $username to sudoers."
        return 1
    fi
}

# Function to install applications
function install_step_install_apps 
{
    update_packages

	#install Visual Studio Code:
    echo "Installing Visual Studio Code..."
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
	sudo apt update
	sudo apt install code

    #install other apps
    apps=(mc passwd bashtop glances bpytop snap nmap doublecmd-gtk mate-system-monitor)
    for app in "${apps[@]}"; do
        echo "Installing $app..."
        sudo apt-get install -y $app
    done
    echo "Applications installed successfully."
}

# Function to install Wine
function install_step_install_wine {
    sudo apt-get install -y wine
    echo "Wine installed successfully."
}

# Function to configure SSH server
function configure_ssh_server 
{
    ssh-keygen -t rsa
    sudo sed -i 's/#Port 22/Port 3444/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
    echo "SSH server configured. Port set to 3444."
}

# Function to install LAMB stack
function install_lamb_stack 
{
    sudo apt-get install -y apache2 mysql-server php libapache2-mod-php
    sudo systemctl enable apache2
    sudo systemctl start apache2
    sudo apt-get install -y mailutils
    # Additional configuration for email setup goes here
    echo "LAMB stack installed successfully."
}

# Function to install additional development/administration tools
function install_additional_tools {
    sudo apt-get install -y gcc perl git qtcreator arduino python
    # Additional development tools installation goes here
    echo "Additional development/administration tools installed successfully."
}

# Function to configure security
function configure_security {
    sudo apt-get install -y iptables
    # Configure iptables
    # Open ports for mail, 80, 443, ssh
    sudo iptables -A INPUT -p tcp --dport 25 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 3444 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    # Install and configure fail2ban
    sudo apt-get install -y fail2ban
    # Additional security configurations go here
    echo "Security configuration completed successfully."
}

# Function to install VMWare Guest Additions
function install_step_install_vmware_guest_additions 
{
    sudo apt-get install -y open-vm-tools-desktop
    echo "VMWare Guest Additions installed successfully."
}

# Main code
while true; do
    show_menu
    read -p "Select an option (1-10, or q): " choice
    case $choice in
        1) install_step_execute_all ;;
        2) install_step_add_sudo_user ;;
        3) install_step_install_apps ;;
        4) install_step_install_wine ;;
        5) configure_ssh_server ;;
        6) install_lamb_stack ;;
        7) install_additional_tools ;;
        8) configure_security ;;
        9) install_step_install_vmware_guest_additions ;;
        q) break ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done
