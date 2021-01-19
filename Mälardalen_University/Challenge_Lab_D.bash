#!/usr/bin/env bash
#Elias Posluk
#StudentID - (epk19001)
#Laboratory work submission
#Mälardarlen University

# Tasks:
#	•	Extract all the service names from the file.
#	•	Sort the names alphabetically removing any duplicates.
#	•	Remove any blank lines or lines that do not begin with a letter of the alphabet.
#	•	Capture the final output to a file named uniqueservices.txt.
#	•	Count the lines in the file using a conditional command that is only executed if the previous combined commands are successful.
# Deliverables:
# Output: https://prnt.sc/o05oth
#	•	Provide the final command line for successful completion.
#	•	The final result should match the following:
set -o pipefail; cat /etc/services | awk '{print $1}' | uniq | grep -i "^[a-z]" | sort > /home/uniqueservices.txt && wc -l /home/uniqueservices.txt; set +o pipefail
   
# Here is the explanation behind set -o pipefail and set +o pipefail:
# The exit status of a pipeline is the exit status of the last command in the pipeline,
# unless the pipefail option is enabled. If pipefail is enabled, the pipeline’s return status is
# the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands exit successfully
# 
#   set -o pipefail - Enable pipefail
#   set +o pipefail - Disable pipefail
#
# We need that to ensure that only if the whole pipeline is successful, the second command will be executed.
