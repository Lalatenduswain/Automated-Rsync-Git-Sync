#!/bin/bash

# Variables for paths and Git details
REMOTE_ALIAS="YourSSH-Alias"
REMOTE_DIR="/var/www/html"
LOCAL_DIR="/opt/Client-RSync-Backup/ClientName"
EXCLUDES=("--exclude=frontend/storage/framework/sessions/" "--exclude=frontend/storage/logs/")
GIT_REPO_URL="git@git.example.com:Example-Information-Technology/example.git"
LOG_FILE="/var/log/rsync_git_sync.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Function to log messages
log_message() {
    echo "[$DATE] $1" >> $LOG_FILE
}

# Ensure SSH connection is available
if ! ssh -q "$REMOTE_ALIAS" exit; then
    log_message "ERROR: SSH connection to $REMOTE_ALIAS failed."
    exit 1
fi

# Perform rsync with error handling
log_message "Starting rsync from $REMOTE_ALIAS:$REMOTE_DIR to $LOCAL_DIR"
rsync -avz "${EXCLUDES[@]}" "$REMOTE_ALIAS:$REMOTE_DIR" "$LOCAL_DIR" >> $LOG_FILE 2>&1
if [[ $? -ne 0 ]]; then
    log_message "ERROR: Rsync failed. Check details above."
    exit 1
fi
log_message "Rsync completed successfully."

# Navigate to the local directory and initialize Git if needed
cd "$LOCAL_DIR" || { log_message "ERROR: Failed to navigate to $LOCAL_DIR"; exit 1; }

if [ ! -d ".git" ]; then
    log_message "Initializing new Git repository."
    git init >> $LOG_FILE 2>&1
    git remote add origin "$GIT_REPO_URL" >> $LOG_FILE 2>&1
fi

# Ensure main branch is checked out
log_message "Switching to main branch."
git checkout main >> $LOG_FILE 2>&1
if [[ $? -ne 0 ]]; then
    log_message "ERROR: Failed to switch to main branch. Check if branch exists."
    exit 1
fi

# Stage, commit, and push changes
log_message "Staging changes for commit."
git add . >> $LOG_FILE 2>&1

CHANGES=$(git status --porcelain)
if [ -n "$CHANGES" ]; then
    log_message "Committing changes."
    git commit -m "Automated sync and commit: $DATE" >> $LOG_FILE 2>&1
    if [[ $? -ne 0 ]]; then
        log_message "ERROR: Git commit failed."
        exit 1
    fi

    log_message "Pushing changes to remote."
    git push origin main >> $LOG_FILE 2>&1
    if [[ $? -ne 0 ]]; then
        log_message "ERROR: Git push failed. Check for conflicts or authentication issues."
        exit 1
    fi
    log_message "Changes pushed successfully."
else
    log_message "No changes detected. Nothing to commit."
fi

log_message "Script completed successfully."

exit 0
