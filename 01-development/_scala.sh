#!/bin/bash -e

# declare -r version="3.3.9";
declare -r version="$(curl http://www.scala-lang.org/download/all.html | grep "/download/[0-9]" | grep -v "\-RC" | grep -v "\-M" | grep -v "\.final" | grep -Po "\d+.\d+.\d+" | head -n 1)"
declare -r url="http://downloads.typesafe.com/scala/${version}/scala-${version}.tgz"
declare -r exportFile="$HOME/.bash_exports"

wget -P /tmp "$url"
tar -zxf "/tmp/scala-${version}.tgz" -C /tmp
[ -d "/usr/lib/scala" ] || sudo mkdir -p "/usr/lib/scala"
sudo mv "/tmp/scala-${version}" "/usr/lib/scala/"

for binfile in $(find /usr/lib/scala/scala-${version}/bin -executable -type f ! -name "*.bat"); do
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

if ! grep -qc 'SCALA_HOME' "$exportFile"; then
cat <<EOT | sudo tee -a "$exportFile"

# Scala
export SCALA_HOME="\$(update-alternatives --get-selections | grep -e "^scala " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/scala||")"
EOT
fi

echo "Scala v${version} installed"