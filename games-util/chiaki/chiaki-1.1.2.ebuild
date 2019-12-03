# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

HOMEPAGE="https://github.com/thestr4ng3r/chiaki"
SRC_URI="https://github.com/thestr4ng3r/chiaki/releases/download/v1.1.2/chiaki-v1.1.2-src.tar.gz"

DESCRIPTION="Free and Open Source PS4 Remote Play Client"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test cli +qt5 +opus openssl gamepad +sdl"

DEPEND=">=dev-util/cmake-3.2
		dev-python/protobuf-python
		qt5? (	dev-qt/qtcore
				dev-qt/qtmultimedia
				dev-qt/qtopengl
				dev-qt/qtsvg
				media-video/ffmpeg )
		opus? (	media-libs/opus )
		openssl? ( >=dev-libs/openssl-1.1.0l )
		gamepad? ( dev-qt/gamepad )"

S="${WORKDIR}/chiaki"

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

	if use qt5 ; then
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

	if use gamepad ; then
		cmake_flags+=( -DCHIAKI_GUI_ENABLE_QT_GAMEPAD=ON )
	else
		cmake_flags+=( -DCHIAKI_GUI_ENABLE_QT_GAMEPAD=OFF )
	fi

	if use sdl ; then
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
	emake
}

src_install() {
	cd "${S}/build"
	emake install

	if use qt5 ; then
		# Move icon file
		mkdir "${D}/usr/share/icons/hicolor/512x512/apps"
		mv "${D}/usr/share/icons/hicolor/512x512/chiaki.png" "${D}/usr/share/icons/hicolor/512x512/apps/chiaki.png"
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}