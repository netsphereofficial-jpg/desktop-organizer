# Desktop Organizer for macOS

Automatically organize your macOS Desktop into clean, structured folders. This tool keeps your Desktop tidy by automatically sorting files into appropriate categories.

## Features

- **Automated Organization**: Runs 4 times daily (9 AM, 1 PM, 6 PM, 10 PM)
- **Smart Categorization**: Automatically sorts files by type and project
- **Security File Handling**: Dedicated folders for keystores and certificates
- **Background Service**: Uses macOS LaunchAgent for seamless automation
- **Detailed Logging**: Tracks all file movements
- **Business-Ready**: Optimized for software development and app builds

## Folder Structure

The script organizes files into these folders on your Desktop:

```
Desktop/
├── Screenshots/          # PNG screenshots and simulator screenshots
├── Projects/            # Code projects and development folders
├── Builds & Releases/   # APK, AAB files and app builds
│   ├── StepzSync/      # StepzSync builds, APKs, AABs, debug symbols
│   ├── Belloo/         # Belloo builds, APKs, AABs, debug symbols
│   └── Other/          # Other project builds
├── Security/            # Security and signing files
│   ├── Keystores/      # .jks, .keystore files
│   └── Certificates/   # .pem, .crt, .key, .p12 files
├── Archives/            # ZIP and archive files
├── Documents/           # Document files
│   ├── Personal/       # PDFs, resumes, letters
│   ├── Financial/      # Bank statements, ID documents
│   └── Photos/         # JPG/JPEG images
├── Notes/              # Markdown files
└── Inbox/              # Miscellaneous downloads (DMG, PKG, TXT)
```

## Installation

### 1. Copy the organization script

```bash
# Create directory for user scripts
mkdir -p ~/.local/bin

# Copy the script to a permanent location
cp organize_desktop.sh ~/.local/bin/
chmod +x ~/.local/bin/organize_desktop.sh
```

### 2. Install the LaunchAgent

```bash
# Copy the plist to LaunchAgents directory
cp com.desktop.organizer.plist ~/Library/LaunchAgents/

# Load the agent
launchctl load ~/Library/LaunchAgents/com.desktop.organizer.plist
```

### 3. Grant Full Disk Access (Required for macOS)

For the LaunchAgent to access your Desktop, you need to grant Full Disk Access:

1. Open **System Settings** → **Privacy & Security** → **Full Disk Access**
2. Click the lock icon to make changes
3. Click the **+** button
4. Press **Cmd+Shift+G** and type: `/bin/zsh`
5. Click **Open** and enable the checkbox

### 4. Verify installation

```bash
# Check if the agent is loaded
launchctl list | grep com.desktop.organizer
```

You should see output like: `-	0	com.desktop.organizer`

## Usage

### Automatic Operation

Once installed, the script runs automatically:
- **9:00 AM** - Start of workday cleanup
- **1:00 PM** - Post-lunch organization
- **6:00 PM** - End of workday cleanup
- **10:00 PM** - Night cleanup

### Manual Execution

Run the script anytime manually:

```bash
~/.local/bin/organize_desktop.sh
```

### View Logs

Check what files have been organized:

```bash
# View organization log
cat ~/.desktop_organizer.log

# View stdout log
cat ~/.desktop_organizer_stdout.log

# View error log (if any)
cat ~/.desktop_organizer_stderr.log
```

## Customization

### Change Schedule

Edit `~/Library/LaunchAgents/com.desktop.organizer.plist`:

```xml
<!-- Run hourly instead of daily -->
<key>StartInterval</key>
<integer>3600</integer>  <!-- 3600 seconds = 1 hour -->
```

Or keep calendar-based schedule but change the time:

```xml
<key>StartCalendarInterval</key>
<dict>
    <key>Hour</key>
    <integer>9</integer>   <!-- Change to 9 AM -->
    <key>Minute</key>
    <integer>30</integer>  <!-- Run at 9:30 AM -->
</dict>
```

After editing, reload the agent:

```bash
launchctl unload ~/Library/LaunchAgents/com.desktop.organizer.plist
launchctl load ~/Library/LaunchAgents/com.desktop.organizer.plist
```

### Add Custom File Types

Edit `organize_desktop.sh` to add more file types or custom rules:

```bash
# Example: Add PDF sorting
for file in *.pdf; do
    if [[ -f "$file" ]]; then
        mv "$file" "Documents/Personal/"
        log_message "Moved PDF: $file"
        ((MOVED_COUNT++))
    fi
done
```

## Uninstallation

To remove the desktop organizer:

```bash
# Unload the agent
launchctl unload ~/Library/LaunchAgents/com.desktop.organizer.plist

# Remove files
rm ~/Library/LaunchAgents/com.desktop.organizer.plist
rm ~/Desktop/organize_desktop.sh
rm ~/.desktop_organizer.log
rm ~/.desktop_organizer_stdout.log
rm ~/.desktop_organizer_stderr.log
```

## File Type Support

The organizer currently handles:

- **Screenshots**: `Screenshot*.png`, `Simulator*.png`
- **Android Builds**: `*.apk`, `*.aab` (Android App Bundles)
- **Security Files**: `*.jks`, `*.keystore`, `*.p12`, `*.pem`, `*.crt`, `*.key`
- **Debug Symbols**: Folders ending with `-debug-symbols`
- **Archives**: `*.zip`
- **Documents**: `*.pdf`, `*.doc`, `*.docx`, `*.xls`, `*.xlsx`, `*.ppt`, `*.pptx`
- **Images**: `*.jpg`, `*.jpeg`, `*.JPG`, `*.JPEG`
- **Notes**: `*.md`
- **Installers**: `*.dmg`, `*.pkg`, `*.deb`, `*.rpm`
- **Text Files**: `*.txt`

## Troubleshooting

### Script not running automatically

```bash
# Check if agent is loaded
launchctl list | grep com.desktop.organizer

# Check error logs
cat ~/.desktop_organizer_stderr.log
```

### Permission errors

If the script runs manually but not automatically, grant Full Disk Access to `/bin/zsh`:
- System Settings → Privacy & Security → Full Disk Access → Add `/bin/zsh`

```bash
# Make script executable
chmod +x ~/.local/bin/organize_desktop.sh
```

### Test the script

```bash
# Run manually to see if it works
~/Desktop/organize_desktop.sh

# Check the log
tail ~/.desktop_organizer.log
```

## Requirements

- macOS (tested on macOS 15.0+)
- zsh shell (default on macOS)
- File system permissions for Desktop access

## License

MIT License - Feel free to modify and distribute

## Author

Created by Nikhil Sahu

## Contributing

Contributions welcome! Feel free to submit issues or pull requests.
