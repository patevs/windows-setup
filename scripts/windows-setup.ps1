# windows-setup.ps1

# Write-Host "Running Environment Checks..." -ForegroundColor "Yellow"

# Check OS and ensure we are running on Windows
# if (-Not ($Env:OS -eq "Windows_NT")) {
#   Write-Host "Error: This script only supports Windows machines. Exiting..."
#   exit 1
# }

# Check PowerShell version
# if (($PSVersionTable.PSVersion.Major) -lt 5) {
#   Write-Output 'PowerShell 5 or later is required. Go to https://microsoft.com/powershell to get the latest version of PowerShell.' -ForegroundColor DarkRed
#   exit 1
# }

# Test if running as administrator
# function Test-IsAdministrator {
#     return ([Security.Principal.WindowsPrincipal]`
#             [Security.Principal.WindowsIdentity]::GetCurrent()`
#     ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
# }

# Test if a given command is available
# function Test-CommandAvailable {
#     param (
#         [Parameter(Mandatory = $True, Position = 0)]
#         [String] $Command
#     )
#     return [Boolean](Get-Command $Command -ErrorAction SilentlyContinue)
# }

# ----------------------------------------

# Create PowerShell profile if it doesn't already exist
# mkdir -Path (Split-Path -Parent $PROFILE) -ErrorAction SilentlyContinue
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType "file" -Force }

# ----------------------------------------

# Run from admin shell

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# ----------------------------------------

# Run from admin shell

# Chocolatey installs
choco install git.install
choco install Firefox
# choco install GoogleChrome
# choco install AndroidStudio
# choco install visualstudio-installer
# choco install visualstudio2026buildtools
# choco install visualstudio2026-workload-nativedesktop
# choco install libreoffice-fresh

# Install Desktop development with C++ workload
# using Visual Studio Installer CLI
# vs_buildtools.exe --quiet --wait --norestart ^
#   --add Microsoft.VisualStudio.Workload.NativeDesktop ^
#   --includeRecommended ^
#   --removeOos true

# ----------------------------------------

# Configure Git
git config --global user.name "Patrick Evans"
git config --global user.username "PatEvs"
git config --global user.email "ppevans11@gmail.com"
git config --global color.ui true
git config --global core.editor "code --wait"   # VS Code
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
# git config --global interactive.diffFilter "diff-so-fancy --patch"
# git config --global init.defaultBranch main
# git config --global alias.st status

# ----------------------------------------

# Install Scoop
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# ----------------------------------------

# Run from admin shell

# Enable LongPaths
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1

# Enable Developer Mode
#
# Source - https://stackoverflow.com/a/40033638
# Posted by David Gardiner
# Retrieved 2026-10-27, License - CC BY-SA 3.0

# Create AppModelUnlock if it doesn't exist, required for enabling Developer Mode
$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
if (-not(Test-Path -Path $RegistryKeyPath)) {
    New-Item -Path $RegistryKeyPath -ItemType Directory -Force
}

# Add registry value to enable Developer Mode
New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1

# ----------------------------------------

# Install NuGet Provider
Install-PackageProvider -Name NuGet -Force

# Install PowerShellGet Module
#
# Note: When you install PowerShellGet, it automatically installs the latest version of PackageManagement.
# https://learn.microsoft.com/en-us/powershell/gallery/powershellget/install-powershellget
Install-Module -Name PowerShellGet -Force

# Install-Module PowerShellGet -Repository PSGallery -Force -AllowClobber
# Install-Module Microsoft.PowerShell.PSResourceGet -Repository PSGallery

# Install or upgrade PSReadLine
Install-Module PSReadLine -Repository PSGallery -Scope CurrentUser -Force

# ----------------------------------------

# Install-Module PSWindowsUpdate
# Import-Module PSWindowsUpdate
# # Check for Windows updates
# Get-WindowsUpdate
# # Install Windows updates
# Install-WindowsUpdate -AcceptAll -AutoReboot # -IgnoreReboot

# ----------------------------------------

# Add scoop buckets
scoop bucket add extras
scoop bucket add versions
scoop bucket add nonportable
scoop bucket add nerd-fonts
scoop bucket add java

# Scoop utilities
scoop install sudo
scoop install gsudo
scoop install 7zip
# Add 7zip as a context menu option by running:
# Invoke-Expression "$(scoop prefix 7zip)\install-context.reg"
scoop install innounp
scoop install dark
scoop install aria2

scoop install scoop-search
scoop install scoop-completion
# Run following command to add scoop-completion to Powershell profile:
# Invoke-Expression "$(scoop prefix scoop-completion)\add-profile-content.ps1"

# Text editors and IDEs
scoop install notepadplusplus
# Add Notepad++ as a context menu option by running:
# Invoke-Expression "$(scoop prefix notepadplusplus)\install-context.reg"
scoop install vscode
# Add Visual Studio Code as a context menu option by running:
# Invoke-Expression "$(scoop prefix vscode)\install-context.reg"
# For file associations, run:
# Invoke-Expression "$(scoop prefix vscode)\install-associations.reg"
# For github integration, run:
# Invoke-Expression "$(scoop prefix vscode)\install-github-integration.reg"

# Command line utilities
scoop install posh-git
# Run the following command to add posh-git to PowerShell profile:
# Add-PoshGitToProfile

# ----------------------------------------

# Install Dracula theme for CMD and PowerShell

# Install ColorTool utility
scoop install colortool
# Move to color schemes directory
cd $(colortool --location)
# Download the Dracula theme
wget https://raw.githubusercontent.com/dracula/powershell/master/theme/Dracula-ColorTool.itermcolors -OutFile Dracula-ColorTool.itermcolors
# Apply the theme
colortool --both Dracula-ColorTool.itermcolors

# Set environment variable `prompt` to the following value:
# $E[1;32;40m→ $E[1;36;40m$p$E[1;35;40m› $E[1;37;40m

# ----------------------------------------

scoop install pwsh
# Add pwsh to explorer context menu option:
# Invoke-Expression "reg import $(scoop prefix pwsh)\install-explorer-context.reg"
# Add pwsh to file context menu option:
# Invoke-Expression "reg import $(scoop prefix pwsh)\install-file-context.reg"

scoop install windows-terminal
# Add Windows Terminal as a context menu option:
# Invoke-Expression "reg import $(scoop prefix windows-terminal)\install-context.reg"

# ----------------------------------------

# Install Hack-NF Nerd Font
# Normal version, Nerd Fonts Symbol/Icon could be 1 or 2 cell wide
scoop install Hack-NF
# Monospace version, Nerd Fonts Symbol/Icon will be always 1 cell wide
scoop install Hack-NF-Mono

# Make 'Hack Nerd Font Mono' an available Console font
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont' 000 'Hack Nerd Font Mono'
# $key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont'
# Get-ItemProperty $key # Print current registry value
# Set-ItemProperty -Path $key -Name '000' -Value 'Hack Nerd Font Mono' -PropertyType String

# ----------------------------------------

# Console utilities
scoop install terminal-icons
scoop install lsd
scoop install bat
scoop install less
scoop install s
# scoop install yazi

# ----------------------------------------

# Configure scoop
scoop config aria2-enabled true
scoop config cat_style default
scoop config use_lessmsi true
scoop config use_sqlite_cache true
scoop config use_git_history true

# ----------------------------------------

# Programming languages and SDKs

# Python 2
# scoop install python27
# Python 3
scoop install python
# Allow applications and third-party installers to find python by running:
# Invoke-Expression "reg import $(scoop prefix python)\install-pep-514.reg"

# Node JS 12
# scoop install nodejs12
# Node JS LTS
scoop install nodejs-lts
# Node JS Latest
# scoop install nodejs

# Java 8
# scoop install ojdkbuild8
# Java 11
# scoop install openjdk11
# Java 17
scoop install openjdk17
# Java latest
# scoop install openjdk
# scoop install oraclejdk-lts

# scoop install dotnet-sdk
scoop install go
scoop install perl
# scoop install flutter
# scoop install ruby
# scoop install rustup

# Development tools
# scoop install msys2
# scoop install mysql-workbench
scoop install yarn

# Git Tools
# scoop install diff-so-fancy
# scoop install gh
# scoop install hub

# System Utilities
scoop install bulk-crap-uninstaller
scoop install snappy-driver-installer-origin

# Applications
scoop install postman
# scoop install libreoffice

# ----------------------------------------

# Python3 Installs

# Update Pip
python3 -m pip install --upgrade pip
# python3 -m pip install --upgrade setuptools
# python3 -m pip install --upgrade wheel

# ----------------------------------------

# NPM Installs

# Update NPM
npm install --global npm

# npm install --global add-gitignore
npm install --global check-it-out
# npm install --global del-cli
npm install --global diff-so-fancy
npm install --global gitmoji-cli
npm install --global npm-check-updates
# npm install --global typescript

# ----------------------------------------

# VS Code extensions

code --install-extension dracula-theme.theme-dracula
code --install-extension vscode-icons-team.vscode-icons
code --install-extension WakaTime.vscode-wakatime
code --install-extension riussi.code-stats-vscode
code --install-extension editorconfig.editorconfig

# aaron-bond.better-comments
# alefragnani.project-manager
# christian-kohler.npm-intellisense
# dart-code.dart-code
# dart-code.flutter
# davidanson.vscode-markdownlint
# dbaeumer.vscode-eslint
# editorconfig.editorconfig
# esbenp.prettier-vscode
# formulahendry.auto-close-tag
# formulahendry.auto-rename-tag
# golang.go
# kamranbekirov.flutter-pubgrade
# mariusschulz.yarn-lock-syntax
# ms-vscode.powershell
# oderwat.indent-rainbow
# pkief.material-icon-theme
# tomoki1207.pdf
# yzhang.markdown-all-in-on

# ----------------------------------------

# Install Android SDK, platforms, build-tools,
# and platform-tools using Android Command Line Tools
# sdkmanager "platform-tools" \
#            "platforms;android-34" \
#            "build-tools;34.0.0" \
#            "cmdline-tools;latest"

# Accept Android licenses
# yes | sdkmanager --licenses

# ----------------------------------------
