#Used for raw manipulation
#Usage:
#1. perl grin.pl
#2. (optonal) perl snp.pl 
#check freq:  ./plink --noweb --file grin13 --allow-no-sex --freq
#3.Use Plink to get associate results:
#  ./plink --noweb --missing-genotype N --allow-no-sex --file grin13 --assoc
#4.Use Plink to get episasis:
#  ./plink --noweb --missing-genotype N --allow-no-sex --file grin13 --fast-epistasis --epi1 1.731e-08 --epi2 1.731e-08
#5. get plink.raw
#  ./plink --noweb --file grin13 --recodeA
#6. generate cout and rout from raw
#  perl prepareMHfromRAW.pl

open( DATA,
"C:\\Users\\install\\Desktop\\work\\grin\\To_soybase_file_one_include_all.txt"
  )
  || die("Can't the file£º$_!");
open( PHENO, "C:\\Users\\install\\Desktop\\work\\grin\\pheno.csv" )
  || die("Can't the file£º$_!");
open( PEDFILE, ">C:\\Users\\install\\Desktop\\work\\grin\\grin.ped" )
  || die("Can't the file£º$_!");
open( MAPFILE, ">C:\\Users\\install\\Desktop\\work\\grin\\grin.map" )
  || die("Can't the file£º$_!");

#$chrwant = 13;

$n = 0;
while ( $line = <PHENO> ) {
	chomp($line);
	@array = split( ",", $line );
	$phe   = @array[3];
	$pre   = substr $phe, 0, 1;
	if ( $pre eq "\"" ) {
		$phe = substr $phe, 1, 1;
	}
	if ( $phe ne "" ) {
		$pinumraw = substr @array[2], 1;

		#$piname = @array[0]. $pinumraw. @array[1];
		$piname = @array[0] . $pinumraw;
		$PIarray{$piname} = $phe;

		#print $piname."\t".$PIarray{$piname}."\n";
		$n = $n + 1;
	}
}
close PHENO;

print "Start\n";
$snpcount = 0;
while ( $line = <DATA> ) {
	chop($line);
	if ( $snpcount == 0 ) {
		@array = split( "\t", $line );
		$count = 0;
		for ( $i = 2 ; $i < scalar(@array) ; $i++ ) {

			#print @array[$i]."\n";
			$pinumraw = substr @array[$i], 0, 8;
			if ( exists $PIarray{$pinumraw} ) {
				$num                  = $i - 2;
				$pihm{$num}           = $PIarray{$pinumraw};
				$PIindexarray[$count] = $num;

				#print @array[$i]."\t".$PIarray{ $pinumraw }."\n";
				$count = $count + 1;
			}
		}
		print "END\n";
		$snpcount = $snpcount + 1;
	}
	else {
		@array  = split( "\t", $line );
		$ori    = @array[1];
		@array1 = split( "_", $ori );
		$pos    = @array1[4];
		$chr    = @array1[3];
		
			$mapArray[$snpcount] =
			    $chr . "\t" . $chr . "_" . $pos . "_"
			  . @array1[5] . "_"
			  . @array1[6]
			  . "\tNA\t"
			  . $pos . "\n";
			for ( $i = 2 ; $i < scalar(@array) ; $i++ ) {
				if ( exists $pihm{ ( $i - 2 ) } ) {
					$tmpalle = @array[$i];
					$dataarray[ ( $snpcount - 1 ) ][ ( $i - 2 ) ] = $tmpalle;

					#print "*".($snpcount-1)."\t".($i - 2)."\t".@array[$i]."\n";
				}
			}

			$snpcount = $snpcount + 1;

	}

}
close DATA;
$snpcount = $snpcount - 1;
print "snpcount:" . $snpcount . "\nPed Start\n";

print scalar(@PIindexarray) . "\n";

for ( $i = 0 ; $i < scalar(@PIindexarray) ; $i++ ) {
	print $i. "\t" . @PIindexarray[$i] . "\n";
	$num = $i + 1;
	if ( $pihm{ @PIindexarray[$i] } eq "P" ) {
		$phetoken = 1;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "W" ) {
		$phetoken = 2;
	}
	else {
		print "ERROR in pheno!\n";
	}
	$line = "1\t" . $num . "\t0\t0\t0\t" . $phetoken . "\t";
	for ( $j = 0 ; $j < $snpcount ; $j++ ) {

		#for ( $j = 0 ; $j < 2 ; $j++ ) {
		$alle = $dataarray[$j][ $PIindexarray[$i] ];
		$line = $line . $alle . "\t" . $alle . "\t";
		
	}
	$outArray[$i] = $line . "\n";
}

print PEDFILE @outArray;
close PEDFILE;
print MAPFILE @mapArray;
close MAPFILE;

