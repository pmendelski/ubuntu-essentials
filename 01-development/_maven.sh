#!/bin/bash -e

# Build download url
declare -r version="$(curl -L http://ftp.piotrkosoft.net/pub/mirrors/ftp.apache.org/maven/maven-3 | grep DIR | tail -n 1 | grep -Po '\d+.\d+.\d+' | head -n 1)"
declare -r url="http://ftp.piotrkosoft.net/pub/mirrors/ftp.apache.org/maven/maven-3/${version}/binaries/apache-maven-${version}-bin.tar.gz"

# Fetch and extract
rm -rf "/tmp/apache-maven-${version}-bin.*"
trap "rm -rf /tmp/apache-maven-${version}-bin.*" EXIT
wget -LP /tmp "$url"
tar -zxf "/tmp/apache-maven-${version}-bin.tar.gz" -C /tmp
sudo mkdir -p "/usr/lib/mvn"
sudo rm -rf "/usr/lib/mvn/apache-maven-${version}"
sudo mv "/tmp/apache-maven-${version}" "/usr/lib/mvn/"

# Create symbolic link
sudo rm -f "/usr/lib/mvn/apache-maven-current"
sudo ln -s "/usr/lib/mvn/apache-maven-${version}" "/usr/lib/mvn/apache-maven-current"

# Update ubuntu alternatives
for binfile in $(find /usr/lib/mvn/apache-maven-${version}/bin -executable -type f ! -name "*.bat"); do
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

if [ -z "$MAVEN_HOME" ] && ! grep -qc 'MAVEN_HOME' "$HOME/.bash_exports"; then
cat <<EOT | tee -a "$HOME/.bash_exports"

# Java Build Tool: Maven
export MAVEN_HOME="\$(update-alternatives --get-selections | grep -e "^mvn " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/mvn||")"
export MVN_HOME="\$MAVEN_HOME"
export M2_HOME="\$MAVEN_HOME"
export M3_HOME="\$MAVEN_HOME"
EOT
fi

echo "Maven v${version} installed"
