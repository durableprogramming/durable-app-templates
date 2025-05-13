#!/bin/bash

# Colors and styles
RESET="\033[0m"
BOLD="\033[1m"
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
BG_BLUE="\033[44m"

# Clean screen and set cursor to top
clear_screen() {
  tput clear
  tput cup 0 0
}

# Draw header
draw_header() {
  clear_screen
  echo -e "${CYAN}"
  echo '                        .::::           lkkkkkkkkkd  lkkko  dkkk: -kkkkkkkkkd.    .kkkkx    .kkkkkkkkkx.  kkkk.     xkkkkkkkx'
  echo '                   ...  llll;           dKKKKKKKKKK- dKKKx  OKKKl ,KKKKKKKKKKx    lKKKKK.   .KKKKKKKKKKx  KKKK.     OKKKKKKKK.'
  echo '            ..  ..llllc,llll.           dKKKc  OKKK- dKKKx  OKKKl ,KKKk  :KKKx    KKKKKKl   .KKKK  -KKKx  KKKK.     OKKKc'
  echo '           cllllllllllllllll            dKKKc  OKKK- dKKKx  OKKKl ,KKKk  :KKKx   .KKKKKKK   .KKKK  -KKKx  KKKK.     OKKKc'
  echo '          ,lllllll,    clll; KO0O-      dKKKc  OKKK- dKKKx  OKKKl ,KKKk  :KKKx   dKKKcKKK.  .KKKK;.kKKKl  KKKK.     OKKKO'---
  echo '        -,cllll- .cloo.      -KKKKc     dKKKc  OKKK- dKKKx  OKKKl ,KKKK:-0KKKx   KKKk KKKk  .KKKKKKKKKKl  KKKK.     OKKKKKKK.'
  echo '      llllll;   cKKKK       .KKKK0      dKKKc  OKKK- dKKKx  OKKKl ,KKKKKKKKKKc  ,KKKc OKKK  .KKKK  -KKK0  KKKK.     OKKKl'
  echo '       llll;    KKKKd        .KKKKk:    dKKKc  OKKK- dKKKx  OKKKl ,KKKk.KKKK    0KKKk-KKKK; .KKKK  .KKK0  KKKK.     OKKKc'
  echo '      .llll    .KKKK.         oKKKKKl   dKKKk .KKKK- dKKKK..KKKKl ,KKKk lKKKx  .KKKKKKKKKK0 .KKKK. lKKK0  KKKKx.... OKKKO....'
  echo '     :lllll    oKKKK          oKKKK     dKKKKKKKKKK. :KKKKKKKKKK, ,KKKk  0KKK- lKKKo   KKKK..KKKKKKKKKKx  KKKKKKKK. OKKKKKKKk'
  echo '     llllll-   KKKKo          KKKKd'
  echo '       -llll. .KKKK.         OKKKKK'-
  echo '        lllll oKKK0        ;0KKKKK0     ;llllll clllllc :lllllc :llllc  llllll;  .lll   lll  :ll  ll:  lll cl: lll ll  lllll.'
  echo '       .llll, KKKKd    .,o0KKKKc        ;lc .ll cl: -ll :l: ,ll :l:     ll- :l:  ;lll.  lll..lll  lll ;lll cl: lll,ll  ll.'
  echo '             -KKKKKK00KKKKKKKKd         ;lc .ll cl: -ll :l: ,ll :l:     ll- :l:  ll;l;  llllclll  llllllll cl: llllll  ll.'
  echo '             kKKKKKKKKKKK: 0K.          ;ll.cll cll,cll :l: ,ll :l: ;lc llc,ll: .lc.ll  ll:ll;ll  ll;ll;ll cl: llllll  ll. ll.'
  echo '             KKKK: cKKk                 ;lc     cl:,ll  :l: ,ll :l: ;lc ll,:lc  cll;ll. ll ;c ll  ll ll ll cl: ll lll  ll. ll.'
  echo '            :KKKK                       ;lc     cl: ll- :ll-lll :ll;llc ll- ll. ll. :l: ll    ll  ll   .ll cl: ll lll  ll:;ll.'
  echo
  echo -e "                                        ${WHITE}https://durableprogramming.com${RESET}\n\n"
  echo -e "${BOLD}${YELLOW}============================== Durable Programming App Templates ==============================${RESET}\n"
}

# Draw menu
draw_menu() {
  local selected=$1
  local options=(
    "Ruby on Rails (PostgreSQL or MySQL)"
    "Ruby on Rails with SvelteJS (PostgreSQL or MySQL)"
    "Python devenv template"
    "Ruby devenv template"
    "Quit"
  )

  for i in "${!options[@]}"; do
    if [[ $i -eq $selected ]]; then
      echo -e "  ${BOLD}${BG_BLUE}${WHITE}>> ${options[$i]} <<${RESET}"
    else
      echo -e "     ${options[$i]}"
    fi
  done
}

# Draw footer
draw_footer() {
  echo -e "\n${YELLOW}Use arrow keys to navigate, Enter to select${RESET}"
  echo -e "\n${CYAN}This work is marked with CC0 1.0. To view a copy of this license, visit:"
  echo -e "${WHITE}https://creativecommons.org/publicdomain/zero/1.0/${RESET}"
  echo -e "\n${CYAN}Copyright 2024, Durable Programming LLC. All rights reserved."
  echo -e "${WHITE}https://github.com/durableprogramming/durable-app-templates${RESET}"
}

# Install template
install_template() {
  local choice=$1
  clear_screen
  echo -e "${BOLD}${YELLOW}Installing template...${RESET}\n"

  case $choice in
    0) # Ruby on Rails
      echo -e "${CYAN}Enter app name:${RESET} "
      read app_name
      echo -e "${CYAN}Select database (postgres/mysql):${RESET} "
      read db_type
      if [[ "$db_type" != "postgres" && "$db_type" != "mysql" ]]; then
        echo -e "${RED}Invalid database type. Using postgres as default.${RESET}"
        db_type="postgres"
      fi
      if [[ "$db_type" == "postgres" ]]; then
        db_flag="postgresql"
      else
        db_flag="mysql"
      fi
      echo -e "${CYAN}Use Docker? (y/n):${RESET} "
      read use_docker
      if [[ "$use_docker" == "y" ]]; then
        export USE_DOZZLE=1
        export USE_DOCKER_ETCHOSTS=1
      fi
      echo -e "${CYAN}Use Nix? (y/n):${RESET} "
      read use_nix
      if [[ "$use_nix" == "y" ]]; then
        export USE_NIX=1
      fi
      
      echo -e "\n${GREEN}Creating Rails app $app_name with $db_type database...${RESET}\n"
      rails new $app_name --database=$db_flag -m https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/ruby-on-rails/template.rb
      ;;
      
    1) # Ruby on Rails with SvelteJS
      echo -e "${CYAN}Enter app name:${RESET} "
      read app_name
      echo -e "${CYAN}Select database (postgres/mysql):${RESET} "
      read db_type
      if [[ "$db_type" != "postgres" && "$db_type" != "mysql" ]]; then
        echo -e "${RED}Invalid database type. Using postgres as default.${RESET}"
        db_type="postgres"
      fi
      if [[ "$db_type" == "postgres" ]]; then
        db_flag="postgresql"
      else
        db_flag="mysql"
      fi
      echo -e "${CYAN}Use Docker? (y/n):${RESET} "
      read use_docker
      if [[ "$use_docker" == "y" ]]; then
        export USE_DOZZLE=1
        export USE_DOCKER_ETCHOSTS=1
      fi
      echo -e "${CYAN}Use Nix? (y/n):${RESET} "
      read use_nix
      if [[ "$use_nix" == "y" ]]; then
        export USE_NIX=1
      fi
      
      echo -e "\n${GREEN}Creating Rails app with SvelteJS $app_name with $db_type database...${RESET}\n"
      rails new $app_name --database=$db_flag -m https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/ruby-on-rails-sveltejs/template.rb
      ;;
      
    2) # Python devenv
      echo -e "${CYAN}Enter directory name (default: python-devenv):${RESET} "
      read dir_name
      if [[ -z "$dir_name" ]]; then
        dir_name="python-devenv"
      fi
      
      mkdir -p "$dir_name"
      cd "$dir_name"
      echo -e "\n${GREEN}Installing Python development environment...${RESET}\n"
      curl -s https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/devenv/python/install.sh | bash
      cd ..
      ;;
      
    3) # Ruby devenv
      echo -e "${CYAN}Enter directory name (default: ruby-devenv):${RESET} "
      read dir_name
      if [[ -z "$dir_name" ]]; then
        dir_name="ruby-devenv"
      fi
      
      mkdir -p "$dir_name"
      cd "$dir_name"
      echo -e "\n${GREEN}Installing Ruby development environment...${RESET}\n"
      curl -s https://raw.githubusercontent.com/durableprogramming/durable-app-templates/main/devenv/ruby/install.sh | bash
      cd ..
      ;;
      
    4) # Quit
      echo -e "${GREEN}Goodbye!${RESET}"
      exit 0
      ;;
  esac
  
  echo -e "\n${GREEN}Installation complete!${RESET}"
  echo -e "\nPress any key to return to the menu..."
  read -n 1
}

# Main function
main() {
  local selected=0
  local options_count=5
  
  # Hide cursor
  tput civis
  
  # Trap to ensure cursor is shown on exit
  trap 'tput cnorm; exit 0' INT TERM EXIT
  
  while true; do
    draw_header
    draw_menu $selected
    draw_footer
    
    # Read a single key
    read -s -n 1 key
    
    # Process arrow keys
    if [[ $key == $'\e' ]]; then
      read -s -n 2 key
      if [[ $key == "[A" ]]; then # Up arrow
        ((selected--))
        if [[ $selected -lt 0 ]]; then
          selected=$((options_count - 1))
        fi
      elif [[ $key == "[B" ]]; then # Down arrow
        ((selected++))
        if [[ $selected -ge $options_count ]]; then
          selected=0
        fi
      fi
    elif [[ $key == "" ]]; then # Enter key
      install_template $selected
    fi
  done
}

# Start the script
main
