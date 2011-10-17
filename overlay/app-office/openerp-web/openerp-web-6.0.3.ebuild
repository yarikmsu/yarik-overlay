# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"

inherit eutils distutils

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://www.openerp.com/"
SRC_URI="http://www.openerp.com/download/stable/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-python/cherrypy
	dev-python/mako
	dev-python/Babel
	dev-python/formencode
	dev-python/simplejson
	dev-python/pyparsing"

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

PYTHON_MODNAME="openerp-web"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-6.0.1-setup_dirty_hack.patch"
}

src_install() {
	distutils_src_install

	doinitd "${FILESDIR}/${PN}"
	newconfd "${FILESDIR}/openerp-web-confd" "${PN}"

	dodir /etc/openerp
	keepdir /var/run/openerp
	keepdir /var/log/openerp
	insinto /etc/openerp
	doins doc/${PN}.cfg || die "doins failed."

	dodoc doc/*
}
