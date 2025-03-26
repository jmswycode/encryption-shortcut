#!/bin/bash
#!/bin/sh

#-----------------------------------------------------------
# The author generated this text in part with GPT‑4o, OpenAI’s large-scale
# language-generation model. Upon generating draft language, the author 
# reviewed, edited, and revised the language to their own liking and takes
# ultimate responsibility for the content of this publication.
#-----------------------------------------------------------
# get sources: https://github.com/jmswycode/encryption-shortcut
#-----------------------------------------------------------

# Setting password, number of iterations, and whether ID is used
PASSWORD="123"     # Change this to your password
ITERATIONS=600000  # Number of iterations for encryption (default 10000)
ID_OPTION=""       # Leave empty "" to include ID, set to "OFF" to remove ID

# Detect the display environment (Wayland/X11) and choose the appropriate clipboard tool
if [ "$XDG_SESSION_TYPE" = "wayland" ] && command -v wl-copy &>/dev/null; then
    CLIP_CMD="wl-copy"
    PASTE_CMD="wl-paste"
elif [ "$XDG_SESSION_TYPE" = "x11" ] && command -v xclip &>/dev/null; then
    CLIP_CMD="xclip -selection clipboard"
    PASTE_CMD="xclip -o -selection primary"
elif command -v xclip &>/dev/null; then
    CLIP_CMD="xclip -selection clipboard"
    PASTE_CMD="xclip -o -selection primary"
elif command -v wl-copy &>/dev/null; then
    CLIP_CMD="wl-copy"
    PASTE_CMD="wl-paste"
else
    notify-send "Error" "Clipboard tool (xclip/wl-copy) not found."
    exit 1
fi

# First, we gotta know what we're doing – encrypting or decrypting?
MODE=$1 

# Uh-oh, did you forget to tell me what to do?
if [ -z "$MODE" ]; then
    notify-send "Error" "Not provided."
    exit 1
fi

# Grab the text from clipboard (automatic fallback)
TEXT=$($PASTE_CMD 2>/dev/null)

# Is there any text? Or are we encrypting the void?
if [ -z "$TEXT" ]; then
    notify-send "Error" "No text selected."
    exit 1
fi

if [ "$MODE" = "encrypt" ]; then
    # 🔒 Alright, let's lock this thing up!
    
    # Generate a easy random ID (to recognize messages)
    ID=$(printf "ID-%s-%04d" "$(cat /dev/urandom | tr -dc 'a-z' | fold -w 2 | head -n 1)" $((RANDOM % 10000)))

    # Encrypt the text using OpenSSL (fancy security stuff)
    ENCRYPTED=$(echo "$TEXT" | openssl enc -aes-256-cbc -a -e -salt -pbkdf2 -md sha256 -iter $ITERATIONS -pass pass:"$PASSWORD")

    # Make sure the encrypted text is in one neat line (no messy newlines)
    ENCRYPTED=$(echo "$ENCRYPTED" | tr -d '\n')

    # Should we add the fancy ID or keep it minimalistic?
    if [ "$ID_OPTION" = "OFF" ]; then
        RESULT="\"$ENCRYPTED\""
    else
        RESULT="\"[$ID]:$ENCRYPTED\""
    fi

    # Copy it to clipboard (automatic fallback)
    echo -n "$RESULT" | $CLIP_CMD

    # Situation if paste only using xclip
    if [ "$CLIP_CMD" = "xclip -selection clipboard" ] && command -v xdotool &>/dev/null; then
        xdotool key Ctrl+V
    fi

    # Let’s celebrate!
    notify-send "Encryption Successful" "Text replaces, or just press CTRL+V to paste."

elif [ "$MODE" = "decrypt" ]; then
    # 🔑 Time to unlock the secrets!

    # Does the text have ID tag?
    if echo "$TEXT" | grep -qE '\[ID-[a-z]{2}-[0-9]{4}\]:'; then
        # Yep! Let's save it and clean up the text before decrypting
        ID=$(echo "$TEXT" | grep -oE 'ID-[a-z]{2}-[0-9]{4}')
        
        # If wrapped in quotes, let's strip those out too (keep it clean)
        if [[ "$TEXT" =~ ^\".*\"$ ]]; then
            CLEANED_TEXT=$(echo "$TEXT" | sed -E 's/^"\[ID-[a-z]{2}-[0-9]{4}\]://; s/"$//')
        else
            CLEANED_TEXT=$(echo "$TEXT" | sed -E 's/^\[ID-[a-z]{2}-[0-9]{4}\]://')
        fi
    else
        # No ID? No problem. Let’s just remove
        CLEANED_TEXT=$(echo "$TEXT" | sed -E 's/^"//; s/"$//')
    fi

    # Decrypting with OpenSSL
    DECRYPTED=$(echo "$CLEANED_TEXT" | openssl enc -aes-256-cbc -a -d -salt -pbkdf2 -md sha256 -iter $ITERATIONS -pass pass:"$PASSWORD" 2>/dev/null)

    # Did it work, or did we just create gibberish?
    if [ -z "$DECRYPTED" ] || ! echo "$DECRYPTED" | grep -q '[[:print:]]'; then
        notify-send "Error" "Failed to decrypt text. The password, iterations, or text might be incorrect."
        exit 1
    fi

    # What’s the next ending? Do we show the ID or just the text?
    if [ -n "$ID" ]; then
        RESULT="[$ID]:$DECRYPTED"
    else
        RESULT="$DECRYPTED"
    fi

    # Copy it to clipboard (automatic fallback)
    echo -n "$RESULT" | $CLIP_CMD

    # Situation if paste only using xclip
    if [ "$CLIP_CMD" = "xclip -selection clipboard" ] && command -v xdotool &>/dev/null; then
        xdotool key Ctrl+V
    fi

    # Mission accomplished!
    notify-send "Decryption Successful" "Text replaces, or just press CTRL+V to paste."
else
    # Uhh, what was that? That’s not encrypt or decrypt!
    notify-send "Error" "Not provided."
    exit 1
fi
