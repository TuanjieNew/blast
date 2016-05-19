#!/usr/bin/perl
##file name:make_lib3.pl
use strict;
use warnings;

open FILE,"/1_disk/public_resources/hg19.fa";
my $num;
my $site;
while(my $line=<FILE>){
	chomp ($line=uc($line));
	$line=~ s/\R//;
	if($line=~ m/>.*/){
		$site=0;
		$num=substr($line,4);
		if($num eq "X"){
			$num=23;
		}
		elsif($num eq "Y"){
			$num=24;
		}
		elsif($num eq "M"){
			$num=25;
		}
#		push(@loc,$num);
	}
	else{
		my $len=length($line);
		my $value=0;
		while($len>=10){
		    my $word=substr($line,$value,10);
		    open FILE1,">>./make_lib3/$word";
			my $content="$num.$site;";
			print FILE1 $content;
			$len--;
			$value++;
			$site++;
			close FILE1;
		}
	}
}
