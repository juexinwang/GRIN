open(TPED,"C:\\Users\\install\\Desktop\\work\\grin\\grinSTEMTERM_CT.tped") or die("Cannot find $_!\n");
open(TFAM,"C:\\Users\\install\\Desktop\\work\\grin\\grinSTEMTERM_CT.tfam") or die("Cannot find $_!\n");
open(HMP,">C:\\Users\\install\\Desktop\\work\\grin\\grinSTEMTERM_CT.hmp") or die("Cannot find $_!\n");


$cline="rs#\talleles\tchrom\tpos\tstrand\tassembly#\tcenter\tprotLSID\tassayLSID\tpanel\tQCcode\t";

$n=0;
while($line=<TFAM>){
	chomp($line);
	@array=split(" ",$line);
	@piArray[$n]=@array[1];
	$n++;
}
for($i=0;$i<scalar(@piArray);$i++){
	$cline.=@piArray[$i]."\t";
}
@outArray[0]=$cline."\n";

$n=1;
while($line=<TPED>){
	chomp($line);
	@array=split(" ",$line);
	$cline = @array[1]."\t\t".@array[0]."\t".@array[3]."\t\t\t\t\t\t\t\t";
	for($i=4;$i<scalar(@array);$i=$i+2){
		$cline=$cline.@array[$i].@array[$i+1]."\t";
	}
	@outArray[$n]=$cline."\n";
	$n++;
}


print HMP @outArray;
close TPED;
close HMP;

