#!/bin/bash
set -e

source utils.sh

# Default flags
declare -i nocolor=0
declare -i silent=0
declare -i verbose=0
declare -i force=0
declare -i dryrun=0
declare filter
declare dir

declare -r REPOSITORIES_FILE=".repositories"
declare -r PACKAGES_FILE=".packages"
declare -r CONFIG_BEFORE_FILE=".config-before"
declare -r CONFIG_AFTER_FILE=".config-after"
declare -r LOCK_FILE=".lock"

repository() {
    for repo in "$@"
    do
        echo "printInfo \"[REPOSITORY] $repo\"" >> $REPOSITORIES_FILE
        echo "sudo add-apt-repository -y $repo && printSuccess \"Repository installed successfully: $pack\"" >> $REPOSITORIES_FILE
        printInfo "[REPOSITORY] Registered repository: $repo"
    done
}

package() {
    for pack in "$@"
    do
        echo "printInfo \"[PACKAGE] $pack\"" >> $PACKAGES_FILE
        echo "sudo apt-get -qq install -y --force-yes $pack && printSuccess \"Package installed successfully: $pack\"" >> $PACKAGES_FILE
        printInfo "[PACKAGE] Registered package: $pack"
    done
}

script_before() {
    for config in "$@"
    do
        echo "$config" >> $CONFIG_BEFORE_FILE
        printInfo "[BEFORE] Registered before script"
    done
}

script_after() {
    for config in "$@"
    do
        echo "$config" >> $CONFIG_AFTER_FILE
        printInfo "[AFTER] Registered after script"
    done
}

reset() {
    printDebug "Removing last install scenario"
    [ -f $CONFIG_BEFORE_FILE ] && rm $CONFIG_BEFORE_FILE || printDebug "No before-scripts file"
    [ -f $REPOSITORIES_FILE ] && rm $REPOSITORIES_FILE || printDebug "No repositories file"
    [ -f $PACKAGES_FILE ] && rm $PACKAGES_FILE || printDebug "No packages file"
    [ -f $CONFIG_AFTER_FILE ] && rm $CONFIG_AFTER_FILE || printDebug "No after-scripts file"
}

install() {
    if ([ ! -f $LOCK_FILE ]); then
        if ([ -f $CONFIG_BEFORE_FILE ]); then
            printSuccess ">>> Executing: before-scripts"
            source $CONFIG_BEFORE_FILE
            rm $CONFIG_BEFORE_FILE
            printSuccess "<<< Finished: before-scripts"
        fi
        if ([ -f $REPOSITORIES_FILE ]); then
            printSuccess ">>> Installing repositories"
            source $REPOSITORIES_FILE
            sudo apt-get update
            rm $REPOSITORIES_FILE
            printSuccess "<<< Installed repositories"
        fi
        if ([ -f $PACKAGES_FILE ]); then
            printSuccess ">>> Installing packages"
            source $PACKAGES_FILE
            rm $PACKAGES_FILE
            printSuccess "<<< Installed packages"
        fi
        if ([ -f $CONFIG_AFTER_FILE ]); then
            printSuccess ">>> Executing: after-scripts"
            source $CONFIG_AFTER_FILE
            rm $CONFIG_AFTER_FILE
            printSuccess "<<< Finished: after-scripts"
        fi
    fi
}

function main() {
    reset
    filter="${filter:-*}"
    dir="${dir:-*}"

    for dir in `find . -maxdepth 1 -mindepth 1 -name "$dir" -type d 2>/dev/null | sort`; do
        if askForConfirmation "Do you want to install packages from '$dir'?"; then
            printInfo "Intstalling scripts from $dir"

            for f in `find $dir -type f -name "$filter" ! -name "_*" ! -name "*~" 2>/dev/null | sort`; do
                if askForConfirmation "Do you want to install packages from '$f'?"; then
                    source $f
                else
                    printWarn "Omitted install script: $f"
                fi
            done

            for f in `find $dir -type f -name "$filter" -name "_*" ! -name "*~" 2>/dev/null | sort`; do
                if askForConfirmation "Do you want to run install scripts from '$f'?"; then
                    script_after "bash -e $f"
                else
                    printWarn "Omitted install script: $f"
                fi
            done
        else
            printWarn "Omitted directory: $dir"
        fi
    done

    if [ dryrun = 0 ]; then
        printInfo "Install skipped because of dryrun"
    else
        install
        reset
    fi

}

function resume() {
    if [ dryrun = 0 ]; then
        printInfo "Install skipped because of dryrun"
    else
        install
        reset
    fi
}

function printHelp() {
    echo "NAME"
    echo "  essentials - Ubuntu essentials. Source: https://github.com/mendlik/ubuntu-essentials"
    echo ""
    echo "SYNOPSIS"
    echo "  ./install.sh [OPTION]..."
    echo ""
    echo "OPTIONS"
    echo "  -r, --resume          Resume installation process from last error"
    echo "  -f, --force           Force 'Yes' answer to all questions"
    echo "  -v, --verbose         Print additional logs"
    echo "  -s, --silent          Disable logs. Except confirmations."
    echo "  -n, --nocolor         Disable colors"
    echo "  -d, --dir <VALUE>     Filter install directories"
    echo "  -f, --filter <VALUE>  Filter install scripts"
    echo "  -h, --help            Print help"
    echo ""
}

while (("$#")); do
    case $1 in
        --dryrun|-d)
            dryrun=1
            ;;
        --force|-f)
            force=1
            ;;
        --silent|-s)
            silent=1
            ;;
        --nocolor|-n)
            nocolor=1
            ;;
        --dir|-d)
            shift
            dir=$1
            ;;
        --filter|-f)
            shift
            filter=$1
            ;;
        --verbose|-v)
            verbose=$((verbose + 1)) # Each -v argument adds 1 to verbosity.
            ;;
        --help|-h)
            printHelp
            exit 0;
            ;;
        --resume|-r)
            resume;
            exit 0;
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
    esac
    shift
done
main
