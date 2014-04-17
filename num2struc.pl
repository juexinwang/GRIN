#
open(INPUT,"C:\\Users\\install\\Desktop\\work\\grin\\STEMTERM_Num_.txt") or die("Cannot find $_ !\n");
open(OUTPUT,">C:\\Users\\install\\Desktop\\work\\grin\\STEMTERM_Num__.txt") or die("Cannot find $_ !\n");

$n=0;
while($line=<INPUT>){
	chomp($line);
	@array=split("\t",$line);
	$cline = "";
	for($i=0;$i<scalar(@array);$i++){
		if(@array[$i] eq "0.0"){
			$tmp = 0;
		}elsif(@array[$i] eq "1.0"){
			$tmp = 1;
		}else{
			$tmp = @array[$i];
		}
		if($i ne (scalar(@array)-1)){
			$cline=$cline.$tmp."\t";
		}else{
			$cline=$cline.$tmp;
		}
	}
	@outArray[$n]=$cline."\n";
	$n++;
}
print OUTPUT @outArray;
close INPUT;
close OUTPUT;