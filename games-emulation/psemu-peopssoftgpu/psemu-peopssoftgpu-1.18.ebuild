# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games

DESCRIPTION="P.E.Op.S Software GPU plugin"
HOMEPAGE="http://sourceforge.net/projects/peops/"
SRC_URI="mirror://sourceforge/peops/PeopsSoftGpu${PV//./}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="x86? ( x11-libs/gtk+:1 )
	amd64? ( app-emulation/emul-linux-x86-gtklibs )"

S="${WORKDIR}"/gpuPeopsSoft

src_install() {
	dodoc *.txt
	insinto "$(games_get_libdir)"/psemu/cfg
	doins gpuPeopsSoftX.cfg || die "doins failed"
	exeinto "$(games_get_libdir)"/psemu/plugins
	doexe libgpuPeops* || die "doexe failed"
	exeinto "$(games_get_libdir)"/psemu/cfg
	doexe cfgPeopsSoft || die "doexe failed"
	prepgamesdirs
}
