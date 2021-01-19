#Elias Posluk
#StudentID - (epk19001)
#Laboratory work submission
#Course-ID: DVA239
#Mälardarlen University

#Subtask: Create a directory at the root (/) of the file system for each department. This name should reflect the department name that will use the directory.
mkdir /engineering
mkdir /sales
mkdir /infosys

#Subtask: Create a group for each department. This name should reflect the department name that the group will be assigned
groupadd engineering
groupadd sales
groupadd infosys

#Subtask: Create an administrative user for each of the departments.
#Subtask: The user will have a Bash login shell.
#Subtask: The user will belong to the respective group for each department. This will need to be the user’s primary group.
adduser --home /engineering/engadmin --ingroup engineering --shell /bin/bash engadmin
adduser --home /sales/salesadmin --ingroup sales --shell /bin/bash salesadmin
adduser --home /infosys/isadmin --ingroup infosys --shell /bin/bash isadmin

#Subtask: Create two additional users for each department.
#Subtask: The users will have a Bash login shell.
#Subtask: The users will belong to their respective group for each department. This will need to be the user’s primary group.
#Explanation: This command will prompt for user password when run! --home ensures that a home directory for the user will be created and read,write&execute permissions will be given to it, --ingroup sets the user's primary group to the department group he belongs to, --shell sets the user's shell to bash, --gecos adds some information about the user.
#Explanation2: --home in these commands cover the following subtasks as well:
    #Subtask: Ensure that only the owner of a fil...... **The user will also have ownership of their respective department folders.**
	#Subtask: Normal users in each department will have full access (Read, Write and Execute) to their respective department folders.
adduser --home /engineering/enguser1 --ingroup engineering --shell /bin/bash --gecos "Engineering User 1" enguser1
adduser --home /engineering/enguser2 --ingroup engineering --shell /bin/bash --gecos "Engineering User 2" enguser2
adduser --home /sales/salesuser1 --ingroup sales --shell /bin/bash --gecos "Sales User 1" salesuser1
adduser --home /sales/salesuser2 --ingroup sales --shell /bin/bash --gecos "Sales User 2" salesuser2
adduser --home /infosys/isuser1 --ingroup infosys --shell /bin/bash --gecos "InfoSys User 1" isuser1
adduser --home /infosys/isuser2 --ingroup infosys --shell /bin/bash --gecos "InfoSys User 2" isuser2

#Subtask: Ensure that the owner of each of the directories is the department administrator and the group ownership is the group for each department.
#Explanation: Set ownership of the department directories to the respective department administrators and the department groups
chown engadmin:engineering /engineering
chown salesadmin:sales /sales
chown isadmin:infosys /infosys

#Subtask: The department administrator will have full access to their respective department directories.
#Explanation: Ensure r(read)w(write)x(execute) permissions are given to u(the user who owns the directory, in our case the department administrator)
chmod u+rwx /engineering
chmod u+rwx /sales
chmod u+rwx /infosys

#Subtask: Ensure that only the owner of a file in the department’s directory can delete the file. The user will also have ownership of their respective department folders.
#Explanation: Add the stickybit to department's directories to ensure only the owner of the file, !!root and the owner of the file and the owner of the directory can remove the files!!
chmod a+t /engineering
chmod a+t /sales
chmod a+t /infosys

#Subtask: The department folders will ONLY be accessible by users/administrators in each of the respective departments. Ensure that no one else will have permissions to the folders.
#Explanation: Recursively removing others' access from the department directories&folders. o-rwx means remove read,write and execute for others. -R means do it recursively for /engineering and every file&folder inside it. Same for /sales and /infosys
chmod o-rwx -R /engineering
chmod o-rwx -R /sales
chmod o-rwx -R /infosys

#Subtask: Create a document in each of the department directories.
#Explanation: This is pretty much self explainatory, just using touch to create the empty files.
touch /engineering/document.txt
touch /sales/document.txt
touch /infosys/document.txt

#Subtask: The ownerships on this file will be the same as the directory it is located in.
#Explanation: Ensuring that the same ownership is set as we did for /engineering, /sales & /infosys above
chown engadmin:engineering /engineering/document.txt
chown salesadmin:sales /sales/document.txt
chown isadmin:infosys /infosys/document.txt

#Subtask: The document should contain only one line of text that states, “This file contains confidential information for the department.”
#Explanation: > redirects the output of echo and writes it to the document.
echo "This file contains confidential information for the department." > /engineering/document.txt
echo "This file contains confidential information for the department." > /sales/document.txt
echo "This file contains confidential information for the department." > /infosys/document.txt

#Subtask: This file can be read by any user in the department but can only be modified by the department administrator. No one else has permissions to this file.
#Explanation: u=rw means that the owner has read & write permissions to the file. g=r means that all users that are in the file's ownership group have read permissions. o-rwx means that others have no permissions over the file.
chmod u=rw,g=r,o-rwx /engineering/document.txt
chmod u=rw,g=r,o-rwx /sales/document.txt
chmod u=rw,g=r,o-rwx /infosys/document.txt

#*****************DELIVERABLES*****************
#Task:
#	•	Use the appropriate command to verify each user and group has been created.
#	•	Use the appropriate command to verify each user’s group assignment.
# 
# Command used: members
#
# NOTE: The members command is not installed by default. We can install it with the following command in Ubuntu:
apt -y install members

#The command will verify the existence of the group and show all users that are part of the group. If the group does not exist, the command will return an error.
members engineering
members sales
members infosys

# Output: https://prnt.sc/o054ga
#root@epk19001:/# members engineering
#engadmin enguser1 enguser2
#root@epk19001:/# members sales
#salesadmin salesuser1 salesuser2
#root@epk19001:/# members infosys
#isadmin isuser1 isuser2

# Output: https://prnt.sc/o055ht
# To verify that users have been created succesfully, you can use any of the following commands and replace isadmin with any other username
getnet passwd isadmin
#or
cat /etc/passwd | grep isadmin
#I used the later option.

#Task:
#	•	Use the appropriate command to verify the directory creation and the permission settings.
#   •	Use the appropriate command to verify the files are created in their respective directories.
# Command used: ls 
# Command options:
#   -l :use a long listing format
#   -a :do not ignore entries starting with

ls -la /engineering
ls -la /sales
ls -la /infosys

# Output: https://prnt.sc/o052h3
#root@epk19001:/# ls -la /engineering
#total 24
#drwxr-x--T  5 engadmin engineering 4096 jun 10 22:11 .
#drwxr-xr-x 27 root     root        4096 jun 10 21:53 ..
#-rw-r-----  1 engadmin engineering   64 jun 10 22:12 document.txt
#drwxr-x---  3 engadmin engineering 4096 jun 10 21:55 engadmin
#drwxr-x---  3 enguser1 engineering 4096 jun 10 22:01 enguser1
#drwxr-x---  3 enguser2 engineering 4096 jun 10 22:01 enguser2
#root@epk19001:/# ls -la /sales
#total 24
#drwxr-x--T  5 salesadmin sales 4096 jun 10 22:11 .
#drwxr-xr-x 27 root       root  4096 jun 10 21:53 ..
#-rw-r-----  1 salesadmin sales   64 jun 10 22:13 document.txt
#drwxr-x---  3 salesadmin sales 4096 jun 10 21:58 salesadmin
#drwxr-x---  3 salesuser1 sales 4096 jun 10 22:03 salesuser1
#drwxr-x---  3 salesuser2 sales 4096 jun 10 22:04 salesuser2
#root@epk19001:/# ls -la /infosys
#total 24
#drwxr-x--T  5 isadmin infosys 4096 jun 10 22:11 .
#drwxr-xr-x 27 root    root    4096 jun 10 21:53 ..
#-rw-r-----  1 isadmin infosys   64 jun 10 22:13 document.txt
#drwxr-x---  3 isadmin infosys 4096 jun 10 21:59 isadmin
#drwxr-x---  3 isuser1 infosys 4096 jun 10 22:05 isuser1
#drwxr-x---  3 isuser2 infosys 4096 jun 10 22:06 isuser2
#root@epk19001:/# 