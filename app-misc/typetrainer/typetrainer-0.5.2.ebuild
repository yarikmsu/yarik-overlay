# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

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

