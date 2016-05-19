#!/usr/bin/perl
#file name: make_lib2.pl
use strict;
use Data::Dumper;
use Storable;
use warnings;

=pod
for(my $i=1;$i<25;$i++){
open FILE1,"./hg19_splice/$i.txt";
my $line1=<FILE1>;
my $value=0;
my $len=length($line1);
#print $len,"\n";
my $key="";
while($len>10){
	$key=substr($line1,$value,11);
	open FILE2,">>./make_lib2/$key";
	my $content="$i.$value;";
	print FILE2 $content;
	$len-=11;
	$value+=11;
	close FILE2;

}
close FILE1;
}
=cut
my $hashref=retrieve("/2_disk/niutj/lib_test/hg_19.txt");
print Dumper(\%$hashref);

