#!/bin/bash

declare -gr PR_ESC="\e"
declare -gr PR_RESET="\e[0m"
declare -rgA PR_COLORS=(
    ["WHITE"]="97"
    ["BLACK"]="30"
    ["RED"]="31"
    ["GREEN"]="32"
    ["YELLOW"]="33"
    ["BLUE"]="34"
    ["MAGENTA"]="35"
    ["CYAN"]="36"
    ["GRAY"]="37"
    # intensive colors
    ["GRAY_INT"]="90"
    ["RED_INT"]="91"
    ["GREEN_INT"]="92"
    ["YELLOW_INT"]="93"
    ["BLUE_INT"]="94"
    ["MAGENTA_INT"]="95"
    ["CYAN_INT"]="96"
)
declare -rgA PR_FORMAT=(
    ["NORMAL"]="0"
    ["BOLD"]="1"
    ["UNDERLINE"]="4"
    ["INVERSE"]="7"
    # Don't work on ubuntu
    # ["BLINK"]="5"
    # ["DIM"]="2"
)

function defineColors() {
    local color color_val format format_val
    for color in "${!PR_COLORS[@]}"; do
        color_val=${PR_COLORS[${color}]}
        for format in "${!PR_FORMAT[@]}"; do
            format_val=${PR_FORMAT[${format}]}
            [ "$format" = "NORMAL" ] && \
                format="" || \
                format="_$format"
            eval PR_${color}${format}="'\e[${format_val};${color_val}m'";
        done
    done
}

defineColors
unset -f defineColors

# Default flags
declare -i nocolor=0
declare -i silent=0
declare -i verbose=0
declare -i force=0

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
        print "$1$2${PR_RESET}"
    else
        print "$2"
    fi
}

printlnColor() {
    printColor "$1" "$2\n"
}

printQuestion() {
    printColor $PR_YELLOW "  [?] $1"
}

printSuccess() {
    printlnColor $PR_GREEN "  [ok] $1"
}

printError() {
    printlnColor $PR_RED "  [error] $1"
}

printWarn() {
    printlnColor $PR_MAGENTA "  [warn] $1"
}

printInfo() {
    printlnColor $PR_CYAN "  $1"
}

printDebug() {
    [ $verbose = 1 ] && println "  $1" || :
}
