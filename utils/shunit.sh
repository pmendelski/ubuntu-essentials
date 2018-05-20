#!/bin/bash

# This script should be sourced only once
[[ ${SHUNIT_LOADED:-} -eq 1 ]] && return || readonly SHUNIT_LOADED=1

# Colors
declare ASSERT_RED=$(tput setaf 1)
declare ASSERT_GREEN=$(tput setaf 2)
declare ASSERT_MAGENTA=$(tput setaf 5)
declare ASSERT_NORMAL=$(tput sgr0)
declare ASSERT_BOLD=$(tput bold)

# Padding
declare -r ASSERT_PADDING="  "

# Runner flags
declare -i bail=0

# Testing state
declare currentTestFile=""
declare currentTestTitle=""
declare -r TEST_FAILURE_SEP="|"
declare -a testFailures=()
declare -i testCount=0

reportFailures() {
  if [ ${#testFailures[@]} -eq 0 ]; then
    echo -e "\n${ASSERT_BOLD}${ASSERT_GREEN}Tests Passed: ${testCount}\n"
    exit 0
  else
    local previousTestTitle=""
    local -i failures=0
    for failure in "${testFailures[@]}"; do
      IFS=$TEST_FAILURE_SEP read -ra a <<<$failure;
      local testFile=${a[0]}
      local testTitle=${a[1]}
      local message=${a[2]}
      if [ ! "$testTitle" == "$previousTestTitle" ]; then
        previousTestTitle=$testTitle
        failures=$((failures + 1))
      fi
    done
    echo -e "\n${ASSERT_BOLD}${ASSERT_RED}Tests Failed: ${failures}/${testCount}\n"
    exit 1
  fi
}

trap reportFailures EXIT

printTestSummary() {
  local printedTestTitle=0
  for failure in "${testFailures[@]}"; do
    IFS=$TEST_FAILURE_SEP read -ra a <<<$failure;
    local testFile=${a[0]}
    local testTitle=${a[1]}
    local message=${a[2]}
    if [ "$testFile" == "$currentTestFile" ] && [ "$testTitle" == "$currentTestTitle" ]; then
      if [ $printedTestTitle -eq 0 ]; then
        printedTestTitle=1
        echo "${ASSERT_PADDING}${ASSERT_RED}✖ ${testTitle}${ASSERT_NORMAL}"
      fi
      echo "${ASSERT_PADDING}${ASSERT_PADDING}${ASSERT_RED}${message}${ASSERT_NORMAL}"
    fi
  done
  if [ $printedTestTitle -eq 0 ]; then
    printedTestTitle=1
    echo "${ASSERT_PADDING}${ASSERT_GREEN}✔ ${testTitle}${ASSERT_NORMAL}"
  fi
}

addFailure() {
  local -r msg="${1:-Failed}"
  local -r entry="${currentTestFile}${TEST_FAILURE_SEP}${currentTestTitle}${TEST_FAILURE_SEP}${msg}"
  testFailures+=("$entry")
  if [ $bail = 1 ]; then
    exit 1;
  fi
}

test() {
  local -r testName="$1"
  local -r testTitle="${2:-$testName}"
  local -r testFile="${BASH_SOURCE[1]}"
  if [ ! "$testFile" == "$currentTestFile" ]; then
    echo -e "\n${ASSERT_BOLD}${ASSERT_MAGENTA}${BASH_SOURCE[1]}${ASSERT_NORMAL}"
  fi
  testCount=$((testCount + 1))
  currentTestFile=$testFile
  currentTestTitle=$testTitle
  $testName
  printTestSummary
}

runTests() {
  local -r files=${@:-$(find . -name "*.test.sh")}
  for file in $files; do
    source "$file"
  done
}

#############
# Assertions
#############

assertEq() {
  local -r expected="$1"
  local -r actual="$2"
  local -r msg="${3:-Expected equal ('$actual' == '$expected')}"
  if [ ! "$expected" == "$actual" ]; then
    addFailure "$msg"
    return 1
  fi
}

assertNotEq() {
  local -r expected="$1"
  local -r actual="$2"
  local -r msg="${3:-Expected not equal ('$actual' != '$expected')}"
  if [ "$expected" == "$actual" ]; then
    addFailure "$msg"
    return 1
  fi
}

assertSuccess() {
  local -r actual=$?
  local -r msg="${1:-Expected success operation (status: $actual)}"
  assertEq 0 $actual "$msg"
  return "$?"
}

assertFailure() {
  local -r actual="$?"
  local -r msg="${1:-Expected failure operation (status: $actual)}"
  echo "Actual: $actual, msg: $msg"
  assertNotEq 0 $actual "$msg"
  return "$?"
}

assertDir() {
  local -r actual="$1"
  local -r msg="${2:-Expected '$actual' to be a directory}"
  [[ -d "$actual"  ]]
  assertSuccess "$msg"
  return "$?"
}

assertFile() {
  local -r actual="$1"
  local -r msg="${2:-Expected '$actual' to be a file}"
  [[ -f "$actual"  ]]
  assertSuccess "$msg"
  return "$?"
}

assertNotExist() {
  local -r actual="$1"
  local -r msg="${2:-Expected '$actual' to exist}"
  [[ -e "$actual"  ]]
  assertSuccess "$msg"
  return "$?"
}

assertNotExists() {
  local -r actual="$1"
  local -r msg="${2:-Expected '$actual' to not exist}"
  [[ ! -e "$actual"  ]]
  assertSuccess "$msg"
  return "$?"
}

assertStartsWith() {
  local -r actual="$1"
  local -r prefix="$2"
  local -r msg="${3:-Expected '$actual' to start with '$prefix'}"
  [[ ! "${actual##$prefix}" == "${actual}" ]]
  assertSuccess "$msg"
  return "$?"
}

assertEndsWith() {
  local -r actual="$1"
  local -r suffix="$2"
  local -r msg="${3:-Expected '$actual' to end with '$prefix'}"
  [[ ! "${actual%%$suffix}" == "${actual}" ]]
  assertSuccess "$msg"
  return "$?"
}

assertContains() {
  local -r actual="$1"
  local -r part="$2"
  local -r msg="${3:-Expected '$actual' to contain '$part'}"
  [[ ! "${actual/$part/}" == "${actual}" ]]
  assertSuccess "$msg"
  return "$?"
}

###############################################
# Executed as subshell
# Example: ./shunit.sh *.test.sh
# Must be placed at the bottom of the shunit.sh
###############################################

printHelp() {
  echo "NAME"
  echo "  shunit - Test tool for bash scripts. Source: https://github.com/pmendelski/shunit"
  echo ""
  echo "SYNOPSIS"
  echo "  ./shunit.sh [OPTIONS]... [FILES]"
  echo ""
  echo "OPTIONS"
  echo "  -r, --resume          Resume installation process from last error"
  echo "  -c, --nocolor         Disable colors"
  echo "  -h, --help            Print help"
  echo "  -b, --bail            Stop on first failure"
  echo ""
}

noColors() {
  ASSERT_RED=""
  ASSERT_GREEN=$""
  ASSERT_MAGENTA=""
  ASSERT_NORMAL=""
  ASSERT_BOLD=""
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  while (("$#")); do
  case $1 in
    --nocolor|-c)
      noColors
      ;;
    --bail|-b)
      bail=1
      ;;
    --help|-h)
      printHelp
      exit 0
      ;;
    --) # End of all options.
      shift
      break
      ;;
    -?*) # Unidentified option.
      println "Unknown option: $1"
      println "Try --help option"
      exit 1
      ;;
    esac
    shift
  done
  runTests $@
fi
