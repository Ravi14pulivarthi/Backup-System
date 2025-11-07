
# Step 1: Load Config
CONFIG_FILE="./backup.config"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Config file not found. Using default settings."
    BACKUP_DESTINATION="./backups"
    EXCLUDE_PATTERNS=".git,node_modules,.cache"
    DAILY_KEEP=7
    WEEKLY_KEEP=4
    MONTHLY_KEEP=3
fi

# Step 2: Input Check
SOURCE_DIR="$1"
if [ -z "$SOURCE_DIR" ]; then
    echo "Error: Please provide a folder to backup."
    echo "Usage: ./backup.sh /path/to/folder"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source folder not found."
    exit 1
fi

# Step 3: Setup Paths
TIMESTAMP=$(date +%Y-%m-%d-%H%M)
BACKUP_NAME="backup-$TIMESTAMP.tar.gz"
CHECKSUM_FILE="$BACKUP_NAME.sha256"
LOG_FILE="backup.log"

mkdir -p "$BACKUP_DESTINATION"

# Step 4: Exclude Patterns
EXCLUDE_ARGS=()
IFS=',' read -r -a patterns <<< "$EXCLUDE_PATTERNS"
for pattern in "${patterns[@]}"; do
    EXCLUDE_ARGS+=("--exclude=$pattern")
done

# Step 5: Create Backup
echo "[INFO] Creating backup: $BACKUP_NAME"
tar -czf "$BACKUP_DESTINATION/$BACKUP_NAME" "${EXCLUDE_ARGS[@]}" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to create backup!" | tee -a "$LOG_FILE"
    exit 1
fi

# Step 6: Generate Checksum
cd "$BACKUP_DESTINATION" || exit
sha256sum "$BACKUP_NAME" > "$CHECKSUM_FILE"

# Step 7: Verify Backup
sha256sum -c "$CHECKSUM_FILE" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Backup verified successfully!" | tee -a "$LOG_FILE"
else
    echo "[ERROR] Backup verification failed!" | tee -a "$LOG_FILE"
fi

# Step 8: Cleanup Old Backups (Rotation)
echo "[INFO] Cleaning up old backups..."

# Keep only the latest N backups based on DAILY_KEEP
find "$BACKUP_DESTINATION" -name "backup-*.tar.gz" | sort | head -n -"$DAILY_KEEP" | xargs -r rm -f
find "$BACKUP_DESTINATION" -name "backup-*.sha256" | sort | head -n -"$DAILY_KEEP" | xargs -r rm -f

echo "[INFO] Cleanup completed. Keeping last $DAILY_KEEP backups."

# Step 9: Log Completion
echo "[INFO] Backup completed: $BACKUP_NAME" | tee -a "$LOG_FILE"
