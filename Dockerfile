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

# Download the Damn Small Linux ISO
RUN wget https://www.damnsmalllinux.org/download/dsl-2024.rc7.iso -O /dsl-2024.rc7.iso

# Expose the VNC port and the web server port
EXPOSE 5900 6080

# Start QEMU with web VNC using noVNC
CMD ["sh", "-c", "qemu-system-i386 -accel tcg -M pc -m 4096 -cdrom /dsl-2024.rc7.iso -vga qxl -vnc :0 & websockify --web=/usr/share/novnc 6080 localhost:5900"]
