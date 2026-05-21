#!/bin/bash

set -euo pipefail

MAVEN_VERSION="${1:-3.9.16}"
INSTALL_DIR="${HOME}/tools"

MAVEN_DIR="apache-maven-${MAVEN_VERSION}"
ARCHIVE="apache-maven-${MAVEN_VERSION}-bin.tar.gz"
URL="https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${ARCHIVE}"

echo "🚀 Installing Apache Maven ${MAVEN_VERSION} on macOS"

# -----------------------------
# 1. Check Java
# -----------------------------
if ! command -v java >/dev/null 2>&1; then
  echo "❌ Java is not installed"
  exit 1
fi

echo "☕ Java version:"
java -version

# -----------------------------
# 2. Prepare directory
# -----------------------------
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# -----------------------------
# 3. Download Maven
# -----------------------------
if [ ! -f "$ARCHIVE" ]; then
  echo "📥 Downloading Maven..."
  curl -fLO "$URL"
else
  echo "ℹ️ Maven archive already exists"
fi

# -----------------------------
# 4. Extract
# -----------------------------
echo "📦 Extracting Maven..."

rm -rf "$MAVEN_DIR"
tar -xzf "$ARCHIVE"

# -----------------------------
# 5. Set environment (CI-safe)
# -----------------------------
export MAVEN_HOME="$INSTALL_DIR/$MAVEN_DIR"
export PATH="$MAVEN_HOME/bin:$PATH"

echo "🧠 MAVEN_HOME=$MAVEN_HOME"

# -----------------------------
# 6. Verify
# -----------------------------
echo "🧪 Verifying installation..."
mvn -v

echo "🎉 Maven ${MAVEN_VERSION} installed successfully"
