#! /bin/env perl
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

 srec_conv.pl <lin_s12|pag_s12|lin_s12x|pag_s12x>  <src file> 

=head1 REQUIRES

perl5.005, hsw12_srec_import, File::Basename, FindBin

=head1 DESCRIPTION

This script is a command line frontend to the HSW12 S-Record Importer.

=head1 METHODS

=over 4

=item srec_conv.pl <lin_s12|pag_s12|lin_s12x|pag_s12x>  <src file>

 Convers S-Records. 
 This script reads the following arguments:
     1. format:         S-Record input format
     2. src file:       S-Record input file

=back

=head1 AUTHOR

Dirk Heisswolf

=head1 VERSION HISTORY

=item V00.00 - Aug 19, 2004

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
require hsw12_srec_import;

###############
# global vars #
###############
if ($#ARGV != 1) {
    printf "usage: %s <%s|%s|%s|%s> <src file>\n", $0, $hsw12_srec_import::srec_type_lin_s12,
                                                       $hsw12_srec_import::srec_type_pag_s12,
						       $hsw12_srec_import::srec_type_lin_s12x,
						       $hsw12_srec_import::srec_type_pag_s12x;
    print  "\n";
    exit;
}
    
$srec_type        = shift @ARGV;
$src_file         = shift @ARGV;

if (($srec_type ne $hsw12_srec_import::srec_type_lin_s12)  &&
    ($srec_type ne $hsw12_srec_import::srec_type_pag_s12)  &&
    ($srec_type ne $hsw12_srec_import::srec_type_lin_s12x) &&
    ($srec_type ne $hsw12_srec_import::srec_type_pag_s12x)) {

    printf STDOUT "Unkown S-Record format: \"%s\"\n", $srec_type;
    printf STDOUT "Try one of the following: %s, %s, %s, %s\n", ($hsw12_srec_import::srec_type_lin_s12,
								 $hsw12_srec_import::srec_type_pag_s12,
								 $hsw12_srec_import::srec_type_lin_s12x,
								 $hsw12_srec_import::srec_type_pag_s12x);
    exit;
}

printf STDOUT "Reading: %s \"%s\"\n", $src_file, $srec_type;

###################
# Import S-Record #
###################
$code = hsw12_srec_import->new($src_file, $srec_type);


###################
# write list file #
###################
if (open (FILEHANDLE, sprintf(">%s.lst", $src_file))) {
    $out_string = $code->print_listing();
    print FILEHANDLE $out_string;
    print STDOUT     $out_string;
    close FILEHANDLE;
} else {
    printf STDERR "Can't open list file \"%s.lst\"\n", $src_file;
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
    if (open (FILEHANDLE, sprintf(">%s_lin.%s\n", $prog_name, lc($srec_format)))) {
	$out_string = $code->print_lin_srec(uc($prog_name),
					    $srec_format,
					    $srec_data_length,
					    $srec_add_s5,
					    $srec_word_entries);
	print FILEHANDLE $out_string;
	close FILEHANDLE;
    } else {
	printf STDERR "Can't open S-recordfile \"%s_lin.%s\"\n", $prog_name, lc($srec_format);
	exit;
    }

    ########################
    # write paged S-record #
    ########################
    if (open (FILEHANDLE, sprintf(">%s_pag.%s\n", $prog_name, lc($srec_format)))) {
	$out_string = $code->print_pag_srec(uc($prog_name),
					    $srec_format,
					    $srec_data_length,
					    $srec_add_s5,
					    $srec_word_entries);
	print FILEHANDLE $out_string;
	close FILEHANDLE;
    } else {
	printf STDERR "Can't open S-recordfile \"%s_pag.%s\"\n", $prog_name, lc($srec_format);
	exit;
    }
}















