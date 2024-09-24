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

# Create a directory for the Windows XP ISO and QEMU image
RUN mkdir -p /data

# Change the working directory to /data
WORKDIR /data

# Download the Windows XP ISO into the /data directory
RUN wget -O /data/xp.iso https://ss2.softlay.com/files/en_windows_xp_professional_sp3_Nov_2013_Incl_SATA_Drivers.iso

# Create a QEMU image for Windows XP installation
RUN qemu-img create -f qcow2 /data/xp.qcow2 64G

# Create a start script to simplify container execution
RUN echo '#!/bin/sh\n\
qemu-system-i386 -accel tcg -M pc -m 2G -cdrom /data/xp.iso -vga cirrus -drive file=/data/xp.qcow2,format=qcow2 -vnc :0 &\n\
websockify --web=/usr/share/novnc 6080 localhost:5900' > /data/start.sh && \
    chmod +x /data/start.sh

# Expose the VNC port and the web server port
EXPOSE 5900 6080

# Set the default command to execute the start script
CMD ["/data/start.sh"]
