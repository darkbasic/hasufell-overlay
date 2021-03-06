# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit scons-utils qt4-r2 games git-2

DESCRIPTION="An accuracy-focused Gameboy / Gameboy Color emulator"
HOMEPAGE="http://sourceforge.net/projects/gambatte"
EGIT_REPO_URI="https://github.com/sinamas/gambatte.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="qt4 +sdl"
REQUIRED_USE="|| ( qt4 sdl )"

RDEPEND="
	sys-libs/zlib
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		media-libs/alsa-lib
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXrandr
		x11-libs/libXv
	)
	sdl? ( media-libs/libsdl[X,audio,joystick,video] )"
DEPEND="${RDEPEND}"

fix_scons() {
	local i
	for i; do
		cat >> $i << END
import os
import SCons.Util

if os.environ.has_key('AR'):
	env['AR'] = os.environ['AR']
if os.environ.has_key('RANLIB'):
	env['RANLIB'] = os.environ['RANLIB']
if os.environ.has_key('CC'):
	env['CC'] = os.environ['CC']
if os.environ.has_key('CFLAGS'):
	env['CCFLAGS'] += SCons.Util.CLVar(os.environ['CFLAGS'])
if os.environ.has_key('CXX'):
	env['CXX'] = os.environ['CXX']
if os.environ.has_key('CXXFLAGS'):
	env['CXXFLAGS'] += SCons.Util.CLVar(os.environ['CXXFLAGS'])
if os.environ.has_key('CPPFLAGS'):
	env['CCFLAGS'] += SCons.Util.CLVar(os.environ['CPPFLAGS'])
if os.environ.has_key('LDFLAGS'):
	env['LINKFLAGS'] += SCons.Util.CLVar(os.environ['LDFLAGS'])
END
	done
}

src_prepare() {
	# Fix zlib/minizip build error
	sed -i \
		-e '1i#define OF(x) x' \
		libgambatte/src/file/unzip/{unzip,ioapi}.h \
		|| die "sed iompi.h failed"

	fix_scons {gambatte_sdl,libgambatte}/SConstruct
}

src_compile() {
	# build core library
	cd "${S}"/libgambatte || die
	escons

	# build sdl frontend
	if use sdl; then
		cd "${S}"/gambatte_sdl || die
		escons
	fi

	# build qt frontend
	if use qt4; then
		cd "${S}"/gambatte_qt || die
		eqmake4 ${PN}_qt.pro
		emake
	fi
}

src_install() {
	use sdl && dogamesbin gambatte_sdl/gambatte_sdl
	use qt4 && dogamesbin gambatte_qt/bin/gambatte_qt

	nonfatal dodoc README changelog

	prepgamesdirs
}
