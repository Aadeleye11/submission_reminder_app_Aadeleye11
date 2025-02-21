#!/bin/bash

# Function to check submissions
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"
    echo "-----------------------------------------"

    reminders=""
    space="----------------------------------"

    while IFS=, read -r student assignment status; do
        student=$(echo "$student" | xargs)
	assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        echo -e "Student Name: $student\nAssignment: $assignment\nSubmission Status:$status\n$space"

        if [[ "$status" == "Not Submitted" ]]; then
            reminders+="⚠️ Reminder: ${student^^} has NOT submitted the $assignment assignment!\n"
        fi
    done < <(tail -n +2 "$submissions_file")  # Skip header

    echo -e "$reminders"
}

