#!/usr/bin/env bash
#Elias Posluk
#StudentID - (epk19001)
#Mälardarlen University
#ProjectWork Assignment, Key managment 

#key_gen function
#We check how many keypairs are currently in the .ssh folder
function key_gen () {
    key_count=$(ls -lah .ssh/id_rsa* 2>/dev/null | wc -l)
    pair_id=$(($key_count/2 + 1))
    key_path=".ssh/id_rsa${pair_id}"
    pub_path=".ssh/id_rsa${pair_id}.pub"
    ssh-keygen -t rsa -b 4096 -f $key_path
}

#Key delete function
#you get asked on which key you want to delete/remove
function key_del () {
    read -p "Enter the name of the key you'd like to delete(e.g id_rsa1): " key_name
    key_path="$HOME/.ssh/${key_name}"
    rm -i $key_path
    rm -i "${key_path}.pub"
}

#key list function
#We list all the keys stored in the Home .ssh directory
function key_list () {
    echo "List of available keys stored in ${HOME/.ssh/}:"
    ls -1 $HOME/.ssh/id_rsa* | while read key_name;
    do
        if [ ! "${key_name##*.}" == "pub" ]; then
            echo -e "\033[31m$(basename $key_name)\033[0m\t$(ssh-keygen -l -f $key_name)"
        fi
        
    done
    echo -e "\n"
}

#ssh_authorize function
function ssh_authorize () {
    read -p "Enter the name of the key to authorize: " key_name
    read -p "Enter the IP of the remote machine: " ip_addr
    read -p "Enter the username: " username
    read -p "Enter the port of the server (default is 22): " port

    if [ -z "$port" ]; then #port 22 by default if the user doesn't input anything else
        port=22
    fi

    ssh-copy-id -i "$HOME/.ssh/${key_name}" -p$port "${username}@${ip_addr}"
    
}

#ssh connect function
function ssh_connect () {
    read -p "Enter the name of the key to authorize with: " key_name
    read -p "Enter the IP of the remote machine: " ip_addr
    read -p "Enter the username: " username
    read -p "Enter the port of the server (default is 22): " port

    if [ -z "$port" ]; then
        port=22
    fi

    ssh -i "$HOME/.ssh/${key_name}" -p$port "${username}@${ip_addr}" 
}

#key manager menu
while [ true ]; do
    clear
    echo "*****************************************************"
    echo "            SSH KEY MANAGER (version 1.0.0)"
    echo "-----------------------------------------------------"
    echo -e "Manage OpenSSH Keys:"
    echo -e "\033[31mkey:create \033[0m \tGenerate a new OpenSSH key pair"
    echo -e "\033[31mkey:delete \033[0m \tDelete an existing OpenSSH key pair"
    echo -e "\033[31mkey:list \033[0m \tList all keys\n"
    echo -e "Manage remote machines:"
    echo -e "\033[31mssh:authorize \033[0m \tAuthorize a key on a remote machine"
    echo -e "\033[31mssh:connect \033[0m \tConnect to a remote machine\n"
    echo -e "\033[32mexit \033[0m \t To exit the program"
    read -p "Select choice by typing the full command (e.g key:create): " main_menu_choice

    case "$main_menu_choice" in
        "key:create")
            key_gen
        ;;
        "key:delete")
            key_del
        ;;
        "key:list")
            key_list
        ;;
        "ssh:authorize")
            key_list
            ssh_authorize
        ;;
        "ssh:connect")
            key_list
            ssh_connect
        ;;
        "exit")
            echo "Good bye!"
            break
        ;;
        *)
            echo "Incorrect choice! A correct choice would look like: key:create"
        ;;
    esac
    read -p "Press any key to return to the main menu.."
done