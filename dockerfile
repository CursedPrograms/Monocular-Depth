# Linux image for the Python app.
# The webcam and the OpenCV windows need host access, e.g. on Linux:
#   docker build -t monocular-depth .
#   docker run -it --device /dev/video0 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v "$(pwd)/models:/app/models" monocular-depth
FROM python:3.11-slim

# Libraries opencv-python needs for its GUI windows
RUN apt-get update && apt-get install -y --no-install-recommends libgl1 libglib2.0-0 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "scripts/monocular_depth.py"]
