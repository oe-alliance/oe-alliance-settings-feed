#!/bin/bash

# Script by jbleyel for https://github.com/oe-alliance

PVER="1.2"
PR="r0"
PACK="hans"
LOCAL="local"
GITREPRO="oe-mirrors/hanssettings"
PACKNAME="enigma2-plugin-settings-hans"
D=$(pwd) &> /dev/null
PD=${D}/$LOCAL
B=${D}/build
TMP=${D}/tmp
R=${D}/feed
Homepage="https://gitlab.openpli.org/openpli/hanssettings"
GitSource="https://github.com/oe-mirrors/hanssettings"

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
	ls -l
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
git clone --depth 1 ${GitSource} local

VER="$PVER+git$GITCOMMITS+${GITHASH}_${PR}"

mkdir -p ${R}

rm -rf ${D}/feed/${PACKNAME}*.ipk

MakeIPK e2_hanssettings_19e_23e_basis 19e-23e-basis ${VER}
MakeIPK e2_hanssettings_19e_23e_28e 19e-23e-28e ${VER}
MakeIPK e2_hanssettings_13e_19e_23e_28e 13e-19e-23e-28e ${VER}
MakeIPK e2_hanssettings_9e_13e_19e_23e_28e 9e-13e-19e-23e-28e ${VER}
MakeIPK e2_hanssettings_9e_13e_19e_23e_28e_AND_rotating 9e-13e-19e-23e-28e-rotating ${VER}
MakeIPK e2_hanssettings_kabelNL kabelNL ${VER}
