#!/bin/bash

# Nome dell'immagine Docker
IMAGE_NAME="filippo125/ha-icloudpd-addon"
TAG="2.91"

# Costruisce l'immagine per architettura amd64
docker buildx create --use

docker buildx build --platform linux/amd64 -t $IMAGE_NAME:$TAG . --push

echo "Build completata e pushata per $IMAGE_NAME:$TAG (amd64)"
