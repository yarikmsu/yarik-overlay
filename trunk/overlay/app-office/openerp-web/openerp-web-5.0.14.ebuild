# Copyright 1999-2010101010101010101010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils distutils

REV=""

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://www.openerp.com/"
SRC_URI="www.openerp.com/download/stable/source/${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/pyparsing
	>=dev-python/cherrypy-3.1.2
	>=dev-python/Babel-0.9.4
	dev-python/mako
	dev-python/formencode
	dev-python/simplejson"
RDEPEND=$DEPEND

src_compile() {
	return
}

src_install() {
	distutils_src_install

	newinitd "${FILESDIR}"/openerp-web-init.d openerp-web
	newconfd "${FILESDIR}"/openerp-web-conf.d openerp-web

	keepdir /var/run/openerp
	keepdir /var/log/openerp

	insinto /etc/openerp
	rm -rf "${D}/usr/scripts"
	mv "${D}/usr/config/openerp-web.cfg" "${D}/etc/openerp/openerp-web.cfg"
	"rm -rf ${D}/usr/config"
	"rm -rf ${D}/doc"
}
