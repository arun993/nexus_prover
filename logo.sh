#!/bin/bash
# Define color and style variables
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

# Function to center text in the terminal
center_text() {
  local text="$1"
  local term_width
  term_width=$(tput cols)
  local text_length=${#text}
  local padding=$(( (term_width - text_length) / 2 ))
  printf "%*s%s\n" "$padding" "" "$text"
}

# Print ASCII art in red
echo -e "${RED}"
echo "███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗     ██████╗██╗     ██╗"
echo "████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██╔════╝██║     ██║"
echo "██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║     ██║     ██║"
echo "██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║     ██║     ██║"
echo "██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╗███████╗██║"
echo "╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝╚══════╝╚═╝"
echo -e "${RESET}"

# Print additional centered text with red bold styling
echo -e "${RED}${BOLD}"
echo "Follow me on X/Twitter : https://x.com/Arun__993 "
echo "Github : https://github.com/arun993 "
echo -e "${RESET}"
