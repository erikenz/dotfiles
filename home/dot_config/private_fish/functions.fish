# --- Compression ---
function compress
    if test (count $argv) -ne 1
        echo "Usage: compress <directory>"
        return 1
    end
    tar -czf (string trim -r -c '/' $argv[1]).tar.gz (string trim -r -c '/' $argv[1])
end

alias decompress='tar -xzf'

# --- Write ISO to SD card ---
function iso2sd
    if test (count $argv) -ne 2
        echo "Usage: iso2sd <input_file> <output_device>"
        echo "Example: iso2sd ~/Downloads/ubuntu-25.04-desktop-amd64.iso /dev/sda"
        echo ""
        echo "Available SD cards:"
        lsblk -d -o NAME | grep -E '^sd[a-z]' | awk '{print "/dev/"$1}'
    else
        sudo dd bs=4M status=progress oflag=sync if=$argv[1] of=$argv[2]
        and sudo eject $argv[2]
    end
end

# --- Format drive (single ext4 partition) ---
function format-drive
    if test (count $argv) -ne 2
        echo "Usage: format-drive <device> <name>"
        echo "Example: format-drive /dev/sda 'My Stuff'"
        echo ""
        echo "Available drives:"
        lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
        return 1
    end

    set device $argv[1]
    set label $argv[2]

    echo "WARNING: This will completely erase all data on $device and label it '$label'."
    read -l -P "Are you sure you want to continue? (y/N): " confirm
    if string match -qr '^[Yy]$' -- $confirm
        sudo wipefs -a $device
        sudo dd if=/dev/zero of=$device bs=1M count=100 status=progress
        sudo parted -s $device mklabel gpt
        sudo parted -s $device mkpart primary ext4 1MiB 100%
        if string match -q "*nvme*" $device
            sudo mkfs.ext4 -L $label {$device}p1
        else
            sudo mkfs.ext4 -L $label {$device}1
        end
        sudo chmod -R 777 "/run/media/$USER/$label"
        echo "Drive $device formatted and labeled '$label'."
    end
end

# --- Video transcoding helpers ---
function transcode-video-1080p
    if test (count $argv) -ne 1
        echo "Usage: transcode-video-1080p <input_file>"
        return 1
    end
    ffmpeg -i $argv[1] -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy (string replace -r '\.[^.]+$' '' $argv[1])-1080p.mp4
end

function transcode-video-4K
    if test (count $argv) -ne 1
        echo "Usage: transcode-video-4K <input_file>"
        return 1
    end
    ffmpeg -i $argv[1] -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k (string replace -r '\.[^.]+$' '' $argv[1])-optimized.mp4
end

# --- Image transcoding helpers ---
function img2jpg
    if test (count $argv) -ne 1
        echo "Usage: img2jpg <image>"
        return 1
    end
    magick $argv[1] -quality 95 -strip (string replace -r '\.[^.]+$' '' $argv[1]).jpg
end

function img2jpg-small
    if test (count $argv) -ne 1
        echo "Usage: img2jpg-small <image>"
        return 1
    end
    magick $argv[1] -resize 1080x\> -quality 95 -strip (string replace -r '\.[^.]+$' '' $argv[1]).jpg
end

function img2png
    if test (count $argv) -ne 1
        echo "Usage: img2png <image>"
        return 1
    end
    magick $argv[1] -strip \
        -define png:compression-filter=5 \
        -define png:compression-level=9 \
        -define png:compression-strategy=1 \
        -define png:exclude-chunk=all \
        (string replace -r '\.[^.]+$' '' $argv[1]).png
end
