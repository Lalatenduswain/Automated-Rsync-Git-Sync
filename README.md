# Automated Rsync and Git Sync Script for Validex Project

**Author:** Lalatendu Swain | [GitHub](https://github.com/Lalatenduswain)

## Introduction

This repository contains a Bash script named `automated_rsync_git_sync.sh` that automates the process of syncing a remote directory to a local directory, committing any changes, and pushing these changes to a Git repository. This is particularly useful for developers and system administrators who want to ensure continuous updates between a server and a local backup.

## Prerequisites

Before using this script, make sure to have the following:

- **Git** installed on the local machine. [Installation Guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- **Rsync** installed on the local machine. Install via:
  ```bash
  sudo apt-get install rsync
  ```
- **SSH** access configured between the local machine and the remote server. Ensure key-based authentication is set up for seamless operation.
- **Git repository access** with write permissions.
- **Sudo permissions** if you are running the script in directories that require elevated privileges.

## Script Overview

The script performs the following main tasks:

1. Establishes an SSH connection to verify remote server availability.
2. Uses `rsync` to synchronize the contents of the specified remote directory to the local backup directory, excluding defined paths.
3. Initializes a Git repository in the local directory (if not already initialized).
4. Ensures the main branch is checked out.
5. Stages any changes, commits them with a timestamped message, and pushes them to a remote repository.
6. Logs all operations and outputs errors for troubleshooting.

## Script Details

### Script Name

`automated_rsync_git_sync.sh`

### Script Logic Explained

1. **Log function**: Captures messages and outputs them to a log file.
2. **SSH Check**: Verifies if the remote server is reachable.
3. **Rsync Operation**: Syncs the remote directory with the local one while excluding certain subdirectories.
4. **Git Initialization**: Ensures a Git repository is present.
5. **Git Operations**:
   - Checks out the `main` branch.
   - Stages changes, commits them, and pushes to the remote repository.
   - Handles error checking at each step to log issues.

### How to Run the Script

1. Clone the repository:
   ```bash
   git clone https://github.com/Lalatenduswain/automated_rsync_git_sync.sh
   ```

2. Navigate to the script directory:
   ```bash
   cd automated_rsync_git_sync.sh
   ```

3. Make the script executable:
   ```bash
   chmod +x automated_rsync_git_sync.sh
   ```

4. Run the script:
   ```bash
   ./automated_rsync_git_sync.sh
   ```

### Script Code

```bash
#!/bin/bash

# Variables for paths and Git details
REMOTE_ALIAS="remote-server"
REMOTE_DIR="/path/to/remote/dir"
LOCAL_DIR="/path/to/local/dir"
EXCLUDES=("--exclude=some/path/" "--exclude=another/path/")
GIT_REPO_URL="git@github.com:your-username/your-repo.git"
LOG_FILE="/path/to/log/file.log"
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
```

## Running the Script Safely

### Disclaimer

**Author:** Lalatendu Swain | [GitHub](https://github.com/Lalatenduswain) | [Website](https://blog.lalatendu.info/)

This script is provided as-is and may require modifications or updates based on your specific environment and requirements. Use it at your own risk. The authors of the script are not liable for any damages or issues caused by its usage.

### Donations

If you find this script useful and want to show your appreciation, you can donate via [Buy Me a Coffee](https://www.buymeacoffee.com/lalatendu.swain).

## Support or Contact

Encountering issues? Don't hesitate to submit an issue on our [GitHub page](https://github.com/Lalatenduswain/automated_rsync_git_sync.sh/issues).
