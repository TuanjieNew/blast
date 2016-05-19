#!/usr/bin/perl
#the file name is: get_file2.pl
#match=2,mismatch=0;gap=-1
use strict;
use warnings;
print "Enter the file name and directory: ";
my $input_file=<>;
open FILE,"$input_file" or die "The file cannot open\n";
my @sequence;
my @name;
my $name1;
my $name2;
my $seq;

print "Match=2    Mismatch=0    Gap=-1\n";
while(my $line=<FILE>){
	chomp $line;
	if($line=~ m/gi.*/){
		push(@name,$line);
		my $name=@name;
		if($name>1){
			push(@sequence,$seq);
		}
		my $null_value;
		$seq=$null_value;
	}
	else{
		$seq.=$line;
	}
}
push(@sequence,$seq);
my $sequence=@sequence;
for(my $k=0;$k<$sequence;$k++){
	for(my $l=$k+1;$l<$sequence;$l++){
		my ($seq1,$seq2);
		$seq1=$sequence[$k];
		$seq2=$sequence[$l];
		$name[$k]=~ m/\[.*\]/;
		$name1=$&;
		$name[$l]=~ m/\[.*\]/;
		$name2=$&;
		#print "\$pro1: $seq1\n";
		#print "\$pro2: $seq2\n";
		#print "\$name1: $name1\n";
		#print "\$name2: $name2\n";
		&alignment($seq1,$seq2);
		
	}
}

sub alignment {
	my($pro1,$pro2)=@_;
	my $match=2;
	my $mismatch=0;
	my $gap=-1;

	my @matrix;
	$matrix[0][0]{score}=0;
	$matrix[0][0]{pointer}="none";
	for (my $j=1;$j<=length($pro1);$j++){
		$matrix[0][$j]{score}=0;
		$matrix[0][$j]{pointer}="none";
	}
	for (my $i=1;$i<=length($pro2);$i++){
		$matrix[$i][0]{score}=0;
		$matrix[$i][0]{pointer}="none";
	}

	my $max_i=0;
	my $max_j=0;
	my $max_score=0;
	my ($i,$j);

	for (my $i=1;$i<=length($pro2);$i++){
		for ($j=1;$j<=length($pro1);$j++){
			my ($diag_score,$left_score,$up_score);
			#calculater match score
			my $letter1=substr($pro1,$j-1,1);
			my $letter2=substr($pro2,$i-1,1);
			if ($letter1 eq $letter2){
				$diag_score=$matrix[$i-1][$j-1]{score} + $match;
			}
			else{
				$diag_score=$matrix[$i-1][$j-1]{score} + $mismatch;
			}
			$up_score=$matrix[$i-1][$j]{score}+$gap;
			$left_score=$matrix[$i][$j-1]{score}+$gap;
			if ($diag_score<=0 and $up_score<=0 and $left_score<=0){
				$matrix[$i][$j]{score}=0;
				$matrix[$i][$j]{pointer}="none";
				next;
			}
			 #choose the highest score
			 if ($diag_score>=$up_score){
				 if ($diag_score>=$left_score){
					 $matrix[$i][$j]{score}=$diag_score;
					 $matrix[$i][$j]{pointer}="diagonal";
				 }
				 else{
					 $matrix[$i][$j]{score}=$left_score;
					 $matrix[$i][$j]{pointer}="left";
				 }
			 }
			 else {
				 if ($left_score>=$up_score){
					 $matrix[$i][$j]{score}=$left_score;
					 $matrix[$i][$j]{pointer}="left";
				 }
				 else{
					 $matrix[$i][$j]{score}=$up_score;
					 $matrix[$i][$j]{pointer}="up";
				 }
			 }

			 # set maximum score
			 if($matrix[$i][$j]{score}>$max_score){
				 $max_i=$i;
				 $max_j=$j;
				 $max_score=$matrix[$i][$j]{score};
			 }
		 }
	 }

	 #trace back

	 my $align1="";
	 my $align2="";
	 $j=$max_j;
	 $i=$max_i;
	 my $equal_num=0;

	 while(1){
		 last if $matrix[$i][$j]{pointer} eq "none";
		 if ($matrix[$i][$j]{pointer} eq "diagonal"){
			 $align1.=substr($pro1,$j-1,1);
			 $align2.=substr($pro2,$i-1,1);
			 $i--;$j--;
		 }
		 elsif($matrix[$i][$j]{pointer} eq "left"){
			 $align1.=substr($pro1,$j-1,1);
			 $align2.="-";
			 $j--;
		 }
		 elsif($matrix[$i][$j]{pointer} eq "up"){
			 $align1.="-";
			 $align2.=substr($pro2,$i-1,1);
			 $i--;
		 }

	 }
 
	 $align1=reverse $align1;
	 $align2=reverse $align2;
     for (my $k=0;$k<=length($align1);$k++){
		 my $letter1=substr($align1,$k,1);
		 my $letter2=substr($align2,$k,1);
		 if ($letter1 eq $letter2){
			 $equal_num++;
		 }
	 }
	 my $identity=($equal_num*100/length($align1));
	 my $len=length($align1);
	 printf "%-20s: %s\n",$name1,$align1;
	 printf "%-20s: %s\n",$name2,$align2;
	 printf "Identity: %d/%d(%.2f%%)\n",$equal_num,$len, $identity;
	 print "Score: $max_score\n";

 }
					 




