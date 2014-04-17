#!/usr/bin/perl

open(RAW,"C:\\Users\\install\\Desktop\\work\\grin\\plink13.raw") || die("Cannot open $_ !");
open(COUT,">C:\\Users\\install\\Desktop\\work\\grin\\plink13.cout") || die("Cannot open $_ !");
open(ROUT,">C:\\Users\\install\\Desktop\\work\\grin\\plink13.rout") || die("Cannot open $_ !");
open(ROUTP,">C:\\Users\\install\\Desktop\\work\\grin\\plink13.routp") || die("Cannot open $_ !");

$n=0;
while($line=<RAW>){
	chomp($line);
	@array = split(" ",$line);
	if($n==0){
		#the file header;
	}else{
		#cout
		$pheno = @array[5];
		$tmp = "";
		for ($i=6;$i<scalar(@array);$i++){
			$tmp = $tmp.@array[$i]." ";
		}
		$tmp = $tmp.$pheno."\n";
		$coutArray[$n-1]=$tmp;
		
		#rout
		$pheno = @array[5];
		$tmp = "";
		for ($i=6;$i<(scalar(@array)-2);$i++){
			$tmp = $tmp.@array[$i].",";
		}
		$tmp = $tmp.@array[(scalar(@array)-1)]."\n";
		$routArray[$n-1]=$tmp;
		$routPArray[$n-1]=$pheno."\n";
	}
	$n=$n+1;
}

print COUT @coutArray;
print ROUT @routArray;
print ROUTP @routPArray;

close RAW;
close COUT;
close ROUT;
close ROUTP;