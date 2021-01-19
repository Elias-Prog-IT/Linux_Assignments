#!/usr/bin/env bash
#Elias Posluk
#StudentID - (epk19001)
#ProjectWork Assignment
#Mälardarlen University


#create group function.
function create_group () {
    #invokes the read command and asks the name of the new group, which it laters saves the name
    #in the group name variabel. It then executes the addgroup command and passes the groupname to the command and creates the group.
    read -p "Name of the new group: " group_name
    addgroup $group_name
}

#creates list group
#The output of all etc/group(s) information gets printed out and gets piped to the cut command,
#which uses ':' colon as a seperator and prints the specific match with -f1 as the user inputs.    
function list_groups () {
    grps=$(cat /etc/group | cut -d':' -f1)
    echo -e "List of available groups is:\n${grps}"
}

#View group function
#here you get the question on what group you want to view, with the input we check if the group exists.
#If the group doesn't exist, we get a notification about the group name input doesn't exist 
#otherwise if the input is true and groupname exists, we get a printout on the terminal with information
function view_group () {
    while [ true ]; do
        read -p "Enter the name of the group: " group_name

        if [ "`cat /etc/group | cut -d':' -f1 | grep -i -c -w $group_name`" -eq 0 ]; then
            echo "Group not found! Try again"
            continue
        else
            #Get every username from /etc/passwd and iterate while read receives input
            cat /etc/passwd | cut -d: -f1 | while read name
            do
                #Check if the username is part of group_name and if it is - print it
                groups $name | cut -d: -f2 | grep -i -q -w "$group_name" && echo $name
            done
            break
        fi
    done
}

#The modify group function
#We ask the name of the group, we check if the group exists. If the group exists, we end up in a new menu
#where we get the options to invoke new options/operations, as modifying or removing a user to a group or go back to previous menu. 
function modify_group () {
    while [ true ]; do
        read -p "Enter the name of the group: " group_name
        
        if [ "`cat /etc/group | cut -d':' -f1 | grep -i -c -w $group_name`" -eq 0 ]; then
            echo "Group not found! Try again."
            continue
        else
            echo "Available operations:"
            echo -e "\033[31madd\033[0m \t\tAdd user to the group"
            echo -e "\033[31mdelete\033[0m \t\tRemove user from the group"
            echo -e "\033[31mback\033[0m \t\tGo back to previous menu"
            read -p "Select operation: " operation
            
            case "$operation" in
                "add")
                    echo -e "Enter the username to add to the group \033[31m${group_name}\033[0m: " 
                    read user_name
                    usermod -a -G $group_name $user_name && echo "Success!"
                    return
                ;;
                "delete")
                    echo -e "Enter the username to remove from from the group \033[31m${group_name}\033[0m: "
                    read user_name
                    gpasswd -d $user_name $group_name
                    return
                ;;
                "back")
                    return
                ;;
                *)
                    echo "Invalid choice!"
                    continue
                ;;
            esac
            
        fi
    done
}

#user add function adds a new user 
function user_add () {
    read -p "Enter the username of the new user: " username
    adduser $username
}

#user list function 
#it contains information about the users, the groups they are in, directories, etc
function users_list () {
    users=$(cut -d: -f1 /etc/passwd)
    echo -e "List of available groups is:\n${users}"
}

#user view function 
#You get asked for username in the while-loop
#If everything is correct you get almost all information about the specific user except for the users
#password which is hashed. you can see where the password is saved in (cat /etc/shadow)
function user_view () {
    while [ true ]; do    
        read -p "Enter the username or 'exit' to return to the main menu: " username
        if [ "$username" == "exit" ]; then
            return
        elif [ ! $(getent passwd $username) ]; then
            echo -e "\033[31mUser not found! Try again \033[0m"
            continue
        else
            break
        fi
    done

    getent passwd $username | while IFS=: read uname pass_hash uid gid info home_dir shell
    do
        echo -e "\033[31mUsername:\033[0m \t\t${username}"
        echo -e "\033[31mComment:\033[0m \t\t${info}"
        echo -e "\033[31mGID (User ID):\033[0m \t\t${uid}"
        echo -e "\033[31mGID (Group ID):\033[0m \t${gid}"
        echo -e "\033[31mHome Directory:\033[0m \t${home_dir}"
        echo -e "\033[31mShell:\033[0m \t\t\t${shell}"
        echo -e "\033[31mPassword:\033[0m \t\t${pass_hash} (hashed and cannot be seen in plain text)"
    done  
    
}

#the modify user function
#We have another check on the username, if it exists, in the while-loop.
#we can change the password, of the user or delete the user, etc.
function user_modify () {
    while [ true ]; do    
        read -p "Enter the username to modify or 'exit' to return to the main menu: " username
        if [ "$username" == "exit" ]; then
            break
        elif [[ ! $(getent passwd $username) ]]; then
            echo -e "\033[31mUser not found! Try again \033[0m"
            continue
        else
            break
        fi
    done

    echo -e "\033[31mpassword\033[0m\tChange user password"
    echo -e "\033[31muid\033[0m\t\tChange user's UID"
    echo -e "\033[31mgid\033[0m\t\tChange user's GID "
    echo -e "\033[31mcomment\033[0m\t\tChange user's GECOS"
    echo -e "\033[31mshell\033[0m\t\tChange user's login shell"
    echo -e "\033[31mhome\033[0m\t\tChange user's home directory and copy all files to it"
    echo -e "\033[31mremove\033[0m\t\tDelete the user"

    read -p "Enter the name of the property or exit to return to the main menu?: " property

    case "$property" in
        "password")
            passwd $username
        ;;
        "uid")
            read -p "Enter the new UID: " new_uid
            output=$(usermod -u $new_uid $username 2>&1)
            if [ -z "$output" ]; then
                echo "User ${username}'s new UID is now ${new_uid}"
            else
                echo $output
            fi
        ;;
        "gid")
            read -p "Enter the new GID: " new_gid
            output=$(usermod -g $new_gid $username 2>&1)
            if [ -z "$output" ]; then
                echo "User ${username}'s new GID is now ${new_gid}"
            else
                echo $output
            fi
        ;;
        "comment")
            chfn $username
        ;;
        "remove")
            deluser $username
        ;;
        "shell")
            chsh $username
        ;;
        "home")
            read -p "Enter the new home directory: " new_home_dir
            output=$(usermod -d $new_home_dir $username 2>&1)
            if [ -z "$output" ]; then
                echo "User ${username}'s new home directory is now ${new_home_dir}"
            else
                echo $output
            fi
        ;;
        "exit")
            return
        ;;
        *)
            echo "Incorrect choice!"
        ;;
    esac
    
}

#Folder create function
#here we ask for the absolute file to the new folder, and creates the new folder 
function folder_create () {
    echo "WARN: This function executes the mkdir command with the -p argument which creates all parent directories if needed"
    read -p "Enter the absolute path of the new folder(e.g /tmp/newfolder): " folder_path
    mkdir -p -v $folder_path
}

#Folder list function.
#it provides all the content in the directory with details about permissions, users, group owners, the size and last modified
function folder_list () {
    read -p "Enter the absolute path of the folder(e.g /tmp/somefolder/someotherfolder): " folder_path
    ls -lah $folder_path
}

#folder view function
#prints the owner of the file, group, permissions, last modified (timestamp),  
function folder_view () {
    read -p "Enter the absolute path of the folder(e.g /tmp/somefolder/someotherfolder): " folder_path
    echo -e "owner\tUser: $(stat --printf='%U(UID:%u)' $folder_path)"
    echo -e "group\tGroup: $(stat --printf='%G(GID:%g)' $folder_path)"
    echo -e "permissions\t$(stat --printf='%A/%a' $folder_path)"
    echo -e "lastmodified\t$(stat --printf='%y' $folder_path)"
}

#the modify function
function folder_modify () {
    while [ true ]; do    
        read -p "Enter the absolute path of the folder(e.g /tmp/somefolder/someotherfolder): " folder_path
        if [ "$folder_path" == "exit" ]; then
            return
        elif [[ ! -d "$folder_path" ]]; then
            echo -e "\033[31mDirectory not found! Try again \033[0m"
            continue
        else
            break
        fi
    done
    
    #We read the folder permission. The folder permissions have specifics with different calculations
    #Stickybit=1xxx, sgid=2xxx, suid=4xxx - altogether=7xxx, e.g. sticky+sgid=3xxx, sgid+ugid=6xxx and so on.
    folder_permissions=$(stat --printf='%a' $folder_path)
    case $(($folder_permissions)) in
        ([1][0-7][0-7][0-7] | [5][0-7][0-7][0-7] ) 
            stickybit=true
            sgid=false
        ;;
        [2][0-7][0-7][0-7] | [6][0-7][0-7][0-7])
            stickybit=false
            sgid=true
        ;;
        [3][0-7][0-7][0-7] | [7][0-7][0-7][0-7])
            stickybit=true
            sgid=true
        ;;
        *)
            stickybit=false
            sgid=false
        ;;
    esac
    
    #We print the information about the folder, owner, group, permissions, etc
    echo -e "\033[31mowner\033[0m\t\tUser: $(stat --printf='%U(UID:%u)' $folder_path)"
    echo -e "\033[31mgroup\033[0m\t\tGroup: $(stat --printf='%G(GID:%g)' $folder_path)"
    echo -e "\033[31mpermissions\033[0m\t$(stat --printf='%A/%a' $folder_path)"
    echo -e "\033[31mstickybit\033[0m\tIs enabled: ${stickybit}"
    echo -e "\033[31msgid\033[0m\t\tIs enabled: ${sgid}"
    echo -e "\033[31mlastmodified\033[0m\t$(stat --printf='%y' $folder_path)"

    read -p "Enter the property ou want to change: " choice
    case "$choice" in
        "owner")
            read -p "Enter the username of the new owner: " new_owner
            chown $new_owner $folder_path
        ;;
        "group")
            read -p "Enter the new owner group: " new_group
            chgrp $new_grp $folder_path
        ;;
        "permissions")
            read -p "Enter the new owner group: " new_group
            chgrp $new_grp $folder_path
        ;;
        "stickybit")
            if [ "$stickybit" == "true" ]; then
                read -p "Stickybit is currently enabled, would you like to disable it? [y/n]" disable
            
                if [ "$disable" == "y" ]; then
                    chmod -t $folder_path && echo "Disabled!"
                else
                    echo "No action taken."
                fi
            else
                read -p "Stickybit is currently disabled, would you like to enable it? [y/n]" enable
                if [ "$enable" == "y" ]; then
                    chmod +t $folder_path && echo "Enabled!"
                else
                    echo "No action taken."
                fi
            fi
        ;;
        "sgid")
            if [ "$sgid" == "true"]; then
                read -p "SGID is currently enabled, would you like to disable it? [y/n]" $disable
                if [ "$disable" == "y" ]; then
                    chmod -s $folder_path && echo "Disabled!"
                else
                    echo "No action taken."
                fi
            else
                read -p "SGID is currently disabled, would you like to enable it? [y/n]" $enable
                if [ "$enable" == "y" ]; then
                    chmod +s $folder_path && echo "Enabled!"
                else
                    echo "No action taken."
                fi
            fi
        ;;
        "lastmodified")
            touch -m $folder_path
        ;;
        *)
            echo "Invalid choice, try again!"
        ;;
    esac
    
}

#openssh install function
function openssh_install () {
#We check if the openshh is already installed with the command under
    ossh=$(dpkg -l | grep openssh-server)
    
    #if it is installed already, we get asked if we want to uninstall
    if [ -z "$ossh" ]; then
        read -p "OpenSSH seems installed:\n${ossh}\n Uninstall?[y/n]:" uninstall
        if [ "$uninstall" == "y" ]; then
            apt remove --purge -y openssh-server
        else
            echo "No action taken."
        fi
    else 
        read -p "OpenSSH does not seem to be installed, install?[y/n]:" install #if it is not installed, we install it if the user says yes
        if [ "$install" == "y" ]; then
            apt install -y openssh-server
        else
            echo "No action taken."
        fi
    fi   
}

#openssh_enable function
function openssh_enable () {
#we check if its running/listening on any of the ports with the command below
    isrunning=$(netstat -tulpn | grep sshd)
    systemctl is-enabled --quiet ssh.service
    isenabled=$?
    if [ $isenabled -eq 0 ]; then
        read -p "OpenSSH seems to be enabled, would you like to disable it?[y/n]:" disable
        if [ "$disable" == "y" ]; then
            systemctl disable ssh.service
            systemctl stop ssh.service
        else
            echo "No action taken."
        fi
    else
        read -p "OpenSSH seems to be disabled, would you like to enable it? [y/n]" enable
        if [ "$enable" == "y" ]; then
           systemctl enable ssh.service
           systemctl start ssh.service
           netstat -tulpn | grep sshd
        else
            echo "No action taken."
        fi
    fi
}

#printing the main menu in the begining using the echo command.
# \033
while [ true ]; do
    clear
    echo "*****************************************************"
    echo "            SYSTEM MODIFIER (version 1.0.0)"
    echo "-----------------------------------------------------"
    echo -e "Manage Groups:"
    echo -e "\033[31mgroup:add \033[0m \tCreate a new group"
    echo -e "\033[31mgroup:list \033[0m \tList system groups"
    echo -e "\033[31mgroup:view \033[0m \tList user associations for group"
    echo -e "\033[31mgroup:modify \033[0m \tModify user associations for group"
    echo -e "Manage Users:"
    echo -e "\033[31muser:add \033[0m \tCreate a new user"
    echo -e "\033[31muser:list \033[0m \tList system users"
    echo -e "\033[31muser:view \033[0m \tView user properties"
    echo -e "\033[31muser:modify \033[0m \tModify user properties"
    echo -e "Manage folders:"
    echo -e "\033[31mfolder:add \033[0m \tCreate a new folder"
    echo -e "\033[31mfolder:list \033[0m \tList folder contents"
    echo -e "\033[31mfolder:view \033[0m \tList folder properties"
    echo -e "\033[31mfolder:modify \033[0m \tModify folder properties\n"
    echo -e "Manage OpenSSH:"
    echo -e "\033[31mssh:install \033[0m \tInstall/Uninstall OpenSSH\n"
    echo -e "\033[31mssh:modify \033[0m \tEnable/Disable OpenSSH\n"
    echo -e "\033[32mexit \033[0m \t To exit the program"

    read -p "Select choice by typing the full command (e.g group:add): " main_menu_choice

#Going through a case-statement with the input from the user.
    case "$main_menu_choice" in
        "group:add")
            create_group
        ;;
        "group:list")
            list_groups
        ;;
        "group:view")
            view_group
        ;;
        "group:modify")
            modify_group
        ;;
        "user:add")
            user_add
        ;;
        "user:list")
            users_list
        ;;
        "user:view")
            user_view
        ;;
        "user:modify")
            user_modify
        ;;
        "folder:add")
            folder_add
        ;;
        "folder:list")
            folder_list
        ;;
        "folder:view")
            folder_view
        ;;
        "folder:modify")
            folder_modify
        ;;
        "ssh:install")
            openssh_install
        ;;
        "ssh:modify")
            openssh_enable
        ;;
        "exit")
            echo "Good bye!"
            break
        ;;
        *)
            echo "Incorrect choice! A correct choice would look like: user:add"
        ;;
    esac
    read -p "Press any key to return to the main menu.."
done