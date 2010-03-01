#! /usr/bin/env perl
##################################################################################
#                            HCS12 S-RECORD IMPORTER                             #
##################################################################################
# file:    hsw12_srec_import.pm                                                  #
# author:  Dirk Heisswolf                                                        #
# purpose: This is the core of the HSW12 AssemblerS-Record Importer              #
##################################################################################
# Copyright (C) 2003-2009 by Dirk Heisswolf. All rights reserved.                #
# This file is part of "HSW12". HSW12 is free software;                          #
# you can redistribute it and/or modify it under the same terms as Perl itself.  #
##################################################################################
=pod
=head1 NAME

hsw12_srec_import - HCS12 S-Record Importer

=head1 SYNOPSIS

 require hsw12_srec_import

 $srec = hsw12_srec_import->new($source_file, $srec_type, $verbose);
 print FILEHANDLE $srec->print_listing();
 print FILEHANDLE $srec->print_lin_srec($string, $srec_format, $srec_length, $s5, $fill_bytes);
 print FILEHANDLE $srec->print_pag_srec($string, $srec_format, $srec_length, $s5, $fill_bytes);

=head1 REQUIRES

perl5.005, File::Basename, FindBin, Text::Tabs

=head1 DESCRIPTION

This module provides subroutines to...

=over 4

 - import a linear or paged S-Record file
 - create code lisings
 - create linear and paged S-Records

=back

=head1 METHODS

=head2 Creation

=over 4

=item hsw12_srec_import->new($file_name, $srec_type)

 Creates and returns an hsw12_asm object. 
 This method requires three arguments:
     1. $source_file:   name of the S-Record file (string)
     2. $srecord_type:  S-record type: "lin", "pag" (string)
     3. $verbose:       switch to enable progress messages (boolean)

=back

=head2 Outputs

=over 4

=item $asm_object->print_listing()

 Returns an assembler type code listing (string). 

=item $asm_object->print_lin_srec($string, 
				  $srec_format,
				  $srec_length,
				  $s5,
				  $fill_bytes)

 Returns a linear S-Record of the imported hex code (string). 
 This method requires five arguments:
     1. $string: S0 header                             (string)
     2. $srec_format: address format: S19, S28, or S37 (string)
     3. $srec_length: nuber of data bytes in S-Record  (integer)
     4. $fill_bytes:  add fill bytes                   (boolean)

=item $asm_object->print_pag_srec($string, 
				  $srec_format,
				  $srec_length,
				  $s5,
				  $fill_bytes)

 Returns a paged S-Record of the imported hex code (string). 
 This method requires five arguments:
     1. $string: S0 header                             (string)
     2. $srec_format: address format: S19, S28, or S37 (string)
     3. $srec_length: nuber of data bytes in S-Record  (integer)
     4. $fill_bytes:  add fill bytes                   (boolean)


=back

=head2 Misc

=over 4

=item $asm_object->reload(boolean)
 This method requires one argument:
     1. $verbose:  switch to enable progress messages (boolean)

 Reloads the S-Record file. 

=item $asm_object->$evaluate_expression($expr, $pc_lin, $pc_pag, $loc)

 Converts an expression into an integer and resolves compiler symbols. 
 This method requires four arguments:
     1. $expr:   expression (string)
     2. $pc_lin: current linear program counter (integer)
     3. $pc_pag: current paged program counter (integer)
     4. $loc:    current "LOC" count (integer)

=back

=head1 AUTHOR

Dirk Heisswolf

=head1 VERSION HISTORY

=item V00.00 - Jun 4, 2003

 initial release

=item V00.01 - Dec 9, 2003

 -added HCS12X S-Record import feature

=cut


#################
# Perl settings #
#################
#use warnings;
#use strict;
require hsw12_asm;

####################
# create namespace #
####################
package hsw12_srec_import;

###########
# modules #
###########
use IO::File;
use Fcntl;
#use Text::Tabs;

####################
# global variables #
####################
#$source_file   (string)
#$srec_type     (string)
#$problems      (boolean)
#@code          (array)
#%lin_addrspace (hash)
#%pag_addrspace (hash)
#%verbose       (boolean)

#############
# constants #
#############
###########
# version #
###########
*version = \"00.01";#"

#############################
# default S-record settings #
#############################
*srec_def_format      = \"S28";#" 
*srec_def_data_length = \64;
*srec_def_add_s5      = \0;
*srec_def_fill_byte   = \0xff;

###################
# path delimeters #
###################
*path_del         = \qr/[\/\\]/;
*path_absolute    = \qr/^\.?[\/\\]/;

#######################
# operand expressions #
#######################
*op                    = \qr/(?:[^,]|\\,)+/ix;
*op_opt                = \qr/(?:[^,]|\\,)*/ix;
*del                   = \qr/\s*(?<!\\),\s*/ix;
*op_keywords           = \qr/^\s*(A|B|D|X|Y|PC|SP|CCR|TMP2|TMP3|UNMAPPED)\s*$/i; #$1: keyword
*op_unmapped           = \qr/^\s*UNMAPPED\s*$/i;
*op_oprtr              = \qr/\-|\+|\*|\/|%|&|\||~|<<|>>/;
*op_no_oprtr           = \qr/[^\-\+\/%&\|~<>\s]/;
*op_term               = \qr/\%[01]+|[0-9]+|\$[0-9a-fA-F]+|\"(\w)\"|\*|\@/;
*op_binery             = \qr/^\s*([~\-]?)\s*\%([01_]+)\s*$/; #$1:complement $2:binery number
*op_dec                = \qr/^\s*([~\-]?)\s*([0-9_]+)\s*$/; #$1:complement $2:decimal number
*op_hex                = \qr/^\s*([~\-]?)\s*\$([0-9a-fA-F_]+)\s*$/; #$1:complement $2:hex number
*op_ascii              = \qr/^\s*([~\-]?)\s*[\'\"](.+)[\'\"]\s*$/; #$1:complement $2:ASCII caracter
#*op_symbol             = \qr/^\s*([~\-]?)\s*([\w]+[\`]?)\s*$/; #$1:complement $2:symbol
#*op_curr_lin_pc        = \qr/^\s*([~\-]?)\s*\@\s*$/;
#*op_curr_pag_pc        = \qr/^\s*([~\-]?)\s*\*\s*$/;
*op_formula            = \qr/^\s*($op)\s*$/; #$1:formula
*op_formula_pars       = \qr/^\s*(.*)\s*\(\s*([^\(\)]+)\s*\)\s*(.*)\s*$/; #$1:leftside $2:inside $3:rightside 
*op_formula_and        = \qr/^\s*([^\&]*)\s*\&\s*(.+)\s*$/; #$1:leftside $2:rightside 
*op_formula_or         = \qr/^\s*([^\|]*)\s*\|\s*(.+)\s*$/; #$1:leftside $2:rightside 
*op_formula_exor       = \qr/^\s*([^\^]*)\s*\^\s*(.+)\s*$/; #$1:leftside $2:rightside 
*op_formula_rightshift = \qr/^\s*([^>]*)\s*>>\s*(.+)\s*$/; #$1:leftside $2:rightside 
*op_formula_leftshift  = \qr/^\s*([^<]*)\s*<<\s*(.+)\s*$/; #$1:leftside $2:rightside 
*op_formula_mul        = \qr/^\s*(.*$op_no_oprtr)\s*\*\s*(.+)\s*$/; #$1:leftside $2:rightside 
*op_formula_div        = \qr/^\s*([^\/]*)\s*\/\s*(.+)\s*$/; #$1:leftside $2:rightside 
*op_formula_mod        = \qr/^\s*(.*$op_no_oprtr)\s*\%\s*(.*)\s*$/; #$1:leftside $2:rightside 
*op_formula_plus       = \qr/^\s*([^\+]*)\s*\+\s*(.+)\s*$/; #$1:leftside $2:rightside 
*op_formula_minus      = \qr/^\s*(.*$op_no_oprtr)\s*\-\s*(.+)\s*$/; #$1:leftside $2:rightside 
*op_whitespace         = \qr/^\s*$/; 

##################
# S-Record types #
##################
*srec_type_lin_s12     = \"lin_s12";#"
*srec_type_pag_s12     = \"pag_s12";#"
*srec_type_lin_s12x    = \"lin_s12x";#"
*srec_type_pag_s12x    = \"pag_s12x";#"

####################
# S-Record formats #
####################
*srec_format_nothing  = \qr/^\s*$/; 
*srec_format_S0       = \qr/^\s*([Ss]0)([0-9a-fA-F]{2})([0-9a-fA-F]{4})([0-9a-fA-F]*)([0-9a-fA-F]{2})\s*$/; #$1:type $2:count $3:address $4:data $5:checksum
*srec_format_S1       = \qr/^\s*([Ss]1)([0-9a-fA-F]{2})([0-9a-fA-F]{4})([0-9a-fA-F]*)([0-9a-fA-F]{2})\s*$/; #$1:type $2:count $3:address $4:data $5:checksum
*srec_format_S2       = \qr/^\s*([Ss]2)([0-9a-fA-F]{2})([0-9a-fA-F]{6})([0-9a-fA-F]*)([0-9a-fA-F]{2})\s*$/; #$1:type $2:count $3:address $4:data $5:checksum 
*srec_format_S3       = \qr/^\s*([Ss]3)([0-9a-fA-F]{2})([0-9a-fA-F]{8})([0-9a-fA-F]*)([0-9a-fA-F]{2})\s*$/; #$1:type $2:count $3:address $4:data $5:checksum 
*srec_format_S5       = \qr/^\s*([Ss]5)([0-9a-fA-F]{2})([0-9a-fA-F]{4})([0-9a-fA-F]*)([0-9a-fA-F]{2})\s*$/; #$1:type $2:count $3:address $4:data $5:checksum
*srec_format_S7       = \qr/^\s*([Ss]7)([0-9a-fA-F]{2})([0-9a-fA-F]{8})([0-9a-fA-F]*)([0-9a-fA-F]{2})\s*$/; #$1:type $2:count $3:address $4:data $5:checksum
*srec_format_S8       = \qr/^\s*([Ss]8)([0-9a-fA-F]{2})([0-9a-fA-F]{6})([0-9a-fA-F]*)([0-9a-fA-F]{2})\s*$/; #$1:type $2:count $3:address $4:data $5:checksum
*srec_format_S9       = \qr/^\s*([Ss]9)([0-9a-fA-F]{2})([0-9a-fA-F]{4})([0-9a-fA-F]*)([0-9a-fA-F]{2})\s*$/; #$1:type $2:count $3:address $4:data $5:checksum

########################
# compiler expressions #
########################
*cmp_no_hexcode        = \qr/^\s*(.*?[^0-9a-fA-F\ ].*?)\s*$/; #$1:string

###############
# constructor #
###############
sub new {
    my $proto            = shift @_;
    my $class            = ref($proto) || $proto;
    my $source_file      = shift @_;
    my $srec_type        = shift @_;
    my $verbose          = shift @_;
    my $self = {};

    #initalize global variables
    $self->{source_files} = [$source_file];
    $self->{srec_type}    = $srec_type;
    $self->{verbose}      = $verbose;
   
    #reset remaining global variables
    $self->{problems}         = "no code";
    $self->{code}             = [];
    $self->{lin_addrspace}    = {};
    $self->{pag_addrspace}    = {};

    #instantiate object
    bless $self, $class;

    #printf STDERR "source_file: %s\n", $source_file;
    #printf STDERR "srec_type: %s\n",   $srec_type;
    #printf STDERR "verbose: %s\n",     $verbose;

    #compile code
    if ($self->import_srec($source_file, $srec_type)) {
	$self->{problems} = "Invalid S-Record file";
    } else {
	############################
	# determine address spaces #
	############################
	$self->determine_addrspaces();
	$self->{problems} = 0;
    }

    return $self;
}

##############
# destructor #
##############
#sub DESTROY {
#    my $self = shift @_;
#}

##########
# reload #
##########
sub reload {
    my $self         = shift @_;
    my $verbose      = shift @_;

    #reset global variables
    $self->{problems}         = "no code";
    $self->{code}             = [];
    $self->{lin_addrspace}    = {};
    $self->{pag_addrspace}    = {};
    if (defined $verbose) {
	$self->{verbose}      = $verbose;
    }

    #compile code
    if ($self->import_srec($source_file, $srec_type)) {
	$self->{problems} = "Invalid S-Record file";
    } else {
	############################
	# determine address spaces #
	############################
	$self->determine_addrspaces();
	$self->{problems} = 0
    }
}

###############
# import_srec #
###############
sub import_srec {
    my $self         = shift @_;
    my $source_file  = shift @_;
    my $srec_type    = shift @_;
     #file
    my $file_handle;
    #errors
    my $error;
    my $error_count;
    #line
    my $line;
    my $line_count;
    my $srec_count;
    my $type;
    my $length;
    my $address;    
    my $data;
    my $checksum;
    my $pc_lin;
    my $pc_pag;
    #data
    my $data_count;
    my $data_string;
    #source code
    my @srccode_sequence;
    #temporary
    my $match;
    my $value;

    ######################
    # clear program data #
    ######################
    $self->{problems}         = "no code";
    $self->{code}             = [];
    $self->{lin_addrspace}    = {};
    $self->{pag_addrspace}    = {};

    #############
    # open file #
    #############
    $error = 0;
    if (-e $source_file) {
	if (-r $source_file) {
	    if ($file_handle = IO::File->new($source_file, O_RDONLY)) {
	    } else {
		$error = sprintf("unable to open file \"%s\" (%s)", $source_file, $!);
		print "$error\n";
	    }
	} else {
	    $error = sprintf("file \"%s\" is not readable", $source_file);
	    print "$error\n";
	}
    } else {
	$error = sprintf("file \"%s\" does not exist", $source_file);
	print "$error\n";
    }
    #################
    # quit on error #
    #################
    if ($error) {
	#store error message
	push @{$self->{code}}, [undef,         #line count
				\$source_file, #file name
				[],            #code sequence
				"",            #label
				"",            #opcode
				"",            #arguments
				undef,         #linear pc
				undef,         #paged pc
				undef,         #hex code
				undef,         #bytes
				undef,         #cycles
				[$error]];     #errors
	return 1;
    }


    #reset variables
    $error            = 0;
    $error_count      = 0;
    $line_count       = 0;
    $srec_count       = 0;
    @srccode_sequence = ();

    #############
    # line loop #
    #############
    while ($line = <$file_handle>) {
	#trim line
	chomp $line;
	$line =~ s/\s*$//;
	$line =~ s/^\s*//;
	
	#increment line count
	$line_count++;	
	#printf STDERR "%3d: %s\n", $line_count, $line;

	##############
	# parse line #
	##############
	for ($line) {
	    ###########
	    # nothing #
	    ###########
	    /$srec_format_nothing/ && do {

		print STDERR "Empty!\n";

	    last;};
	    #############
	    # S0-Record #
	    #############
	    /$srec_format_S0/ && do {
		$type     = $1;
		$length   = $2;
		$address  = $3;
		$data     = $4;
		$checksum = $5;

		#printf STDERR "type:     %s (S0)\n", $type;
		#printf STDERR "lenth:    %s (%d)\n", $length, hex($length);
		#printf STDERR "address:  %s\n",      $address;
		#printf STDERR "data:     %s\n",      $data;
		#printf STDERR "checksum: %s\n",      $checksum;

		$error = $self->check_srec(2,
					   $length,
					   $address,
					   $data,
					   $checksum);

		if (!$error) {
		    push @srccode_sequence, $self->print_S0_data($data);
		} else {
		    #invalid S-Record
		    #store S-Record
		    push @srccode_sequence, $line;
		    #store error message
		    push @{$self->{code}}, [$line_count,         #line count
					    \$source_file,       #file name
					    [@srccode_sequence], #code sequence
					    "",                  #label
					    "S0",                #opcode
					    "",                  #arguments
					    undef,               #linear pc
					    undef,               #paged pc
					    undef,               #hex code
					    undef,               #bytes
					    undef,               #cycles
					    [$error]];           #errors
		    $error_count++;
		    @srccode_sequence = ();
		}	    
		last;};
	    #############
	    # S1-Record #
	    #############
	    /$srec_format_S1/ && do {
		$type     = $1;
		$length   = $2;
		$address  = $3;
		$data     = $4;
		$checksum = $5;
    
		#printf STDERR "type:     %s (S1)\n", $type;
		#printf STDERR "lenth:    %s (%d)\n", $length, hex($length);
		#printf STDERR "address:  %s\n",      $address;
		#printf STDERR "data:     %s\n",      $data;
		#printf STDERR "checksum: %s\n",      $checksum;

		$error = $self->check_srec(2,
					   $length,
					   $address,
					   $data,
					   $checksum);
		($pc_lin, $pc_pag)          = $self->determine_pc($address, $srec_type); 
		($data_count, $data_string) = $self->format_S123_data($data);
		push @srccode_sequence, sprintf("S1-Record: \$%.4X - \$%.4X (%d bytes)", (hex($address),
											  (hex($address) + $data_count - 1),
											  $data_count));
		#push @srccode_sequence, "srec_count = $srec_count";

		if (!$error) {
		    #store data
		    push @{$self->{code}}, [$line_count,         #line count
					    \$source_file,       #file name
					    [@srccode_sequence], #code sequence
					    "",                  #label
					    "S1",                #opcode
					    "",                  #arguments
					    $pc_lin,             #linear pc
					    $pc_pag,             #paged pc
					    $data_string,        #hex code
					    $data_count,         #bytes
					    undef,               #cycles
					    []];                 #errors
		    $srec_count++;
		    @srccode_sequence = ();
		} else {
		    #invalid S-Record
		    #store S-Record
		    push @srccode_sequence, $line;
		    #store error message
		    push @{$self->{code}}, [$line_count,         #line count
					    \$source_file,       #file name
					    [@srccode_sequence], #code sequence
					    "",                  #label
					    "S1",                #opcode
					    "",                  #arguments
					    $pc_lin,             #linear pc
					    $pc_pag,             #paged pc
					    undef,               #hex code
					    undef,               #bytes
					    undef,               #cycles
					    [$error]];           #errors
		    $srec_count++;
		    $error_count++;
		    @srccode_sequence = ();
		}	    
		last;};
	    #############
	    # S2-Record #
	    #############
	    /$srec_format_S2/ && do {
 		$type     = $1;
		$length   = $2;
		$address  = $3;
		$data     = $4;
		$checksum = $5;
   
		#printf STDERR "type:     %s (S2)\n", $type;
		#printf STDERR "lenth:    %s (%d)\n", $length, hex($length);
		#printf STDERR "address:  %s\n",      $address;
		#printf STDERR "data:     %s\n",      $data;
		#printf STDERR "checksum: %s\n",      $checksum;

		$error = $self->check_srec(3,
					   $length,
					   $address,
					   $data,
					   $checksum);
		($pc_lin, $pc_pag)          = $self->determine_pc($address, $srec_type); 
		($data_count, $data_string) = $self->format_S123_data($data);
		push @srccode_sequence, sprintf("S2-Record: \$%.6X - \$%.6X (%d bytes)", (hex($address),
											  (hex($address) + $data_count - 1),
											  $data_count));
		
		#printf STDERR "hex:    %s\n", $data_string;
		#printf STDERR "pc_lin: %X\n", $pc_lin;
		#printf STDERR "pc_pag: %X\n", $pc_pag;

		if (!$error) {
		    #store data
		    push @{$self->{code}}, [$line_count,         #line count
					    \$source_file,       #file name
					    [@srccode_sequence], #code sequence
					    "",                  #label
					    "S2",                #opcode
					    "",                  #arguments
					    $pc_lin,             #linear pc
					    $pc_pag,             #paged pc
					    $data_string,        #hex code
					    $data_count,         #bytes
					    undef,               #cycles
					    []];                 #errors
		    $srec_count++;
		    @srccode_sequence = ();
		} else {
		    #invalid S-Record
		    #store S-Record
		    push @srccode_sequence, $line;
		    #store error message
		    push @{$self->{code}}, [$line_count,         #line count
					    \$source_file,       #file name
					    [@srccode_sequence], #code sequence
					    "",                  #label
					    "S2",                #opcode
					    "",                  #arguments
					    $pc_lin,             #linear pc
					    $pc_pag,             #paged pc
					    undef,               #hex code
					    undef,               #bytes
					    undef,               #cycles
					    [$error]];           #errors
		    $srec_count++;
		    $error_count++;
		    @srccode_sequence = ();
		}	    
		last;};
	    #############
	    # S3-Record #
	    #############
	    /$srec_format_S3/ && do {
		$type     = $1;
		$length   = $2;
		$address  = $3;
		$data     = $4;
		$checksum = $5;
    
		#printf STDERR "type:     %s (S3)\n", $type;
		#printf STDERR "lenth:    %s (%d)\n", $length, hex($length);
		#printf STDERR "address:  %s\n",      $address;
		#printf STDERR "data:     %s\n",      $data;
		#printf STDERR "checksum: %s\n",      $checksum;

		$error = $self->check_srec(4,
					   $length,
					   $address,
					   $data,
					   $checksum);
		($pc_lin, $pc_pag)          = $self->determine_pc($address, $srec_type); 
		($data_count, $data_string) = $self->format_S123_data($data);
		push @srccode_sequence, sprintf("S3-Record: \$%.8X - \$%.8X (%d bytes)", (hex($address),
											  (hex($address) + $data_count - 1),
											  $data_count));
		if (!$error) {
		    #store data
		    push @{$self->{code}}, [$line_count,         #line count
					    \$source_file,       #file name
					    [@srccode_sequence], #code sequence
					    "",                  #label
					    "S3",                #opcode
					    "",                  #arguments
					    $pc_lin,             #linear pc
					    $pc_pag,             #paged pc
					    $data_string,        #hex code
					    $data_count,         #bytes
					    undef,               #cycles
					    []];                 #errors
		    $srec_count++;
		    @srccode_sequence = ();
		} else {
		    #invalid S-Record
		    #store S-Record
		    push @srccode_sequence, $line;
		    #store error message
		    push @{$self->{code}}, [$line_count,         #line count
					    \$source_file,       #file name
					    [@srccode_sequence], #code sequence
					    "",                  #label
					    "S3",                #opcode
					    "",                  #arguments
					    $pc_lin,             #linear pc
					    $pc_pag,             #paged pc
					    undef,               #hex code
					    undef,               #bytes
					    undef,               #cycles
					    [$error]];           #errors
		    $srec_count++;
		    $error_count++;
		    @srccode_sequence = ();
		}	    
		last;};
	    #############
	    # S5-Record #
	    #############
	    /$srec_format_S5/ && do {
		$type     = $1;
		$length   = $2;
		$address  = $3;
		$data     = $4;
		$checksum = $5;
    
		#printf STDERR "type:     %s (S5)\n", $type;
		#printf STDERR "lenth:    %s (%d)\n", $length, hex($length);
		#printf STDERR "address:  %s\n",      $address;
		#printf STDERR "data:     %s\n",      $data;
		#printf STDERR "checksum: %s\n",      $checksum;

		$error = $self->check_srec(2,
					   $length,
					   $address,
					   $data,
					   $checksum);
		
		push @srccode_sequence, sprintf("S5-Record: %d S-Records counted", hex($address));
		if (!$error) {
		    $error = $self->check_s5rec($address, $srec_count);
		}		    
		$srec_count = 0;

		if ($error) {
		    #invalid S-Record
		    #store S-Record
		    push @srccode_sequence, $line;
		    #store error message
		    push @{$self->{code}}, [$line_count,         #line count
					    \$source_file,       #file name
					    [@srccode_sequence], #code sequence
					    "",                  #label
					    "S5",                #opcode
					    "",                  #arguments
					    undef,               #linear pc
					    undef,               #paged pc
					    undef,               #hex code
					    undef,               #bytes
					    undef,               #cycles
					    [$error]];           #errors
		    $error_count++;
		    @srccode_sequence = ();
		}	    
		last;};
	    #############
	    # S7-Record #
	    #############    
	    /$srec_format_S7/ && do {
		$type     = $1;
		$length   = $2;
		$address  = $3;
		$data     = $4;
		$checksum = $5;
    
		#printf STDERR "type:     %s (S7)\n", $type;
		#printf STDERR "lenth:    %s (%d)\n", $length, hex($length);
		#printf STDERR "address:  %s\n",      $address;
		#printf STDERR "data:     %s\n",      $data;
		#printf STDERR "checksum: %s\n",      $checksum;

		$error = $self->check_srec(4,
					   $length,
					   $address,
					   $data,
					   $checksum);
		
		push @srccode_sequence, sprintf("S7-Record: Start address = %.8X", hex($address));

		if ($error) {
		    #invalid S-Record
		    #store S-Record
		    push @srccode_sequence, $line;
		    #store error message
		    push @{$self->{code}}, [$line_count,         #line count
					    \$source_file,       #file name
					    [@srccode_sequence], #code sequence
					    "",                  #label
					    "S7",                #opcode
					    "",                  #arguments
					    undef,               #linear pc
					    undef,               #paged pc
					    undef,               #hex code
					    undef,               #bytes
					    undef,               #cycles
					    [$error]];           #errors
		    $error_count++;
		    @srccode_sequence = ();
		}	    
		last;};
	    #############
	    # S8-Record #
	    #############
	    /$srec_format_S8/ && do {
		$type     = $1;
		$length   = $2;
		$address  = $3;
		$data     = $4;
		$checksum = $5;
    
		#printf STDERR "type:     %s (S8)\n", $type;
		#printf STDERR "lenth:    %s (%d)\n", $length, hex($length);
		#printf STDERR "address:  %s\n",      $address;
		#printf STDERR "data:     %s\n",      $data;
		#printf STDERR "checksum: %s\n",      $checksum;

		$error = $self->check_srec(3,
					   $length,
					   $address,
					   $data,
					   $checksum);
		
		push @srccode_sequence, sprintf("S8-Record: Start address = %.6X", hex($address));

		if ($error) {
		    #invalid S-Record
		    #store S-Record
		    push @srccode_sequence, $line;
		    #store error message
		    push @{$self->{code}}, [$line_count,         #line count
					    \$source_file,       #file name
					    [@srccode_sequence], #code sequence
					    "",                  #label
					    "S8",                #opcode
					    "",                  #arguments
					    undef,               #linear pc
					    undef,               #paged pc
					    undef,               #hex code
					    undef,               #bytes
					    undef,               #cycles
					    [$error]];           #errors
		    $error_count++;
		    @srccode_sequence = ();
		}	    
		last;};
	    #############
	    # S9-Record #
	    #############
	    /$srec_format_S9/ && do {    
      		$type     = $1;
		$length   = $2;
		$address  = $3;
		$data     = $4;
		$checksum = $5;
    
		#printf STDERR "type:     %s (S9)\n", $type;
		#printf STDERR "lenth:    %s (%d)\n", $length, hex($length);
		#printf STDERR "address:  %s\n",      $address;
		#printf STDERR "data:     %s\n",      $data;
		#printf STDERR "checksum: %s\n",      $checksum;

		$error = $self->check_srec(2,
					   $length,
					   $address,
					   $data,
					   $checksum);
		
		push @srccode_sequence, sprintf("S9-Record: Start address = %.4X", hex($address));

		if ($error) {
		    #invalid S-Record
		    #store S-Record
		    push @srccode_sequence, $line;
		    #store error message
		    push @{$self->{code}}, [$line_count,         #line count
					    \$source_file,       #file name
					    [@srccode_sequence], #code sequence
					    "",                  #label
					    "S9",                #opcode
					    "",                  #arguments
					    undef,               #linear pc
					    undef,               #paged pc
					    undef,               #hex code
					    undef,               #bytes
					    undef,               #cycles
					    [$error]];           #errors
		    $error_count++;
		    @srccode_sequence = ();
		}	    
		last;};
	    ####################
	    # invalid S-Record #
	    ####################

	    print STDERR "Invalid S-Record!\n";

	    #store S-Record
	    push @srccode_sequence, $line;
	    #store error message
	    push @{$self->{code}}, [$line_count,         #line count
				    \$source_file,       #file name
				    [@srccode_sequence], #code sequence
				    "",                  #label
				    "",                  #opcode
				    "",                  #arguments
				    undef,               #linear pc
				    undef,               #paged pc
				    undef,               #hex code
				    undef,               #bytes
				    undef,               #cycles
				    ["invalid S-Recor"]];           #errors
	    $error_count++;
	    @srccode_sequence = ();
	}
    }
    $file_handle->close();
    return $error_count;
}

##############
# check_srec #
##############
sub check_srec {
    my $self           = shift @_;
    my $addr_width     = shift @_;
    my $length         = shift @_;
    my $address        = shift @_;
    my $data           = shift @_;
    my $checksum       = shift @_;
    #data
    my @data_chars;
    my $act_length;
    #checksum
    my $act_checksum;
    my $byte;
    #errors
    my $error;
    
    #####################
    # check data length #
    #####################
    @data_chars = (split(//, $address), split(//, $data));
    $act_length = ((($#data_chars + 1) / 2) + 1);
    $length     = hex($length);
    if ($length != $act_length) {
	$error = sprintf("Incorrect data length %d instead of %d", $act_length, $length);
	return $error;
    }

    ##################
    # check checksum #
    ##################
    $act_checksum = 0;
    while ($#data_chars >= 1) {
	$byte  = shift @data_chars;
	$byte .= shift @data_chars;
	$act_checksum += hex($byte);
    }
    #add data length
    $act_checksum += $length;
    $act_checksum = (0xff - ($act_checksum & 0xff));
    $checksum     = hex($checksum);

    if ($checksum != $act_checksum) {
	$error = sprintf("Incorrect checksum %.2X instead of %.2X", $act_checksum, $checksum);
	return $error;
    }

    #############
    # no errors #
    #############
    $error = 0;
    return $error;
}

#################
# print_S0_data #
#################
sub print_S0_data {
    my $self = shift @_;
    my $data = shift @_;
    #data
    my @data_chars;
    my $byte;
    my $string;

    #####################
    # extract S0 string #
    #####################
    @data_chars = split //, $data;
    $string = "\"";
    while ($#data_chars >= 1) {
	$byte    = shift @data_chars;
	$byte   .= shift @data_chars;
	$string .= chr(hex($byte));
	#printf STDERR "hex to string: %.2s -> \"%s\"\n", hex($byte), $string;
    }
    $string .= "\"";
    return $string;
}

####################
# format_S123_data #
####################
sub format_S123_data {
    my $self = shift @_;
    my $data = shift @_;
    #data
    my @data_chars;
    my $count;
    my $string;

    #######################
    # extract byte string #
    #######################
    @data_chars = split //, $data;
    $string = "";
    $count  = 0;
    while ($#data_chars >= 1) {
	$string .= shift @data_chars;
	$string .= shift @data_chars;
	$string .= " ";
	$count++;
    }
    $string =~ s/\s*$//g;
    return ($count, $string);
}

################
# determine_pc #
################
sub determine_pc {
    my $self      = shift @_;
    my $address   = shift @_;
    my $srec_type = shift @_;
    #program counter
    my $pc_lin;
    my $pc_pag;

    for ($srec_type) {
	#######################
	# linear S12 S-Record #
	#######################
	/^$srec_type_lin_s12$/ && do {
	    #print STDERR "LINEAR S-RECORD!\n";
	    $pc_lin = hex($address);
	    #######################
	    # determine linear pc #
	    #######################
	    if ((($pc_lin & 0xffffff) >= 0xf4000) &&
		(($pc_lin & 0xffffff) <  0xf7fff)) {
		#####################
		# fixed page => $3D #
		#####################
		$pc_pag = (($pc_lin - 0xf4000) & 0xffff);
	    } elsif ((($pc_lin & 0xffffff) >= 0xf8000) &&
		     (($pc_lin & 0xffffff) <  0xfbfff)) {
		#####################
		# fixed page => $3E #
		#####################
		$pc_pag = (($pc_lin - 0xf4000) & 0xffff);
	    } elsif ((($pc_lin & 0xffffff) >= 0x00000) &&
		     (($pc_lin & 0xffffff) <  0xf3fff)) {
		#####################
		# paged memory area #
		#####################
		$pc_pag = ((($pc_lin & 0xfc000) << 2) + (($pc_lin & 0x03fff) + 0x08000));
	    } elsif ((($pc_lin & 0xffffff) >= 0xfc000) &&
		     (($pc_lin & 0xffffff) <  0xfffff)) {
		####################
		# fixed page => 3F #
		####################
		$pc_pag = (($pc_lin - 0xf0000) & 0xffff);
	    } else {
		#################
		# unmapped page #
		#################
		$pc_pag = undef;
	    }
	    last;};
	######################
	# paged S12 S-Record #
	######################
	/^$srec_type_pag_s12$/ && do {
	    #print STDERR "PAGED S-RECORD!\n";
	    $pc_pag = hex($address);
	    #######################
	    # determine linear pc #
	    #######################
	    if ((($pc_pag & 0xffff) >= 0x0000) &&
		(($pc_pag & 0xffff) <  0x4000)) {
		#####################
		# fixed page => $3D #
		#####################
		$pc_lin = ((0x3d * 0x4000) + (($pc_pag - 0x0000) & 0xffff));
	    } elsif ((($pc_pag & 0xffff) >= 0x4000) &&
		     (($pc_pag & 0xffff) <  0x8000)) {
		#####################
		# fixed page => $3E #
		#####################
		$pc_lin = ((0x3e * 0x4000) + (($pc_pag - 0x4000) & 0xffff));
	    } elsif ((($pc_pag & 0xffff) >= 0x8000) &&
		     (($pc_pag & 0xffff) <  0xc000)) {
		#####################
		# paged memory area #
		#####################
		$pc_lin = (((($pc_pag >> 16) & 0xff) * 0x4000) + (($pc_pag - 0x8000) & 0xffff));
	    } elsif ((($pc_pag & 0xffff) >= 0xc000) &&
		     (($pc_pag & 0xffff) <= 0xffff)) {
		####################
		# fixed page => 3F #
		####################
		$pc_lin = ((0x3f * 0x4000) + (($pc_pag - 0xc000) & 0xffff));
	    } else {
		#################
		# unmapped page #
		#################
		$pc_lin = undef;
	    }
	    last;};
	########################
	# linear S12X S-Record #
	########################
	/^$srec_type_lin_s12x$/ && do {
	    #print STDERR "LINEAR S-RECORD!\n";
	    $pc_lin = hex($address);
	    #######################
	    # determine linear pc #
	    #######################
	    if ((($pc_lin & 0xffffff) >= 0x000000) &&
		(($pc_lin & 0xffffff) <  0x000800)) {
		##################
		# register space #
		##################
		$pc_pag = $pc_lin;
	    } elsif ((($pc_lin & 0xffffff) >= 0x000800) &&
		     (($pc_lin & 0xffffff) <  0x001000)) {
		##################
		# unmapped space #
		##################
		$pc_pag = undef;
	    } elsif ((($pc_lin & 0xffffff) >= 0x001000) &&
		     (($pc_lin & 0xffffff) <  0x0fe000)) {
		#############
		# paged RAM #
		#############
		$pc_pag = (0x1000 + 
			   ($pc_lin & 0xfff) +
			   ((($pc_lin - 0x1000) & 0xff000)<<4));
	    } elsif ((($pc_lin & 0xffffff) >= 0x0fe000) &&
		     (($pc_lin & 0xffffff) <  0x100000)) {
		###############
		# unpaged RAM #
		###############
		$pc_pag = (0x2000 + 
			   ($pc_lin - 0x0fe00));
	    } elsif ((($pc_lin & 0xffffff) >= 0x100000) &&
		     (($pc_lin & 0xffffff) <  0x13fc00)) {
		################
		# paged EEPROM #
		################
		$pc_pag = (0x800 + 
			   ($pc_lin & 0x3ff) +
			   ((($pc_lin - 0x100000) & 0xffc00)<<6));
	    } elsif ((($pc_lin & 0xffffff) >= 0x13fc00) &&
		     (($pc_lin & 0xffffff) <  0x140000)) {
		##################
		# unpaged EEPROM #
		##################
		$pc_pag = (0xc00 + 
			   ($pc_lin - 0x13fc00));
	    } elsif ((($pc_lin & 0xffffff) >= 0x140000) &&
		     (($pc_lin & 0xffffff) <  0x7f4000)) {
		###############
		# paged Flash #
		###############
		$pc_pag = (0x8000 + 
			   ($pc_lin & 0xffff) +
			   ((($pc_lin - 0x140000) & 0xff0000)<<8));
	    } elsif ((($pc_lin & 0xffffff) >= 0x7f4000) &&
		     (($pc_lin & 0xffffff) <  0x7f8000)) {
		#################
		# unpaged Flash #
		#################
		$pc_pag = (0x4000 + 
			   ($pc_lin - 0x7f4000));
	    } elsif ((($pc_lin & 0xffffff) >= 0x7f8000) &&
		     (($pc_lin & 0xffffff) <  0x7fc000)) {
		###############
		# paged Flash #
		###############
		$pc_pag = (0x8000 + 
			   ($pc_lin & 0xffff) +
			   ((($pc_lin - 0x140000) & 0xff0000)<<8));
	    } elsif ((($pc_lin & 0xffffff) >= 0x7fc000) &&
		     (($pc_lin & 0xffffff) <  0x800000)) {
		#################
		# unpaged Flash #
		#################
		$pc_pag = (0xc000 + 
			   ($pc_lin - 0x7fc000));
	    } else {
		#################
		# unmapped page #
		#################
		$pc_pag = undef;
	    }
	    last;};
	######################
	# paged S12X S-Record #
	######################
	/^$srec_type_pag_s12x$/ && do {
	    #print STDERR "PAGED S-RECORD!\n";
	    $pc_pag = hex($address);
	    #######################
	    # determine linear pc #
	    #######################
	    if ((($pc_pag & 0xffff) >= 0x0000) &&
		(($pc_pag & 0xffff) <  0x0800)) {
		##################
		# register space #
		##################
		$pc_lin =($pc_pag & 0xffff);
	    } elsif ((($pc_pag & 0xffff) >= 0x0800) &&
		     (($pc_pag & 0xffff) <  0x0c00)) {
		################
		# paged EEPROM #
		################
		$pc_lin = ((($pc_pag & 0xff0000) >> 6)   +
			   (($pc_pag & 0xffff) - 0x0800) +
			     0x100000);
	    } elsif ((($pc_pag & 0xffff) >= 0x0c00) &&
		     (($pc_pag & 0xffff) <  0x1000)) {
		##################
		# unpaged EEPROM #
		##################
		$pc_lin = ((($pc_pag & 0xffff) - 0x1000) +
		             0x13fc00); 
	    } elsif ((($pc_pag & 0xffff) >= 0x1000) &&
		     (($pc_pag & 0xffff) <  0x2000)) {
		#############
		# paged RAM #
		#############
		$pc_lin = ((($pc_pag & 0xff0000) >> 4)   +
			   (($pc_pag & 0xffff) - 0x1000) +
			     0x001000);
	    } elsif ((($pc_pag & 0xffff) >= 0x2000) &&
		     (($pc_pag & 0xffff) <  0x4000)) {
		###############
		# unpaged RAM #
		###############
		$pc_lin = ((($pc_pag & 0xffff) - 0x2000) +
		             0x0fe000); 
	    } elsif ((($pc_pag & 0xffff) >= 0x4000) &&
		     (($pc_pag & 0xffff) <  0x8000)) {
		#################
		# unpaged Flash #
		#################
		$pc_lin = ((($pc_pag & 0xffff) - 0x4000) +
		             0x7f4000); 
	    } elsif ((($pc_pag & 0xffff) >= 0x8000) &&
		     (($pc_pag & 0xffff) <  0xc000)) {
		###############
		# paged Flash #
		###############
		$pc_lin = ((($pc_pag & 0xff0000) >> 2)   +
			   (($pc_pag & 0xffff) - 0x8000) +
			     0x400000);
	    } elsif ((($pc_pag & 0xffff) >= 0xc000) &&
		     (($pc_pag & 0xffff) <  0x10000)) {
		#################
		# unpaged Flash #
		#################
		$pc_lin = ((($pc_pag & 0xffff) - 0xc000) +
		             0x7fc000); 
	    } else {
		#################
		# unmapped page #
		#################
		$pc_lin = undef;
	    }
	    last;};
	####################
	# unknown S-Record #
	####################
	#print STDERR "UNKNOWN S-RECORD!\n";
	$pc_lin = undef;
	$pc_pag = undef;
    }

    #printf STDERR "address: %8s type: %8s paged: %8X linear: %8X\n",  $address, $srec_type, $pc_pag, $pc_lin;

    return ($pc_lin, $pc_pag); 
}

###############
# check_s5rec #
###############
sub check_s5rec {
    my $self           = shift @_;
    my $address        = shift @_;
    my $srec_count     = shift @_;
   
    $address = hex($address);
    ########################
    # check S-Record count #
    ########################
    if ($address == $srec_count) {
	#############
	# no errors #
	#############
	$error = 0;
	return $error;
    } else {
	$error = sprintf("Incorrect S-Record count %d instead of %d", $srec_count, $address);
	return $error;
    }
}


#######################
# evaluate_expression #
#######################
sub evaluate_expression {
    my $self    = shift @_;
    my $expr    = shift @_;
    my $pc_lin  = shift @_;
    my $pc_pag  = shift @_;
    my $loc_cnt = shift @_;

    return hsw12_asm::evaluate_expression($self, $expr, undef, undef, undef);
}

########################
# determine_addrspaces #
########################
sub determine_addrspaces {
    my $self      = shift @_;
   
    return hsw12_asm::determine_addrspaces($self);
}

###########
# outputs #
###########
#################
# print_listing # 
#################
sub print_listing {
    my $self      = shift @_;
    
    return hsw12_asm::print_listing($self);
}

##################
# print_lin_srec # 
##################
sub print_lin_srec {
    my $self              = shift @_;
    my $string            = shift @_;
    my $srec_format       = shift @_;
    my $srec_data_length  = shift @_;
    my $srec_add_s5       = shift @_;
    my $srec_word_entries = shift @_;

    return hsw12_asm::print_lin_srec($self, $string, $srec_format, $srec_data_length, $srec_add_s5, $srec_word_entries);
}

##################
# print_pag_srec # 
##################
sub print_pag_srec {
    my $self              = shift @_;
    my $string            = shift @_;
    my $srec_format       = shift @_;
    my $srec_data_length  = shift @_;
    my $srec_add_s5       = shift @_;
    my $srec_word_entries = shift @_;
 
    return hsw12_asm::print_pag_srec($self, $string, $srec_format, $srec_data_length, $srec_add_s5, $srec_word_entries);
}

#####################
# print_header_srec # 
#####################
sub gen_header_srec {
    my $self             = shift @_;
    my $string           = shift @_;
    my $srec_data_length = shift @_;
 
    return hsw12_asm::gen_header_srec($self, $string, $srec_data_length);
}

#################
# gen_data_srec #
#################
sub gen_data_srec {
    my $self      = shift @_;
    my $address   = shift @_;
    my $data      = shift @_;
    my $format    = shift @_;

    return hsw12_asm::gen_data_srec($self, $address, $data, $format);
}

#############
# gen_s5rec #
#############
sub gen_s5rec {
    my $self      = shift @_;
    my $number    = shift @_;

    return hsw12_asm::gen_srec($self, $number);
}

################
# gen_end_srec # 
################
sub gen_end_srec {
    my $self      = shift @_;
    my $format    = shift @_;
    
    return hsw12_asm::gen_end_srec($self, $format);
}










