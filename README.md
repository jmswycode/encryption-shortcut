<h1 align="center">Encrypting Text Using Keyboard Shortcuts: Quickly Hiding Messages</h1>

[![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black)](#)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu&logoColor=white)](#)
[![Debian](https://img.shields.io/badge/Debian-A81D33?logo=debian&logoColor=fff)](#)
[![Open Source](https://img.shields.io/badge/Open%20Source-Initiative-3DA639?logo=opensourceinitiative&logoColor=white&labelColor=5A5A5A)](#) 
[![OpenSSL](https://img.shields.io/badge/OpenSSL-721412?logo=openssl&logoColor=white)](#)
[![X11](https://img.shields.io/badge/X11-Window%20System-FF6600?logo=x.org&logoColor=white)](#)
[![Wayland](https://img.shields.io/badge/Wayland-Display%20Server-1793D1?logo=wayland&logoColor=white)](#)
[![Bash](https://img.shields.io/badge/Bash-5A5A5A?logo=gnu-bash&logoColor=white)](#)
[![APT](https://img.shields.io/badge/APT-Advanced%20Package%20Tool-336791?logo=debian&logoColor=white)](#)
[![xclip](https://img.shields.io/badge/xclip-clipboard-blue)](#)
[![wl-clipboard](https://img.shields.io/badge/wl--clipboard-Wayland%20Clipboard-6C9EF8)](#)
[![xdotool](https://img.shields.io/badge/xdotool-automation-yellow)](#)
[![libnotify](https://img.shields.io/badge/libnotify-notifications-orange)](#)
[![Xbindkeys](https://img.shields.io/badge/Xbindkeys-0277BD?logo=gnu&logoColor=white)](https://www.nongnu.org/xbindkeys/)


<!-- <p align="center">Preview</p> -->

<p align="center">
  <img src="preview/giphy.gif" alt="Preview GIF" width="auto">
</p>

---  

## [![More](https://img.shields.io/badge/->__-2D2F34?)](#) Quick Installation 

<!--  [![Download](https://img.shields.io/badge/Download-Latest-blue?style=for-the-badge&logo=download)](https://github.com/user/repository/releases/latest) -->

  **quick-install.sh** is designed to quickly and smarts download packages and configure the installation. This script is intended for zero-knowledge users or those who are starting by downloading this repository, so they don’t have to type too many commands in the Terminal.


<p align="center">
  <a href="https://github.com/jmswycode/encryption-shortcuts/blob/main/quick-install.sh">
    <img src="https://img.shields.io/badge/Download-quick--install.sh-blue?style=for-the-badge&logo=download" alt="Download">
  </a>
</p>


```sh
# Once downloaded  
# Put `quick-install.sh` in any folder.  
# Open your terminal in the folder where the file is located.

~$ cd Downloads

📁 ~/Downloads
└── 📜 qucik-install.sh
```

---  

## Command-line utility
Follow these steps to run the installation script.

1. Make the script executable.
   ```bash
   chmod +x qucik-install.sh
   ```  

2. Run the script with bash or `./`
   ```bash
   bash qucik-install.sh
   ```  
**Note:** If the script requires sudo access, it is needed for installing APT packages.

--- 
## 🚀 How to Use  

1. **Encrypt a Message:**  
   - Type the message you want to send.  
   - Select the text you want to encrypt and press `CTRL + SHIFT + G`.  

2. **Decrypt a Message:**  
   - Select the encrypted text you want to decrypt and press `CTRL + SHIFT + R`.  

3. **Decrypting a Message from a Friend:**  
   - If the encrypted text was sent by a friend, copy and paste it into the text area first.  
   - Then press `CTRL + SHIFT + G` to view the original message.  

### 🔧 Configuration  
To change the encryption password, iterations, or disable ID, edit the file located at:  
`~/.encryption-shortcuts/encdec_shortcuts.sh`  

```bash
# Setting password, number of iterations, and whether ID is used
PASSWORD="123"       # Change this to your password  
ITERATIONS=100000    # Number of iterations for encryption (default 10000)  
ID_OPTION=""         # Leave empty "" to include ID, set to "OFF" to remove ID  
```

### 🎛 Changing Shortcut Keys  
To modify the keyboard shortcuts, edit the `~/.xbindkeysrc` file:  

```bash
"bash ~/.encryption-shortcuts/encdec_shortcuts.sh encrypt"
  Control+Shift+E

"bash ~/.encryption-shortcuts/encdec_shortcuts.sh decrypt"
  Control+Shift+G
```

After making changes, restart `xbindkeys` for them to take effect:  
```bash
killall xbindkeys && xbindkeys
```
---  
<!--
## 🤝 Contribution  
If you want to contribute, feel free to create a Pull Request or contact me through an issue.  

## 📜 License  
This project is licensed under the [MIT License](LICENSE). -->
