#!/bin/bash

# Always work from the repo folder
cd "$(dirname "$0")" || exit 1

VENV_DIR="psdenv"
VENV_PYTHON="$VENV_DIR/bin/python"
MODEL_DIR="models"
MODEL_FILE="model-f6b98070.onnx"
MODEL_URL="https://github.com/isl-org/MiDaS/releases/download/v2_1/$MODEL_FILE"

fail() {
    echo "Setup failed: $1"
    rm -f "$MODEL_DIR/$MODEL_FILE.part"
    exit 1
}

# Create the virtual environment if it does not exist
if [ ! -x "$VENV_PYTHON" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR" || fail "could not create the virtual environment"
fi

# Install requirements into the virtual environment once
if [ ! -f "$VENV_DIR/.requirements-installed" ]; then
    echo "Installing requirements..."
    "$VENV_PYTHON" -m pip install -r requirements.txt || fail "could not install requirements"
    touch "$VENV_DIR/.requirements-installed"
fi

# Download the MiDaS model if it is missing
if [ ! -f "$MODEL_DIR/$MODEL_FILE" ]; then
    echo "Downloading $MODEL_FILE..."
    mkdir -p "$MODEL_DIR"
    curl -L --fail -o "$MODEL_DIR/$MODEL_FILE.part" "$MODEL_URL" || fail "could not download the model"
    mv "$MODEL_DIR/$MODEL_FILE.part" "$MODEL_DIR/$MODEL_FILE"
fi

# Run the depth demo in the virtual environment
"$VENV_PYTHON" scripts/monocular_depth.py
