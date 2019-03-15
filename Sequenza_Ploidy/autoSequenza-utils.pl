use strict;

my $ref = "/home/zhuhenan/Documents/ReferenceGenomes/Homo_sapiens/Homo_sapiens_assembly38.fasta";
my $gc  = "/home/zhuhenan/Documents/ProjectWorkspace/CNVAnalysis/hg38.gc50.gz";

my @entries = split("\n", `cat N_T_pair2.csv`);
for (my $i = 1; $i < scalar @entries; $i ++) {
    print $entries[$i],"\n";
    my @run_p = split("\t", $entries[$i]);
    
    my $command = "sequenza-utils bam2seqz -n $run_p[3] -t $run_p[4] -gc $gc -F $ref -C chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY --parallel 24 -o $run_p[2].seqz.gz";
    print $command,"\n\n";
    system $command;
}
