#! /usr/bin/env perl
##################################################################################
#                                    HSW12                                       #
##################################################################################
# file:    symbols_and_macros.pl                                                 #
# author:  Dirk Heisswolf                                                        #
# purpose: Symbol list and macro dumper                                          #
##################################################################################
# Copyright (C) 2003-2009 by Dirk Heisswolf. All rights reserved.                #
# This file is part of "HSW12". HSW12 is free software;                          #
# you can redistribute it and/or modify it under the same terms as Perl itself.  #
##################################################################################
=pod
=head1 NAME

symbols_and_macros.pl - Symbol list and macro dumper

=head1 SYNOPSIS

 symbols_and_macros.pl <src files> -L <library pathes> -D <defines: name=value or name>

=head1 REQUIRES

perl5.005, hsw12_asm, File::Basename, FindBin, Data::Dumper

=head1 DESCRIPTION

This script is a command line frontend to the HSW12 Assembler.

=head1 METHODS

=over 4

=item symbols_and_macros.pl <src files> -L <library pathes> -D <defines: name=value or name>

 Starts the HSW12 Assembler. 
 This script reads the following arguments:
     1. src files:      source code files(*.s)
     2. library pathes: directories to search for include files
     3. defines:        assembler defines

=back

=head1 AUTHOR

Dirk Heisswolf

=head1 VERSION HISTORY

=item V00.00 - Aug 25, 2014

 initial release

=cut

#################
# Perl settings #
#################
use 5.005;
#use warnings;
use File::Basename;
use FindBin qw($RealBin);
use Data::Dumper;
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

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
@months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
@days   = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");

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

###################
# print help text #
###################
if ($#src_files < 0) {
    printf "usage: %s [-L <library path>] [-D <define: name=value or name>] <src files> \n", $0;
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
#printf "libraries:    %s (%s)\n",join(", ", @lib_files), $#lib_files;
#printf "source files: %s (%s)\n",join(", ", @src_files), $#src_files;
if ($#lib_files < 0) {
  foreach $src_file (@src_files) {
    #printf "add library:%s/\n", dirname($src_file);
    push @lib_files, sprintf("%s%s", dirname($src_file), $hsw12_asm::path_del);
  }
}

####################
# load symbol file #
####################
$symbol_file_name = sprintf("%s%s%s.sym", $output_path, $hsw12_asm::path_del, $prog_name);
#printf STDERR "Loading: %s\n",  $symbol_file_name;
if (open (FILEHANDLE, sprintf("<%s", $symbol_file_name))) {
    $data = join "", <FILEHANDLE>;
    eval $data;
    close FILEHANDLE;
}
#printf STDERR $data;
#printf STDERR "Importing %s\n",  join(",\n", keys %{$symbols});
#exit;

#######################
# compile source code #
#######################
#printf STDERR "src files: \"%s\"\n", join("\", \"", @src_files);  
#printf STDERR "lib files: \"%s\"\n", join("\", \"", @lib_files);  
#printf STDERR "defines:   \"%s\"\n", join("\", \"", @defines);  
$code = hsw12_asm->new(\@src_files, \@lib_files, \%defines, "S12", 1, $symbols);

#####################
# check code status #
#####################
if ($code->{problems}) {
    printf STDERR "Problem summary: %s\n", $code->{problems};
} else {

    #####################
    # write symbol file #
    #####################
    if (open (FILEHANDLE, sprintf("+>%s", $symbol_file_name))) {
	$dump = Data::Dumper->new([$code->{comp_symbols}], ['symbols']);
	$dump->Indent(2);
	print FILEHANDLE $dump->Dump;
 	close FILEHANDLE;
    } else {
	printf STDERR "Can't open symbol file \"%s\"\n", $symbol_file_name;
	exit;
    }

    #########################
    # write linear S-record #
    #########################
    $symbol_file_name = sprintf("%s%s%s_sym.s", $output_path, $hsw12_asm::path_del, $prog_name);
    if (open (FILEHANDLE, sprintf("+>%s", $symbol_file_name))) {
	#Print header
	#------------ 
	printf FILEHANDLE ";###############################################################################\n"; 
	printf FILEHANDLE ";# %-75s #\n", sprintf("%s - Symbols and Macros", $prog_name);
	printf FILEHANDLE ";###############################################################################\n";
	printf FILEHANDLE ";#    Copyright 2009-2014 Dirk Heisswolf                                       #\n";
	printf FILEHANDLE ";#    This file is has been generated by the HSW12 assembler tool chain.       #\n";
	printf FILEHANDLE ";#                                                                             #\n";
	printf FILEHANDLE ";#    It is free software: you can redistribute it and/or modify               #\n";
	printf FILEHANDLE ";#    it under the terms of the GNU General Public License as published by     #\n";
	printf FILEHANDLE ";#    the Free Software Foundation, either version 3 of the License, or        #\n";
	printf FILEHANDLE ";#    (at your option) any later version.                                      #\n";
	printf FILEHANDLE ";#                                                                             #\n";
	printf FILEHANDLE ";#    This code is distributed in the hope that it will be useful,             #\n";
	printf FILEHANDLE ";#    but WITHOUT ANY WARRANTY; without even the implied warranty of           #\n";
	printf FILEHANDLE ";#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #\n";
	printf FILEHANDLE ";#    GNU General Public License for more details.                             #\n";
	printf FILEHANDLE ";#                                                                             #\n";
	printf FILEHANDLE ";#    You should have received a copy of the GNU General Public License        #\n";
	printf FILEHANDLE ";#    along with S12CForth.  If not, see <http://www.gnu.org/licenses/>.       #\n";
	printf FILEHANDLE ";###############################################################################\n";
	printf FILEHANDLE ";# Description:                                                                #\n";
	printf FILEHANDLE ";#    This file contains symboland macro definitions of the                    #\n";
	printf FILEHANDLE ";#    %-71s #\n", sprintf("%s software.", $prog_name);
	printf FILEHANDLE ";#                                                                             #\n";
	printf FILEHANDLE ";###############################################################################\n";
	printf FILEHANDLE ";# Generated on %3s, %3s %.2d %4d                                               #\n", $days[$wday], $months[$mon], $mday, $year;
	printf FILEHANDLE ";###############################################################################\n";
	printf FILEHANDLE "\n";
	printf FILEHANDLE ";###############################################################################\n";
	printf FILEHANDLE ";# Symbol definitions                                                          #\n";
	printf FILEHANDLE ";###############################################################################\n";
	foreach $key (sort keys %{$code->{comp_symbols}}) {
	    if ($code->{comp_symbols}->{$key} > 0xffffff) {
		printf FILEHANDLE "%-24s EQU %12s\n", $key, sprintf("\$%.4X_%.4X", $code->{comp_symbols}->{$key}>>16, 
								                   $code->{comp_symbols}->{$key}&0xffff);
	    } elsif ($code->{comp_symbols}->{$key} > 0xffff) {
		printf FILEHANDLE "%-24s EQU %12s\n", $key, sprintf("\$%.2X_%.4X", $code->{comp_symbols}->{$key}>>16, 
								                   $code->{comp_symbols}->{$key}&0xffff);
	    } elsif ($code->{comp_symbols}->{$key} > 0xff) {
		printf FILEHANDLE "%-24s EQU %12s\n", $key, sprintf("\$%.4X", $code->{comp_symbols}->{$key});
	    } else {
		printf FILEHANDLE "%-24s EQU %12s\n", $key, sprintf("\$%.2X", $code->{comp_symbols}->{$key});
	    }
	}
	printf FILEHANDLE "\n";
	printf FILEHANDLE ";###############################################################################\n";
	printf FILEHANDLE ";# Macro definitions                                                           #\n";
	printf FILEHANDLE ";###############################################################################\n";
	foreach $macro (sort keys %{$code->{macros}}) {
	    printf FILEHANDLE "#macro %s, %d\n", $macro, $code->{macro_argcs}->{$macro};
	    #printf FILEHANDLE "count: %d\n", $#{$code->{macros}->{$macro}}+1;
	    foreach $code_entry (@{$code->{macros}->{$macro}}) {
		foreach $line (@{$code_entry->[2]}) {
		    #Remove comments 
		    $line =~ s/^\*.*$//;
		    $line =~ s/;.*$//;
		    #Remove trailing whitespace 
		    $line =~ s/\s*$//;
		    #Print non-empty lines
		    if ($line !~ /^\s*$/) {
			printf FILEHANDLE "%s\n", $line;
		    }
		}
	    }
	    printf FILEHANDLE "#emac\n\n";
	}
	close FILEHANDLE;
    } else {
	printf STDERR "Can't open symbol file \"%s\"\n", $symbol_file_name;
	exit;
    }
}
