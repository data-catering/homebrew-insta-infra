#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error when substituting.
set -o pipefail # Causes pipelines to fail on the first command that fails.

FORMULA_FILE="Formula/insta-infra.rb"
REPO="data-catering/insta-infra"
CHECKSUMS_FILE="checksums.txt"

echo "Fetching the latest release tag from GitHub..."
LATEST_TAG=$(gh release list --repo "$REPO" --limit 1 --json tagName -q '.[0].tagName')

if [ -z "$LATEST_TAG" ]; then
    echo "Error: Could not fetch the latest release tag. Is 'gh' installed and configured?"
    exit 1
fi

echo "Latest tag: $LATEST_TAG"

# Extract version number without 'v' prefix if needed, although the formula uses 'vX.Y.Z'
VERSION=$LATEST_TAG

echo "Fetching checksums for release $LATEST_TAG..."
CHECKSUM_URL="https://github.com/$REPO/releases/download/$LATEST_TAG/$CHECKSUMS_FILE"
curl -sSL "$CHECKSUM_URL" -o "$CHECKSUMS_FILE"

if [ ! -f "$CHECKSUMS_FILE" ]; then
    echo "Error: Failed to download checksums file from $CHECKSUM_URL"
    exit 1
fi

echo "Extracting checksums..."
ARM64_FILENAME="insta-${VERSION}-darwin-arm64.tar.gz"
AMD64_FILENAME="insta-${VERSION}-darwin-amd64.tar.gz"

# Correctly extract SHA by finding filename line, getting the next line, and taking the 2nd field
ARM64_SHA=$(grep -A 1 "$ARM64_FILENAME" "$CHECKSUMS_FILE" | tail -n 1 | awk '{print $2}')
AMD64_SHA=$(grep -A 1 "$AMD64_FILENAME" "$CHECKSUMS_FILE" | tail -n 1 | awk '{print $2}')

if [ -z "$ARM64_SHA" ]; then
    echo "Error: Could not find checksum for $ARM64_FILENAME in $CHECKSUMS_FILE"
    rm "$CHECKSUMS_FILE"
    exit 1
fi
if [ -z "$AMD64_SHA" ]; then
    echo "Error: Could not find checksum for $AMD64_FILENAME in $CHECKSUMS_FILE"
    rm "$CHECKSUMS_FILE"
    exit 1
fi

echo "ARM64 SHA256: $ARM64_SHA"
echo "AMD64 SHA256: $AMD64_SHA"

echo "Updating $FORMULA_FILE..."

# Update version
sed -i '' "s/^  version .*/  version \"$VERSION\"/" "$FORMULA_FILE"

# Update ARM64 URL and SHA256
ARM64_URL="https:\/\/github.com\/$REPO\/releases\/download\/$LATEST_TAG\/$ARM64_FILENAME"
sed -i '' "/if Hardware::CPU.arm?/,/else/ s|url \".*\"|url \"$ARM64_URL\"|" "$FORMULA_FILE"
sed -i '' "/if Hardware::CPU.arm?/,/else/ s/sha256 .*/sha256 \"$ARM64_SHA\"/" "$FORMULA_FILE"

# Update AMD64 URL and SHA256
AMD64_URL="https:\/\/github.com\/$REPO\/releases\/download\/$LATEST_TAG\/$AMD64_FILENAME"
# Use a range from 'else' to the end of the conditional block 'end' to be more specific
sed -i '' "/else/,/end/ s|url \".*\"|url \"$AMD64_URL\"|" "$FORMULA_FILE"
sed -i '' "/else/,/end/ s/sha256 .*/sha256 \"$AMD64_SHA\"/" "$FORMULA_FILE"


echo "Cleaning up..."
rm "$CHECKSUMS_FILE"

echo "Successfully updated $FORMULA_FILE to version $LATEST_TAG" 