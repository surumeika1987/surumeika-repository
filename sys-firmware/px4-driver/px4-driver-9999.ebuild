# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Unofficial Linux driver for PLEX PX4/PX5/PX-MLT series ISDB-T/S receivers"

HOMEPAGE="https://github.com/nns779/px4_drv"

EGIT_REPO_URI="https://github.com/nns779/px4_drv"

inherit git-r3

SRC_URI="http://plex-net.co.jp/plex/pxw3u4/pxw3u4_BDA_ver1x64.zip -> pxw3u4_BDA_ver1x64.zip"

KEYWORDS="~amd64"

LICENSE="GPL-2.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

BDEPEND="app-arch/unzip
	 sys-kernel/linux-headers"

src_unpack() {
	git-r3_src_unpack
	cd "${WORKDIR}/${P}/fwtool"
	unzip -oj "${DISTDIR}/pxw3u4_BDA_ver1x64.zip" "pxw3u4_BDA_ver1x64/PXW3U4.sys"
}

src_configure() {
	unset ARCH
	default
}

src_compile() {
	cd "${WORKDIR}/${P}/fwtool"
	emake

	./fwtool PXW3U4.sys it930x-firmware.bin

	cd "${WORKDIR}/${P}/driver"
	emake
}

src_install() {
	cd "${WORKDIR}/${P}/driver"

	INSTALL_DIR="${D}/lib/modules/$(shell uname -r)/misc"
	mkdir -p "${INSTALL_DIR}"
	cp px4_drv.ko ${INSTALL_DIR}/px4_drv.ko
	chmod 644 ${INSTALL_DIR}/px4_drv.ko
	mkdir -p "${D}/lib/udev/rules.d/"
	cp ../etc/99-px4video.rules ${D}/lib/udev/rules.d/99-px4video.rules
	chmod 644 ${D}/lib/udev/rules.d/99-px4video.rules
}

pkg_preinst() {
	if [ `grep -e '^px4_drv' /proc/modules | wc -l` -ne 0 ]; then
		modprobe -r px4_drv
	fi
}

pkg_postinst() {
	depmod -a $(shell uname -r)
	modprobe px4_drv
}
