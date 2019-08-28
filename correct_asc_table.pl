#!/usr/bin/perl
open FILE,"< $ARGV[0]" or die "couldn't open file $ARGV[0]\n";
open FILEDB,"> $ARGV[1]" or die "couldn't open file $ARGV[1]\n";
print FILEDB "; tekst, 256 pixels by 8 pixels, 240 is background 255 is white block
; every next line is rotated an extra 32 bytes for the 'inc h' trick to work


";
$_=<FILE>;
for $i (0 .. 7){
	undef @lijst;
	for $j (1 .. 10){
		$_=<FILE>;
		/^.*db\s+([\d,]+)/;
		$_=$1;
		@cols= /(\d+),?/g;
		@lijst=(@lijst,@cols)
	};
	undef @cols;
	if ($i > 0){
		#shift by 32
		$val=256-32*$i;
		@cols=(@lijst[$val .. $#lijst] , @lijst[0 .. ($val-1)]);
		@lijst=@cols;
	}
	undef @cols;

	for $j ( @lijst ){
		if ($#cols > 25){
			print FILEDB "\n db ", join ',',@cols;
			undef @cols;
		}
		$val = ($j==0?'240':'255');
		push @cols, $val;
	};
	print FILEDB "\n db ", join ',',@cols;
	undef @cols;
};
