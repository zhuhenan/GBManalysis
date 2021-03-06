format HEADER =
/ ------------------------------------------------------------------------------------------------------------------
| Purpose : This is pipeine for running Sequenza-utils to prepare seqz file
|
|  Options:
|    --help, -h    Give help screen
|    --file, -f    Control file
|
|  Example:
|    autoSequenza-utils.pl -f /YOUR/CONTROL/FILE
\ ------------------------------------------------------------------------------------------------------------------
.

# ------------------------------------------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------------------------------------------
use strict;
use warnings;
use Getopt::Long qw(GetOptions);
Getopt::Long::Configure qw(gnu_getopt);
use Data::Dumper;

# ------------------------------------------------------------------------------------------------------------------
# Major functions
# sequenza-utils - Read control file and prepare binning seqz files for R
# ------------------------------------------------------------------------------------------------------------------

# Initialization
my ($ctlFile, $opt_h, %User_Preferences);

# Get the input parameters from command line
# Call help screen or do the analysis
GetOptions ('help|h' => \$opt_h, 'file|f=s' => \$ctlFile)
or die("Error in command line arguments\n");
if (defined $opt_h) { &do_help; }
# Read configure file and set user-perference parameters
print ">",$ctlFile,"\n";
open(my $conf, "<", $ctlFile);

while (<$conf>) {
  chomp;               # no newline
  s/#.*|^\s+|\s+$//g;  # no comments, no leading white, no trailing white
  next unless length;  # anything left?
  my ($var, $value) = split(/\s*=\s*/, $_, 2);
  $User_Preferences{$var} = $value;
}
# Read input bam list and initie the sequenza process query
# Default: first line is the header line
my @bams = split("\n", `cat $User_Preferences{"INPUT"}`);
for (my $i = 1; $i < scalar @bams; $i ++) {
  my ($Sample_N, $Sample, $normal, $tumour) = split("\t", $bams[$i]);
  # Call "bam2seqz" function to prepare the fragmented seqz files
  &bam2seqz(\%User_Preferences, $Sample, $normal, $tumour, $i);
  # Call "merge" function to merge all fragments
  &mergefrag(\%User_Preferences, $Sample);
  # Call "seqz_binning" function to bin seqz, reduce memory;
  &seqz_binning(\%User_Preferences, $Sample);
  # Add seqz format header back
  &add_seqz_header(\%User_Preferences, $Sample);
  # Clean intermedia files
  &clean($Sample);
  # run Sequenza
  &sequenza_R(\%User_Preferences, $Sample);
}

# ------------------------------------------------------------------------------------------------------------------
# Sub functions: sequenza-utils: step 1
# bam2seqz: convert normal and tumour bam files to fragmented seqz files
# ------------------------------------------------------------------------------------------------------------------

sub bam2seqz {
  my $command = "";
  my ($User_Preferences, $Sample, $normal, $tumour, $run_id) = @_;
  #
  print "Running $run_id: $Sample\n";
  print "Normal bam: $normal\n";
  print "Tumour bam: $tumour\n\n";
  # command line
  $command  = "sequenza-utils bam2seqz -n $normal -t $tumour";
  $command .= " -gc ".$User_Preferences->{"GC"};
  $command .= " -F ".$User_Preferences->{"REF"};
  $command .= " -o $Sample.seqz";
  $command .= " -C ".$User_Preferences->{"CHR"};
  $command .= " --parallel ".$User_Preferences->{"PARALLEL"};
  # Processing
  print $command,"\n\n";
  system $command;
}

# ------------------------------------------------------------------------------------------------------------------
# Sub functions: sequenza-utils: step 2
# mergefrag: merge all fragments to one seqz file
# ------------------------------------------------------------------------------------------------------------------

sub mergefrag {
  my $command = "";
  my ($User_Preferences, $Sample) = @_;
  #
  my @chr = split(" ", $User_Preferences->{"CHR"});
  for (my $i = 0; $i < scalar @chr; $i ++) { $chr[$i] = "$Sample\_".$chr[$i].".seqz"; }
  my $list = join(" ", @chr);

  print "Merging ".scalar(@chr)." fragments\n";
  # command line
  $command .= "cat $list \| ";
  $command .= "gawk \'\{if \(NR\!=1 && \$1 != \"chromosome\"\) \{print \$0\}\}\' \| ";
  $command .= "bgzip -@ ".$User_Preferences->{"BGZIP_NT"}." > $Sample.seqz.gz";
  #
  print $command,"\n\n";
  system $command;
}

# ------------------------------------------------------------------------------------------------------------------
# Sub functions: sequenza-utils: step 3
# seqz_binning: bin big seqz file with windows 50mb/win
# ------------------------------------------------------------------------------------------------------------------

sub seqz_binning {
  my $command = "";
  my ($User_Preferences, $Sample) = @_;
  #
  print "Biining $Sample.seqz.gz\n";
  # command line
  $command .= "sequenza-utils seqz_binning --seqz $Sample.seqz.gz";
  $command .= " --window ".$User_Preferences->{"WIN"};
  $command .= " -o $Sample.bin50.seqz.gz";
  #
  print $command,"\n";
  system $command;
}

# ------------------------------------------------------------------------------------------------------------------
# Sub functions: sequenza-utils: step 3
# seqz_binning: bin big seqz file with windows 50mb/win
# ------------------------------------------------------------------------------------------------------------------

sub add_seqz_header {
  my $command = "";
  my ($User_Preferences, $Sample) = @_;
  #
  print "Add header line to $Sample.bin50.seqz.gz\n";
  # command line
  $command .= "zcat header.seqz.gz $Sample.bin50.seqz.gz | ";
  $command .= "bgzip -@ ".$User_Preferences->{"BGZIP_NT"}." > $Sample.bin50.head.seqz.gz";
  #
  print $command,"\n";
  system $command;
}

# ------------------------------------------------------------------------------------------------------------------
# Sub functions: sequenza-utils: step 3
# clean: remove all intermedia files
# ------------------------------------------------------------------------------------------------------------------

sub clean {
  my $sample = $_[0];
  #
  print "rm $sample\_chr*.seqz\n";
  print "rm $sample.seqz.gz\n";
  print "rm $sample.bin50.seqz.gz\n\n";
  system "rm $sample\_chr*.seqz";
  system "rm $sample.seqz.gz";
  system "rm $sample.bin50.seqz.gz";
}

# ------------------------------------------------------------------------------------------------------------------
# Sub functions
# sequenza_R - run sequenza R package to calculate ploidy
# ------------------------------------------------------------------------------------------------------------------

sub sequenza_R {
  my $command = "";
  my ($User_Preferences, $Sample) = @_;
  #
  print "Running sequenza R\n";
  #
  $command = "Rscript sequenza.R $Sample.bin50.head.seqz.gz $Sample\n";
  #
  print $command;
  system $command;
}

# ------------------------------------------------------------------------------------------------------------------
# Sub functions
# Give help Screen and exit
# ------------------------------------------------------------------------------------------------------------------
sub do_help {
    $~ = "HEADER";
    write;
    exit;
}
