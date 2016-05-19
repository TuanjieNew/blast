# blast

README
=======

This source code was distributed as the program training of computational biology course 
of South University of Science and Technology of China (SUSTC). It is not suggested to use
these scripts to do academic work because they are not tested strictly. Just for study.

LICENSE
-------
See LICENSE.txt.

DESCRIPTION
-----------
In bioinformatics, BLAST for Basic Local Alignment Search Tool is an algorithm for comparing
primary biological sequence information. This source code can enable users to compare a query 
sequence with a library of human genome and identify library sequences that resemble the query
sequence above a certain threshold.

REQUIREMENTS
------------
Unix operating system (Linux, Mac OS X, etc.).

Reference genome (FASTA format; e.g., hg19.fa or hg39.fa).

Perl 5

USAGE and DETAILS of ALGORITHM
==============================

This program contains three parts. 
If you want to try it, you need to change the path of files.

1. Use splice_genome.pl to cut the whole genome fasta file (e.g., hg19.fa) to single chromosome
(e.g., 1.fa,2.fa, number is the chromosome number) as reference.
2. Use make_library.pl to break the reference genome into overlapping words with 11 bases. 
The 11 base as the name of a test file which contains the chromosome number and location. 
This library workr efficiently at later step, although it will take a lot of time to construct
a library.
3. blast.pl is the core of the program. It can find the similar sequence of query sequence by
accumulated methods in the library and do sequence comparison by Smith Waterman algorithm.
4. alignment.pl the perl version of Smith Waterman algorithm.

OTHER PARTS
-----------
The old_version folder contains other versions of blast.pl and library construction scripts  used to optimeze the program. I just didn't delete them.
The sample folder folder contains the query sequence from homo sapiens. You can use the fasta files to test blast.pl.


