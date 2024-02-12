#!/bin/bash

# To llaunch this script use this command:
#   bash install_deb.sh
#
# Part of https://github.com/Frytskyy/devops_debian_quick_configuration/tree/main
# MIT License
# Copyright (c) 1998-2024 Volodymyr Frytskyy (https://www.vladonai.com/about and https://www.vladonai.com/about-resume)


# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to update package lists
function update_packages 
{
    sudo apt update
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
        echo -e "${RED}Error: Username cannot be empty.${NC}"
        return 1
    fi
    
    if ! id "$username" &>/dev/null; then
        echo -e "${RED}Error: User '$username' does not exist.${NC}"
        return 1
    fi

    sudo /usr/sbin/usermod -aG sudo $username
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}User $username added to sudoers.${NC}"
    else
        echo -e "${RED}Error: Failed to add user $username to sudoers.${NC}"
        return 1
    fi
}

# Function to install applications
function install_step_install_apps 
{
    update_packages

    # Install Visual Studio Code
    echo -e "${CYAN}Installing Visual Studio Code...${NC}"
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt update
    sudo apt install code

    # Install other apps
    apps=(mc passwd bashtop glances bpytop snap nmap doublecmd-gtk mate-system-monitor)
    for app in "${apps[@]}"; do
        echo -e "${CYAN}Installing $app...${NC}"
        sudo apt-get install -y $app
    done
    echo -e "${GREEN}Finished installing Applications.${NC}"
}

# Function to install Wine
function install_step_install_wine 
{
    if sudo apt-get install -y wine; then
        echo -e "${GREEN}Wine installed successfully.${NC}"
    else
        echo -e "${RED}Error: Wine installation failed.${NC}"
    fi
}

# Function to configure SSH server
function configure_ssh_server 
{
    if ssh-keygen -t rsa && \
       sudo sed -i 's/#Port 22/Port 3444/' /etc/ssh/sshd_config && \
       sudo systemctl restart ssh; then
        echo -e "${GREEN}SSH server configured. Port set to 3444.${NC}"
    else
        echo -e "${RED}Error: SSH server configuration failed.${NC}"
    fi
}

# Function to install LAMB stack
function install_lamb_stack 
{
    if sudo apt-get install -y apache2 mysql-server php libapache2-mod-php && \
       sudo systemctl enable apache2 && \
       sudo systemctl start apache2 && \
       sudo apt-get install -y mailutils; then
        echo -e "${GREEN}LAMB stack installed successfully.${NC}"
    else
        echo -e "${RED}Error: LAMB stack installation failed.${NC}"
    fi
}

# Function to install additional development/administration tools
function install_additional_tools 
{
    if sudo apt-get install -y gcc perl git qtcreator arduino python; then
        echo -e "${GREEN}Additional development/administration tools installed successfully.${NC}"
    else
        echo -e "${RED}Error: Installation of additional tools failed.${NC}"
    fi
}

# Function to configure security
function configure_security 
{
    # Configure iptables
    # Open ports for mail, 80, 443, ssh
    # Install and configure fail2ban
    if sudo apt-get install -y iptables && \
       sudo iptables -A INPUT -p tcp --dport 25 -j ACCEPT && \
       sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT && \
       sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT && \
       sudo iptables -A INPUT -p tcp --dport 3444 -j ACCEPT && \
       sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT && \
       sudo apt-get install -y fail2ban; then
        echo -e "${GREEN}Security configuration completed successfully.${NC}"
    else
        echo -e "${RED}Error: Security configuration failed.${NC}"
    fi
}

# Function to install VMWare Guest Additions
function install_step_install_vmware_guest_additions 
{
    if sudo apt-get install -y open-vm-tools-desktop; then
        echo -e "${GREEN}VMWare Guest Additions installed successfully.${NC}"
    else
        echo -e "${RED}Error: Installation of VMWare Guest Additions failed.${NC}"
    fi
}


# Function to display the menu
function show_menu 
{
    # Menu items
    echo -e "${BLUE}${BOLD}Choose what you want to do:${NC}"  # Blue and bold text for the menu title
    echo -e "${YELLOW}${BOLD}1)${NC} Execute ${BOLD}all steps${NC}"        # Yellow and bold text for menu items
    echo -e "${YELLOW}${BOLD}2)${NC} Add user to ${BOLD}sudoers${NC}"
    echo -e "${YELLOW}${BOLD}3)${NC} Install ${BOLD}system updates${NC} + ${BOLD}applications${NC} (mc, bashtop, glances, bpytop, snap, nmap, mate-system-monitor)"
    echo -e "${YELLOW}${BOLD}4)${NC} Install ${BOLD}Wine${NC}"  # Yellow and bold text for menu items
    echo -e "${YELLOW}${BOLD}5)${NC} Configure ${BOLD}SSH${NC} server (generate keys, set port 3444)"
    echo -e "${YELLOW}${BOLD}6)${NC} Install ${BOLD}LAMB${NC} (Apache + MySQL + Email + PHP + domain h2.vladonai.com)"
    echo -e "${YELLOW}${BOLD}7)${NC} Install additional ${BOLD}development${NC}/administration tools (GCC, Python, Perl, Git, QT Creator, Arduino development tools, visual GIT tools)"
    echo -e "${YELLOW}${BOLD}8)${NC} ${BOLD}Configure security${NC} (iptables firewall, open ports for mail, 80, 443, ssh, fail2ban)"
    echo -e "${YELLOW}${BOLD}9)${NC} Install ${BOLD}VMWare${NC} Guest Additions"
    echo -e "${YELLOW}${BOLD}q)${NC} Exit"
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
        *) echo -e "${RED}Invalid choice. Please try again.${NC}" ;;
    esac
done
