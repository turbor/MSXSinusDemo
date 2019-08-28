all:	msxsindm.rom
	openmsx -machine Philips_VG_8020  -ext debugdevice -script startup.tcl -carta msxsindm.rom

clean:
	rm msxsindm.rom

msxsindm.rom:	*.asc
	pasmo --bin --nocase msxsindm.asc msxsindm.rom msxsindm.symbol msxsindm.publics

scrollertext.asc:	scrollertext.xpm
	perl xpmtodb.pl scrollertext.xpm /tmp/1.asc /tmp/2.asc
	perl correct_asc_table.pl /tmp/1.asc scrollertext.asc
