use strict;

my $ref = "/home/zhuhenan/Documents/ReferenceGenomes/Homo_sapiens/Homo_sapiens_assembly38.fasta";
my $gc  = "/home/zhuhenan/Documents/ProjectWorkspace/CNVAnalysis/hg38.gc50Base.txt.gz";

my @entries = split("\n", `cat N_T_pair.csv`);
for (my $i = 1; $i < scalar @entries; $i ++) {
    print $entries[$i],"\n";
    my @run_p = split("\t", $entries[$i]);
    
    my $command = "zcat $run_p[2]_chr1.seqz.gz $run_p[2]_chr2.seqz.gz $run_p[2]_chr3.seqz.gz $run_p[2]_chr4.seqz.gz $run_p[2]_chr5.seqz.gz $run_p[2]_chr6.seqz.gz $run_p[2]_chr7.seqz.gz $run_p[2]_chr8.seqz.gz $run_p[2]_chr9.seqz.gz $run_p[2]_chr10.seqz.gz $run_p[2]_chr11.seqz.gz $run_p[2]_chr12.seqz.gz $run_p[2]_chr13.seqz.gz $run_p[2]_chr14.seqz.gz $run_p[2]_chr15.seqz.gz $run_p[2]_chr16.seqz.gz $run_p[2]_chr17.seqz.gz $run_p[2]_chr18.seqz.gz $run_p[2]_chr19.seqz.gz $run_p[2]_chr20.seqz.gz $run_p[2]_chr21.seqz.gz $run_p[2]_chr22.seqz.gz $run_p[2]_chrX.seqz.gz $run_p[2]_chrY.seqz.gz | gawk \'{if (NR!=1 && \$1 != \"chromosome\") {print \$0}}\' | bgzip > $run_p[2].seqz.gz";
    print $command,"\n\n";
    system $command;
    $command = "tabix -f -s 1 -b 2 -e 2 -S 1 $run_p[2].seqz.gz";
    system $command;
}
