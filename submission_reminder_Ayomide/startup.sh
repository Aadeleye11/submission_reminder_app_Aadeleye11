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

