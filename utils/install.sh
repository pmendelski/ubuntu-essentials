source $(dirname "${BASH_SOURCE[0]}")/print.sh
source $(dirname "${BASH_SOURCE[0]}")/tmpdir.sh

repository() {
  local -r repo="$1"
  local -r installFile="${BASH_SOURCE[1]}"
  (sudo add-apt-repository -y $repo && printSuccess "Repository installed successfully: $repo ($installFile)") \
    || error "Could not install repository: $repo ($installFile)"
}

package() {
  local -r name="$1"
  local -r installFile="${BASH_SOURCE[1]}"
  (sudo apt install -y $name && printSuccess "Package installed successfully: $name ($installFile)") \
    || error "Could not install package: $name ($installFile)"
}

snap() {
  local -r name="$1"
  local -r installFile="${BASH_SOURCE[1]}"
  (sudo snap install $name && printSuccess "Snap installed successfully: $name ($installFile)") \
    || (sudo snap install $name --classic && printSuccess "Snap installed successfully in classic mode: $name ($installFile)") \
    || error "Could not install package: $name ($installFile)"
}

deb() {
  local -r url="$1"
  local -r file="${url##*/}"
  local -r installFile="${BASH_SOURCE[1]}"
  local -r tmpdir="$(createTmpDir)"
  cd "$tmpdir"
  wget -q --show-progress "$url"
  (sudo gdebi --n "$file" && printSuccess "Deb installed successfully: $file ($installFile)") \
    || error "Could not install deb: $file ($installFile)"
  cd -
  removeTmpDir "$tmpdir"
}

aptKey() {
  local -r url="$1"
  wget -q "$url" -O- | sudo apt-key add -
}

aptSource() {
  local -r name="$1"
  local -r entry="$2"
  echo "${entry}" | sudo tee "/etc/apt/sources.list.d/${name}.list"
  sudo apt-get update
}

download() {
  local -r url="$1"
  local -r target="$2"
  if [ -z "$target" ]; then
    wget -q --show-progress "$url" || error "Could not download $url"
  elif [[ "$target" == /tmp/* ]]; then
    wget -q --show-progress "$url" -O "$target" || error "Could not download $url"
  else
    sudo wget -q --show-progress "$url" -O "$target" || error "Could not download $url"
  fi
}

extract() {
  local -r package="$1"
  local -r dest="${2:-${package%%.*}}"
  local -r tmp="$(mktemp -d)"
  printDebug "Extracting ${pwd}/${package}"
  case "$1" in
    (*.tar.gz|*.tgz) tar zxf "$1" -C "${tmp}" ;;
    (*.zip) unzip -q "$1" -d "${tmp}" ;;
    (*) error "Could not extract $1";;
  esac
  local -r extracted="$(ls -1q "$tmp")"
  if [[ ! ${#extracted[*]} == "1" ]]; then
    error "Expected package ${package} to contain single directory. Got: ${#extracted[*]}"
  fi
  if [[ ! -d "${tmp}/${extracted}" ]]; then
    error "Expected package ${package} to contain a directory. ${tmp}/${extracted} is not a directory."
  fi
  mkdir "$dest"
  mv "${tmp}/${extracted}"/* "$dest"
  rm -rf "$tmp"
}

installFromUrl() {
  local -r url="$1"
  local -r file="${url##*/}"
  local -r dest="$2"
  local -r name="${dest##*/}"
  local -r tmpdir="$(createTmpDir)"
  cd "$tmpdir"
  download "$url" "$file"
  extract "$file" "$name"
  sudo rm -fr "$dest"
  sudo mkdir -p "$dest"
  sudo mv -fT "$name" "$dest"
  cd -
  removeTmpDir "$tmpdir"
}

localBin() {
  local -r path="$1"
  local -r name="$2"
  sudo rm -f "/usr/local/bin/$name"
  sudo ln -fs "$path" "/usr/local/bin/$name"
}

desktopEntry() {
  local -r name="$1"
  local entries=""
  shift
  for i in "$@"; do
    entries="$entries$i\n"
  done
  echo -e "$entries" | sudo tee "/usr/share/applications/$name.desktop" > /dev/null
}
