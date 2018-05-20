#!/bin/bash

source $(dirname "${BASH_SOURCE[0]}")/shunit.sh
source $(dirname "${BASH_SOURCE[0]}")/tmpdir.sh

shouldCreateTmpDir() {
  local -r tmpdir=$(createTmpDir)
  assertDir $tmpdir "Expected tmpdir to be a directory"
  assertStartsWith $tmpdir "/tmp/" "Expected '$tmpdir' to be a subdirectory of /tmp"
}

shouldCreateTmpDirWithSuffix() {
  local -r suffix="test"
  local -r tmpdir=$(createTmpDir $suffix)
  assertDir $tmpdir "Expected tmpdir to be a directory"
  assertStartsWith $tmpdir "/tmp/" "Expected '$tmpdir' to be a subdirectory of /tmp"
  assertEndsWith $tmpdir "-$suffix" "Expected '$tmpdir' to have a suffix '$suffix'"
}

shouldRemoveTmpDir() {
  local -r tmpdir=$(createTmpDir)
  removeTmpDir $tmpdir
  assertSuccess
  assertNotExists $tmpdir "Expected tmpdir to not exist"
}

shouldNotRemoveTmpDir() {
  local -r dir="/tmp"
  local -r msg="$(removeTmpDir "$dir")"
  assertDir $dir
  assertContains "$msg" "Could not remove temp dir '$dir'. Passed path is not a subpath of /tmp"
}

shouldNotRemoveNonTmpDir() {
  local -r dir="$(dirname "${BASH_SOURCE[0]}")"
  local -r msg="$(removeTmpDir "$dir")"
  assertDir "$dir"
  assertContains "$msg" "Could not remove temp dir '$dir'. Passed path is not a subpath of /tmp"
}

shouldNotRemoveNotExistingDir() {
  local -r dir="/tmp/non-existing-directory"
  local -r msg="$(removeTmpDir "$dir")"
  assertContains "$msg" "Could not remove temp dir '$dir'. Passed path is not a directory"
}

test shouldCreateTmpDir
test shouldCreateTmpDirWithSuffix
test shouldRemoveTmpDir
test shouldNotRemoveTmpDir
test shouldNotRemoveNonTmpDir
test shouldNotRemoveNotExistingDir
