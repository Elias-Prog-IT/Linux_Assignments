#!/usr/bin/env bash
#Elias Posluk
#StudentID - (epk19001)
#Laboratory work submission
#Mälardarlen University

# Case Scenario
#There has been suspicious activity on the system. In order to preserve log information, it will be necessary to archive the current files in /var/log ending with the log extension. The files are to be saved to a file named log.tar, stored in the directory, ~/archive.
#It has also been requested that the files that were archived be saved to a directory, ~/backup.

#Procedure#

mkdir ~/archive
mkdir ~/backup

cd /var/log
tar cvzf log.tar *.log
mv log.tar ~/archive
cd ~/archive
tar tf log.tar
tar -C ~/backup -zxvf log.tar