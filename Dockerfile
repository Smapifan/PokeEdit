FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y git curl python3 build-essential wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://apt.devkitpro.org/install-devkitpro-pacman && chmod +x install-devkitpro-pacman \
    && ./install-devkitpro-pacman -y \
    && /usr/bin/dkp-pacman -Syu --noconfirm \
    && /usr/bin/dkp-pacman -S --noconfirm devkitA64 libnx switch-tools

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITA64=/opt/devkitpro/devkitA64

WORKDIR /workspace
