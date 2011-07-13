# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
inherit distutils

DESCRIPTION="Typing tutor trainer"
HOMEPAGE="http://github.com/baverman/typetrainer"
SRC_URI="mirror://pypi/t/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-python/pygtk"

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	distutils_src_install
}
