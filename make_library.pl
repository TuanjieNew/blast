#!/usr/bin/perl
#file name:library.pl
use strict;
use warnings;

my $j=0;
my ($all_line,$loca,$name,@name,$num,@loc,$loc);
$loca=0;
open FILE,"/1_disk/public_resources/hg19.fa";
while(my $line=<FILE>){
	my $null_value;
	chomp ($line=uc($line));
	$line=~ s/\R//;
	if($line=~ m/>.*/){
		$line=substr($line,1);

		push(@name,$line);
		if($line=~ /(\d+)/){
			$loc=$1;
		}
		else{
			$num=substr($line,3);
			if($num eq "X"){
				$loc=23;
			}
			elsif($num eq "Y"){
				$loc=24;
			}
			else{
				$loc=25;
			}
		}
		push (@loc,$loc);
		my $name=@name;
		if($name>1){
		&make_hash($all_line,$j);
		$loca=$j+1;
		$j++;
	}
		$all_line=$null_value;

	}
	else{
		$all_line.=$line;
	}
	
}
&make_hash($all_line,$loca);
my $key;
sub make_hash{
	#my (%hash,$key);
	my $value=0;
	my($all_lines,$k)=@_;
	my $len=length($all_lines);
	print $len,"\n";
	while($len>10){
		$key=substr($all_lines,$value,11);
		open FILE1,">>./hg19lib/$key.txt";
		my $content="$loc[$k].$value;";
		print FILE1 $content;
		#	$hash{$key}.="$loc[$k].$value;";
		$len--;
		$value++;
		close FILE1;
	}
	#store \%hash,".//hg.txt";
	#%hash=();
	#my $hashref=retrieve("./hg.txt");
	#print Dumper(\%$hashref);
   
}
