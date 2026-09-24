#!/bin/bash
# Builds ./main from cpp/monocularDepth.cpp (needs g++ and OpenCV with pkg-config)
g++ cpp/monocularDepth.cpp -o main $(pkg-config --cflags --libs opencv4)
