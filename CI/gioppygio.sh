#!/bin/bash

# Script by jbleyel for https://github.com/oe-alliance

PVER="1.0"
PR="r1"
PACK="gioppygio"
LOCAL="local"
GITREPRO="OpenVisionE2/GioppyGio-settings"
PACKNAME="enigma2-plugin-settings-gioppygio"
D=$(pwd) &> /dev/null
PD=${D}/$LOCAL
B=${D}/build
TMP=${D}/tmp
R=${D}/feed
Homepage="http://picons.gioppygio.it/"
GitSource="https://github.com/OpenVisionE2/GioppyGio-settings"

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

VER="$PVER+git$GITCOMMITS+${GITHASH}_r0"

mkdir -p ${R}

rm -rf ${D}/feed/${PACKNAME}*.ipk

MakeIPK GioppyGio_E2_Dual dual ${VER}
MakeIPK GioppyGio_E2_Dual_13E+19E+DTT-Italia dual_13e-19e-dtt-italia ${VER}
MakeIPK GioppyGio_E2_Dual_5W+13E dual-5w-13e ${VER}
MakeIPK GioppyGio_E2_Dual_9E+13E dual e9-13e ${VER}
MakeIPK GioppyGio_E2_Mono mono ${VER}
MakeIPK GioppyGio_E2_Mono_13E+DTT-Italia mono-13e-dtt-talia ${VER}
MakeIPK GioppyGio_E2_Motor motor ${VER}
MakeIPK GioppyGio_E2_Motor_75E_45W+DTT-Italia motor-75e-45w-dtt-italia ${VER}
MakeIPK GioppyGio_E2_Quadri quadri ${VER}
MakeIPK GioppyGio_E2_Quadri_13E+19E+9E+5W quadri-13e-19e-9e-5w ${VER}
MakeIPK GioppyGio_E2_Quadri_9E+13E+16E+19E quadri-9e-13e-16e-19e ${VER}
MakeIPK GioppyGio_E2_Trial trial ${VER}
MakeIPK GioppyGio_E2_Trial_13E+19E+30W trial-13e-19e-30w ${VER}
MakeIPK GioppyGio_E2_Trial_5W+13E+19E trial-5w-13e-19e ${VER}
MakeIPK GioppyGio_E2_Trial_9E+13E+19E trial-9e-13e-19e ${VER}
