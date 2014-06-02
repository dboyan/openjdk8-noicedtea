# Maintainer: Guillaume ALAUX <guillaume@archlinux.org>
# Contributor: Boyan Ding <stu_dby@126.com>
pkgname=('jre8-openjdk-headless-noicedtea' 'jre8-openjdk-noicedtea' 'jdk8-openjdk-noicedtea' 'openjdk8-doc-noicedtea')
pkgbase=java8-openjdk
_java_ver=8
_jdk_update=5
_jdk_build=13
pkgver=${_java_ver}.u${_jdk_update}_b${_jdk_build}
_repo_ver=jdk${_java_ver}u${_jdk_update}-b${_jdk_build}
pkgrel=2
arch=('i686' 'x86_64')
url='http://openjdk.java.net/'
license=('custom')
makedepends=('jdk7-openjdk' 'ccache' 'cpio' 'unzip' 'zip'
             'libxrender' 'libxtst' 'fontconfig' 'libcups' 'alsa-lib')
source=(jdk8u-${_repo_ver}.tar.gz::http://hg.openjdk.java.net/jdk8u/jdk8u/archive/${_repo_ver}.tar.gz
        corba-${_repo_ver}.tar.gz::http://hg.openjdk.java.net/jdk8u/jdk8u/corba/archive/${_repo_ver}.tar.gz
        hotspot-${_repo_ver}.tar.gz::http://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/archive/${_repo_ver}.tar.gz
        jdk-${_repo_ver}.tar.gz::http://hg.openjdk.java.net/jdk8u/jdk8u/jdk/archive/${_repo_ver}.tar.gz
        jaxws-${_repo_ver}.tar.gz::http://hg.openjdk.java.net/jdk8u/jdk8u/jaxws/archive/${_repo_ver}.tar.gz
        jaxp-${_repo_ver}.tar.gz::http://hg.openjdk.java.net/jdk8u/jdk8u/jaxp/archive/${_repo_ver}.tar.gz
        langtools-${_repo_ver}.tar.gz::http://hg.openjdk.java.net/jdk8u/jdk8u/langtools/archive/${_repo_ver}.tar.gz
        nashorn-${_repo_ver}.tar.gz::http://hg.openjdk.java.net/jdk8u/jdk8u/nashorn/archive/${_repo_ver}.tar.gz
        001_adjust-mflags-for-gmake-4.patch
        profile_jdk8-openjdk.csh
        profile_jdk8-openjdk.sh
        profile_jre8-openjdk.csh
        profile_jre8-openjdk.sh
        system-libjpeg.patch
        system-libpng.patch
        system-lcms.patch
        remove-intree-libraries.sh)

sha256sums=('212c32d4bf5787e5f8a25a52b12df3326184de4ab82de6c4e3458643256e86cb'
            '23ebf3c5949bd4faebafb6e04d4aeaa81e35348f142c44f796ae0809dd63865b'
            'e21e8391e47d2e926b44132b83f2bc48ed3c356e1a770993eab96c545757f722'
            '9b2f88d59a6387b6573a50e760f2b72a66835b6629e3c049285106f7b50c8141'
            '1f5e4ebbba05eb88071f289a464660b2dd8a35607efd48aa06acd126e605dcdb'
            'f39f6088ce1226c2f10882283dbbf4f6b6dbd8fa572125f4099709628d52b638'
            '01a4fe1287d7acc3b51efa3d3aac932f36e9acaa249efbc79dadd27cbbea97c6'
            'aca6e881c3bad334d07c66833ad994672c26306eeaadf024557e75378e55258f'
            '682104f7723c5c543c47b53f51cc5577e273a12343bd04bebd1bcd70dd72ded9'
            '008296c931817bb95727af87cda4c292139f159436a1122a039b7850c6bec474'
            'bd155a7ae70b6bebdbba95de73a9cfb3c8e9d8b4ce2a92c38201c486f5fd8427'
            'd6902559ad121e10ac005b66e6e3b08f5ec9d3755800243db92580c0dd9d096a'
            '3a841d8b5732b8995dbeb8851ba7751249f8f0985946bfc2a8f74c618e9712c9'
            'd76f656cc20ed71bcc3490d91001c4cb1102c188979736feadc0c4d75ba0ac61'
            '2a065b11f1504a43f99ad6dce91c6bf0f2625a8109cd397f894f797d8245d704'
            '4314d5b4bdfe0f24299fe6cbba1e2ccde8f40e118253dcb0db36fe192bbffb09'
            'b4e7d6ebac9bdc64009569507812684563824ac65270c5725ab164b64f1db727')

[ "$CARCH" = "x86_64" ] && _JARCH=amd64
[ "$CARCH" = "i686"   ] && _JARCH=i386

_jvmdir=/usr/lib/jvm/java-8-openjdk
_imgdir="jdk8/image/jvm/openjdk-1.8.0_05"
# TODO remove policytool from this array as it is handled separatly or also include its man page
_nonheadless=(bin/policytool
              lib/${_JARCH}/libjsound.so
              lib/${_JARCH}/libjsoundalsa.so
              lib/${_JARCH}/libsplashscreen.so)

prepare() {
  cd "${srcdir}"
  
  mv "jdk8u-${_repo_ver}" jdk8
  cd jdk8
  
  for subrepo in corba hotspot jdk jaxws jaxp langtools nashorn
  do
    mv "../${subrepo}-${_repo_ver}" "${subrepo}"
  done
  
  cd ..
  
  sh remove-intree-libraries.sh
  
  patch -Np0 -i system-libjpeg.patch
  patch -Np0 -i system-libpng.patch
  patch -Np0 -i system-lcms.patch
  
  cd jdk8/hotspot
  patch -p1 -i ../../001_adjust-mflags-for-gmake-4.patch
}

build() {
  cd "${srcdir}/jdk8"

  unset JAVA_HOME
  # http://icedtea.classpath.org/bugzilla/show_bug.cgi?id=1346
  export MAKEFLAGS=${MAKEFLAGS/-j*}

  install -d -m 755 "${srcdir}/jdk8/image/"
  
  cd common/autoconf
  bash ./autogen.sh
  cd ../..
  
  # Do not build with gcc 4.9.0-1
  sh configure \
    --prefix="${srcdir}/jdk8/image" \
    --disable-zip-debug-info \
    --with-boot-jdk=/usr/lib/jvm/java-7-openjdk \
    --with-debug-level=release \
    --with-milestone="fcs" \
    --enable-unlimited-crypto \
    --with-zlib=system \
    --with-libjpeg=system \
    --with-libpng=system \
    --with-lcms=system \
    --with-stdc++lib=dynamic \
    --with-update-version="${_jdk_update}" \
    --with-build-number="b${_jdk_build}" \
    # TODO OpenJDK does not want last version of giflib (add 'giflib' as dependency once fixed)
    #--with-giflib=system \
    # TODO do we need these?
    #--with-update-version=${_JDK_UPDATE_VERSION} \
    #--with-user-release-suffix='archlinux' \

  # Without 'DEBUG_BINARIES', i686 won't build
  # http://mail.openjdk.java.net/pipermail/core-libs-dev/2013-July/019203.html
  make \
    DEBUG_BINARIES=true all
  # These help to debug builds:
  #LOG=trace HOTSPOT_BUILD_JOBS=1

  unset JAVA_HOME
  # http://icedtea.classpath.org/bugzilla/show_bug.cgi?id=1346
  export MAKEFLAGS=${MAKEFLAGS/-j*}
  # FIXME sadly 'DESTDIR' is not used here!
  make DESTDIR="${pkgdir}/" install

  cd "${srcdir}/${_imgdir}"

  # A lot of stuff were directly taken from
  # http://pkgs.fedoraproject.org/cgit/java-1.8.0-openjdk.git/tree/java-1.8.0-openjdk.spec

  # http://icedtea.classpath.org/bugzilla/show_bug.cgi?id=1437
  find . -iname '*.jar' -exec chmod ugo+r {} \;
  chmod ugo+r lib/ct.sym

  # remove redundant *diz and *debuginfo files
  find . -iname '*.diz' -exec rm {} \;
  find . -iname '*.debuginfo' -exec rm {} \;
}

#check() {
#  cd "${srcdir}/${pkgname}-${pkgver}"
#  make -k check
#}

package_jre8-openjdk-headless-noicedtea() {
  pkgdesc="Free Java environment - headless runtime environment - 'NO ICEDTEA' DEVEL VERSION"
  depends=('ca-certificates-java' 'nss')
  optdepends=('java-rhino: for some JavaScript support')
  provides=('java-runtime-headless=8')
  conflicts=('java-runtime-headless')
  # FIXME first file looks like it belongs to 64 arch only…
  # Config files from 'lib' dir that should be backup
  _backup_etc=(etc/java-8-openjdk/${_JARCH}/jvm.cfg
               etc/java-8-openjdk/calendars.properties
               etc/java-8-openjdk/content-types.properties
               etc/java-8-openjdk/flavormap.properties
               etc/java-8-openjdk/images/cursors/cursors.properties
               etc/java-8-openjdk/logging.properties
               etc/java-8-openjdk/management/jmxremote.access
               etc/java-8-openjdk/management/jmxremote.password
               etc/java-8-openjdk/management/management.properties
               etc/java-8-openjdk/management/snmp.acl
               etc/java-8-openjdk/net.properties
               etc/java-8-openjdk/psfont.properties.ja
               etc/java-8-openjdk/psfontj2d.properties
               etc/java-8-openjdk/security/java.policy
               etc/java-8-openjdk/security/java.security
               etc/java-8-openjdk/sound.properties)
  backup=(etc/profile.d/jre.sh
          etc/profile.d/jre.csh
          ${_backup_etc[@]})
  install=install_jre8-openjdk-headless.sh

  cd "${srcdir}/${_imgdir}/jre"

  install -d -m 755 "${pkgdir}${_jvmdir}/jre/"
  cp -a bin lib "${pkgdir}${_jvmdir}/jre"

  # Remove 'non-headless' lib files
  for f in ${_nonheadless[@]}; do
    rm "${pkgdir}${_jvmdir}/jre/${f}"
  done

  # Link binaries into /usr/bin
  pushd "${pkgdir}${_jvmdir}/jre/bin"
  install -d -m 755 "${pkgdir}/usr/bin/"
  install -d -m 755 "${pkgdir}"/usr/share/man/{,ja/}man1/
  for file in *; do
    ln -s ${_jvmdir}/jre/bin/${file} "${pkgdir}/usr/bin"
    install -m 644 "${srcdir}/${_imgdir}/man/man1/${file}.1" \
      "${pkgdir}/usr/share/man/man1/${file}.1"
    install -m 644 "${srcdir}/${_imgdir}/man/ja/man1/${file}.1" \
      "${pkgdir}/usr/share/man/ja/man1/${file}.1"
  done
  popd

  # Link JKS keystore from ca-certificates-java
  rm -f "${pkgdir}${_jvmdir}/jre/lib/security/cacerts"
  ln -sf /etc/ssl/certs/java/cacerts "${pkgdir}${_jvmdir}/jre/lib/security/cacerts"

  # Set some variables
  install -D -m 755 "${srcdir}/profile_jre8-openjdk.sh"  "${pkgdir}/etc/profile.d/jre.sh"
  install -D -m 755 "${srcdir}/profile_jre8-openjdk.csh" "${pkgdir}/etc/profile.d/jre.csh"

  # Install license
  install -d -m 755 "${pkgdir}/usr/share/licenses/${pkgbase}/"
  install -m 644 ASSEMBLY_EXCEPTION LICENSE THIRD_PARTY_README \
                 "${pkgdir}/usr/share/licenses/${pkgbase}"
  ln -sf /usr/share/licenses/${pkgbase} "${pkgdir}/usr/share/licenses/${pkgname}"

  mv "${pkgdir}${_jvmdir}/jre/lib/management/jmxremote.password.template" \
     "${pkgdir}${_jvmdir}/jre/lib/management/jmxremote.password"
  mv "${pkgdir}${_jvmdir}/jre/lib/management/snmp.acl.template" \
     "${pkgdir}${_jvmdir}/jre/lib/management/snmp.acl"

  # Move config files that were set in _backup_etc from ./lib to /etc
  for file in ${_backup_etc[@]}; do
    _filepkgpath=${_jvmdir}/jre/lib/${file#etc/java-8-openjdk/}
    install -D -m 644 "${pkgdir}${_filepkgpath}" "${pkgdir}/${file}"
    ln -sf /${file} "${pkgdir}${_filepkgpath}"
  done
}

package_jre8-openjdk-noicedtea() {
  pkgdesc="Free Java environment - full runtime environment - 'NO ICEDTEA' DEVEL VERSION"
  depends=('java-runtime-headless' 'xdg-utils' 'hicolor-icon-theme')
  optdepends=('alsa-lib: for basic sound support'
              'gtk2: for the Gtk+ look and feel - desktop usage')
  # TODO 'icedtea-web-java7: web browser plugin + Java Web Start'
  # TODO 'giflib: for gif format support'
  # TODO 'libpulse: for advanced sound support'
  provides=('java-runtime=8')
  conflicts=('java-runtime')
  install=install_jre8-openjdk.sh

  cd "${srcdir}/${_imgdir}/jre"

  # TODO? /usr/lib/jvm/java-8-openjdk/jre/lib/sound.properties
  for f in ${_nonheadless[@]}; do
    install -D -m 644 ${f} "${pkgdir}${_jvmdir}/jre/${f}"
  done

  # Link binaries into /usr/bin
  pushd "${pkgdir}${_jvmdir}/jre/bin"
  install -d -m 755 "${pkgdir}/usr/bin/"
  ln -s ${_jvmdir}/jre/bin/policytool "${pkgdir}/usr/bin"
  popd

  # Icons
  for s in 16 24 32 48; do
    install -D -m 644 "${srcdir}/jdk8/jdk/src/solaris/classes/sun/awt/X11/java-icon${s}.png" \
                      "${pkgdir}/usr/share/icons/hicolor/${s}x${s}/apps/java.png"
  done

  # Desktop files
  # TODO add them when switching to IcedTea
  #install -D -m 644 "${srcdir}/icedtea-${_icedtea_ver}/policytool.desktop" \
  #                  "${pkgdir}/usr/share/applications/policytool.desktop"

  # man pages
  install -D -m 644 "${srcdir}/${_imgdir}/man/man1/policytool.1" \
                    "${pkgdir}/usr/share/man/man1/policytool.1"
  install -D -m 644 "${srcdir}/${_imgdir}/man/ja/man1/policytool.1" \
                    "${pkgdir}/usr/share/man/ja/man1/policytool.1"

  # Install license
  install -d -m 755 "${pkgdir}/usr/share/licenses/${pkgbase}/"
  ln -sf /usr/share/licenses/${pkgbase} "${pkgdir}/usr/share/licenses/${pkgname}"
}

package_jdk8-openjdk-noicedtea() {
  pkgdesc="Free Java environment - development kit - 'NO ICEDTEA' DEVEL VERSION"
  # TODO remove the '-noicedtea'
  depends=('jre8-openjdk-noicedtea' 'xdg-utils' 'hicolor-icon-theme')
  provides=('java-environment=8')
  conflicts=('java-environment')
  backup=(etc/profile.d/jdk.sh
          etc/profile.d/jdk.csh)

  cd "${srcdir}/${_imgdir}"

  # Main files
  install -d -m 755 "${pkgdir}${_jvmdir}"

  cp -a include lib "${pkgdir}${_jvmdir}"

  # 'bin' files
  pushd bin
  install -d -m 755 "${pkgdir}/usr/bin/"

  # 'java-rmi.cgi' will be handled separately as it should not be in the PATH and has no man page
  for b in $(ls | grep -v java-rmi.cgi); do
    if [ -e ../jre/bin/${b} ]; then
      # Provide a link of the jre binary in the jdk/bin/ directory
      ln -s ../jre/bin/${b} "${pkgdir}${_jvmdir}/bin/${b}"
    else
      # Copy binary to jdk/bin/
      install -D -m 755 ${b} "${pkgdir}${_jvmdir}/bin/${b}"
      # Copy man page
      install -D -m 644 ../man/man1/${b}.1 "${pkgdir}/usr/share/man/man1/${b}.1"
      install -D -m 644 ../man/ja/man1/${b}.1 "${pkgdir}/usr/share/man/ja/man1/${b}.1"
      # Link from /bin/
      ln -s ${_jvmdir}/bin/${b} "${pkgdir}/usr/bin/${b}"
    fi
  done
  popd

  # Handling 'java-rmi.cgi' separately
  install -D -m 755 bin/java-rmi.cgi "${pkgdir}${_jvmdir}/bin/java-rmi.cgi"

  # Desktop files.
  # TODO add them when switching to IcedTea
  #install -m 644 "${srcdir}/icedtea-${_icedtea_ver}/jconsole.desktop" \
  #  "${pkgdir}/usr/share/applications"

  # Set some variables
  install -D -m 755 "${srcdir}/profile_jdk8-openjdk.sh"  "${pkgdir}/etc/profile.d/jdk.sh"
  install -D -m 755 "${srcdir}/profile_jdk8-openjdk.csh" "${pkgdir}/etc/profile.d/jdk.csh"

  # link license
  install -d -m 755 "${pkgdir}/usr/share/licenses/"
  ln -sf /usr/share/licenses/${pkgbase} "${pkgdir}/usr/share/licenses/${pkgname}"
}

package_openjdk8-doc-noicedtea() {
  pkgdesc="Free Java environment based on OpenJDK 8.0 without IcedTea - documentation"
  cd ${srcdir}/jdk8/build/linux-*
  install -d -m 755 "${pkgdir}/usr/share/doc/openjdk8-doc"
  cp -a docs/* "${pkgdir}/usr/share/doc/openjdk8-doc"
}
