# Use the latest Debian base image
FROM debian:latest

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install required packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    python3 \
    python3-pip \
    git \
    qemu-system-x86 \
    qemu-utils \
    novnc \
    websockify \
    && apt-get clean

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean

# Download the Windows Vista Ultimate ISO
RUN wget https://ss2.softlay.com/files/en_windows_vista_ultimate_sp2_x64_dvd.iso 

# Expose the VNC port and the web server port
EXPOSE 5900 6080

RUN qemu-img create -f qcow2 WinVista.qcow2 128G
 
# Start QEMU with web VNC using noVNC
CMD ["sh", "-c", "qemu-system-i386 -accel tcg -M pc -m 16G -cdrom en_windows_vista_ultimate_sp2_x64_dvd.iso -vga cirrus -vnc :0 & websockify --web=/usr/share/novnc 6080 localhost:5900"]
