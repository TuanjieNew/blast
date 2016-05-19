#!/usr/bin/perl
#file name: splice.pl
open FILE,"/1_disk/public_resources/hg19.fa";
my (@loc,$loc);
my $k=0;
while(my $line=<FILE>){
	chomp($line=uc($line));
	$line=~ s/\R//;
	if($line=~ m/>.*/){
		$line=substr($line,1);
		push(@name,$line);
		$loc=substr($line,3);
		
		push (@loc,$loc);
		my $loclen=@loc;
		if($loclen>1){
			&make_file($all_line);
			$k++;
		}	
		$all_line=$null_value;
	}
	
	else{
		$all_line.=$line;
	}
}
&make_file($all_line);
sub make_file{
	my ($lines)=@_;
	open FILE2,">./hg19_splice/$loc[$k].txt";
	print $k,"\n";
	print FILE2 $all_line;;
}
