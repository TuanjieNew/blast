#!/usr/bin/perl
#file name: make_lib.pl
use strict;
use warnings;
use Data::Dumper;
use Storable;
open *STDIN,"./lib_test/hg_19.txt";

my $hashref=retrieve(*STDIN);
my %hash=\$hashref;
foreach my $key (%hash){
	open FILE,">>./make_lib/$key";
	my $value=$hash{$key};
	print FILE $value;
	close FILE;
}
