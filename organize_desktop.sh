#!/bin/zsh

# Desktop Organization Script
# Automatically organizes files on Desktop into appropriate folders
# Created: 2025-10-28

# Prevent errors when glob patterns don't match any files
setopt null_glob

DESKTOP_PATH="$HOME/Desktop"
DATE=$(date +%Y-%m-%d)
LOG_FILE="$HOME/.desktop_organizer.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Change to Desktop directory
cd "$DESKTOP_PATH" || exit 1

log_message "Starting desktop organization..."

# Create folders if they don't exist
mkdir -p "Screenshots" "Projects" \
         "Builds & Releases/StepzSync" "Builds & Releases/Belloo" "Builds & Releases/Other" \
         "Security/Keystores" "Security/Certificates" \
         "Archives" "Documents/Personal" "Documents/Financial" "Documents/Photos" \
         "Notes" "Inbox"

# Counter for moved files
MOVED_COUNT=0

# Move screenshots to Screenshots folder
for file in Screenshot*.png Simulator*.png; do
    if [[ -f "$file" ]]; then
        mv "$file" "Screenshots/"
        log_message "Moved screenshot: $file"
        ((MOVED_COUNT++))
    fi
done

# Move APK and AAB files to Builds & Releases
for file in *.apk *.aab; do
    if [[ -f "$file" ]]; then
        if [[ "$file" == *"stepzsync"* ]] || [[ "$file" == *"StepzSync"* ]]; then
            mv "$file" "Builds & Releases/StepzSync/"
            log_message "Moved build to StepzSync: $file"
            ((MOVED_COUNT++))
        elif [[ "$file" == *"belloo"* ]] || [[ "$file" == *"Belloo"* ]]; then
            mv "$file" "Builds & Releases/Belloo/"
            log_message "Moved build to Belloo: $file"
            ((MOVED_COUNT++))
        else
            mv "$file" "Builds & Releases/Other/"
            log_message "Moved build: $file"
            ((MOVED_COUNT++))
        fi
    fi
done

# Move keystore and security files to Security folder
for file in *.jks *.keystore *.p12 *.pem *.crt *.key; do
    if [[ -f "$file" ]]; then
        if [[ "$file" == *"keystore"* ]] || [[ "$file" == *.jks ]]; then
            mv "$file" "Security/Keystores/"
            log_message "Moved keystore to Security: $file"
            ((MOVED_COUNT++))
        else
            mv "$file" "Security/Certificates/"
            log_message "Moved certificate to Security: $file"
            ((MOVED_COUNT++))
        fi
    fi
done

# Move debug symbols folders to appropriate build folder
for dir in *-debug-symbols; do
    if [[ -d "$dir" ]]; then
        if [[ "$dir" == *"stepzsync"* ]]; then
            mv "$dir" "Builds & Releases/StepzSync/"
            log_message "Moved debug symbols to StepzSync: $dir"
            ((MOVED_COUNT++))
        elif [[ "$dir" == *"belloo"* ]]; then
            mv "$dir" "Builds & Releases/Belloo/"
            log_message "Moved debug symbols to Belloo: $dir"
            ((MOVED_COUNT++))
        else
            mv "$dir" "Builds & Releases/Other/"
            log_message "Moved debug symbols: $dir"
            ((MOVED_COUNT++))
        fi
    fi
done

# Move zip files to Archives
for file in *.zip; do
    if [[ -f "$file" ]]; then
        mv "$file" "Archives/"
        log_message "Moved archive: $file"
        ((MOVED_COUNT++))
    fi
done

# Move various document types to Documents
for file in *.pdf *.doc *.docx *.xls *.xlsx *.ppt *.pptx; do
    if [[ -f "$file" ]]; then
        mv "$file" "Documents/Personal/"
        log_message "Moved document: $file"
        ((MOVED_COUNT++))
    fi
done

# Move images (except screenshots) to Documents/Photos
for file in *.jpg *.jpeg *.JPG *.JPEG; do
    if [[ -f "$file" ]]; then
        mv "$file" "Documents/Photos/"
        log_message "Moved photo: $file"
        ((MOVED_COUNT++))
    fi
done

# Move markdown files to Notes
for file in *.md; do
    if [[ -f "$file" ]]; then
        mv "$file" "Notes/"
        log_message "Moved note: $file"
        ((MOVED_COUNT++))
    fi
done

# Move downloaded files (common download patterns) to Inbox
for file in *.dmg *.pkg *.deb *.rpm; do
    if [[ -f "$file" ]]; then
        mv "$file" "Inbox/"
        log_message "Moved installer to Inbox: $file"
        ((MOVED_COUNT++))
    fi
done

# Move text files to Inbox
for file in *.txt; do
    if [[ -f "$file" ]]; then
        mv "$file" "Inbox/"
        log_message "Moved text file to Inbox: $file"
        ((MOVED_COUNT++))
    fi
done

log_message "Organization complete. Moved $MOVED_COUNT files."

# Optional: Clean up empty folders (except our organized ones)
# Uncomment if you want automatic cleanup
# find . -maxdepth 1 -type d -empty -not -name "." -not -name "Screenshots" \
#     -not -name "Projects" -not -name "Builds & Releases" -not -name "Archives" \
#     -not -name "Documents" -not -name "Notes" -not -name "Inbox" -delete

exit 0
