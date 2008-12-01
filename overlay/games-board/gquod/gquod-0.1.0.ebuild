# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

MY_PN="gnome-quod"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="The player who makes a square on a grid first wins."
HOMEPAGE="http://sourceforge.net/projects/gquod"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}_0.1.0-1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-cpp/gtkmm-2.12
	gnome-base/librsvg"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	egamesconf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}"
}