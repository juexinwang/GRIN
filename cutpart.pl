#Used for get phenotype data from ped file from PLINK
#For TASSEL, use this after got ped and map
open(PEDFILE, "C:\\Users\\install\\Desktop\\work\\grin\\grinSHATLATE.ped") or die("Cannot find $_!");
open(FILE, ">C:\\Users\\install\\Desktop\\work\\grin\\grinSHATLATE.pheno") or die("Cannot find $_!");

$n = 0;
while ( $line = <PEDFILE> ) {
	chomp($line);
	@array = split( "\t", $line );
	@outArray[$n]=@array[1]."\t".@array[5]."\n";
	$n++;
}
print FILE @outArray;
close PEDFILE;
close FILE;