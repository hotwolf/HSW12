#! /usr/bin/env perl
##################################################################################
#                                    HSW12                                       #
##################################################################################
# file:    hsw12asm.pl                                                           #
# author:  Dirk Heisswolf                                                        #
# purpose: HSW12 Command Line Assembler                                          #
##################################################################################
# Copyright (C) 2003-2009 by Dirk Heisswolf. All rights reserved.                #
# This file is part of "HSW12". HSW12 is free software;                          #
# you can redistribute it and/or modify it under the same terms as Perl itself.  #
##################################################################################
=pod
=head1 NAME

hsw12asm.pl - HSW12 Command Line Assembler

=head1 SYNOPSIS

 hsw12asm.pl <src files> -L <library pathes> -D <defines: name=value or name>

=head1 REQUIRES

perl5.005, hsw12_asm, File::Basename, FindBin

=head1 DESCRIPTION

This script is a command line frontend to the HSW12 Assembler.

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

=item V00.00 - Feb 9, 2003

 initial release

=item V00.01 - Apr 2, 2003

 -added "-s28" and "-s19" command line options

=item V00.02 - Apr 29, 2003

 -making use of the new "verbose mode"

=item V00.03 - Sep 21, 2009

 -made script more platipus friendly

=item V00.04 -Jun 8, 2010

 -truncate all output files

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
$code              = {};

##########################
# read command line args #
##########################
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
	if ($arg !~ /\/$/) {$arg = sprintf("%s/", $arg);}
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

###################
# print help text #
###################
if ($#src_files < 0) {
    printf "usage: %s [-s19|-s28] [-L <library path>] [-D <define: name=value or name>] <src files> \n", $0;
    print  "\n";
    exit;
}

#######################################
# determine program name and location #
#######################################
$prog_name   = basename($src_files[0], ".s");
$output_path = dirname($src_files[0], ".s");

###################
# add default lib #
###################
#printf "libraries:    %s (%s)\n",join("\", \"", @lib_files), $#lib_files;
#printf "source files: %s (%s)\n",join("\", \"", @src_files), $#src_files;
if ($#lib_files < 0) {
  foreach $src_file (@src_files) {
    #printf "add library:%s/\n", dirname($src_file);
    push @lib_files, sprintf("%s/", dirname($src_file));
  }
}

#######################
# compile source code #
#######################
#printf STDERR "src files: \"%s\"\n", join("\", \"", @src_files);  
#printf STDERR "lib files: \"%s\"\n", join("\", \"", @lib_files);  
#printf STDERR "defines:   \"%s\"\n", join("\", \"", @defines);  
$code = hsw12_asm->new(\@src_files, \@lib_files, \%defines, "S12", 1);

###################
# write list file #
###################
$list_file_name = sprintf("%s/%s.lst", $output_path, $prog_name);
if (open (FILEHANDLE, sprintf("+>%s", $list_file_name))) {
    $out_string = $code->print_listing();
    print FILEHANDLE $out_string;
    #print STDOUT     $out_string;
    #printf "output: %s\n", $list_file_name;
    close FILEHANDLE;
} else {
    printf STDERR "Can't open list file \"%s\"\n", $list_file_name;
    exit;
}

#####################
# check code status #
#####################
if ($code->{problems}) {
    printf STDERR "Problem summary: %s\n", $code->{problems};
} else {

    #########################
    # write linear S-record #
    #########################
    $lin_srec_file_name = sprintf("%s_lin.%s", $prog_name, lc($srec_format));
    if (open (FILEHANDLE, sprintf("+>%s", $lin_srec_file_name))) {
	$out_string = $code->print_lin_srec(uc($prog_name),
					    $srec_format,
					    $srec_data_length,
					    $srec_add_s5,
					    $srec_word_entries);
	print FILEHANDLE $out_string;
	close FILEHANDLE;
    } else {
	printf STDERR "Can't open S-recordfile \"%s\"\n", $lin_srec_file_name;
	exit;
    }

    ########################
    # write paged S-record #
    ########################
    $pag_srec_file_name = sprintf("%s_pag.%s", $prog_name, lc($srec_format));
    if (open (FILEHANDLE, sprintf("+>%s", $pag_srec_file_name))) {
	$out_string = $code->print_pag_srec(uc($prog_name),
					    $srec_format,
					    $srec_data_length,
					    $srec_add_s5,
					    $srec_word_entries);
	print FILEHANDLE $out_string;
	close FILEHANDLE;
    } else {
	printf STDERR "Can't open S-recordfile \"%s\"\n", $pag_srec_file_name;
	exit;
    }
}















