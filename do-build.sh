#!/usr/bin/env bash
set -e
HOST_ARCH=$(uname -m)
IMG_NAME="neg2led/unifibrowser"

IMG_TAG=${1:-"latest"}
IMG_TARGET=${2:-$HOST_ARCH}

case $IMG_TARGET in
    "all")
        BUILDX_PLATFORMS=$(echo linux/{amd64,386,arm64,arm/v7,arm/v6} | sed 's/ /,/g')
        ;;
    x86_64|amd64)
        BUILDX_PLATFORMS="linux/amd64"
        ;;
    arm64|aarch64)
        BUILDX_PLATFORMS="linux/arm64"
        ;;
    armhf|armv7)
        BUILDX_PLATFORMS="linux/arm/v7"
        ;;
    armel|armv6)
        BUILDX_PLATFORMS="linux/arm/v6"
        ;;
    arm*)
        BUILDX_PLATFORMS="linux/arm/v6,linux/arm/v7"
        ;;
    *)
        echo "Could not match image target $IMG_TARGET to a buildx platform, sorry..."
        exit 1
        ;;
esac

export DOCKER_BUILDKIT=1
docker buildx build -t $IMG_NAME:$IMG_TAG --platform $BUILDX_PLATFORMS .

exit 0
