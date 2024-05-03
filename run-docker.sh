#!/bin/bash

IMAGE_NAME="jtomcat"

# Check if the image exists
if ! docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
    echo "Image $IMAGE_NAME not found. Building..."
    # Build the image using the Dockerfile in the current directory
    docker build -t "$IMAGE_NAME" ./docker
else
    echo "Image $IMAGE_NAME found."
fi

# Run the container
docker run -v $(pwd):/home/project --name bbpet-webapi -p 8080:8080 "$IMAGE_NAME"

