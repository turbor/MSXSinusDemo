#!/usr/bin/perl
open FILE,"< $ARGV[0]" or die "couldn't open file $ARGV[0]\n";
open FILEDB,"> $ARGV[1]" or die "couldn't open file $ARGV[1]\n";
open FILECOL,"> $ARGV[2]" or die "couldn't open file $ARGV[2]\n";
do { $_=<FILE> } until /^\"/;;
/(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/;
($width,$height,$colors,$charspercol)=($1,$2,$3,$4);
$nr=0;
print FILECOL ";\t color definitions";
for $i (1 .. $colors){
	$_=<FILE>;
	/^\"(.{$charspercol})\s+c\s+\#(..)(..)(..)/;
	($code,$R,$G,$B)=($1,$2,$3,$4);
	#convert to MSXpal stuffcode
	$r=hex("0x".$R);
	$g=hex("0x".$G);
	$b=hex("0x".$B);
	print FILECOL "\n\tdb\t",sprintf("#%02X", (int($r/32)<<4)+int($b/32)),",",sprintf("#%02X", int($g/32));
	$color{$code}=$nr++;
};
print FILECOL "\n\n";

for $i (1 .. $height){
	$_=<FILE>;
	/\"(.*)\"/;
	$_=$1;
	$y=$i-1;$x=0;
	undef @lijst;
	@cols= /(.{$charspercol})/g;
	for $j ( @cols ){
		# print "($x,$y)=".$color{$j}."\n";
		if ($#lijst > 25){
			print FILEDB "\n\tdb\t", join ',',@lijst ;
			undef @lijst;
		};
		$val = $color{$j}+16*$color{$j};
		push @lijst, $val;
		$x++;
	};
	print FILEDB "\n\tdb\t", join ',',@lijst ;
};
print FILEDB "\n\n";

