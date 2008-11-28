# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

RV="${PV}"
MY_P="koffice-${RV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="KOffice is an integrated office suite for KDE, the K Desktop Environment."
HOMEPAGE="http://www.koffice.org/"
SRC_URI="mirror://kde/stable/koffice-${PV}/src/${P}.tar.bz2"
#SRC_URI="mirror://kde/unstable/koffice-${PV/_/-}/src/${MY_P}.tar.bz2"
LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"

# See bug #130442.
#IUSE="doc mysql opengl postgres"
IUSE="doc mysql postgres"

RDEPEND=">=media-libs/freetype-2
	media-libs/fontconfig
	media-libs/libart_lgpl
	dev-libs/libxml2
	dev-libs/libxslt
	sys-libs/readline
	mysql? ( virtual/mysql )
	postgres? ( <dev-libs/libpqxx-2.6.9 )
	virtual/python
	dev-lang/ruby
	>=app-text/wv2-0.1.9
	>=app-text/libwpd-0.8.2
	>=media-gfx/imagemagick-6.2.5.5
	>=media-libs/lcms-1.15
	media-libs/tiff
	media-libs/jpeg
	>=media-libs/openexr-1.2.2-r2
	media-libs/libpng
	>=media-libs/libexif-0.6.13-r1
	virtual/opengl
	virtual/glu"
#	opengl? ( virtual/opengl virtual/glu )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

# add blockers on split packages derived from this one
for x in $(get-child-packages ${CATEGORY}/${PN}); do
	DEPEND="${DEPEND} !${x}"
	RDEPEND="${RDEPEND} !${x}"
done

need-kde 3.45

# TODO: kword sql plugin needs Qt compiled with sql support
# the dependency on python is needed for scripting support in kexi
# and for kivio/kiviopart/kiviosdk.

PATCHES="${FILESDIR}/koffice-xpdf-CVE-2007-3387.diff
		${FILESDIR}/koffice-1.6.3-xpdf2-CVE-2007-4352-5392-5393.diff
		${FILESDIR}/${P}-gcc43.patch"

pkg_setup() {
	# use opengl &&
		if ! built_with_use =x11-libs/qt-3* opengl ; then
			eerror "You need to build x11-libs/qt with opengl use flag enabled."
			die
		fi
		if use arts && ! built_with_use kde-base/kdelibs arts ; then
			eerror "You need to build kde-base/kdelibs with arts use flag enabled."
			die
		fi
}

src_unpack() {
	kde_src_unpack
	# FIXME - disable broken tests for now
	sed -i -e "s:TESTSDIR =.*:TESTSDIR=:" "${S}"/krita/core/Makefile.am \
		$(ls "${S}"/krita/colorspaces/*/Makefile.am)
	sed -i -e "s:toolbar tests:toolbar:" "${S}"/kplato/Makefile.am

	if ! [[ $(xhost >> /dev/null 2>/dev/null) ]] ; then
		einfo "User ${USER} has no X access, disabling some tests."
		sed -e "s:SUBDIRS = . tests:SUBDIRS = .:" -i lib/store/Makefile.am || die "sed failed"
		sed -e "s:SUBDIRS = kohyphen . tests:SUBDIRS = kohyphen .:" -i lib/kotext/Makefile.am || die "sed failed"
	fi

	# Fixing desktop files, cf. bug 190006
	sed -i -e "s:postscript$:postscript;:g" "${S}"/karbon/data/karbon.desktop
	sed -i -e "/^MimeType/{ /[^;]$/{ s/$/;/ } }" "${S}"/kchart/kchart.desktop
	sed -i -e "s:-msaccess:-msaccess;:g" "${S}"/kexi/kexi.desktop
	sed -i -e "s:x-kformula$:x-kformula;:g" "${S}"/kformula/kformula.desktop
	sed -i -e "/^MimeType/{ /[^;]$/{ s/$/;/ } }" "${S}"/kivio/kiviopart/kivio.desktop
	sed -i -e "/^R/{ /[^Y]$/{ s/$/Y/g; } }" "${S}"/krita/krita.desktop
	sed -i -e "/^MimeType/{ /[^;]$/{ s/$/;/ } }" "${S}"/krita/krita.desktop
	sed -i -e "s:x-mswrite:x-mswrite;:g" "${S}"/kword/kword.desktop
	sed -i -e "/^MimeType/{ /[^;]$/{ s/$/;/ } }" "${S}"/kplato/kplato.desktop
	sed -i -e "/^MimeType/{ /[^;]$/{ s/$/;/ } }" "${S}"/kpresenter/kpresenter.desktop
	sed -i -e "/^MimeType/{ /[^;]$/{ s/$/;/ } }" "${S}"/kspread/kspread.desktop
	sed -i -e "/^MimeType/{ /[^;]$/{ s/$/;/ } }" "${S}"/kugar/kudesigner/kudesigner.desktop
	sed -i -e "/^MimeType/{ /[^;]$/{ s/$/;/ } }" "${S}"/kugar/part/kugar.desktop
}

src_compile() {
	local myconf="$(use_enable mysql) $(use_enable postgres pgsql)"
	# $(use_enable opengl gl)"

	kde_src_compile
	if use doc; then
		make apidox || die
	fi
}

src_install() {
	kde_src_install
	if use doc; then
		make DESTDIR="${D}" install-apidox || die
	fi

	dodoc changes-*
}
