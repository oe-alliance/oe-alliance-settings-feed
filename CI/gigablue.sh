#!/bin/bash

# Script by jbleyel for https://github.com/oe-alliance

PVER="1.0"
PR="r1"
PACK="gigablue"
LOCAL="local"
GITREPRO="teamblue-e2/settings"
PACKNAME="enigma2-plugin-settings-gigablue"
D=$(pwd) &> /dev/null
PD=${D}/$LOCAL
B=${D}/build
TMP=${D}/tmp
R=${D}/feed
Homepage="https://github.com/teamblue-e2/settings"

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
git clone --depth 1 ${Homepage} local

VER="$PVER+git$GITCOMMITS+${GITHASH}_r0"

mkdir -p ${R}

rm -rf ${D}/feed/${PACKNAME}*.ipk

MakeIPK gigablue_19e 19e ${VER}
MakeIPK gigablue_19e_13e 19e_13e ${VER}
MakeIPK gigablue_19e_13e_23e_28e 19e_13e_23e_28e ${VER}
MakeIPK gigablue_19e_13e_42e_28e_23e_4e_0w_30w 19e_13e_42e_28e_23e_4e_0w_30w ${VER}
MakeIPK gigablue_42e_19e 42e_19e ${VER}
MakeIPK gigablue_42e_19e_13e 42e_19e_13e ${VER}
MakeIPK gigablue_42e_19e_13e_KD 42e_19e_13e_KD ${VER}
MakeIPK gigablue_42e_19e_13e_UM 42e_19e_13e_UM ${VER}
MakeIPK gigablue_42e_19e_13e_WT 42e_19e_13e_WT ${VER}
MakeIPK gigablue_42e_19e_FTA 42e_19e_FTA ${VER}
MakeIPK gigablue_kabeldeutschland kabeldeutschland ${VER}
MakeIPK gigablue_tipico tipico ${VER}
MakeIPK gigablue_unity_media unity_media ${VER}
MakeIPK gigablue_wilhelmtel wilhelmtel ${VER}
