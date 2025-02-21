#!/bin/bash

#Collects user's name and stores it.
echo -n "Enter your name: "
read name

#Creates parent directory with name variable.
directory="submission_reminder_${name}"

#Creates directories and startup.sh inside the directory.
mkdir -p "$directory"/{app,modules,assets,config}

#!/bin/bash

# Create and populate the functions.sh file with the desired content
cat << 'EOF' > functions.sh
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
            reminders+="⚠ Reminder: ${student^^} has NOT submitted the $assignment assignment!\n"
        fi
    done < <(tail -n +2 "$submissions_file")  # Skip header

    echo -e "$reminders"
}
EOF

#Creates and populates submissions.txt
cat << 'EOF' > submissions.txt
student, assignment, submission status
Chinemerem, Shell Navigation, Not Submitted
Chiagoziem, Git, Submitted
Divine, Shell Navigation, Not Submitted
Anissa, Shell Basics, Submitted
Amos, Python, Not Submitted
Micheal, Emacs, Submitted
Paul, VI, Not Submitted
Nifemi, Hello World, Submitted
Tolu, Shell Basics, Not Submitted
EOF

#Creates and populates reminder.sh with desired code
cat << 'EOF' > reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

#Creates and populates config.env 
cat << 'EOF' > config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

#Creates and populates startup.sh
cat << 'EOF' > startup.sh
#!/bin/bash

# Navigate to the script's directory
cd "$(dirname "$0")"

# Load environment variables
if [ -f config/config.env ]; then
    source config/config.env
else
    echo "Error: config.env file not found!"
    exit 1
fi

# Load helper functions
if [ -f modules/functions.sh ]; then
    source modules/functions.sh
else
    echo "Error: functions.sh file not found!"
    exit 1
fi

# Ensure reminder script is executable
chmod +x app/reminder.sh

# Run the reminder script
if [ -f app/reminder.sh ]; then
    ./app/reminder.sh
else
    echo "Error: reminder.sh file not found!"
    exit 1
fi
EOF

# Move files if they exist
[ -f reminder.sh ] && mv reminder.sh "$directory"/app/
[ -f functions.sh ] && mv functions.sh "$directory"/modules/
[ -f submissions.txt ] && mv submissions.txt "$directory"/assets/
[ -f config.env ] && mv config.env "$directory"/config/
[ -f startup.sh ] && mv startup.sh "$directory"

# Make startup.sh and reminder.sh executable
chmod +x "$directory"/startup.sh
chmod +x "$directory"/app/reminder.sh

echo "Environment setup complete! Navigate to '$directory' and run './startup.sh'"
