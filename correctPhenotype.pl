open(IN, "C:\\Users\\install\\Desktop\\work\\xiangyang\\MLM_oil__.txt") or die("Cannot find $_!");
open(OUT, ">C:\\Users\\install\\Desktop\\work\\xiangyang\\T.txt") or die("Cannot find $_!");

$n=0;
while($line = <IN>){
	chomp($line);
	@array = split( "\t", $line );
	if($n==0){
		
	}else{
		$pre = @array[1];
		@array1=split("_",$pre);
		$pre1=@array1[2];
		@array2=split("Gm",$pre1);
		$chr=@array2[1];
		$outArray[$n-1]=$chr."\n";
	}
	$n++;
}

close IN;
print OUT @outArray;
close OUT;