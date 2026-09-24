# Create a Python virtual environment
python -m venv psdenv

# Activate the virtual environment, install requirements and run the app
& ".\psdenv\Scripts\Activate.ps1"
python -m pip install -r requirements.txt
python main.py
