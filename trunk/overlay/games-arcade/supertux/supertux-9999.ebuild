# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 cmake-utils eutils games

#CMAKE_IN_SOURCE_BUILD=1

DESCRIPTION="Classic 2D jump'n run sidescroller game in a style similar to the original Super Mario Bros."
HOMEPAGE="http://super-tux.sourceforge.net"
SRC_URI=""

EGIT_REPO_URI="https://code.google.com/p/supertux/"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS=""
IUSE="opengl curl debug"

RDEPEND="dev-games/physfs
	dev-libs/boost
	media-libs/glew
	media-libs/libsdl2[joystick]
	media-libs/sdl2-image[png,jpeg]
	media-libs/libvorbis
	media-libs/openal
	x11-libs/libXt
	curl? ( net-misc/curl )
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}"

DOCS="WHATSNEW.txt data/credits.txt"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	sed -e "/Icon=/s/supertux.png/supertux2/" \
		-i supertux2.desktop || die
}

src_configure() {
	local mycmakeargs="-DWERROR=OFF \
			-DINSTALL_SUBDIR_BIN=games/bin \
			-DINSTALL_SUBDIR_DOC=share/doc/${P} \
			$(cmake-utils_use_enable opengl OPENGL) \
			$(cmake-utils_use_enable debug SQDBG) \
			$(cmake-utils_use debug DEBUG)"

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	pushd "${D}/usr/share/pixmaps" &>/dev/null || die
	local ext
	for ext in png xpm ; do
		mv ${PN}{,2}.${ext} || die
	done
	popd &>/dev/null || die

	prepgamesdirs
}
