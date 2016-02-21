#!/bin/bash -e

# declare -r version="3.3.9";
declare -r version="$(curl -L https://services.gradle.org/versions/current | grep version | grep -Po "(\d+.)?\d+.\d+")"
declare -r url="https://services.gradle.org/distributions/gradle-${version}-bin.zip"
declare -r exportFile="$HOME/.bash_exports"

trap "rm -rf /tmp/gradle-${version}*" EXIT
wget -P /tmp "$url"
unzip "/tmp/gradle-${version}-bin.zip" -d /tmp
[ -d "/usr/lib/gradle" ] || sudo mkdir -p "/usr/lib/gradle"
[ -d "/usr/lib/gradle/gradle-${version}" ] && sudo rm -r "/usr/lib/gradle/gradle-${version}" || :
sudo mv "/tmp/gradle-${version}" "/usr/lib/gradle/"

for binfile in $(find /usr/lib/gradle/gradle-${version}/bin -executable -type f ! -name "*.bat"); do
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

if [ -z "$GRADLE_HOME" ] && ! grep -qc 'GRADLE_HOME' "$exportFile"; then
cat <<EOT | tee -a "$exportFile"

# Java Build Tool: Gradle
export GRADLE_HOME="\$(update-alternatives --get-selections | grep -e "^gradle " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/gradle||")"
EOT
fi

echo "Gradle v${version} installed"
