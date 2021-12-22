#!/bin/bash
set -e

function build_and_push_image () {
  local DOCKERFILE=$1
  local IMAGE_NAME=$2
  local BALENA_ARCH=$3
  local PLATFORM=$4
  local LIBRESPOT_VERSION=$5

  echo "Building for $BALENA_ARCH, platform $PLATFORM, pushing to $IMAGE_NAME"
  echo "Using librespot version $LIBRESPOT_VERSION"
  docker buildx build . \
      --pull \
      --build-arg BALENA_ARCH=$BALENA_ARCH \
      --build-arg LIBRESPOT_VERSION=$LIBRESPOT_VERSION \
      --platform $PLATFORM \
      --file "$DOCKERFILE" \
      --tag $IMAGE_NAME \
      --load

  echo "Pushing to dockerhub..."
  docker push $IMAGE_NAME
}

function create_and_push_manifest() {
  local NAME=$1
  local TAG=$2
  
  echo "Creating manifest for $NAME:$TAG..."
  docker manifest create $NAME:$TAG \
    --amend $NAME:aarch64
    # --amend $NAME:rpi \
    # --amend $NAME:armv7hf \
    # --amend $NAME:amd64

  docker manifest push $NAME:$TAG
}

LIBRESPOT_VERSION="0.3.1"

# build_and_push_image "Dockerfile.template" "tmigone/librespot:rpi" "rpi" "linux/arm/v6" "$LIBRESPOT_VERSION"
# build_and_push_image "Dockerfile.template" "tmigone/librespot:armv7hf" "armv7hf" "linux/arm/v7" "$LIBRESPOT_VERSION"
build_and_push_image "Dockerfile.template" "tmigone/librespot:aarch64" "aarch64" "linux/arm64" "$LIBRESPOT_VERSION"
# build_and_push_image "Dockerfile.template" "tmigone/librespot:amd64" "amd64" "linux/amd64" "$LIBRESPOT_VERSION"

create_and_push_manifest "tmigone/librespot" "$LIBRESPOT_VERSION"

build_and_push_image "Dockerfile.pulseaudio.template" "tmigone/librespot:aarch64-pulseaudio" "aarch64" "linux/arm64" "$LIBRESPOT_VERSION"
create_and_push_manifest "tmigone/librespot" "$LIBRESPOT_VERSION-pulseaudio"