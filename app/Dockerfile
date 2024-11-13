# Define what image i'll use
FROM ubuntu:latest

# Install depends
RUN apt-get update && \
    apt-get install -y dialog postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Define workdir
WORKDIR /app

# Copy files to workdir
COPY . /app

# Create a simbolyc link to use showdotux
RUN ln -s /app/main.sh /usr/local/bin/showdotux