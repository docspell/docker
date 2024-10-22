#!/usr/bin/env bash

set -euo pipefail

name="${1?no name}"

repo="ghcr.io/docspell/$name"
image_name="${repo}:latest"
docker build --cache-from type=gha --cache-to type=gha,mode=max -t "$image_name" -f "Dockerfile.$name" .
docker push "$image_name"
full_version="$(docker run --rm --entrypoint cat "$image_name" "/opt/docspell-$name/version")"
full_version_name="${repo}:v${full_version}"
docker tag "$image_name" "$full_version_name"
docker push "$full_version_name"
minor_version="$(cut -d'.' -f1 <<< "$full_version").$(cut -d'.' -f2 <<< "$full_version")"
minor_version_name="${repo}:v${minor_version}"
docker tag "$image_name" "$minor_version_name"
docker push "$minor_version_name"

