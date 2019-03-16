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
# Main functions
# ------------------------------------------------------------------------------------------------------------------

# Initialization - read files
my ($ctl) = &Initialization();

# ------------------------------------------------------------------------------------------------------------------
# Sub functions
# Initialization - test system & catch the command line input & set output file parameters
# ------------------------------------------------------------------------------------------------------------------

sub Initialization {

	# Initialization
  my ($ctlFile, $opt_h);
	# Get the input parameters from command line
  GetOptions (
    'help|h' => \$opt_h,
    'file|f' => \$ctlFile
    );
  # Call help screen or do the analysis
  if (defined $opt_h) { &do_help; }
  if (undef $ctlFile) { print "$0 pipeline configure file is missing!!\n"; &do_help;}
}





# while (<CONFIG>) {
#     chomp;                  # no newline
#     s/#.*//;                # no comments
#     s/^\s+//;               # no leading white
#     s/\s+$//;               # no trailing white
#     next unless length;     # anything left?
#     my ($var, $value) = split(/\s*=\s*/, $_, 2);
#     $User_Preferences{$var} = $value;
# }
#
#
# my @entries = split("\n", `cat N_T_pair2.csv`);
# for (my $i = 1; $i < scalar @entries; $i ++) {
#     print $entries[$i],"\n";
#     my @run_p = split("\t", $entries[$i]);
#
#     my $command = "sequenza-utils bam2seqz -n $run_p[3] -t $run_p[4] -gc $gc -F $ref -C chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY --parallel 24 -o $run_p[2].seqz.gz";
#     print $command,"\n\n";
#     system $command;
# }

# ------------------------------------------------------------------------------------------------------------------
# Sub functions
# Give help Screen and exit
# ------------------------------------------------------------------------------------------------------------------
sub do_help {
    $~ = "HEADER";
    write;
    exit;
}
