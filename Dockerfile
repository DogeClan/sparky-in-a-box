# Use the latest Debian base image
FROM debian:latest

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install required packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    git \
    qemu-system \
    qemu-utils \
    novnc \
    websockify \
    && apt-get clean

# Download the SparkyLinux MinimalGUI ISO from the provided URL
RUN wget -O ubuntu.iso https://releases.ubuntu.com/16.04/ubuntu-16.04.6-desktop-i386.iso 

# Create a virtual hard disk image for the virtual machine (using a volume)
RUN qemu-img create -f qcow2 /data/ubuntu.qcow2 

# Expose the VNC port and the web server port
EXPOSE 5900 6080

# Start QEMU with web VNC using noVNC, using the downloaded SparkyLinux ISO file
CMD ["sh", "-c", "qemu-system-i386 -accel tcg -M pc -m 14G -cdrom sparky.iso -hda /data/ubuntu.qcow2 -vga qxl -vnc :0 & websockify --web=/usr/share/novnc 6080 localhost:5900"]
