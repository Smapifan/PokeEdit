FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget git build-essential python3

RUN wget https://github.com/devkitPro/pacman/releases/download/v1.0.2/devkitpro-pacman.deb
RUN dpkg -i devkitpro-pacman.deb
RUN apt-get update && apt-get install -y devkitpro-pacman

ENV DEVKITPRO=/opt/devkitpro
ENV PATH=$PATH:/opt/devkitpro/devkitA64/bin

RUN dkp-pacman -Syu --noconfirm switch-dev
RUN dkp-pacman -S --noconfirm switch-libnx switch-mesa switch-mbedtls switch-zlib switch-glad
