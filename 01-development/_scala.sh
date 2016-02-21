#!/bin/bash -e

# declare -r version="3.3.9";
declare -r version="$(curl -L http://www.scala-lang.org/download/all.html | grep "/download/[0-9]" | grep -v "\-RC" | grep -v "\-M" | grep -v "\.final" | grep -Po "\d+.\d+.\d+" | head -n 1)"
declare -r url="http://downloads.typesafe.com/scala/${version}/scala-${version}.tgz"
declare -r exportFile="$HOME/.bash_exports"

rm -rf "/tmp/scala-${version}*"
trap "rm -rf /tmp/scala-${version}*" EXIT
wget -LP /tmp "$url"
tar -zxf "/tmp/scala-${version}.tgz" -C /tmp
[ -d "/usr/lib/scala" ] || sudo mkdir -p "/usr/lib/scala"
[ -d "/usr/lib/scala/scala-${version}" ] && sudo rm -r "/usr/lib/scala/scala-${version}" || :
sudo mv "/tmp/scala-${version}" "/usr/lib/scala/"

for binfile in $(find /usr/lib/scala/scala-${version}/bin -executable -type f ! -name "*.bat"); do
    declare binname="$(basename $binfile)"
    sudo update-alternatives --install "/usr/bin/$binname" "$binname" "$binfile" 1000
done;

touch "$exportFile"
if [ -z "$JAVA_HOME" ] && ! grep -qc 'JAVA_HOME' "$exportFile"; then
cat <<EOT | tee -a "$exportFile"

# Java
export JAVA_HOME="\$(update-alternatives --get-selections | grep -e "^java " | tr -s " " | cut -d " " -f 3 | sed -s "s|/jre/bin/java||")"
EOT
fi

if [ -z "$SCALA_HOME" ] && ! grep -qc 'SCALA_HOME' "$exportFile"; then
cat <<EOT | tee -a "$exportFile"

# Scala
export SCALA_HOME="\$(update-alternatives --get-selections | grep -e "^scala " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/scala||")"
EOT
fi

echo "Scala v${version} installed"
