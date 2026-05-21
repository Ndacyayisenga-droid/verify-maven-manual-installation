#!/bin/bash

set -euo pipefail

# ----------------------------
# Config (can be overridden)
# ----------------------------
MAVEN_VERSION="${MAVEN_VERSION:-3.9.16}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/tools}"
MAVEN_DIR_NAME="apache-maven-${MAVEN_VERSION}"
ARCHIVE_NAME="apache-maven-${MAVEN_VERSION}-bin.tar.gz"
DOWNLOAD_URL="https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${ARCHIVE_NAME}"

echo "🚀 Installing Apache Maven ${MAVEN_VERSION}"

# ----------------------------
# 1. Check Java
# ----------------------------
if ! command -v java >/dev/null 2>&1; then
  echo "❌ Java is not installed"
  exit 1
fi

echo "☕ Java version:"
java -version

# ----------------------------
# 2. Prepare directories
# ----------------------------
mkdir -p "$INSTALL_DIR"

cd "$INSTALL_DIR"

# ----------------------------
# 3. Download Maven
# ----------------------------
echo "📥 Downloading Maven ${MAVEN_VERSION}..."

if [ -f "$ARCHIVE_NAME" ]; then
  echo "ℹ️ Archive already exists, skipping download"
else
  curl -fLO "$DOWNLOAD_URL"
fi

# ----------------------------
# 4. Extract Maven
# ----------------------------
echo "📦 Extracting Maven..."

if [ -d "$MAVEN_DIR_NAME" ]; then
  echo "ℹ️ Existing installation found, removing..."
  rm -rf "$MAVEN_DIR_NAME"
fi

tar -xzf "$ARCHIVE_NAME"

# ----------------------------
# 5. Optional cleanup
# ----------------------------
rm -f "$ARCHIVE_NAME"

# ----------------------------
# 6. Set up environment (CI-safe)
# ----------------------------
export MAVEN_HOME="$INSTALL_DIR/$MAVEN_DIR_NAME"
export PATH="$MAVEN_HOME/bin:$PATH"

echo "🧪 Verifying installation..."
echo "MAVEN_HOME = $MAVEN_HOME"

mvn -v

echo "🎉 Maven ${MAVEN_VERSION} installed successfully"-