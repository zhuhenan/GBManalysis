use strict;

my @files = glob("*bin50.seq.gz");
foreach my $file (@files) {
    my @names = split("\\.", $file);
    my $command = "zcat header.gz $file | bgzip > ".$names[0].".bin50.reheader.seqz.gz";
    print $command,"\n";
    system $command;
}
