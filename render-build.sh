#!/bin/bash
set -e  # Exit on error

# Set Java environment
export JAVA_HOME=/usr/lib/jvm/temurin-17-jdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Make gradlew executable and build
chmod +x gradlew
./gradlew build --no-daemon