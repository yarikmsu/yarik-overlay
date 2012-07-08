# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="Module to validate VAT numbers"
HOMEPAGE="http://code.google.com/p/vatnumber/"
SRC_URI="http://vatnumber.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vies"

RDEPEND="vies? ( dev-python/suds )"
DEPEND="${RDEPEND}
	dev-python/setuptools"

PYTHON_MODNAME="vatnumber"

src_install() {
	distutils_src_install
	dodoc COPYRIGHT README CHANGELOG
}
