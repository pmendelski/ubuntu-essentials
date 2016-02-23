#!/bin/bash -e

# Build download url
declare -r version="$(curl -L http://dl.bintray.com/groovy/maven | grep "apache-groovy-binary" | head -n 1 | grep -Po "\d+.\d+.\d+" | tail -n 1)"
declare -r url="http://dl.bintray.com/groovy/maven/apache-groovy-binary-${version}.zip"

# Fetch and extract
rm -rf "/tmp/apache-groovy-binary-${version}*"
trap "rm -rf /tmp/apache-groovy-binary-${version}*" EXIT
wget -LP /tmp --content-disposition "$url"
unzip "/tmp/apache-groovy-binary-${version}.zip" -d /tmp
sudo mkdir -p "/usr/lib/groovy"
sudo rm -rf "/usr/lib/groovy/groovy-${version}"
sudo mv "/tmp/groovy-${version}" "/usr/lib/groovy/"

# Create symbolic link
sudo rm -f "/usr/lib/groovy/default"
sudo ln -s "/usr/lib/groovy/groovy-${version}" "/usr/lib/groovy/default"

# Update alternatives
for binfile in $(find /usr/lib/groovy/groovy-${version}/bin -executable -type f ! -name "*.bat"); do
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

if [ -z "$GROOVY_HOME" ] && ! grep -qc 'GROOVY_HOME' "$HOME/.bash_exports"; then
cat <<EOT | tee -a "$HOME/.bash_exports"

# Groovy
export GROOVY_HOME="\$(update-alternatives --get-selections | grep -e "^groovy " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/groovy||")"
EOT
fi

echo "Gradle v${version} installed"
