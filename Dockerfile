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
    
# Download the Windows Vista Ultimate ISO
RUN wget https://ss2.softlay.com/files/en_windows_xp_professional_sp3_Nov_2013_Incl_SATA_Drivers.iso

# Expose the VNC port and the web server port
EXPOSE 5900 6080

RUN qemu-img create -f qcow2 xp.qcow2 64G
 
# Start QEMU with web VNC using noVNC
CMD ["sh", "-c", "qemu-system-i386 -accel tcg -M pc -m 2G -cdrom en_windows_xp_professional_sp3_Nov_2013_Incl_SATA_Drivers.iso -vga cirrus -vnc :0 & websockify --web=/usr/share/novnc 6080 localhost:5900"]
