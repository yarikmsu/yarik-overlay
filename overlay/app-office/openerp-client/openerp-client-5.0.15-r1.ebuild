# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"
inherit eutils distutils python

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://www.openerp.com/"
SRC_URI="http://www.openerp.com/download/stable/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-python/matplotlib[gtk]
	dev-python/egenix-mx-base
	x11-libs/hippo-canvas[python]"

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

pkg_setup() {
	python_set_active_version 2
}

src_install() {
	distutils_src_install
	rm "${D}/usr/bin/openerp-client"
	dobin "${FILESDIR}/openerp-client"
	insinto "/usr/share/applications"
	doins "${FILESDIR}/openerp-client.desktop"
}