#! /usr/bin/env perl
# generate diabetes report. Argument is date of saved csv file
# Version 0: Jane Coates 8/9/2014

use strict;
use diagnostics;
use Cwd qw(cwd);

my $base = $ARGV[0];
print "Generating diabetes report using data from $base\n";

my $input_file = "../csv_files/${base}.csv";
chdir "R";
print cwd(), "\n";
print "Generating plot\n";
system("Rscript plot_script.R $input_file");
print "Manipulating data\n";
system("Rscript table_script.R $input_file");
chdir "..";
print cwd(), "\n";

#change report.tex file
my $tex_file = "report.tex";
my $text = read_file($tex_file);
$text =~ s/out_(.*?)\.csv/out_$base.csv/;
$text =~ s/\/(.*?)\.pdf/\/$base.pdf/;
output_to_file($tex_file, $text);

system("pdflatex report.tex");
system("pdflatex report.tex");
system("cp report.pdf Reports/${base}_report.pdf");
system("evince report.pdf");

sub read_file {
    my ($file) = @_;

    open my $in, '<:encoding(utf-8)', $file or die "Can't open $file for reading : $!";
    local $/ = undef; #slurp mode
    my $all = <$in>;
    close $in;
    return $all;
}

sub output_to_file {
    my ($file, $output) = @_;

    open my $out, '>:encoding(utf-8)', $file or die "Can't open $file for output : $!";
    print $out $output;
    close $out;
    return;
}
