#!/bin/bash -e

# declare -r version="3.3.9";
declare -r version="$(curl -L https://dl.bintray.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch | grep \<a | grep -v "\-M" | grep -v "\-RC" | sed -e "s|<[^>]\+>||g" | grep -Po "\d+\.\d+\.\d+" | tail -n 1)"
declare -r url="https://dl.bintray.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${version}/sbt-launch.jar"
declare -r exportFile="$HOME/.bash_exports"

[ -d "/tmp/sbt-${version}" ] || mkdir -p "/tmp/sbt-${version}"
rm -rf "rm -rf /tmp/sbt-${version}*"
trap "rm -rf /tmp/sbt-${version}*" EXIT
wget -LP "/tmp/sbt-${version}" --content-disposition "$url"
cat <<EOT | sudo tee "/tmp/sbt-${version}/sbt"

[ ! \$SBT_OPTS ] || SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"
java $SBT_OPTS -jar /usr/lib/sbt/sbt-${version}/sbt-launch.jar "\$@"
EOT
sudo chmod a+x "/tmp/sbt-${version}/sbt"

[ -d "/usr/lib/sbt" ] || sudo mkdir -p "/usr/lib/sbt"
[ -d "/usr/lib/sbt/sbt-${version}" ] && sudo rm -r "/usr/lib/sbt/sbt-${version}" || :
sudo mv "/tmp/sbt-${version}" "/usr/lib/sbt/"

for binfile in $(find /usr/lib/sbt/sbt-${version} -executable -type f); do
    declare binname="$(basename $binfile)"
    sudo update-alternatives --install "/usr/bin/$binname" "$binname" "$binfile" 1000
done;

touch "$exportFile"
if [ -z "$SBT_HOME" ] && ! grep -qc 'SBT_HOME' "$exportFile"; then
cat <<EOT | tee -a "$exportFile"

# Scala Build Tool: SBT
export SBT_HOME="\$(update-alternatives --get-selections | grep -e "^sbt " | tr -s " " | cut -d " " -f 3 | sed -s "s|/sbt||")"
EOT
fi

# Initial run downloads missing dependencies
sbt -v

echo "SBT v${version} installed"
