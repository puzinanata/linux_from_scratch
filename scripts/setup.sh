#!/bin/bash

# Get the absolute path to the project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="$PROJECT_ROOT/data"

# Include utility functions
source "$PROJECT_ROOT/scripts/utils.sh"

echo "Starting setup..."
log "Setup started."

# Create data directory if needed
mkdir -p "$DATA_DIR"

# Create the sample file
echo "Creating sample file in data/"
echo "Sample content" > "$DATA_DIR/sample.txt"

log "Setup complete."
