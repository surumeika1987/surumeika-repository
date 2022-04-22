# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Record Tools for PT1/PT2/PT3 in Linux"

HOMEPAGE="https://github.com/stz2012/recpt1"

EGIT_REPO_URI="https://github.com/stz2012/recpt1"

inherit git-r3

SRC_URI=""

KEYWORDS="~amd64"

LICENSE=""

SLOT="0"

KEYWORDS="~amd64"

IUSE="+b25"

RDEPEND="b25? ( dev-libs/libarib25 )"

DEPEND="${RDEPEND}"

BDEPEND=""

#src_unpack() {
#}

src_configure() {
        cd "${S}/recpt1"
        ./autogen.sh
        if use b25 ; then
                ./configure --enable-b25
        else
                ./configure
        fi
}

src_compile() {
	cd "${S}/recpt1"
	emake
}

src_install() {
	cd "${S}/recpt1"
	mkdir -p "${D}/usr/local/bin"
	emake DESTDIR=${D} install
	mkdir -p "${D}/usr/bin"
	cp -rf "${D}/usr/local/bin" "${D}/usr"
	rm -R "${D}/usr/local"
}
