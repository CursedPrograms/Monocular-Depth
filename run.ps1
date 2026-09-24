# Always work from the repo folder
Set-Location $PSScriptRoot
$ErrorActionPreference = "Stop"

$VENV_DIR = "psdenv"
$VENV_PYTHON = Join-Path $VENV_DIR "Scripts\python.exe"
$MODEL_DIR = "models"
$MODEL_FILE = "model-f6b98070.onnx"
$MODEL_URL = "https://github.com/isl-org/MiDaS/releases/download/v2_1/$MODEL_FILE"
$MODEL_PATH = Join-Path $MODEL_DIR $MODEL_FILE

try {
    # Create the virtual environment if it does not exist
    if (-Not (Test-Path $VENV_PYTHON)) {
        Write-Host "Creating virtual environment..."
        python -m venv $VENV_DIR
        if ($LASTEXITCODE -ne 0) { throw "Could not create the virtual environment" }
    }

    # Install requirements into the virtual environment once
    $marker = Join-Path $VENV_DIR ".requirements-installed"
    if (-Not (Test-Path $marker)) {
        Write-Host "Installing requirements..."
        & $VENV_PYTHON -m pip install -r requirements.txt
        if ($LASTEXITCODE -ne 0) { throw "Could not install requirements" }
        New-Item -ItemType File $marker | Out-Null
    }

    # Download the MiDaS model if it is missing
    if (-Not (Test-Path $MODEL_PATH)) {
        Write-Host "Downloading $MODEL_FILE..."
        New-Item -ItemType Directory -Force $MODEL_DIR | Out-Null
        $ProgressPreference = "SilentlyContinue"  # progress bar makes Invoke-WebRequest very slow
        Invoke-WebRequest $MODEL_URL -OutFile "$MODEL_PATH.part"
        Move-Item -Force "$MODEL_PATH.part" $MODEL_PATH
    }

    # Run the depth demo in the virtual environment
    & $VENV_PYTHON scripts\monocular_depth.py
}
catch {
    Write-Host "Setup failed: $_"
    Remove-Item -ErrorAction SilentlyContinue "$MODEL_PATH.part"
}

# Pause for user input before closing (optional)
Read-Host "Press Enter to continue..."
