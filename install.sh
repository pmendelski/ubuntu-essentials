#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/utils/print.sh

cd "$(dirname "${BASH_SOURCE[0]}")"

# Flags
declare -i nocolor=0
declare -i silent=0
declare -i verbose=0
declare -i dryrun=0
declare -i resume=0
declare files

install() {
  local -r file="$1"
  printInfo "Installing file: $file"
  if [ $dryrun = 0 ]; then
    source $file
  fi
}

resolve() {
  local -r file="$1"
  realpath "$file"
}

listInstallFiles() {
  find . \
    -mindepth 2 -type f \
    ! -path "./.git/*" ! -path "*./utils/*" ! -name ".*" 2>/dev/null \
    | sort
}

installAll() {
  local -r files=$(listInstallFiles)
  for file in $files; do
    install $file
  done
}

installFiles() {
  local -r filesToInstall="$@"
  local -r files=$(listInstallFiles)
  local -i matched=0;
  for file in $files; do
    for fileToInstall in $filesToInstall; do
      if [ $matched = 0 ] && [[ $(resolve "$file") = $(resolve "$fileToInstall")* ]]; then
        matched=1
      fi
    done
    if [ $matched = 1 ]; then
      install "$file"
    else
      printDebug "Skipping: $file"
    fi
    matched=0
  done
}

resumeFrom() {
  local -r startFrom="$1"
  local -r files=$(listInstallFiles)
  local -i found=0
  [ -z "$startFrom" ] && error "Missing file path to resume from. See manual using '--help' option."
  [ ! -f "$startFrom" ] && error "Missing file to resume from."
  printInfo "Resuming from: $startFrom"
  for file in $files; do
    if [ "$found" == 0 ] && [[ $(resolve "$file") = $(resolve "$startFrom")* ]]; then
      found=1
    else
      printDebug "Skipping: $file"
    fi
    if [ "$found" == 1 ]; then
      install $file
    fi
  done
}

function main() {
  if [ $resume = 1 ]; then
    resumeFrom $files
  elif [ -n "$files" ]; then
    installFiles $files
  else
    installAll
  fi
}

function printHelp() {
  echo "Ubuntu essentials"
  echo "Source: https://github.com/pmendelski/ubuntu-essentials"
  echo ""
  echo "NAME"
  echo "  install.sh - Ubuntu essentials install script"
  echo "  cleanup.sh - Ubuntu essentials package manager cleanup script"
  echo ""
  echo "SYNOPSIS"
  echo "  ./install.sh [OPTIONS]... [FILES]"
  echo ""
  echo "OPTIONS"
  echo "  -r, --resume    Resume installation process from given script"
  echo "  -v, --verbose   Print additional logs"
  echo "  -d, --dryrun    Only print additional installation files"
  echo "  -s, --silent    Disable logs. Except errors."
  echo "  -c, --nocolor   Disable colors"
  echo "  -h, --help      Print help"
  echo ""
}

while (("$#")); do
  case $1 in
    --silent|-s)
      silent=1
      ;;
    --nocolor|-c)
      nocolor=1
      ;;
    --dryrun|-d)
      printInfo "Dry run mode enabled"
      dryrun=1
      ;;
    --verbose|-v)
      verbose=$((verbose + 1)) # Each -v argument adds 1 to verbosity.
      ;;
    --help|-h)
      printHelp
      exit 0;
      ;;
    --resume|-r)
      resume=1;
      ;;
    --) # End of all options.
      shift
      break
      ;;
    -?*) # Unidentified option.
      println "Unknown option: $1"
      println "Try --help option"
      exit 1;
      ;;
    *) # Not an option.
      files="$files $1"
      ;;
  esac
  shift
done
main
