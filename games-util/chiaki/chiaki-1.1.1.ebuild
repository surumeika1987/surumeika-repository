# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

HOMEPAGE="https://github.com/thestr4ng3r/chiaki"
SRC_URI="https://github.com/thestr4ng3r/chiaki/releases/download/v1.1.1/chiaki-v1.1.1-src.tar.gz"

DESCRIPTION="Free and Open Source PS4 Remote Play Client"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test cli +gui +opus openssl qtgamepad +sdlgamepad"

DEPEND=">=dev-util/cmake-3.2
		dev-python/protobuf-python
		gui? (	dev-qt/qtcore
				dev-qt/qtmultimedia
				dev-qt/qtopengl
				dev-qt/qtsvg
				media-video/ffmpeg )
		opus? (	media-libs/opus )
		openssl? ( >=dev-libs/openssl-1.1.0l )
		qtgamepad? ( dev-qt/qtgamepad )"

S="${WORKDIR}/chiaki"
		
		
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	unpack ${A}
}

src_prepare() {
	eapply_user
}

src_configure() {
	cd "${S}"
	local cmake_flags=( -DCMAKE_INSTALL_PREFIX="${D}/usr" )

	if use test ; then
		cmake_flags+=( -DCHIAKI_ENABLE_TESTS=ON )
	else
		cmake_flags+=( -DCHIAKI_ENABLE_TESTS=OFF )
	fi

	if use cli ; then
		cmake_flags+=( -DCHIAKI_ENABLE_CLI=ON )
	else
		cmake_flags+=( -DCHIAKI_ENABLE_CLI=OFF )
	fi

	if use gui ; then
		cmake_flags+=( -DCHIAKI_ENABLE_GUI=ON )
	else
		cmake_flags+=( -DCHIAKI_ENABLE_GUI=OFF )
	fi

	if use opus ; then
		cmake_flags+=( -DCHIAKI_LIB_ENABLE_OPUS=ON )
	else
		cmake_flags+=( -DCHIAKI_LIB_ENABLE_OPUS=OFF )
	fi

	if use openssl ; then
		cmake_flags+=( -DCHIAKI_LIB_OPENSSL_EXTERNAL_PROJECT=ON )
	else
		cmake_flags+=( -DCHIAKI_LIB_OPENSSL_EXTERNAL_PROJECT=OFF )
	fi

	if use qtgamepad ; then
		cmake_flags+=( -DCHIAKI_GUI_ENABLE_QT_GAMEPAD=ON )
	else
		cmake_flags+=( -DCHIAKI_GUI_ENABLE_QT_GAMEPAD=OFF )
	fi

	if use sdlgamepad ; then
		cmake_flags+=( -DCHIAKI_GUI_ENABLE_SDL_GAMECONTROLLER=ON )
	else
		cmake_flags+=( -DCHIAKI_GUI_ENABLE_SDL_GAMECONTROLLER=OFF )
	fi

	mkdir "${S}/build"
	cd "${S}/build"
	cmake ${cmake_flags} ..
}

src_compile() {
	cd "${S}/build"
	make
}

src_install() {
	cd "${S}/build"
	make install
	domenu chiaki.desktop
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}