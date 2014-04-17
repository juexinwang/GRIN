open(INPUT,"C:\\Users\\install\\Desktop\\work\\grin\\To_soybase_file_one_include_all.txt") or die("Cannot find $_!\n");
open(OUTPUT,">C:\\Users\\install\\Desktop\\work\\grin\\To_soybase_file_one_include_all_sorted.txt") or die("Cannot find $_!\n");

$count = 0;
while($line = <INPUT>){
	chomp($line);
	if($count!=0){
		@array = split( "\t", $line );
		$pre=@array[1];
		@array1= split("_",$pre);
		$chr=@array1[3];
		$pos=@array1[4];
		$ppos = $chr*100000000+$pos;
		$hm{$ppos}=$count-1;
		$indexhm{$count-1}=$ppos;
		print $count."\t".$chr."\t".$pos."\t".$ppos."\n";
		if($chr*100000000<$pos){
			print $count."\t".$chr."\t".$pos."\t".$ppos."\n"; 
		}
		@outArray[$count-1]=$line."\n";
	}
	else{
		$cline = $line."\n";
	}
	
	$count++;
}

$count = 0;
foreach my $name (sort {$a <=> $b} keys %hm){
    #printf "%-8s %s\n", $name, $hm{$name};
    $hhm{$name}=$count;
    $indexhhm{$count}=$name;
    #print $name."\t".$count."\n";
    $count++;
    
}

for($i=0;$i<scalar(@outArray);$i++){
	#print $i."\t".$indexhhm{$i}."\t".$hm{$indexhhm{$i}}."\n";
	@outArray1[$i]= @outArray[$hm{$indexhhm{$i}}];
}

$outArray2[0]=$cline;
for($i=0;$i<scalar(@outArray);$i++){
	@outArray2[$i+1]= @outArray1[$i];
}
close INPUT;
print OUTPUT @outArray2;
close OUTPUT;
