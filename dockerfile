# Use the official Windows Server Core as the base image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set the working directory
WORKDIR /app

# Copy the application files from the host to the container
COPY . .

# Install any necessary dependencies (example: PowerShell modules or other tools)
# RUN powershell -Command Install-Package -Name <package_name>

# Specify the command to run your application
CMD ["powershell.exe", "-File", "your-script.ps1"]
