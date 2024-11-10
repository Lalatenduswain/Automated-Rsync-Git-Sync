# Automated Rsync and Git Commit Script

## Overview

This repository contains a Bash script designed to automate the process of syncing files from a remote server to a local directory using `rsync`, and then committing and pushing any changes to a Git repository. This can be particularly useful for maintaining backups or ensuring that changes in a remote directory are versioned and tracked in a local Git repository.

**GitHub Username:** [Lalatendu Swain](https://github.com/Lalatenduswain)  
**Git Repository URL:** [https://github.com/Lalatenduswain/Automated-Rsync-Git-Sync](https://github.com/Lalatenduswain/Automated-Rsync-Git-Sync)

## Prerequisites

Before running this script, ensure the following requirements are met:

- **SSH Key Authentication**: Set up SSH key-based authentication between your local machine and the remote server.
- **Installed Packages**:
  - `rsync`
  - `git`
  - `ssh`
- **Permissions**:
  - Ensure that the script has executable permissions: `chmod +x sync_rsync_git.sh`.
  - You may need `sudo` privileges for installing required packages or accessing certain directories.

## Script Overview

### Script Name
`sync_rsync_git.sh`

### Purpose
This script performs the following functions:
1. Verifies an SSH connection to the remote server.
2. Uses `rsync` to sync files from the remote directory to the local directory with specific exclusions.
3. Initializes a Git repository if one doesn't exist.
4. Stages, commits, and pushes changes to a specified remote Git repository.

### Script Details
The script includes robust error handling and logging to a log file located at `/var/log/rsync_git_sync.log` for tracking activities and potential issues.

### Script Logic
1. **SSH Connection Check**: Verifies that the remote server is accessible via SSH.
2. **Rsync Operation**: Synchronizes the remote directory to the local path with exclusions.
3. **Git Initialization**:
   - Checks if a Git repository is already initialized.
   - If not, initializes a new Git repository and sets the remote origin.
4. **Branch Checkout**: Ensures the `main` branch is active.
5. **Commit and Push**:
   - Adds and commits changes if detected.
   - Pushes changes to the remote repository.

## Script Usage

### Step-by-Step Instructions
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Lalatenduswain/Automated-Rsync-Git-Sync.git
   cd Automated-Rsync-Git-Sync
   ```

2. **Ensure Prerequisites are Installed**:
   Install required packages if they are not already available:
   ```bash
   sudo apt update
   sudo apt install rsync git ssh -y
   ```

3. **Configure SSH**:
   Ensure SSH key-based authentication is set up for seamless access to the remote server.

4. **Run the Script**:
   Make the script executable:
   ```bash
   chmod +x sync_rsync_git.sh
   ```

   Run the script:
   ```bash
   ./sync_rsync_git.sh
   ```

5. **Verify Logs**:
   Check `/var/log/rsync_git_sync.log` for detailed output and potential errors.

## Script Explanation

### Variables
- `REMOTE_ALIAS`: SSH alias for the remote server.
- `REMOTE_DIR`: Directory path on the remote server to sync from.
- `LOCAL_DIR`: Local directory path for syncing files.
- `EXCLUDES`: Array of paths to exclude during the `rsync` operation.
- `GIT_REPO_URL`: URL of the remote Git repository.
- `LOG_FILE`: Path for storing log output.
- `DATE`: Timestamp for log entries.

### Key Functions
- **log_message**: Logs messages to the specified log file with timestamps.
- **SSH Connection Check**: Ensures that the remote server is accessible.
- **Rsync Operation**: Synchronizes files with the specified exclusions and logs output.
- **Git Initialization and Branch Management**: Checks and manages the Git repository state, switching to the `main` branch if needed.
- **Commit and Push Logic**: Detects changes, commits, and pushes updates to the remote repository.

## Disclaimer | Running the Script

**Author**: Lalatendu Swain | [GitHub](https://github.com/Lalatenduswain) | [Website](https://blog.lalatendu.info/)

This script is provided as-is and may require modifications or updates based on your specific environment and requirements. Use it at your own risk. The authors of the script are not liable for any damages or issues caused by its usage.

## Donations

If you find this script useful and want to show your appreciation, you can donate via [Buy Me a Coffee](https://www.buymeacoffee.com/lalatendu.swain).

## Support or Contact
Encountering issues? Don't hesitate to submit an issue on our [GitHub page](https://github.com/Lalatenduswain/Automated-Rsync-Git-Sync/issues).

---

Feel free to contribute, raise issues, or suggest improvements to the script. Your feedback is always appreciated!
