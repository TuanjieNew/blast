#!/usr/bin/perl
#file name:blast_test.pl
use strict;
#use warnings;
use Storable;
print "Enter the file name: ";
my $input_file=<>;
#open FILE,"/2_disk/niutj/test.fasta" or die "cannot open file,$!";
open FILE,"$input_file" or die "the file cannot open,$!\n";
my $my_lines;
while( my $line=<FILE>){
#	my($my_lines,$key,%hash,$len);
	chomp($line=uc($line));
	$line=~ s/\R//;
	if($line!~ m/>.*/){
		$my_lines.=$line;
	}
}
close FILE;
my $len=length($my_lines);
#print "\$my_lines: $my_lines\n";
my $value=0;
my @search;
while($len>10){
    my $key=substr($my_lines,$value,11);
	push(@search,$key);
	$len-=1;
	$value+=1;
}
$len=length($my_lines);
my %diag;
while(my ($index,$word)=each @search){
	#print "he$index and $word\n";
#	open FILE1,"/2_disk/chenyr/libfiles1/$word" or die "cannot open the file: $word,$!";
    open FILE1,"/2_disk/niutj/blast_lib/make_lib2/$word" or die "cannot open file: $word,$!";
    my $location=<FILE1>;
	my @loca=split(/;/,$location);
#	print $loca[0],"\n";
	foreach my $loca (@loca){
		my @site=split(/\./,$loca);
		$diag{$site[0]}{$site[1]-$index}++;
			
	}
}
my $key_value=5;
foreach my $key1(keys (%diag)){
#	print "key1:$key1\n";
	foreach my $key2(keys %{$diag{$key1}}){

	    if($diag{$key1}{$key2}>$key_value){
#			print $diag{$key1}{$key2},"hello\n";
			open FILE2,"/2_disk/niutj/hg19_fa/$key1.txt" or die "cannot open file:$key1,$!";
			my $line=<FILE2>;
#			print "\$key2:$key2\n";
			my $seq=substr($line,$key2-1,$len);
#			print "\$seq2:$seq\n";
			&alignment($my_lines,$seq,$key1,$key2);
			close FILE2;
		}
	}

}

sub alignment{
	my ($pro1,$pro2,$chr_name,$chr_loc)=@_;
	my $match=2;
	my $mismatch=0;
	my $gap=-1;

	my @matrix;
	$matrix[0][0]=0;
	for (my $j=1;$j<=length($pro1);$j++){
		$matrix[0][$j]=$matrix[0][$j-1]+$gap;
	}
	for (my $i=1;$i<=length($pro2);$i++){
		$matrix[$i][0]=$matrix[$i-1][0]+$gap;
	}

	my $max_i=0;
	my $max_j=0;
	my $j=length($pro1);
	my $i=length($pro2);
	my $max_score=0;

	for (my $i=1;$i<=length($pro2);$i++){
		for ($j=1;$j<=length($pro1);$j++){
			my ($diag_score,$left_score,$up_score);
			#calculate match score
			my $letter1=substr($pro1,$j-1,1);
			my $letter2=substr($pro2,$i-1,1);
			if ($letter1 eq $letter2){
				$diag_score=$matrix[$i-1][$j-1]+$match;
			}
			else{
				$diag_score=$matrix[$i-1][$j-1]+$mismatch;
			}
			$up_score=$matrix[$i-1][$j]+$gap;
			$left_score=$matrix[$i][$j-1]+$gap;
			#choose the highest score
			if ($diag_score>=$up_score){
				if ($diag_score>=$left_score){
					$matrix[$i][$j]=$diag_score;
				}
				else{
					$matrix[$i][$j]=$left_score;
				}
			}
			else{
				if ($left_score>=$up_score){
					$matrix[$i][$j]=$left_score;
				}
				else{
					$matrix[$i][$j]=$up_score;
				}
			}
			#set maximum score
			if ($matrix[$i][$j]>$max_score){
				$max_i=$i;
				$max_j=$j;
				$max_score=$matrix[$i][$j];
			}
		}
	}

	#trace back
	my $align1="";
	my $align2="";
	my $equal_num=0;
	$align1.=substr($pro1,$j,1);
	$align2.=substr($pro2,$i,1);

	while($i!=0 and $j !=0){
		if ($matrix[$i-1][$j-1]>=$matrix[$i-1][$j]){
			if ($matrix[$i][$j]>=$matrix[$i][$j-1]){
				$align1.=substr($pro1,$j-1,1);
				$align2.=substr($pro2,$i-1,1);
				$i--;$j--;
			}
			else{
				$align1.=substr($pro1,$j-1,1);
				$align2.="-";
				$j--;
			}
		}
		else{
			if($matrix[$i-1][$j]>=$matrix[$i][$j-1]){
				$align1.="-";
				$align2.=substr($pro2,$i-1,1);
				$i--;
			}
			else{
				$align1.=substr($pro1,$j-1,1);
				$align2.="-";
				$j--;
			}
		}
	}


	$align2=substr($align2,1);
	$align1=reverse $align1;
	$align2=reverse $align2;
	for (my $k=0;$k<$len;$k++){
		my $letter1=substr($align1,$k,1);
		my $letter2=substr($align2,$k,1);
		if ($letter1 eq $letter2){
			$equal_num++;
		}
	}
	my $identity=($equal_num*100/length($pro1));
	print "chromosome and location: chr$chr_name,$chr_loc\n";
	printf " query_seq: %s\n",$align1;
	printf "genome_seq: %s\n",$align2;
	printf "Identity: %d/%d(%.2f%%)\n",$equal_num,length($pro1),$identity;
	print "Score: $max_score\n";
}

