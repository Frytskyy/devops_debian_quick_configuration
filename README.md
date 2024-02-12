# devops_debian_quick_configuration

## MIT License
Copyright (c) 1998-2024 Volodymyr Frytskyy (https://www.vladonai.com/about and https://www.vladonai.com/about-resume)
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# CLI bash script to quickly install/configure the system
This script is designed to streamline the process of setting up a Debian Linux system according to personal preferences. It provides a menu-driven interface that allows users to choose from various configuration options, such as adding a user to sudoers, installing system updates and applications, configuring SSH server, installing LAMB server, installing development tools, setting up security measures, and more.

May be usefuel for DevOps and Developers who need to deploy new <b>Virtual Machine</b> or <b>Kubernete</b> quickly but still to controll the process and monitor the result.

# To install this script from GitHub, follow these steps:
To install this script directly from GitHub and execute it, follow these steps:
1. Open a terminal on your Debian system.
2. Use wget to download the script directly from GitHub. You can use the following command:
  ```
  wget -N "https://raw.githubusercontent.com/Frytskyy/devops_debian_quick_configuration/main/scripts/install_deb.sh"
  ```
3. Give execution permission to the downloaded script:
  ```
  chmod +x install_deb.sh
  ```
4. Run the script:
  ```
  bash install_deb.sh
  ```
5. Follow the on-screen prompts to configure your Linux system according to your preferences.

These instructions will allow users to download the script directly from GitHub, grant execution permission, and execute it without the need for manual extraction.
