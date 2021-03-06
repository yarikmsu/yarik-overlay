# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 unpacker

NV_URI="http://us.download.nvidia.com/XFree86/"
X86_NV_PACKAGE="NVIDIA-Linux-x86-${PV}"

DESCRIPTION="Kernel and mesa firmware for nouveau (video accel and pgraph)"
HOMEPAGE="http://nouveau.freedesktop.org/wiki/VideoAcceleration/"
SRC_URI="${NV_URI}Linux-x86/${PV}/${X86_NV_PACKAGE}.run
	https://drive.google.com/uc?export=download&id=0B8mcZauYdlmqbEhYZlZ1YmFlRjg -> nvidia_extract_firmware-${PV}.py"

LICENSE="MIT NVIDIA-r2"
SLOT="0"
KEYWORDS=""

DEPEND="${PYTHON_DEPS}"
RDEPEND=""

RESTRICT="bindist mirror"

S="${WORKDIR}"

src_unpack() {
	mkdir "${S}/${X86_NV_PACKAGE}"
	cd "${S}/${X86_NV_PACKAGE}"
	unpack_makeself "${X86_NV_PACKAGE}.run"
}

src_compile() {
	"${PYTHON}" "${DISTDIR}"/nvidia_extract_firmware-${PV}.py || die "Extracting firmwares failed..."
}

src_install() {
	insinto /lib/firmware/nouveau
	doins nv* vuc-*
}
