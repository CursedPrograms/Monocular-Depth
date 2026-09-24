import os
import sys
import time

import cv2


# Models live in <repo>/models, regardless of the working directory
path_model = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "models")

# Model file -> input size. The first one found is used.
models = [
    ("model-f6b98070.onnx", 384),  # MiDaS v2.1 Large
    ("model-small.onnx", 256),     # MiDaS v2.1 Small
]

model_file = None
for name, size in models:
    if os.path.exists(os.path.join(path_model, name)):
        model_file, input_size = os.path.join(path_model, name), size
        break

if model_file is None:
    print(f"No MiDaS model found in '{path_model}'.")
    print("Download model-f6b98070.onnx or model-small.onnx - see README.md.")
    sys.exit(1)

print(f"Loading {os.path.basename(model_file)}")

# Load the DNN model
model = cv2.dnn.readNet(model_file)

if model.empty():
    print("Could not load the neural net! - Check path")
    sys.exit(1)

# Use the GPU when OpenCV was built with CUDA, otherwise the CPU
if cv2.cuda.getCudaEnabledDeviceCount() > 0:
    print("Using CUDA")
    model.setPreferableBackend(cv2.dnn.DNN_BACKEND_CUDA)
    model.setPreferableTarget(cv2.dnn.DNN_TARGET_CUDA)
else:
    print("Using CPU")
    model.setPreferableBackend(cv2.dnn.DNN_BACKEND_OPENCV)
    model.setPreferableTarget(cv2.dnn.DNN_TARGET_CPU)

# Webcam
cap = cv2.VideoCapture(0)

if not cap.isOpened():
    print("Could not open the webcam.")
    sys.exit(1)

while cap.isOpened():

    # Read in the image
    success, img = cap.read()
    if not success:
        print("Could not read a frame from the webcam.")
        break

    imgHeight, imgWidth, channels = img.shape

    # start time to calculate FPS
    start = time.time()

    # Create Blob from Input Image
    # MiDaS v2.1 ( Scale : 1 / 255, Size : 384 x 384 (Large) / 256 x 256 (Small), Mean Subtraction : ( 123.675, 116.28, 103.53 ), Channels Order : RGB )
    # swapRB=True converts the BGR webcam frame to RGB
    blob = cv2.dnn.blobFromImage(img, 1/255., (input_size, input_size), (123.675, 116.28, 103.53), True, False)

    # Set input to the model
    model.setInput(blob)

    # Make forward pass in model
    output = model.forward()

    output = output[0, :, :]
    output = cv2.resize(output, (imgWidth, imgHeight))

    # Normalize the output (brighter = closer)
    output = cv2.normalize(output, None, 0, 1, norm_type=cv2.NORM_MINMAX, dtype=cv2.CV_32F)

    # End time
    end = time.time()
    # calculate the FPS for current frame detection
    fps = 1 / max(end - start, 1e-6)
    # Show FPS
    cv2.putText(img, f"{fps:.2f} FPS", (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

    cv2.imshow('image', img)
    cv2.imshow('Depth Map', output)

    if cv2.waitKey(10) & 0xFF == ord('q'):
        break


cap.release()
cv2.destroyAllWindows()
