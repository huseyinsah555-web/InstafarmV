#!/usr/bin/env sh
##############################################################################
# InstaFarm - Gradle Wrapper Script (Linux/Mac)
# Gradle yoksa otomatik indirir ve derler.
##############################################################################
set -e

APP_HOME="$(cd "$(dirname "$0")" && pwd)"
GRADLE_VERSION="8.4"
GRADLE_HOME="${HOME}/.gradle/wrapper/dists/gradle-${GRADLE_VERSION}-bin/gradle-${GRADLE_VERSION}"

# System gradle var mi?
if command -v gradle > /dev/null 2>&1; then
    exec gradle "$@"
fi

# Cache'de var mi?
if [ -f "${GRADLE_HOME}/bin/gradle" ]; then
    exec "${GRADLE_HOME}/bin/gradle" "$@"
fi

# Indir
echo "==> Gradle ${GRADLE_VERSION} indiriliyor..."
CACHE_DIR="${HOME}/.gradle/wrapper/dists/gradle-${GRADLE_VERSION}-bin"
mkdir -p "${CACHE_DIR}"
ZIP="/tmp/gradle-${GRADLE_VERSION}.zip"

if command -v curl > /dev/null 2>&1; then
    curl -fL "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o "${ZIP}"
elif command -v wget > /dev/null 2>&1; then
    wget -q "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -O "${ZIP}"
else
    echo "HATA: curl veya wget bulunamadi. Lutfen https://gradle.org/install/ adresinden Gradle kurun."
    exit 1
fi

unzip -q "${ZIP}" -d "${CACHE_DIR}/"
rm -f "${ZIP}"
chmod +x "${GRADLE_HOME}/bin/gradle"
echo "==> Gradle hazir!"

exec "${GRADLE_HOME}/bin/gradle" "$@"
