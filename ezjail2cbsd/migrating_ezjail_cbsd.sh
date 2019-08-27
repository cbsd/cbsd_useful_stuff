#!/bin/sh
# by LordNicky 20190603
# See: https://www.bsdstore.ru/en/12.0.x/ezjail2cbsd_ssi.html
#      https://github.com/cbsd/cbsd/issues/412

manual_enter_function () {
echo "Enter path to migrating jail-data dir:";
read target_jail;
echo "Enter path to example jail-data dir:";
read source_jail;
verify_function;
}

verify_function () {
if file $target_jail/bin | egrep -q link;
then if file $source_jail/bin | egrep -q directory;
     then check_function;
     else echo "Please, check path to the directory 
of example jail, that you entered: 
$source_jail";
     exit 1;		
     fi
else echo "Please, check path to the directory
of migrating jail, that you entered:
$target_jail";
exit 1;	   
fi
}	

check_function () {
echo "Check:
Migrating: $target_jail
Example: $source_jail
I will delete symlinks to ezjail-basejail from MIGRATING 
and change them to directories from EXAMPLE.
Correctly? (y/n)";
read user_reply;
case "$user_reply" in 
	y|Y) echo "Ok, continue...";
	main_function;
	;; 
	n|N) echo "Ok, stopping"; 
	exit 0;; 
	*) echo "No user reply, stopping.";
	exit 1;;
esac
}

main_function () {
rm $target_jail/bin;
cp -R $source_jail/bin $target_jail/;
rm $target_jail/boot;
cp -R $source_jail/boot $target_jail/;
rm $target_jail/lib;
cp -R $source_jail/lib $target_jail/;
rm $target_jail/libexec;
cp -R $source_jail/libexec $target_jail/;
rm $target_jail/rescue;
cp -R $source_jail/rescue $target_jail/;
rm $target_jail/sbin;
cp -R $source_jail/sbin $target_jail/;
cp -R $source_jail/compat $target_jail/;
rm $target_jail/usr/bin;
cp -R $source_jail/usr/bin $target_jail/usr/;
rm $target_jail/usr/include;
cp -R $source_jail/usr/include $target_jail/usr/;
rm $target_jail/usr/lib;
cp -R $source_jail/usr/lib $target_jail/usr/;
rm $target_jail/usr/lib32;
rm $target_jail/usr/libdata;
cp -R $source_jail/usr/libdata $target_jail/usr/;
rm $target_jail/usr/libexec;
cp -R $source_jail/usr/libexec $target_jail/usr/;
rm $target_jail/usr/ports;
cp -R $source_jail/usr/ports $target_jail/usr/;
rm $target_jail/usr/sbin;
cp -R $source_jail/usr/sbin $target_jail/usr/;
rm $target_jail/usr/share;
cp -R $source_jail/usr/share $target_jail/usr/;
rm $target_jail/usr/src;
cp -R $source_jail/usr/src $target_jail/usr/;
cp -R $source_jail/usr/home $target_jail/usr/;
echo "Well done.";
exit 0;
}

if [ "$1" == "" ]
then manual_enter_function;
else if [ "$2" == "" ]
     then manual_enter_function;	
     else source_jail=$1;
          target_jail=$2;
	  verify_function;
     fi
fi

exit 0;
