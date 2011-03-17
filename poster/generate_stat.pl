#!/usr/bin/perl -w


print "Generating stats...\n";

my $add = 0;
my $del = 0;
my $mod = 0;
my $file = "x3";


#my $lines = `wc -l $file | awk '{print \$1}'`;
#print "lines=$lines\n";
#my $line = 0;

#open FX, "cat $file" or die "Can't open $file";

while (<>) {
#	$line++;
#	my $mod100=$line/100;
#	my $mul100=$mod100*100;
#	if ($line == $mul100) {
#		print "$line..";
#	}
	chomp;
	my @arr = split;
#	print "$_\n";
#	print "add = $arr[0]\n";
#	print "del = $arr[1]\n";
#	print "file = $arr[2]\n";
#	print "---\n";

	my $a = $arr[0];
	my $d = $arr[1];
	my $f = $arr[2];
	if ($a == $d) {
#		print "equal\n";
		$mod = $mod + $a;
	} else {
		if ($a < $d) {
#			print "add less than del\n";
			$mod = $mod + $a;
			$del = $del + $d - $a;
		} else {
#			print "add greater than del\n";
			$mod = $mod + $d;
			$add = $add + $a - $d;
		}
	}
#	print ("mod = $mod add = $add del = $del\n");


}

print "added    = $add\n";
print "deleted  = $del\n";
print "modified = $mod\n";

exit;

#
#
#
#	echo "\"$LINE\"  A=$A D=$D"
#	if [[ $A -eq $D ]] ; then
##		echo "equal"
#		MOD=$(($MOD+$A))
#	elif [[ $A -lt $D ]] ; then
##		echo "add less than del"
#		MOD=$(($MOD+$A))
#		DEL=$(($DEL+$D-$A))
#	else
##		echo "add greater than del"
#		MOD=$(($MOD+$D))
#		ADD=$(($ADD+$A-$D))
#	fi
#
##	echo "MOD=$MOD ADD=$ADD DEL=$DEL"
##	echo "---"
#
#done < $FILE3
#
#echo ""
#
#echo "added    = $ADD"
#echo "deleted  = $DEL"
#echo "modified = $MOD"
#


#echo "generating inserts"
#INSERT=0
#for IN in `cat x3 | awk '{print $1}'`
#do
#	INSERT=$(($INSERT+$IN))
#done
#
#echo "generating deletions"
#DELETE=0
#for DEL in `cat x3 | awk '{print $2}'`
#do
#	DELETE=$(($DELETE+$DEL))
#done
#
#echo "insert = $INSERT"
#echo "delete = $DELETE"
#
#echo "lines added = $(($INSERT-$DELETE))"
#if [[ $INSERT < $DELETE ]] ; then
#	echo "modified = $INSERT"
#else
#	echo "modified = $DELETE"
#fi

