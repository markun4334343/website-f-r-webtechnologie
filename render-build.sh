#!/bin/bash
set -e  # Exit on error
sudo apt-get update
sudo apt-get install -y ncurses-bin  # Fixes tput error
chmod +x gradlew
export JAVA_HOME=/usr/lib/jvm/temurin-17-jdk-amd64
./gradlew build --no-daemon