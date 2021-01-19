#!/usr/bin/env bash
#Elias Posluk
#StudentID - (epk19001)
#Laboratory work submission
#Mälardarlen University

function create_group () {
    # $? is a special variable containing the exit status of last task.
    # The command addgroup is a convenience wrapper around the lower level groupadd utility. 
    # It does the checks for us and returns 1 if the group already exists
    # or the group name has forbidden characters.
    # A manual check if the group exists would look like: grep -q $group_name /etc/group,
    # but why should we re-invent the wheel?
    
    while [ true ]; do
        read -p "Name of the new group: " groupname
        addgroup "$groupname"
        if [ $? -eq 0 ]; then
            echo "Group ${groupname} created succesfully!"
            break
        fi
    done
}

function user_add () {
    # This could have been cut significantly if we used the adduser,
    # same as above, it is a convenience wrapper around groupadd.
    # We could have simply invoked it and it will do the interactivity and checkings for
    # us (ask for password, shell, home dir, etc.).
    # useradd man pages: https://linux.die.net/man/8/useradd

    while [ true ]; do    
        read -p "Enter the username of the new user: " username
        if [[ $(getent passwd "$username") ]]; then
            echo "User already exists, try again with a new username: "
            continue
        else
            break
        fi
    done

    homedir="/${username}"

    useradd "$username" -g "$groupname" -d "$homedir" -m -s /bin/bash
    if [ $? -eq 0 ]; then
        echo "User created succesfully!"
    fi

    if [ ! -d "$homedir" ]; then
        echo "Creating home directory: ${homedir} ..."
        mkdir -p "$homedir"
    fi

    chown "$username":"$groupname" "$homedir"
    if [ $? -eq 0 ]; then
        echo "Home directory ${homedir} ownership set to ${username}:${groupname} ..."
    fi

    chmod u=rwx,g=rwx,o=rx,a+t "$homedir"
    if [ $? -eq 0 ]; then
        echo "Home directory ${homedir} permissions set to 775 & sticky bit enabled..."
    fi

    echo "Setting user password:"
    while [ true ]; do
        passwd "$username"
        if [ $? -ne 0 ]; then
            echo "Try again!"
        else
            break
        fi
    done
}

#Invoke the tasks
create_group
user_add
