#!/bin/bash
python3 -m venv psdenv
source psdenv/bin/activate
python -m pip install -r requirements.txt
python main.py
