# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2:2.6"
inherit distutils python

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
}

src_install() {
	distutils_src_install
}
