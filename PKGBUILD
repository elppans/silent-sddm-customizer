# Maintainer: Marcelo K. <marcelo.elven@...>
# shellcheck disable=all

pkgname=silent-sddm-customizer-git
pkgver=1.0.0
pkgrel=1
pkgdesc="Scripts para rotacionar temas do Silent SDDM e converter avatares de usuário."
arch=('any')
license=('MIT')
depends=('sddm' 'sddm-silent-theme' 'imagemagick' 'bash')
provides=("$pkgname")
conflicts=("$pkgname")
url="https://github.com/elppans/${pkgname}"
source=("git+${url}.git#branch=main")
sha256sums=('SKIP')
# Automatically detect and use the correct install file
# if [ -e "${pkgname}.install" ]; then
install=${pkgname}.install
# elif [ -e "pkgbuild.install" ]; then
# 	install=pkgbuild.install
# fi
prepare() {
	cd "${srcdir}/${pkgname}"
	# Add any preparation steps here, if needed
	# For example: patch -p1 < "${srcdir}/patch-file.patch"
}
package() {
	if [ -d "${srcdir}/${pkgname}" ]; then
		cd "${srcdir}/${pkgname}"
		# Determine the correct source directory
		if [ -d "${pkgname}" ]; then
			srcdir="${srcdir}/${pkgname}/${pkgname}"
		else
			srcdir="${srcdir}/${pkgname}"
		fi
	fi

	# Install files
	local dirs=("usr" "etc")
	for dir in "${dirs[@]}"; do
		if [ -d "${srcdir}/${dir}" ]; then
			cp -a "${srcdir}/${dir}" "${pkgdir}/"
		fi
	done

	# Install license file if present
	if [ -f "LICENSE" ]; then
		install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
	fi

	# Install documentation if present
	if [ -f "README.md" ]; then
		install -Dm644 README.md "${pkgdir}/usr/share/doc/${pkgname}/README.md"
	fi
}
cat > "${install}" <<EOF
post_install() {
grep -q sddm /etc/group || groupadd sddm
groups $USER | grep -q '\bsddm\b' || usermod -aG sddm $USER
chgrp sddm /usr/share/sddm/themes/silent
chgrp sddm /usr/share/sddm/themes/silent/metadata.desktop
chmod 664 /usr/share/sddm/themes/silent/metadata.desktop
}
post_upgrade() {
    post_install
}
# post_remove() {
# 	cat <<END
# The "package" has been removed.
# END
}
EOF
