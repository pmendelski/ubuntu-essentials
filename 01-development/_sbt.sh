#!/bin/bash -e

# Build download url
declare -r version="$(curl -L https://dl.bintray.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch | grep \<a | grep -v "\-M" | grep -v "\-RC" | sed -e "s|<[^>]\+>||g" | grep -Po "\d+\.\d+\.\d+" | tail -n 1)"
declare -r url="https://dl.bintray.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${version}/sbt-launch.jar"

# Fetch
rm -rf "/tmp/sbt-${version}*"
trap "rm -rf /tmp/sbt-${version}*" EXIT
mkdir -p "/tmp/sbt-${version}"
wget -LP "/tmp/sbt-${version}" --content-disposition "$url"

# Create execution script
cat <<EOT | sudo tee "/tmp/sbt-${version}/sbt"

[ ! \$SBT_OPTS ] || SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"
java $SBT_OPTS -jar /usr/lib/sbt/sbt-${version}/sbt-launch.jar "\$@"
EOT
sudo chmod a+x "/tmp/sbt-${version}/sbt"

# Move files to target directory
sudo mkdir -p "/usr/lib/sbt"
sudo rm -rf "/usr/lib/sbt/sbt-${version}"
sudo mv "/tmp/sbt-${version}" "/usr/lib/sbt/"

# Create symbolic link
sudo rm -f "/usr/lib/sbt/sbt-current"
sudo ln -s "/usr/lib/sbt/sbt-${version}" "/usr/lib/sbt/sbt-current"

# Update ubuntu alternatives
for binfile in $(find /usr/lib/sbt/sbt-${version} -executable -type f); do
    declare binname="$(basename $binfile)"
    sudo update-alternatives --install "/usr/bin/$binname" "$binname" "$binfile" 1000
done;

# Add system variables
touch "$HOME/.bash_exports"
if [ -z "$SBT_HOME" ] && ! grep -qc 'SBT_HOME' "$HOME/.bash_exports"; then
cat <<EOT | tee -a "$HOME/.bash_exports"

# Scala Build Tool: SBT
export SBT_HOME="\$(update-alternatives --get-selections | grep -e "^sbt " | tr -s " " | cut -d " " -f 3 | sed -s "s|/sbt||")"
EOT
fi

# Initial run - downloads missing dependencies
sbt -v

echo "SBT v${version} installed"
