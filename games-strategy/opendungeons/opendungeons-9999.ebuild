# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils eutils git-2 games

MY_PN=OpenDungeons

DESCRIPTION="An open source, real time strategy game based on the Dungeon Keeper series"
HOMEPAGE="http://opendungeons.sourceforge.net"
EGIT_REPO_URI="git://${PN}.git.sourceforge.net/gitroot/${PN}/${PN}"
EGIT_BRANCH="development"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS=""
IUSE=""

# compile error with ogre-1.8.0
# https://sourceforge.net/apps/trac/opendungeons/ticket/69
RDEPEND=">=dev-games/cegui-0.7.0[ogre,opengl]
	>=dev-games/ogre-1.7.0[cg,freeimage,ois,opengl]
	!>=dev-games/ogre-1.8.0
	dev-games/ois
	dev-libs/libpcre
	dev-libs/zziplib
	games-strategy/opendungeons-data
	media-libs/flac
	media-libs/freeimage
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libsfml
	media-libs/libsndfile
	media-libs/libvorbis
	media-libs/openal
	virtual/opengl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CMAKE_IN_SOURCE_BUILD=1

src_configure() {
	local mycmakeargs=(
		-DOPENDUNGEONS_DATA_PATH="${GAMES_DATADIR}"/${MY_PN}
		-DOPENDUNGEONS_BINARY_PATH="${GAMES_BINDIR}"/${MY_PN}.bin
		-DBINDIR="${GAMES_BINDIR}"
		)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	doicon "${FILESDIR}"/${PN}.svg || die
	make_desktop_entry ${MY_PN} ${PN} ${PN}

	prepgamesdirs
}
