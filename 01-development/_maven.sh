#!/bin/bash -e

# declare -r version="3.3.9";
declare -r version="$(curl http://ftp.piotrkosoft.net/pub/mirrors/ftp.apache.org/maven/maven-3 | grep DIR | tail -n 1 | grep -Po '\d+.\d+.\d+' | head -n 1)"
declare -r url="http://ftp.piotrkosoft.net/pub/mirrors/ftp.apache.org/maven/maven-3/${version}/binaries/apache-maven-${version}-bin.tar.gz"
declare -r exportFile="$HOME/.bash_exports"

wget -P /tmp "$url"
tar -zxf "/tmp/apache-maven-${version}-bin.tar.gz" -C /tmp
[ -d "/usr/lib/mvn" ] || sudo mkdir -p "/usr/lib/mvn"
sudo mv "/tmp/apache-maven-${version}" "/usr/lib/mvn/"

for binfile in $(find /usr/lib/mvn/apache-maven-${version}/bin -executable -type f ! -name "*.bat"); do
    declare binname="$(basename $binfile)"
    sudo update-alternatives --install "/usr/bin/$binname" "$binname" "$binfile" 1000
done;

[ ! -e "$HOME/.bash_exports" ] || touch "$HOME/.bash_exports"

if ! grep -qc 'JAVA_HOME' "$HOME/.bash_exports"; then
cat <<EOT | sudo tee -a "$exportFile"

# Java
export JAVA_HOME="\$(update-alternatives --get-selections | grep -e "^java " | tr -s " " | cut -d " " -f 3 | sed -s "s|/jre/bin/java||")"
EOT
fi

if ! grep -qc 'MAVEN_HOME' "$exportFile"; then
cat <<EOT | sudo tee -a "$exportFile"

# Java Build Tool: Maven
export MAVEN_HOME="\$(update-alternatives --get-selections | grep -e "^mvn " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/mvn||")"
export MVN_HOME="\$MAVEN_HOME"
export M2_HOME="\$MAVEN_HOME"
export M3_HOME="\$MAVEN_HOME"
EOT
fi

echo "Maven v${version} installed"