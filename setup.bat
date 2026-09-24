@echo off
python -m venv psdenv
cmd /k ".\psdenv\Scripts\activate & python -m pip install -r requirements.txt & python main.py"
