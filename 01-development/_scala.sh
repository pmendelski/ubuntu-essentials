#!/bin/bash -e

# Build download url
declare -r version="$(curl -L http://www.scala-lang.org/download/all.html | grep "/download/[0-9]" | grep -v "\-RC" | grep -v "\-M" | grep -v "\.final" | grep -Po "\d+.\d+.\d+" | head -n 1)"
declare -r url="http://downloads.typesafe.com/scala/${version}/scala-${version}.tgz"

# Fetch and extract
rm -rf "/tmp/scala-${version}*"
trap "rm -rf /tmp/scala-${version}*" EXIT
wget -LP /tmp "$url"
tar -zxf "/tmp/scala-${version}.tgz" -C /tmp
sudo mkdir -p "/usr/lib/scala"
sudo rm -rf "/usr/lib/scala/scala-${version}"
sudo mv "/tmp/scala-${version}" "/usr/lib/scala/"

# Create symbolic link
sudo rm -f "/usr/lib/scala/default"
sudo ln -s "/usr/lib/scala/scala-${version}" "/usr/lib/scala/default"

# Update alternatives
for binfile in $(find /usr/lib/scala/scala-${version}/bin -executable -type f ! -name "*.bat"); do
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

if [ -z "$SCALA_HOME" ] && ! grep -qc 'SCALA_HOME' "$HOME/.bash_exports"; then
cat <<EOT | tee -a "$HOME/.bash_exports"

# Scala
export SCALA_HOME="\$(update-alternatives --get-selections | grep -e "^scala " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/scala||")"
EOT
fi

scalac -version

echo "Scala v${version} installed"
