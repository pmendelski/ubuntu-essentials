# This script should be sourced only once
[[ ${UTILS_PRINT_SOURCED:-} -eq 1 ]] && return || readonly UTILS_PRINT_SOURCED=1

# Default flags
declare -ri nocolor=0
declare -ri silent=0
declare -ri verbose=0
declare -ri force=0

# Colors
declare -r COLOR_RED=`tput setaf 1`
declare -r COLOR_GREEN=`tput setaf 2`
declare -r COLOR_YELLOW=`tput setaf 3`
declare -r COLOR_BLUE=`tput setaf 4`
declare -r COLOR_MAGENTA=`tput setaf 5`
declare -r COLOR_CYAN=`tput setaf 6`
declare -r COLOR_RESET=`tput sgr0`

askForConfirmation() {
    [ $force != 0 ] && return 0;
    printQuestion "$1 [Y/n] "
    read -r response
    case $response in
        [yY][eE][sS]|[Y]) # deliberately no 'y'
            return 0;
            ;;
        [nN][oO]|[nN])
            return 1;
            ;;
        *)
            askForConfirmation "$1"
            return $?
            ;;
    esac
}

execute() {
    $1 &> /dev/null
    printResult $? "${2:-$1}"
}

printResult() {
    [ $1 -eq 0 ] \
        && printSuccess "$2" \
        || printError "$2"

    [ "$3" == "true" ] && [ $1 -ne 0 ] \
        && exit
}

print() {
    [ $silent == 0 ] && printf "$1"
}

println() {
    print "$1\n"
}

printColor() {
    if [ $nocolor = 0 ]; then
        print "$1$2${COLOR_RESET}"
    else
        print "$2"
    fi
}

printlnColor() {
    printColor "$1" "$2\n"
}

printQuestion() {
    printColor $COLOR_YELLOW "[?] $1"
}

printSuccess() {
    printlnColor $COLOR_GREEN "[ok] $1"
}

printError() {
    printlnColor $COLOR_RED "[error] $1"
}

printWarn() {
    printlnColor $COLOR_MAGENTA "[warn] $1"
}

printInfo() {
    printlnColor $COLOR_CYAN "$1"
}

printDebug() {
    [ $verbose = 1 ] && println "$1" || :
}

error() {
  printError "$@";
  exit 1
}