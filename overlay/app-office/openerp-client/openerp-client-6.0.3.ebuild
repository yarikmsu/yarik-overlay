# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
inherit distutils

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://www.openerp.com/"
SRC_URI="http://www.openerp.com/download/stable/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-python/matplotlib[gtk]
	dev-python/egenix-mx-base
	x11-libs/hippo-canvas[python]
	media-gfx/pydot
	dev-python/lxml
	x11-libs/gdk-pixbuf[jpeg]"

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	distutils_src_install
	rm "${D}/usr/bin/openerp-client"
	dobin "${FILESDIR}/openerp-client"
	insinto "/usr/share/applications"
	doins "${FILESDIR}/openerp-client.desktop"
}
