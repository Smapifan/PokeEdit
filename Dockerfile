FROM ubuntu:22.04

# Basis-Tools und Debug-Helfer
RUN apt-get update && apt-get install -y wget git build-essential python3 file tree

# devkitPro Paketmanagement installieren
RUN wget https://github.com/devkitPro/pacman/releases/download/v1.0.2/devkitpro-pacman.deb
RUN dpkg -i devkitpro-pacman.deb
RUN apt-get update && apt-get install -y devkitpro-pacman

# devkitPro-Switch Toolchain und Libraries
ENV DEVKITPRO=/opt/devkitpro
ENV PATH="/opt/devkitpro/devkitA64/bin:/opt/devkitpro/tools/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN dkp-pacman -Syu --noconfirm switch-dev
RUN dkp-pacman -S --noconfirm switch-libnx switch-mesa switch-mbedtls switch-zlib switch-glad
