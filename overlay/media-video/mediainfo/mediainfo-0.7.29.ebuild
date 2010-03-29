# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools wxwidgets confutils

WX_GTK_VER="2.8"

DESCRIPTION="MediaInfo supplies technical and tag information about media files"
HOMEPAGE="http://mediainfo.sourceforge.net"
CLI_SRC_URI="mirror://sourceforge/${PN}/MediaInfo_CLI_${PV}_GNU_FromSource.tar.bz2"
GUI_SRC_URI="mirror://sourceforge/${PN}/MediaInfo_GUI_${PV}_GNU_FromSource.tar.bz2"
SRC_URI="${CLI_SRC_URI}
	wxwidgets? ( ${GUI_SRC_URI} )"

S="${WORKDIR}"
S0="${S}/ZenLib/Project/GNU/Library"
S1="${S}/MediaInfoLib/Project/GNU/Library"
S2="${S}/MediaInfo/Project/GNU/CLI"
S3="${S}/MediaInfo/Project/GNU/GUI"

LICENSE="GPL-3 LGPL-3 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="curl debug libmms static unicode wxwidgets"

DEPEND="
	sys-libs/zlib
	curl? ( net-misc/curl )
	libmms? ( >=media-libs/libmms-0.4 )
	wxwidgets? ( =x11-libs/wxGTK-${WX_GTK_VER}* )
"
RDEPEND="
	${DEPEND}
"

pkg_setup() {
#	confutils_use_depend_all X wxwidgets
	if use wxwidgets; then
		confutils_require_built_with_all "=x11-libs/wxGTK-${WX_GTK_VER}*" X
	fi
}

src_unpack() {
#	subversion_fetch ${ESVN_REPO_URI} MediaInfo
#	ESVN_PROJECT="mediainfolib" subversion_fetch\
#		https://mediainfo.svn.sourceforge.net/svnroot/mediainfo/MediaInfoLib/tags/${PV}\
#		MediaInfoLib
#	ESVN_PROJECT="zenlib" subversion_fetch\
#		https://zenlib.svn.sourceforge.net/svnroot/zenlib/ZenLib/tags/${PV}\
#		ZenLib
	unpack ${A}

	cd "${S}"
	cp -rf MediaInfo_CLI_GNU_FromSource/* ./
	use wxwidgets && cp -rf MediaInfo_GUI_GNU_FromSource/* ./
	rm -rf MediaInfo_*_GNU_FromSource

	for d in ${S0} ${S1} ${S2}; do
		cd ${d} && eautoreconf
	done

	if use wxdgets; then
		cd ${S3}
		eautoreconf
	fi
}

src_compile() {
	local myconf="
			--enable-shared \
			--disable-option-checking \
			--disable-dependency-tracking \
			$(use_enable static) \
			$(use_enable debug) \
			$(use_enable unicode) \
			$(use_enable static staticlibs) \
			$(use_with curl libcurl) \
			$(use_with libmms) \
	"
	local myXconf="
			$(use_with wxwidgets) \
			$(use_with wxwidgets wx-gui) \
			$(use_with wxwidgets wx-config ${WX_CONFIG}) \
	"
	for d in ${S0} ${S1} ${S2}; do
		cd ${d}
		econf \
			${myconf} \
			|| die "econf failed in ${d}"
		emake || die "emake failed in ${d}"
	done

	if use wxwidgets; then
		cd ${S3}
		econf \
			${myconf} \
			${myXconf} \
			|| die "econf failed in ${S3}"
		emake || die "emake failed in ${S3}"
	fi
}

src_install() {
	for d in ${S0} ${S1} ${S2}; do
		emake DESTDIR="${D}" -C ${d} install || die
	done
	if use wxwidgets; then
		emake DESTDIR="${D}" -C ${S3} install || die
	fi
	dodoc MediaInfo/History*.txt MediaInfoLib/*.txt MediaInfoLib/Release/ReadMe_DLL_Linux.txt
	newdoc MediaInfo/Release/ReadMe_CLI_Linux.txt ReadMe_CLI.txt
	if use wxwidgets; then
		newdoc MediaInfo/Release/ReadMe_CLI_Linux.txt ReadMe_GUI.txt || die
	fi
}
