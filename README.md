# Automated Backup System (Bash Script)

## Project Overview
This project is a Bash-based automated backup system that safely backs up important folders, verifies backup integrity, and cleans up old backups automatically.  
It works like a smart copy system that compresses, verifies, and manages your backups efficiently.

---

## Features
- Takes a folder as input to back up  
- Creates a compressed `.tar.gz` file with a timestamp  
- Generates and verifies a `SHA256` checksum  
- Skips unwanted folders like `.git`, `node_modules`, and `.cache`  
- Automatically deletes old backups (keeps only the last 7)  
- Stores logs in `backup.log`  
- Uses configuration file (`backup.config`) for flexible settings  

---

## Project Structure
backup-system/
├── backup.sh ← Main script
├── backup.config ← Configuration file
├── README.md ← Documentation
└── backups/ ← Backup files are saved here

yaml
Copy code

---

## How to Use

**Step 1:** Open terminal and go to the project directory  
```bash
cd /mnt/c/Users/user/Desktop/Docker\ Task/docker-demo/backup-system
Step 2: Give permission to execute the script

bash
Copy code
chmod +x backup.sh
Step 3: Create a test folder and sample file

bash
Copy code
mkdir -p ~/test-data
echo "Hello Backup System" > ~/test-data/sample.txt
Step 4: Run the backup script

bash
Copy code
./backup.sh ~/test-data
Step 5: Check your backups

bash
Copy code
ls ~/backups
How It Works
The script reads settings from backup.config.

Compresses the target folder into a .tar.gz file with a timestamp.

Generates a SHA256 checksum to verify backup integrity.

Deletes older backups (keeps only the last 7).

Logs every operation in backup.log.

Example Log Output
csharp
Copy code
[INFO] Creating backup: backup-2025-11-07-1007.tar.gz
[SUCCESS] Backup verified successfully!
[INFO] Cleaning up old backups...
[INFO] Cleanup completed. Keeping last 7 backups.
[INFO] Backup completed: backup-2025-11-07-1007.tar.gz
Configuration Example (backup.config)
ini
Copy code
BACKUP_DESTINATION="$HOME/backups"
EXCLUDE_PATTERNS=".git,node_modules,.cache"
DAILY_KEEP=7
WEEKLY_KEEP=4
MONTHLY_KEEP=3
Example Output Files
After running the script, you will find in ~/backups:

lua
Copy code
backup-2025-11-07-1007.tar.gz
backup-2025-11-07-1007.tar.gz.sha256
backup.log
Error Handling
If folder not found → prints Error: Source folder not found.

If config missing → uses default settings automatically.

If backup fails → logs the error in backup.log.

Testing
Tested on Ubuntu (WSL) environment:

Backup creation

Verification using checksum

Automatic cleanup

Logging of all operations

Conclusion
This Automated Backup System fulfills all the requirements of the Bash Scripting Project by performing:

Backup creation

Verification

Cleanup

Logging

Configuration handling
