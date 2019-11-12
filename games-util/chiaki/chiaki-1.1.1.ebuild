# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

HOMEPAGE="https://github.com/thestr4ng3r/chiaki"
SRC_URI="https://github.com/thestr4ng3r/chiaki/releases/download/v1.1.1/chiaki-v1.1.1-src.tar.gz"

DESCRIPTION="Free and Open Source PS4 Remote Play Client"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="-test -cli gui -android opus -openssl -qtgamepad sdlgamepad -standalone"

DEPEND=">=dev-util/cmake-3.2
		gui? (	dev-qt/qtcore
				dev-qt/qtmultimedia
				dev-qt/qtopengl
				dev-qt/qtsvg
				media-video/ffmpeg )
		opus? (	media-libs/opus )
		openssl? ( >=dev-libs/openssl-1.1.0l )
		dev-libs/protobuf
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
	// TODO: Set Cmake flags

	mkdir "${S}/build"
	cd "${S}/build"
	cmake ..
	
}

src_compile() {
	cd "${S}/build"
	make
}

src_install() {
	// TODO install
}
