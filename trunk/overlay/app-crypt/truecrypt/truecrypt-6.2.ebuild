# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs multilib wxwidgets

MY_P="${P}.tar.gz"

DESCRIPTION="Free open-source disk encryption software"
HOMEPAGE="http://www.truecrypt.org/"
#SRC_URI="TrueCrypt ${PV} Source.tar.gz"
SRC_URI="${P}.tar.gz
	pkcs11.h
	pkcs11f.h
	pkcs11t.h"

LICENSE="truecrypt-collective-1.4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"
RESTRICT="mirror fetch bindist"

RDEPEND="sys-fs/fuse
	=x11-libs/wxGTK-2.8*"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}-source"

pkg_nofetch() {
	einfo "Please download tar.gz source from:"
	einfo "http://www.truecrypt.org/downloads2.php"
	einfo "Then put the file in ${DISTDIR}/${MY_P}"
	einfo "Please download RSA Security Inc. PKCS #11 Cryptographic Token Interface (Cryptoki) 2.20"
	einfo "header files:"
	einfo "ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-11/v2-20/pkcs11.h"
	einfo "ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-11/v2-20/pkcs11f.h"
	einfo "ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-11/v2-20/pkcs11t.h"
	einfo "Then put files in ${DISTDIR}"
}

pkg_setup() {
	WX_GTK_VER="2.8"
	if use X; then
		need-wxwidgets unicode
	else
		need-wxwidgets base-unicode
	fi
}

src_unpack() {
	unpack ${MY_P}
	cd "${S}"

#	epatch "${FILESDIR}/${PN}-6.1-64bit.patch"
#	epatch "${FILESDIR}/${PN}-6.1-bool.patch"
	epatch "${FILESDIR}/${PN}-6.1-external-wx.patch"
}

src_compile() {
	local EXTRA
	use amd64 && EXTRA="${EXTRA} USE64BIT=1"
	use X || EXTRA="${EXTRA} NOGUI=1"
	if has_version '<sys-libs/glibc-2.7'; then
		if [ "$(gcc-version)" = "4.3" ]; then
			elog "You are trying to compile ${P} using >=sys-devel/gcc-4.3 and <sys-libs/glibc-2.7"
			elog "In this case compiling will failed if not -O0 optimization flag used."
			elog "Therefore ${P} will compliling with -O0 flag."
			elog "Otherwise you could install >=sys-libs/glibc-2.7 or use <sys-devel/gcc-4.3"
			CFLAGS="${CFLAGS} -O0"
			CXXFLAGS="${CXXFLAGS} -O0"
		fi
	fi
	emake \
		${EXTRA} \
		PKCS11_INC="${DISTDIR}" \
		NOSTRIP=1 \
		VERBOSE=1 \
		NOTEST=1 \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		CXX="$(tc-getCXX)" \
		RANLIB="$(tc-getRANLIB)" \
		EXTRA_CFLAGS="${CFLAGS}" \
		EXTRA_CXXFLAGS="${CXXFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		WX_CONFIG="${WX_CONFIG}" \
		WX_CONFIG_EXTRA="" \
		|| die
}

src_test() {
	"${S}/Main/truecrypt" --text --test
}

src_install() {
	dobin Main/truecrypt
	dodoc Readme.txt 'Release/Setup Files/TrueCrypt User Guide.pdf'
	insinto "/$(get_libdir)/rcscripts/addons"
	newins "${FILESDIR}/${PN}-stop.sh" "${PN}-stop.sh"
}

pkg_postinst() {
	elog "potential legal problems - use at own risk"
	elog "http://lists.freedesktop.org/archives/distributions/2008-October/000276.html"
}
