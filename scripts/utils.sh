#!/bin/bash

# Get the absolute path to the project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"

log() {
    mkdir -p "$LOG_DIR"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_DIR/setup.log"
}

