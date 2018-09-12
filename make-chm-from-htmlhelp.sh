#!/bin/sh

htmlhelp="build/htmlhelp"
buildname="AGSHelpdoc"

echo "Enabling binary TOC and index..."
sed -E -i.bak -n "/^Binary (TOC|Index)=No$/!p" "$htmlhelp/$buildname.hhp" && \
rm "$htmlhelp/$buildname.hhp.bak"

echo "Checking or getting chmcmd..."
chmcmd=`which chmcmd`

if [ $? != 0 ]; then
	rm -f chmcmd && wget –quiet https://github.com/ericoporto/freepascal/releases/download/3.0.4/chmcmd
	echo "af4eea94c843adb20f8ae10884badbc5 chmcmd" > chmcmd.md5
	md5sum -c chmcmd.md5 || exit 1
	chmod +x chmcmd
	chmcmd=`pwd`"/chmcmd"
fi

echo "Using $chmcmd:
$(
	cd "$htmlhelp" && \
	rm -f "$buildname.chm" && \
	"$chmcmd" "$buildname.hhp" && \
	chmod a+r-w-x "$buildname.chm" && \
	mv -fv "$buildname.chm" ../../ags-help.chm
)"
