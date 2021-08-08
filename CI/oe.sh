#!/bin/bash

# Script by jbleyel for https://github.com/oe-alliance

PVER="1.0"
PR="r6"
LOCAL="local"
GITREPRO="oe-alliance/oe-alliance-settings"
D=$(pwd) &> /dev/null
PD=${D}/$LOCAL
B=${D}/build
TMP=${D}/tmp
R=${D}/feed
Homepage="https://github.com/oe-alliance/oe-alliance-settings"

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
Package: ${PACKNAME}.${2}
Version: ${3}
Description: ${PACK} ${2}
Section: base
Priority: optional
Maintainer: OE-Core Developers <openembedded-core@lists.openembedded.org>
License: Proprietary
Architecture: all
OE: ${PACKNAME}.${2}
Source: ${Homepage}
EOF

	tar -C ${TMP}/CONTROL -czf ${B}/control.tar.gz .
	rm -rf ${TMP}/CONTROL

    PKG="${PACKNAME}.${2}_${3}_all.ipk"
    tar -C ${TMP} -czf ${B}/data.tar.gz .
    echo "2.0" > ${B}/debian-binary
	cd ${B}
	ls -l
	ar -r ${R}/${PKG} ./debian-binary ./control.tar.gz ./data.tar.gz 
	cd ${D}

}

GITCOMMITS=$(curl  --silent -I -k "https://api.github.com/repos/$GITREPRO/commits?per_page=1" | sed -n '/^[Ll]ink:/ s/.*"next".*page=\([0-9]*\).*"last".*/\1/p')
GITHASH=$(git ls-remote https://github.com/$GITREPRO HEAD | sed -e 's/^\(.\{7\}\).*/\1/')
OLDHASH=$(head -n 1 oe.hash 2>/dev/null)

if [ "$OLDHASH" == "$GITHASH" ]; then
    exit 0
fi
echo $GITHASH > oe.hash
rm -rf ${PD}
git clone --depth 1 ${Homepage} local

VER="$PVER+git$GITCOMMITS+${GITHASH}_r0"

mkdir -p ${R}

PACKNAME="enigma2-plugin-settings-vhannibal"
PACK="Vhannibal E2 Settings File"

rm -rf ${D}/feed/${PACKNAME}*.ipk

MakeIPK vhannibal.trial trial ${VER}
MakeIPK vhannibal.quad.nordic quad.nordic ${VER}
MakeIPK vhannibal.quad.9e.13e.16e.19e quad.9e.13e.16e.19e ${VER}
MakeIPK vhannibal.quad.7e.13e.19e.42e quad.7e.13e.19e.42e ${VER}
MakeIPK vhannibal.quad.13e.19e.23e.28e quad.13e.19e.23e.28e ${VER}
MakeIPK vhannibal.motor motor ${VER}

MakeIPK vhannibal.motor.and.dtt.torino motor.and.dtt.torino ${VER}
MakeIPK vhannibal.motor.and.dtt.roma motor.and.dtt.roma ${VER}
MakeIPK vhannibal.motor.and.dtt.milano motor.and.dtt.milano ${VER}
MakeIPK vhannibal.motor.and.dtt.napoli motor.and.dtt.napoli ${VER}
MakeIPK vhannibal.motor.and.dtt.italia motor.and.dtt.italia ${VER}
MakeIPK vhannibal.motor.and.dtt.forli motor.and.dtt.forli ${VER}

MakeIPK vhannibal.hotbird hotbird ${VER}
MakeIPK vhannibal.hotbird.and.dtt.torino hotbird.and.dtt.torino ${VER}
MakeIPK vhannibal.hotbird.and.dtt.roma hotbird.and.dtt.roma ${VER}
MakeIPK vhannibal.hotbird.and.dtt.milano hotbird.and.dtt.milano ${VER}
MakeIPK vhannibal.hotbird.and.dtt.napoli hotbird.and.dtt.napoli ${VER}
MakeIPK vhannibal.hotbird.and.dtt.italia hotbird.and.dtt.italia ${VER}
MakeIPK vhannibal.hotbird.and.dtt.forli hotbird.and.dtt.forli ${VER}

MakeIPK vhannibal.dual.feeds dual.feeds ${VER}
MakeIPK vhannibal.dual.feeds.and.dtt.torino dual.feeds.and.dtt.torino ${VER}
MakeIPK vhannibal.dual.feeds.and.dtt.roma dual.feeds.and.dtt.roma ${VER}
MakeIPK vhannibal.dual.feeds.and.dtt.milano dual.feeds.and.dtt.milano ${VER}
MakeIPK vhannibal.dual.feeds.and.dtt.napoli dual.feeds.and.dtt.napoli ${VER}
MakeIPK vhannibal.dual.feeds.and.dtt.italia dual.feeds.and.dtt.italia ${VER}
MakeIPK vhannibal.dual.feeds.and.dtt.forli dual.feeds.and.dtt.forli ${VER}

PACKNAME="enigma2-plugin-settings-mr.mister"
PACK="Mr Mister E2 Settings File"

rm -rf ${P}/${PACKNAME}*.ipk

#MakeIPK mr.mister.multi.sat multi.sat ${VER}
#MakeIPK mr.mister.28.2e 28.2e ${VER}

PACKNAME="enigma2-plugin-settings-malimali"
PACK="Malimali E2 Settings File"

rm -rf ${P}/${PACKNAME}*.ipk

#MakeIPK malimali.motor.42e.to.30w motor.42e.to.30w ${VER}
#MakeIPK malimali.9e.13e.19e 9e.13e.19e ${VER}
#MakeIPK malimali.3e.7e.9e.13e.16e.19e 3e.7e.9e.13e.16e.19e ${VER}
#MakeIPK malimali.39e.28e.26e.23e.19e.16e.13e.7e.0.8w 39e.28e.26e.23e.19e.16e.13e.7e.0.8w ${VER}
#MakeIPK malimali.39e.28e.23e.19e.16e.13e.0.8w 39e.28e.23e.19e.16e.13e.0.8w ${VER}
#MakeIPK malimali.19e 19e ${VER}
#MakeIPK malimali.13e 13e ${VER}
#MakeIPK malimali.13e.19e 13e.19e ${VER}
#MakeIPK malimali.13e.16e.19e.28e 13e.16e.19e.28e ${VER}