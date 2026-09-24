[![Twitter: @NorowaretaGemu](https://img.shields.io/badge/X-@NorowaretaGemu-blue.svg?style=flat)](https://x.com/NorowaretaGemu)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

<br>

<br>
<div align="center">
  <a href="https://ko-fi.com/cursedentertainment">
    <img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="ko-fi" style="width: 20%;"/>
  </a>
</div>
  <br>

<div align="center">
  <img alt="Python" src="https://img.shields.io/badge/python%20-%23323330.svg?&style=for-the-badge&logo=python&logoColor=white"/>
</div>

<div align="center">
   <img alt="OpenCV" src="https://img.shields.io/badge/opencv-%23323330.svg?&style=for-the-badge&logo=opencv&logoColor=white"/>
</div>
<div align="center">
  <img alt="PowerShell" src="https://img.shields.io/badge/PowerShell-%23323330.svg?&style=for-the-badge&logo=powershell&logoColor=white"/>
  <img alt="Shell" src="https://img.shields.io/badge/Shell-%23323330.svg?&style=for-the-badge&logo=gnu-bash&logoColor=white"/>
  <img alt="Batch" src="https://img.shields.io/badge/Batch-%23323330.svg?&style=for-the-badge&logo=windows&logoColor=white"/>
  </div>  
  <br>

# Monocular-Depth

Real-time depth estimation from a single webcam using [MiDaS v2.1](https://github.com/isl-org/MiDaS) and OpenCV's DNN module. It shows the camera feed next to a depth map (brighter = closer). Press `q` to quit.

## How to Run:

### Quick Start

Needs Python 3 installed. Run one script and it does everything:

Windows:
- `.\run.bat`
or
- `.\run.ps1`

Unix-like systems (Linux/macOS):
- `./run.sh`

On the first run it creates a `psdenv` virtual environment, installs `requirements.txt` into it and downloads the MiDaS v2.1 Large model (~400 MB) to `models/`. After that it skips whatever is already there and starts the depth demo straight away.

<br>

### Download the Model Manually

The model is not included in the repo. The run scripts download it for you, or download one of these and put it in a `models/` folder in the repo root:

| Model | File | Notes |
|---|---|---|
| MiDaS v2.1 Large | [model-f6b98070.onnx](https://github.com/isl-org/MiDaS/releases/download/v2_1/model-f6b98070.onnx) | Better quality, slower (384x384) |
| MiDaS v2.1 Small | [model-small.onnx](https://github.com/isl-org/MiDaS/releases/download/v2_1/model-small.onnx) | Faster (256x256), used by the C++ version |

```
Monocular-Depth/
  models/
    model-f6b98070.onnx
    model-small.onnx
```

The Python script uses the Large model if present, otherwise the Small one. It runs on the GPU when OpenCV is built with CUDA, otherwise on the CPU (the pip `opencv-python` package is CPU-only).

PowerShell:

```powershell
New-Item -ItemType Directory -Force models
Invoke-WebRequest https://github.com/isl-org/MiDaS/releases/download/v2_1/model-f6b98070.onnx -OutFile models/model-f6b98070.onnx
Invoke-WebRequest https://github.com/isl-org/MiDaS/releases/download/v2_1/model-small.onnx -OutFile models/model-small.onnx
```

Linux/macOS:

```bash
mkdir -p models
curl -L -o models/model-f6b98070.onnx https://github.com/isl-org/MiDaS/releases/download/v2_1/model-f6b98070.onnx
curl -L -o models/model-small.onnx https://github.com/isl-org/MiDaS/releases/download/v2_1/model-small.onnx
```

<br>

### Install Requirements

Using Python directly:

```bash
pip install -r requirements.txt
```
Or run: 
- `install_requirements.bat`

The run scripts above do this for you inside the `psdenv` virtual environment.

<br>

### Run main.py

Opens a menu to pick a script:

```bash
python main.py
```

<br>

## Build the C++ Version

The C++ version (`cpp/monocularDepth.cpp`) uses `models/model-small.onnx`. It needs g++ and OpenCV with pkg-config. On Windows the easiest way is [MSYS2](https://www.msys2.org/):

```bash
pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-opencv mingw-w64-ucrt-x86_64-pkgconf
```

Build:

```bash
g++ cpp/monocularDepth.cpp -o main.exe $(pkg-config --cflags --libs opencv4)
```

or Run:
- `.\exemake.bat` (Windows)
- `./exemake.sh` (Linux/macOS)

Run from the repo root (so `models/` is found):
- `.\runmain.bat`

<br>

## Docker

The `dockerfile` builds a Linux image for the Python version. The webcam and windows need access to the host, so this works on Linux with X11:

```bash
docker build -t monocular-depth .
docker run -it --device /dev/video0 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v "$(pwd)/models:/app/models" monocular-depth
```

<br>
<div align="center">
© Cursed Entertainment
</div>
<br>
<div align="center">
<a href="https://cursed-entertainment.itch.io/" target="_blank">
    <img src="https://github.com/CursedPrograms/cursedentertainment/raw/main/images/logos/logo-wide-grey.png"
        alt="CursedEntertainment Logo" style="width:250px;">
</a>
</div>
