# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker

NV_URI="http://us.download.nvidia.com/XFree86/"
X86_NV_PACKAGE="NVIDIA-Linux-x86-${PV}"

DESCRIPTION="NVIDIA firmware required to do video acceleration with nouveau."
HOMEPAGE="http://nouveau.freedesktop.org/wiki/VideoAcceleration/"
SRC_URI="${NV_URI}Linux-x86/${PV}/${X86_NV_PACKAGE}.run
	https://raw.github.com/imirkin/re-vp2/845a51ab607df85fc0ed01f0b5b6d57850e37662/extract_firmware.py -> nvidia_extract_firmware.py"

LICENSE="MIT NVIDIA-r1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND="<dev-lang/python-3"
RDEPEND=""
RESTRICT="bindist mirror strip"
IUSE="-bindist"
REQUIRED_USE="!bindist"

S="${WORKDIR}"

src_unpack() {
	mkdir "${X86_NV_PACKAGE}"
	cd "${X86_NV_PACKAGE}"
	unpack_makeself "${X86_NV_PACKAGE}.run"
}

src_compile() {
	python2 "${DISTDIR}"/nvidia_extract_firmware.py
}

src_install() {
	insinto /lib/firmware/nouveau
	doins nv* vuc-*
}
