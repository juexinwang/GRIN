open(INPUT, "C:\\Users\\install\\Desktop\\work\\grin\\grin13.ped") || die("Cannot open $_!");
open(OUTPUT, ">C:\\Users\\install\\Desktop\\work\\grin\\1275.txt") || die("Cannot open $_!");
$n=0;
$major1=0;
	$major2=0;
	$minor1=0;
	$minor2=0;
	$hete1=0;
	$hete2=0;
while($line=<INPUT>){
	chomp($line);
	@array = split("\t",$line);
	$pheno = @array[5];
	$alle1 = @array[2554];
	$alle2 = @array[2555];
	$results = $alle1."\t".$alle2;#1275:1275*2+4,1275*2+5 13	13_4553337	NA	4553337
	if($alle1 eq "T" && $alle2 eq "T"){
		print "TT:\t".$alle1."\t".$alle2."\n";
		if($pheno eq "1"){
			$minor1 = $minor1 +1;
		}else{
			$minor2 = $minor2 +1;
		}
	}elsif($alle1 eq "G" && $alle2 eq "G"){
		if($pheno eq "1"){
			$major1 = $major1 +1;
			print "1GG:\t".$alle1."\t".$alle2."\n";
		}else{
			$major2 = $major2 +1;
			print "2GG:\t".$alle1."\t".$alle2."\n";
		}
	}else{
		print "TG:\t".$alle1."\t".$alle2."\n";
		if($pheno eq "1"){
			$hete1 = $hete1 +1;
		}else{
			$hete2 = $hete2 +1;
		}
	}
	
	#print scalar(@array)."\t".$pheno."\t".$results."\n";
	#print $pheno."\n";
	$outArray[$n]=$pheno."\t".$results."\n";
	$n=$n+1;
}
print OUTPUT @outArray;
close INPUT;
close OUTPUT;

print $minor1."\t".$minor2."\t".$major1."\t".$major2."\t".$hete1."\t".$hete2."\n";