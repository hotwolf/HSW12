#! /usr/bin/env perl
##################################################################################
#                                    HSW12                                       #
##################################################################################
# file:    hsw12asm_debug.pl                                                              #
# author:  Dirk Heisswolf                                                        #
# purpose: HSW12 Command Line Debug Script                                       #
##################################################################################
# Copyright (C) 2003-2009 by Dirk Heisswolf. All rights reserved.                #
# This file is part of "HSW12". HSW12 is free software;                          #
# you can redistribute it and/or modify it under the same terms as Perl itself.  #
##################################################################################
=pod
=head1 NAME

hsw12asm_debug.pl - Debug script for the HSW12 command line assembler

=head1 SYNOPSIS

 hsw12asm_debug.pl <src files> -L <library pathes> -D <defines: name=value or name>

=head1 REQUIRES

perl5.005, hsw12_asm, File::Basename, FindBin, Data::Dumper

=head1 DESCRIPTION

This script dumps all command line args to STDERR. The purpose of this script
is to help debug the execution of hsw12asm.pl. 

=head1 METHODS

=over 4

=item hsw12.pl <src files> -L <library pathes> -D <defines: name=value or name>

 Starts the HSW12 Assembler. 
 This script reads the following arguments:
     1. src files:      source code files(*.s)
     2. library pathes: directories to search for include files
     3. defines:        assembler defines

=back

=head1 AUTHOR

Dirk Heisswolf

=head1 VERSION HISTORY

=item V00.00 - Feb 14, 2013

 -S-Record files will be generated in the source directory

=cut

#################
# Perl settings #
#################
use 5.005;
#use warnings;
use File::Basename;
use FindBin qw($RealBin);
use lib $RealBin;
require hsw12_asm;

###############
# global vars #
###############
@src_files         = ();
@lib_files         = ();
%defines           = ();
$output_path       = ();
$prog_name         = "";
$arg_type          = "src";
$srec_format       = $hsw12_asm::srec_def_format;
$srec_data_length  = $hsw12_asm::srec_def_data_length;
$srec_add_s5       = $hsw12_asm::srec_def_add_s5;
$srec_word_entries = 1;
$symbols           = {};
$code              = {};

#########################
# Dump Perl information #
#########################
printf STDERR "Perl executable:          \"%s\"\n", $^X;
printf STDERR "Script name:              \"%s\"\n", $0;
printf STDERR "Command line arguments:   \"%d\"\n", ($#ARGV+1);

##############################
# Dump all command line args #
##############################
foreach $i (0..$#ARGV) {
    printf STDERR "Command line argument %2d: \"%s\"\n", $i, $ARGV[$i];
}

###############################
# Interpret command line args #
###############################
#printf "parsing args: count: %s\n", $#ARGV + 1;
foreach $arg (@ARGV) {
    #printf "  arg: %s\n", $arg;
    if ($arg =~ /^\s*\-L\s*$/i) {
	$arg_type = "lib";
    } elsif ($arg =~ /^\s*\-D\s*$/i) {
	$arg_type = "def";
    } elsif ($arg =~ /^\s*\-s19\s*$/i) {
	$srec_format = "S19";
	if ($srec_data_length > 32) {
	    $srec_data_length = 32;
	}
    } elsif ($arg =~ /^\s*\-s28\s*$/i) {
	$srec_format      = "S28";
    } elsif ($arg =~ /^\s*\-/) {
	#ignore
    } elsif ($arg_type eq "src") {
	#sourcs file
	push @src_files, $arg;
    } elsif ($arg_type eq "lib") {
	#library path
	if ($arg !~ /\/$/) {$arg = sprintf("%s%s", $arg, $hsw12_asm::path_del);}
	unshift @lib_files, $arg;
        $arg_type          = "src";
    } elsif ($arg_type eq "def") {
	#precompiler define
	if ($arg =~ /^\s*(\w+)=(\w+)\s*$/) {
	    $defines{uc($1)} = $2;
	} elsif ($arg =~ /^\s*(\w+)\s*$/) {
	    $defines{uc($1)} = "";
	}
        $arg_type          = "src";
    }
}
$prog_name        = basename($src_files[0], ".s");
$output_path      = dirname($src_files[0], ".s");
$symbol_file_name = sprintf("%s%s%s.sym", $output_path, $hsw12_asm::path_del, $prog_name);

###################
# add default lib #
###################
#printf "libraries:    %s (%s)\n",join(", ", @lib_files), $#lib_files;
#printf "source files: %s (%s)\n",join(", ", @src_files), $#src_files;
if ($#lib_files < 0) {
  foreach $src_file (@src_files) {
    #printf "add library:%s/\n", dirname($src_file);
    push @lib_files, sprintf("%s%s", dirname($src_file), $hsw12_asm::path_del);
  }
}
######################
# Dump configuration #
######################
printf STDERR "Program name:             \"%s\"\n", $prog_name;
printf STDERR "Output path:              \"%s\"\n", $output_path;
printf STDERR "Symbol file name:         \"%s\"\n", $symbol_file_name;
printf STDERR "Libraries:                \"%s\"\n", join(", ", @lib_files);
printf STDERR "Source files:             \"%s\"\n", join(", ", @src_files);

1;














