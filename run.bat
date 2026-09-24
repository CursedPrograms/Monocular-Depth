@echo off
setlocal

rem Always work from the repo folder
cd /d "%~dp0"

set "VENV_DIR=psdenv"
set "MODEL_DIR=models"
set "MODEL_FILE=model-f6b98070.onnx"
set "MODEL_URL=https://github.com/isl-org/MiDaS/releases/download/v2_1/%MODEL_FILE%"

rem Create the virtual environment if it does not exist
if not exist "%VENV_DIR%\Scripts\python.exe" (
    echo Creating virtual environment...
    python -m venv "%VENV_DIR%" || goto :error
)

rem Install requirements into the virtual environment once
if not exist "%VENV_DIR%\.requirements-installed" (
    echo Installing requirements...
    "%VENV_DIR%\Scripts\python.exe" -m pip install -r requirements.txt || goto :error
    type nul > "%VENV_DIR%\.requirements-installed"
)

rem Download the MiDaS model if it is missing
if not exist "%MODEL_DIR%\%MODEL_FILE%" (
    echo Downloading %MODEL_FILE%...
    if not exist "%MODEL_DIR%" mkdir "%MODEL_DIR%"
    curl -L --fail -o "%MODEL_DIR%\%MODEL_FILE%.part" "%MODEL_URL%" || goto :error
    move /y "%MODEL_DIR%\%MODEL_FILE%.part" "%MODEL_DIR%\%MODEL_FILE%" > nul
)

rem Run the depth demo in the virtual environment
"%VENV_DIR%\Scripts\python.exe" scripts\monocular_depth.py
goto :end

:error
echo Setup failed.
if exist "%MODEL_DIR%\%MODEL_FILE%.part" del "%MODEL_DIR%\%MODEL_FILE%.part"

:end
pause
