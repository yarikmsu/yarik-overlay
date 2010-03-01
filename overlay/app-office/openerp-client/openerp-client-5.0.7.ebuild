# Copyright 1999-2010 Gentoo Foundation
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

DEPEND="dev-python/pygtk
	gnome-base/libglade
	dev-python/egenix-mx-base
	dev-python/matplotlib"

RDEPEND="${DEPEND}"

src_install() {
	distutils_src_install
	# Adjusting program location
	sed -i -e "s|${D}|/|" "${D}/usr/bin/openerp-client"
}
