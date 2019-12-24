# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

HOMEPAGE="https://github.com/ebruck/radiotray-ng"
SRC_URI="https://github.com/ebruck/radiotray-ng/archive/v0.2.7.tar.gz -> ${P}.tar.gz"

DESCRIPTION="An Internet radio player for Linux"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test debug"

DEPEND="sys-apps/lsb-release
        net-misc/curl[ssl(+)]
        dev-libs/jsoncpp
        dev-libs/libxdg-basedir
        x11-libs/libnotify
        dev-libs/boost
        media-libs/gstreamer
        media-libs/gst-plugins-good
        >=dev-libs/libappindicator-12.10.0-r301
        >=x11-libs/gtk+-3.24.10
        dev-libs/libbsd
        sys-libs/ncurses
        dev-cpp/glibmm
        >=x11-libs/wxGTK-3.0.4-r300
        dev-util/cmake"

RDEPEND="${DEPEND}"
BDEPEND=""

inherit xdg-utils

src_unpack() {
	unpack ${A}
}

src_prepare() {
	eapply_user
}

src_configure() {
	cd "${S}"
	local cmake_flags=( -DCMAKE_INSTALL_PREFIX="${D}" )

        if use test ; then
                cmake_flags+=( -DBUILD_TESTS=ON )
        fi

        if use debug ; then
                cmake_flags+=( -DCMAKE_BUILD_TYPE=Debug )
        else
                cmake_flags+=( -DCMAKE_BUILD_TYPE=Release )
        fi
        
        mkdir "${S}/build"
	cd "${S}/build"
	cmake .. ${cmake_flags[@]}
}

src_compile() {
	cd "${S}/build"
	emake
}

src_install() {
	cd "${S}/build"
	emake DESTDIR=${D} install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}