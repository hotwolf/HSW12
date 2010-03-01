#! /usr/bin/env perl
##################################################################################
#                                    HSW12                                       #
##################################################################################
# file:    asm_bdmpod_drv.pl                                                     #
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

 asm_bdmpod_drv.pl firmware_code driver_code

=head1 REQUIRES

perl5.005, hsw12_asm, File::Basename, FindBin

=head1 DESCRIPTION

This script is a command line frontend to the HSW12 Assembler.

=head1 METHODS

=over 4

=item hsw12asm_bdmpod.pl <src files> -L <library pathes> -D <defines: name=value or name>

 Starts the HSW12 Assembler. 
 This script reads the following arguments:
     1. src files:      source code files(*.s)
     2. library pathes: directories to search for include files
     3. defines:        assembler defines

=back

=head1 AUTHOR

Dirk Heisswolf

=head1 VERSION HISTORY

=item V00.00 - Mar 23, 2006

 initial release

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
$prog_name         = "";
$arg_type          = "src";
$srec_format       = $hsw12_asm::srec_def_format;
$srec_data_length  = $hsw12_asm::srec_def_data_length;
$srec_add_s5       = $hsw12_asm::srec_def_add_s5;
$srec_word_entries = 1;
$code              = {};
$out_string        = "";
$start_symbol      = "";
$start_addr        = 0;
$end_symbol        = "";
$end_addr          = 0;

##########################
# read command line args #
##########################
foreach $arg (@ARGV) {
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
    } elsif ($arg_type eq "def") {
	#precompiler define
	if ($arg =~ /^\s*(\w+)=(\w+)\s*$/) {
	    $defines{uc($1)} = $2;
	} elsif ($arg =~ /^\s*(\w+)\s*$/) {
	    $defines{uc($1)} = "";
	}
    }
}

###################
# print help text #
###################
if ($#src_files < 0) {
    printf "usage: %s <src files> [-s19|-s28] [-L <library pathes>] [-D <defines: name=value or name>]\n", $0;
    print  "\n";
    exit;
}

##########################
# determine program name #
##########################
$prog_name = basename($src_files[0], ".s");

###################
# add default lib #
###################
if ($#lib_files < 0) {
    push @lib_files, sprintf("%s/", dirname($src_files[0]));
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
if (open (FILEHANDLE, sprintf(">%s.lst", $prog_name))) {
    $out_string = $code->print_listing();
    print FILEHANDLE $out_string;
    #print STDOUT     $out_string;
    close FILEHANDLE;
} else {
    printf STDERR "Can't open list file \"%s.lst\"\n", $prog_name;
    exit;
}

#####################
# check code status #
#####################
if ($code->{problems}) {
    printf STDERR "Problem summary: %s\n", $code->{problems};
} else {


    ########################
    # determine dump range #
    ########################
    if (exists $code->{comp_symbols}->{uc($start_symbol)}) {
    	$start_addr = $code->{comp_symbols}->{uc($start_symbol)};
    	printf STDERR "...Start address (%s): %4X\n", uc($start_symbol), $start_addr;
    } else {
    	printf STDERR "   =>Start address \"%s\" undefined\n", uc($start_symbol);
    	exit;
    }
    if (exists $code->{comp_symbols}->{uc($end_symbol)}) {
    	$start_addr = $code->{comp_symbols}->{uc($end_symbol)};
    	printf STDERR "   ...End address (%s): %4X\n", uc($end_symbol), $end_addr;
    } else {
    	printf STDERR "   =>End address \"%s\" undefined\n", uc($end_symbol);
    	exit;
    }
    
    ##################
    # write bin file #
    ##################
    if (open (FILEHANDLE, sprintf(">%s_drv.bin", $prog_name))) {
    	printf STDOUT "...Dumping driver binary \"%s_drv.bin\"\n", $prog_name;
    	$out_string = $code->print_pag_binary($start_addr, $end_addr);
    	print FILEHANDLE $out_string;
    	#print STDOUT     $out_string;
    	close FILEHANDLE;
    } else {
    	printf STDERR "Can't open list file \"%s_drv.bin\"\n", $prog_name;
    	exit;
    }

    #########################
    # write linear S-record #
    #########################
    if (open (FILEHANDLE, sprintf(">%s_fw.%s\n", $prog_name, lc($srec_format)))) {
	printf STDOUT "...Dumping firmware S-record \"%s_fw.%s\"\n", $prog_name, lc($srec_format);
	$out_string = $code->print_lin_srec(uc($prog_name),
					    $srec_format,
					    $srec_data_length,
					    $srec_add_s5,
					    $srec_word_entries);
	print FILEHANDLE $out_string;
	close FILEHANDLE;
    } else {
	printf STDERR "Can't open S-recordfile \"%s_fw.%s\"\n", $prog_name, lc(srec_format);
	exit;
    }
}
