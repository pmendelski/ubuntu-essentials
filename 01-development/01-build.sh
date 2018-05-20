#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

package build-essential
package automake
package make
package checkinstall
package dpatch
package patchutils
package autotools-dev
package debhelper
package quilt
package fakeroot
package xutils
package lintian
package cmake
package dh-make
package libtool
package autoconf

