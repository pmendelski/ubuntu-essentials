# This script should be sourced only once
[[ ${UTILS_TMPDIR_SOURCED:-} -eq 1 ]] && return || readonly UTILS_TMPDIR_SOURCED=1

source $(dirname "${BASH_SOURCE[0]}")/print.sh

createTmpDir() {
  local -r suffix=$1
  local -r tmpdir=$([[ -n "$suffix" ]] \
    && mktemp -d --suffix "-$suffix" \
    || mktemp -d)
  if [[ ! "$tmpdir" || ! -d "$tmpdir" ]]; then
    error "Could not create temp dir $tmpdir"
  fi
  echo $tmpdir
}

removeTmpDir() {
  local -r tmpdir=$1
  if [[ ! "$tmpdir" ]]; then
    error "Could not remove temp dir. Missing path parementer $tmpdir"
  fi
  if [[ ! -d "$tmpdir"  ]]; then
    error "Could not remove temp dir '$tmpdir'. Passed path is not a directory"
  fi
  if [[ "${tmpdir##/tmp/}" == "${tmpdir}" ]] && [ ! "$tmpdir" == "/tmp/" ] ; then
    error "Could not remove temp dir '$tmpdir'. Passed path is not a subpath of /tmp"
  fi
  rm -rf "$tmpdir"
}
