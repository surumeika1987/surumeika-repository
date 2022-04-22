# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ARIB STD-B25 Library for Linux"

HOMEPAGE="https://github.com/stz2012/libarib25"

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/stz2012/libarib25"
fi

inherit ${SCM} cmake

SRC_URI=""

if [ "${PV#9999}" = "${PV}" ] ; then
	VERSION="0.2.5-20190204"
	S="${WORKDIR}/${PN}-${VERSION}"
	SRC_URI="https://github.com/stz2012/libarib25/archive/v${VERSION}.tar.gz -> ${P}.tar.gz"
fi

KEYWORDS="amd64"

LICENSE="Apache-2.0"

SLOT="0"

IUSE=""

RDEPEND="sys-apps/pcsc-lite"

DEPEND="${RDEPEND}"

BDEPEND=""

src_prepare() {
	echo "" > "${S}/cmake/PostInstall.cmake"
	cmake_src_prepare
}

src_configure() {
	cmake_src_configure
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	env-update
}
