# Use the official Node.js 6 image as the base image
FROM node:6

# docker build -t snorpy_app .
# docker run -p 8080:8080 -it --rm --name snorpy_container snorpy_app

# Expose port 8080 to allow external access to the application
EXPOSE 8080

# Replace debian sources with the archive mirror since Debian 9 (Stretch) is no longer supported
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/security.debian.org/s/^/#/' /etc/apt/sources.list && \
    apt-get update && apt-get install -y p7zip-full wget

# Create a new user named 'snorpy' with a home directory and a predefined password
RUN useradd -m --user-group -p $(echo SOMEPASSWORDHERE | openssl passwd -1 -stdin) snorpy

# Clone the Snorpy repository from GitHub to the /opt/snorpy directory
RUN git clone https://github.com/chrisjd20/Snorpy.git /opt/snorpy

# Extract the node_modules.zip file into the /opt/snorpy/ directory
RUN 7z x /opt/snorpy/node_modules.zip -o/opt/snorpy/

# Change the ownership of the /opt/snorpy directory to the 'snorpy' user
RUN chown snorpy:snorpy /opt/snorpy -R

# Switch to the 'snorpy' user
USER snorpy

# Set the working directory to /opt/snorpy
WORKDIR /opt/snorpy

# Define the command to run the application
ENTRYPOINT ["node", "/opt/snorpy/app.js"]
