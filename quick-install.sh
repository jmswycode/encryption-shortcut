#!/bin/bash


#-----------------------------------------------------------
# The author generated this text in part with GPT‑4o, OpenAI’s large-scale
# language-generation model. Upon generating draft language, the author 
# reviewed, edited, and revised the language to their own liking and takes
# ultimate responsibility for the content of this publication.
#-----------------------------------------------------------
# get sources: https://github.com/jmswycode/encryption-shortcut
#-----------------------------------------------------------

# Function to check and install packages
install_if_not_exists() {
    if ! dpkg -l | grep -q "^ii  $1 "; then
        sudo apt install -y "$1"
    else
        echo "$1 is already installed, skipping installation."
    fi
}

# Check and install required packages
install_if_not_exists git
install_if_not_exists xdotool
install_if_not_exists openssl

# Check if using X11, install xclip if true
if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    install_if_not_exists xclip
fi

# Check if using Wayland, install wl-clipboard if true
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    install_if_not_exists wl-clipboard
fi

# Verify installation
if command -v git &>/dev/null && command -v xdotool &>/dev/null && command -v openssl &>/dev/null && { [ "$XDG_SESSION_TYPE" != "wayland" ] || command -v wl-copy &>/dev/null; } && { [ "$XDG_SESSION_TYPE" != "x11" ] || command -v xclip &>/dev/null; }; then
    echo "All packages have been successfully installed."
else
    echo "Failed to install one or more packages. Please check the log above."
fi


# Check if ~/.encryption-shortcuts folder exists, if not, download it from GitHub
if [ ! -d "$HOME/.encryption-shortcuts" ]; then
    if [ ! -d ".encryption-shortcuts" ]; then
        echo "Folder .encryption-shortcuts not found. Downloading from GitHub..."
        git clone --depth=1 --filter=blob:none --sparse https://github.com/jmswycode/encryption-shortcuts.git temp_repo
        cd temp_repo
        git sparse-checkout set .encryption-shortcuts
        mv .encryption-shortcuts ../
        cd ..
        rm -rf temp_repo
        echo "Folder .encryption-shortcuts has been downloaded."
    fi
    # Move .encryption-shortcuts folder to the user's home directory
    mv -f .encryption-shortcuts ~/
    echo "Folder .encryption-shortcuts has been moved to the user's home directory."
else
    echo "Folder .encryption-shortcuts already exists in the home directory. Skipping download."
fi


# Set execute permission for encdec_shortcuts.sh
chmod +x ~/.encryption-shortcuts/encdec_shortcuts.sh
echo "Execute permission has been set for encdec_shortcuts.sh."
echo "You can change the encryption password and other configurations in '$HOME/.encryption-shortcuts/encdec_shortcuts.sh'."

# Add keyboard shortcuts using xbindkeys
XBINDSKEYS_CONFIG=~/.xbindkeysrc

# Ensure xbindkeys is installed
install_if_not_exists xbindkeys

# Add shortcuts if not already present
if ! grep -q "bash ~/.encryption-shortcuts/encdec_shortcuts.sh encrypt" "$XBINDSKEYS_CONFIG"; then
    echo '"bash ~/.encryption-shortcuts/encdec_shortcuts.sh encrypt"' >> "$XBINDSKEYS_CONFIG"
    echo '  Control+Shift+E' >> "$XBINDSKEYS_CONFIG"
fi

if ! grep -q "bash ~/.encryption-shortcuts/encdec_shortcuts.sh decrypt" "$XBINDSKEYS_CONFIG"; then
    echo '"bash ~/.encryption-shortcuts/encdec_shortcuts.sh decrypt"' >> "$XBINDSKEYS_CONFIG"
    echo '  Control+Shift+G' >> "$XBINDSKEYS_CONFIG"
fi

echo "Keyboard shortcuts have been added."

# Restart xbindkeys to apply changes
xbindkeys
pkill xbindkeys || true
xbindkeys

echo "Keyboard shortcut configuration completed."
echo "You can change the encryption and decryption shortcut keys in the .xbindkeysrc file located at: '$HOME/.xbindkeysrc'."

