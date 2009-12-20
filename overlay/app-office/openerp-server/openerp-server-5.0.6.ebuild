# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild is a modification of the ebuild from zugaina overlay by Yaroslav Gorbunov for yarik-overlay
EAPI=2

inherit eutils distutils multilib python

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://www.openerp.com/"
SRC_URI="http://www.openerp.com/download/stable/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND="virtual/postgresql-base
	dev-python/reportlab
	media-gfx/pydot
	dev-python/psycopg:2[mxdatetime]
	dev-libs/libxml2[python]
	dev-libs/libxslt[python]
	dev-python/pychart
	dev-python/pytz
	dev-python/pyxml
	dev-python/lxml
	dev-python/vobject
	ssl? ( dev-python/pyopenssl )
	dev-python/egenix-mx-base"

RDEPEND="${DEPEND}"

OPENERP_USER=oerp
OPENERP_GROUP=oerp

pkg_setup() {
	enewgroup ${OPENERP_GROUP}
	enewuser ${OPENERP_USER} -1 -1 -1 ${OPENERP_GROUP}
	gpasswd -a ${OPENERP_USER} postgres 2>/dev/null
}

src_compile() {
	return
}

src_install() {
	distutils_src_install

	newinitd "${FILESDIR}"/openerp-init.d openerp
	newconfd "${FILESDIR}"/openerp-conf.d openerp

	keepdir /etc/openerp
	keepdir /var/run/openerp
	keepdir /var/log/openerp

	# Adjusting program location
	sed -i -e "s|${D}|/|" "${D}/usr/bin/openerp-server"

	chmod 0775 "${D}/usr/$(get_libdir)/python${PYVER}/site-packages/openerp-server/openerp-server.py"
	find "${D}/usr/lib/python${PYVER}/site-packages/openerp-server/addons" -type f | xargs chmod 0644
	find "${D}/usr/$(get_libdir)/python${PYVER}/site-packages/openerp-server/addons" -type f | xargs chmod 0644

	fowners ${OPENERP_USER}:${OPENERP_GROUP} /var/run/openerp
	fowners ${OPENERP_USER}:${OPENERP_GROUP} /var/log/openerp
	fowners ${OPENERP_USER}:${OPENERP_GROUP} /etc/openerp

	chown -R ${OPENERP_USER}:${OPENERP_GROUP} "${D}/usr/lib/python${PYVER}/site-packages/openerp-server/addons"
	chown -R ${OPENERP_USER}:${OPENERP_GROUP} "${D}/usr/$(get_libdir)/python${PYVER}/site-packages/openerp-server/addons"
}

pkg_postinst() {
	elog "In order to setup the initial database, run:"
	elog "  emerge --config =${CATEGORY}/${PF}"
	elog "Be sure the database is started before"
}

pquery() {
	psql -q -At -U postgres -d template1 -c "$@"
}

pkg_config() {
	einfo "In the following, the 'postgres' user will be used."
	if ! pquery "SELECT usename FROM pg_user WHERE usename = '${OPENERP_USER}'" | grep -q ${OPENERP_USER}; then
		openerp-server -s --config=/etc/openerp/oerp_serverrc --stop-after-init
		ebegin "Creating database user ${OPENERP_USER}"
		createuser --quiet --username=postgres --createdb ${OPENERP_USER} --no-createrole
		eend $? || die "Failed to create database user"
	fi
}
