#!/usr/bin/perl
# mainly used for Kristin
#Usage:
#1. perl grin.pl
#2. (optonal) perl snp.pl
#check freq:  ./plink --noweb --file grin13 --allow-no-sex --freq
#3.Use Plink to get associate results:
#  ./plink --noweb --missing-genotype N --allow-no-sex --file grin13 --assoc --adjust
#4.Use Plink to get episasis:
#  ./plink --noweb --missing-genotype N --allow-no-sex --file grin13 --fast-epistasis --epi1 1.731e-08 --epi2 1.731e-08
#5. get plink.raw
#  ./plink --noweb --file grin13 --recodeA
#6. generate cout and rout from raw
#  perl prepareMHfromRAW.pl

#$chrwant = 16;
#$chrwant1 = "06";
#$chrwant2 = "0";
#$chrwant3 = "19";
#$chrwant4 = "20";

open( DATA, "To_soybase_file_one_include_all_test.txt" )
  || die("Can't the file£º$_!");
open( PHENO, "pheno_HILUMCOLOR.txt" )
  || die("Can't the file£º$_!");
open( PEDFILE, ">grinHILUMCOLOR.ped" )
  || die("Can't the file£º$_!");
open( MAPFILE, ">grinHILUMCOLOR.map" )
  || die("Can't the file£º$_!");

$n = 0;
while ( $line = <PHENO> ) {
	chomp($line);
	@array = split( ",", $line );
	$phe   = @array[1];
	$pre   = substr $phe, 0, 1;
	if ( $pre eq "\"" ) {
		$phe = substr $phe, 1;
	}
	if ( $phe ne "" ) {

		#$pinumraw = substr @array[2], 1;
		#$piname = @array[0]. $pinumraw. @array[1];
		#$piname = @array[0] . $pinumraw;
		$piname = @array[0];
		if ( exists $PIarrayO{$piname} ) {
			$redund{$piname} = $piname;
		}
		$PIarrayO{$piname} = $phe;

		#print $piname."\t".$PIarray{$piname}."\n";
		$n = $n + 1;
	}
}
close PHENO;

foreach $key ( keys %PIarrayO ) {
	if ( exists $redund{$key} ) {

	}
	else {
		$PIarray{$key} = $PIarrayO{$key};
	}
}

print "Start\n";
$snpcount = 0;
while ( $line = <DATA> ) {
	chop($line);
	if ( $snpcount == 0 ) {
		@array = split( "\t", $line );
		$count = 0;
		for ( $i = 2 ; $i < scalar(@array) ; $i++ ) {

			#print @array[$i]."\n";
			#$pinumraw = substr @array[$i], 0, 8;
			$pinumraw = @array[$i];
			if ( exists $PIarray{$pinumraw} ) {
				$num                  = $i - 2;
				$pihm{$num}           = $PIarray{$pinumraw};
				$PIindexarray[$count] = $num;

			   #print @array[$i]."\t".$PIarray{ $pinumraw }."\t".$pinumraw."\n";
				$count = $count + 1;
			}
		}
		print "Total count:\t" . $count . "\n";
		$snpcount = $snpcount + 1;
	}
	else {
		@array  = split( "\t", $line );
		$ori    = @array[1];
		@array1 = split( "_", $ori );
		$pos    = @array1[4];
		$chr    = @array1[3];

#if ( $chr eq $chrwant ) {
#if (( $chr eq $chrwant1 ) ||( $chr eq $chrwant2 )||( $chr eq $chrwant3 )||( $chr eq $chrwant4 ))  {
		$mapArray[$snpcount] =
		    $chr . "\t" . $chr . "_" . $pos . "_"
		  . @array1[5] . "_"
		  . @array1[6]
		  . "\tNA\t"
		  . $pos . "\n";
		for ( $i = 2 ; $i < scalar(@array) ; $i++ ) {
			if ( exists $pihm{ ( $i - 2 ) } ) {
				$tmpalle = @array[$i];
				if ( $tmpalle eq "H" || $tmpalle eq "U" ) {
					if (   ( @array1[5] eq "A" && @array1[6] eq "C" )
						|| ( @array1[5] eq "C" && @array1[6] eq "A" ) )
					{
						$tmpalle = "M";
					}
					elsif (( @array1[5] eq "A" && @array1[6] eq "G" )
						|| ( @array1[5] eq "G" && @array1[6] eq "A" ) )
					{
						$tmpalle = "R";
					}
					elsif (( @array1[5] eq "A" && @array1[6] eq "T" )
						|| ( @array1[5] eq "T" && @array1[6] eq "A" ) )
					{
						$tmpalle = "W";
					}
					elsif (( @array1[5] eq "C" && @array1[6] eq "G" )
						|| ( @array1[5] eq "G" && @array1[6] eq "C" ) )
					{
						$tmpalle = "S";
					}
					elsif (( @array1[5] eq "C" && @array1[6] eq "T" )
						|| ( @array1[5] eq "T" && @array1[6] eq "C" ) )
					{
						$tmpalle = "Y";
					}
					elsif (( @array1[5] eq "T" && @array1[6] eq "G" )
						|| ( @array1[5] eq "G" && @array1[6] eq "T" ) )
					{
						$tmpalle = "K";
					}
					else {
						print "ERROR!";
					}
				}
				$dataarray[ ( $snpcount - 1 ) ][ ( $i - 2 ) ] = $tmpalle;

				#print "*".($snpcount-1)."\t".($i - 2)."\t".@array[$i]."\n";
			}
		}

		$snpcount = $snpcount + 1;

		#}

	}

}
close DATA;
$snpcount = $snpcount - 1;
print "snpcount:" . $snpcount . "\nPed Start\n";

print scalar(@PIindexarray) . "\n";

for ( $i = 0 ; $i < scalar(@PIindexarray) ; $i++ ) {
	print $i. "\t" . @PIindexarray[$i] . "\n";
	$num = $i + 1;

	#Pheno
	#$phetoken=$pihm{ @PIindexarray[$i]};

	#print $pihm{ @PIindexarray[$i] } ."\n";
	if ( $pihm{ @PIindexarray[$i] } eq "Bf" ) {
		$phetoken = 1;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Bfib" ) {
		$phetoken = 2;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Bl" ) {
		$phetoken = 3;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Blbr" ) {
		$phetoken = 4;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Br" ) {
		$phetoken = 5;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Brbl" ) {
		$phetoken = 6;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Dbf" ) {
		$phetoken = 7;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Dbr" ) {
		$phetoken = 8;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Dg" ) {
		$phetoken = 9;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Dib" ) {
		$phetoken = 10;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Drbr" ) {
		$phetoken = 11;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "G" ) {
		$phetoken = 12;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Ggn" ) {
		$phetoken = 13;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Gn" ) {
		$phetoken = 14;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Gnbl" ) {
		$phetoken = 15;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Gnbr" ) {
		$phetoken = 16;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "H" ) {
		$phetoken = 17;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Ib" ) {
		$phetoken = 18;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Ig" ) {
		$phetoken = 19;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Lbf" ) {
		$phetoken = 20;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Lbl" ) {
		$phetoken = 21;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Lbr" ) {
		$phetoken = 22;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Lg" ) {
		$phetoken = 23;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Lggn" ) {
		$phetoken = 24;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Lgn" ) {
		$phetoken = 25;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Lib" ) {
		$phetoken = 26;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Rbf" ) {
		$phetoken = 27;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Rbl" ) {
		$phetoken = 28;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Rbr" ) {
		$phetoken = 29;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Tn" ) {
		$phetoken = 30;
	}
	elsif ( $pihm{ @PIindexarray[$i] } eq "Y" ) {
		$phetoken = 31;
	}
	else {
		print $i. "\t"
		  . @PIindexarray[$i] . "\t"
		  . $pihm{ @PIindexarray[$i] }
		  . "\tError!\n";
	}

	$line = "1\t" . $num . "\t0\t0\t0\t" . $phetoken . "\t";
	for ( $j = 0 ; $j < $snpcount ; $j++ ) {

		#for ( $j = 0 ; $j < 2 ; $j++ ) {
		$alle = $dataarray[$j][ $PIindexarray[$i] ];
		if ( $alle eq "A" or $alle eq "T" or $alle eq "G" or $alle eq "C" ) {
			$line = $line . $alle . "\t" . $alle . "\t";
		}
		elsif ( $alle eq "M" ) {
			$line = $line . "A\tC\t";
		}
		elsif ( $alle eq "R" ) {
			$line = $line . "A\tG\t";
		}
		elsif ( $alle eq "W" ) {
			$line = $line . "A\tT\t";
		}
		elsif ( $alle eq "S" ) {
			$line = $line . "C\tG\t";
		}
		elsif ( $alle eq "Y" ) {
			$line = $line . "C\tT\t";
		}
		elsif ( $alle eq "K" ) {
			$line = $line . "G\tT\t";
		}
		elsif ( $alle eq "-" ) {
			$line = $line . "N\tN\t";
		}
		elsif ( $alle eq "U" ) {
			$line = $line . "N\tN\t";
		}
		elsif ( $alle eq "H" ) {
			$line = $line . "N\tN\t";
		}
		else {
			print $alle
			  . "Error! in "
			  . $alle . "::"
			  . $i . "\t"
			  . $j . "\t"
			  . @PIindexarray[$i] . "\n";
		}
	}
	$outArray[$i] = $line . "\n";
}

print PEDFILE @outArray;
close PEDFILE;
print MAPFILE @mapArray;
close MAPFILE;

