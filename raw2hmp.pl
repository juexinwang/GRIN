open(INPUT,"C:\\Users\\install\\Desktop\\work\\grin\\To_soybase_file_one_include_all.txt") or die("Cannot find $_!\n");
open(HMP,">C:\\Users\\install\\Desktop\\work\\grin\\grin.hmp") or die("Cannot find $_!\n");

$n=0;
while($line=<INPUT>){
	print $n."\n";
	chomp($line);
	@array=split(" ",$line);
	if($n==0){
		$cline="rs#\talleles\tchrom\tpos\tstrand\tassembly#\tcenter\tprotLSID\tassayLSID\tpanel\tQCcode\t";
		@array=split(" ",$line);
		for($i=2;$i<scalar(@array)-3;$i++){
			$cline.=@array[$i]."\t";
		}
		@outArray[0]=$cline."\n";
	}else{
		@array1 =split("_",@array[1]);
		$chr = @array1[3];
		$pos = @array1[4]; 
		$cline = @array[1]."\t\t".$chr."\t".$pos."\t\t\t\t\t\t\t\t";
		for($i=2;$i<scalar(@array)-3;$i++){
			$cline=$cline.@array[$i]."\t";
		}
		@outArray[$n]=$cline."\n";
	}	
	$n++;
}

close INPUT;
print HMP @outArray;
close HMP;

