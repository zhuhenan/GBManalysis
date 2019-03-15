use strict;

my $ref = "/home/zhuhenan/Documents/ReferenceGenomes/Homo_sapiens/Homo_sapiens_assembly38.fasta";
my $gc  = "/home/zhuhenan/Documents/ProjectWorkspace/CNVAnalysis/hg38.gc50Base.txt.gz";

my @entries = split("\n", `cat N_T_pair.csv`);
for (my $i = 1; $i < scalar @entries; $i ++) {
    print $entries[$i],"\n";
    my @run_p = split("\t", $entries[$i]);
    
    my $command = "sequenza-utils seqz_binning -s $run_p[2].seqz.gz -w 50 -o $run_p[2].bin50.seq.gz";
    system $command;
}
