#!/bin/bash -e

# Build download url
declare -r version="$(curl -L https://services.gradle.org/versions/current | grep version | grep -Po "(\d+.)?\d+.\d+")"
declare -r url="https://services.gradle.org/distributions/gradle-${version}-bin.zip"

# Fetch and extract
rm -rf "/tmp/gradle-${version}*"
trap "rm -rf /tmp/gradle-${version}*" EXIT
wget -P /tmp "$url"
unzip "/tmp/gradle-${version}-bin.zip" -d /tmp
sudo mkdir -p "/usr/lib/gradle"
sudo rm -rf "/usr/lib/gradle/gradle-${version}"
sudo mv "/tmp/gradle-${version}" "/usr/lib/gradle/"

# Create symbolic link
sudo rm -f "/usr/lib/gradle/default"
sudo ln -s "/usr/lib/gradle/gradle-${version}" "/usr/lib/gradle/default"

# Update alternatives
for binfile in $(find /usr/lib/gradle/gradle-${version}/bin -executable -type f ! -name "*.bat"); do
    declare binname="$(basename $binfile)"
    sudo update-alternatives --install "/usr/bin/$binname" "$binname" "$binfile" 1000
done;

# Add system variables
touch "$HOME/.bash_exports"
if [ -z "$JAVA_HOME" ] && ! grep -qc 'JAVA_HOME' "$HOME/.bash_exports"; then
cat <<EOT | tee -a "$HOME/.bash_exports"

# Java
export JAVA_HOME="\$(update-alternatives --get-selections | grep -e "^java " | tr -s " " | cut -d " " -f 3 | sed -s "s|/jre/bin/java||")"
EOT
fi

if [ -z "$GRADLE_HOME" ] && ! grep -qc 'GRADLE_HOME' "$HOME/.bash_exports"; then
cat <<EOT | tee -a "$HOME/.bash_exports"

# Java Build Tool: Gradle
export GRADLE_HOME="\$(update-alternatives --get-selections | grep -e "^gradle " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/gradle||")"
EOT
fi

echo "Gradle v${version} installed"
