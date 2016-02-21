#!/bin/bash -e

# declare -r version="3.3.9";
declare -r version="$(curl http://dl.bintray.com/groovy/maven | grep "apache-groovy-binary" | head -n 1 | grep -Po "\d+.\d+.\d+" | tail -n 1)"
declare -r url="http://dl.bintray.com/groovy/maven/apache-groovy-binary-${version}.zip"
declare -r exportFile="$HOME/.bash_exports"

wget -P /tmp --content-disposition "$url"
unzip "/tmp/apache-groovy-binary-${version}.zip" -d /tmp
[ -d "/usr/lib/groovy" ] || sudo mkdir -p "/usr/lib/groovy"
sudo mv "/tmp/groovy-${version}" "/usr/lib/groovy/"

for binfile in $(find /usr/lib/groovy/groovy-${version}/bin -executable -type f ! -name "*.bat"); do
    declare binname="$(basename $binfile)"
    sudo update-alternatives --install "/usr/bin/$binname" "$binname" "$binfile" 1000
done;

[ ! -e "$HOME/.bash_exports" ] || touch "exportFile"


if ! grep -qc 'JAVA_HOME' "$exportFile"; then
cat <<EOT | sudo tee -a "$exportFile"

# Java
export JAVA_HOME="\$(update-alternatives --get-selections | grep -e "^java " | tr -s " " | cut -d " " -f 3 | sed -s "s|/jre/bin/java||")"
EOT
fi

if ! grep -qc 'GROOVY_HOME' "$exportFile"; then
cat <<EOT | sudo tee -a "$exportFile"

# Groovy
export GROOVY_HOME="\$(update-alternatives --get-selections | grep -e "^groovy " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/groovy||")"
EOT
fi

echo "Gradle v${version} installed"