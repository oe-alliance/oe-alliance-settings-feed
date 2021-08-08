#!/bin/bash

# Script by jbleyel for https://github.com/oe-alliance

PVER="1.0"
PR="r0"
PACK="morpheus883"
LOCAL="local"
GITREPRO="morpheus883/enigma2-settings"
PACKNAME="enigma2-plugin-settings-morpheus883"
D=$(pwd) &> /dev/null
PD=${D}/$LOCAL
B=${D}/build
TMP=${D}/tmp
R=${D}/feed
Homepage="https://github.com/morpheus883/enigma2-settings"

function MakeIPK ()
{

    rm -rf ${B}
    rm -rf ${TMP}
    mkdir -p ${B}
    mkdir -p ${TMP}
    mkdir -p ${TMP}/CONTROL

    mkdir -p ${TMP}/etc/enigma2/
    cp -rp ${PD}/$1/* ${TMP}/etc/enigma2/

cat > ${TMP}/CONTROL/control << EOF
Package: ${PACKNAME}-${2}
Version: ${3}
Description: ${PACK} enigma2 settings ${2}
Section: base
Priority: optional
Maintainer: OE-Core Developers <openembedded-core@lists.openembedded.org>
License: Proprietary
Architecture: all
OE: ${PACKNAME}-${2}
Source: ${Homepage}
EOF

	tar -C ${TMP}/CONTROL -czf ${B}/control.tar.gz .
	rm -rf ${TMP}/CONTROL

    PKG="${PACKNAME}-${2}_${3}_all.ipk"
    tar -C ${TMP} -czf ${B}/data.tar.gz .
    echo "2.0" > ${B}/debian-binary
	cd ${B}
	ar -r ${R}/${PKG} ./debian-binary ./control.tar.gz ./data.tar.gz 
	cd ${D}

}

GITCOMMITS=$(curl  --silent -I -k "https://api.github.com/repos/$GITREPRO/commits?per_page=1" | sed -n '/^[Ll]ink:/ s/.*"next".*page=\([0-9]*\).*"last".*/\1/p')
GITHASH=$(git ls-remote https://github.com/$GITREPRO HEAD | sed -e 's/^\(.\{7\}\).*/\1/')
OLDHASH=$(head -n 1 $PACK.hash 2>/dev/null)

if [ "$OLDHASH" == "$GITHASH" ]; then
    exit 0
fi
echo $GITHASH > $PACK.hash
rm -rf ${PD}
git clone --depth 1 ${Homepage} local

VER="$PVER+git$GITCOMMITS+${GITHASH}_r0"

mkdir -p ${R}

rm -rf ${D}/feed/${PACKNAME}*.ipk

MakeIPK morph883_motor motor ${VER}
MakeIPK morph883_9e-13e 9e-13e ${VER}
MakeIPK morph883_9e-13e-19.2e 9e-13e-19.2e ${VER}
MakeIPK morph883_4.8e-13e 4.8e-13e ${VER}
MakeIPK morph883_4.8e-13e-19.2e 4.8e-13e-19.2e ${VER}
MakeIPK morph883_30w-13e 30w-13e ${VER}
MakeIPK morph883_30w-13e-19.2e 30w-13e-19.2e ${VER}
MakeIPK morph883_13e 13e ${VER}
MakeIPK morph883_13e-42e 13e-42e ${VER}
MakeIPK morph883_13e-28.2e 13e-28.2e ${VER}
MakeIPK morph883_13e-23.5e 13e-23.5e ${VER}
MakeIPK morph883_13e-19.2e 13e-19.2e ${VER}
MakeIPK morph883_13e-19.2e-42e 13e-19.2e-42e ${VER}
MakeIPK morph883_13e-19.2e-23.5e 13e-19.2e-23.5e ${VER}
MakeIPK morph883_13e-19.2e-28.2e 13e-19.2e-28.2e ${VER}
MakeIPK morph883_13e-16e 13e-16e ${VER}
MakeIPK morph883_13e-16e-19.2e 13e-16e-19.2e ${VER}
MakeIPK morph883_13e-16e-19.2e-23.5e 13e-16e-19.2e-23.5e ${VER}
MakeIPK morph883_0.8w-4.8e-13e 0.8w-4.8e-13e ${VER}
MakeIPK morph883_0.8w-13e 0.8w-13e ${VER}
MakeIPK morph883_0.8w-13e-19.2e 0.8w-13e-19.2e ${VER}
MakeIPK morph883_0.8w-13e-19.2e-28.2e 0.8w-13e-19.2e-28.2e ${VER}

