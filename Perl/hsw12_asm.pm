#! /usr/bin/env perl
##################################################################################
#                             HC(S)12 ASSEMBLER                                  #
##################################################################################
# file:    hsw12_asm.pm                                                          #
# author:  Dirk Heisswolf                                                        #
# purpose: This is the core of the HSW12 Assembler                               #
##################################################################################
# Copyright (C) 2003-2005 by Dirk Heisswolf. All rights reserved.                #
# This file is part of "HSW12". HSW12 is free software;                          #
# you can redistribute it and/or modify it under the same terms as Perl itself.  #
##################################################################################
=pod
=head1 NAME

hsw12_asm - HC(S) Assembler

=head1 SYNOPSIS

 require hsw12_asm

 $asm = hsw12_asm->new(\@source_files, \@library_dirs, \%assembler_defines, $cpu, $verbose);
 print FILEHANDLE $asm->print_listing();
 print FILEHANDLE $asm->print_lin_srec();
 print FILEHANDLE $asm->print_pag_srec();

=head1 REQUIRES

perl5.005, File::Basename, FindBin, Text::Tabs

=head1 DESCRIPTION

This module provides subroutines to...

=over 4

 - compile HC(S)12 assembler source code
 - create code lisings
 - create linear and paged S-Records
 - provide access to the symbols used in the source code

=back

=head1 METHODS

=head2 Creation

=over 4

=item hsw12_asm->new(\@source_files, \@library_dirs, \%assembler_defines, $verbose)

 Creates and returns an hsw12_asm object.
 This method requires five arguments:
     1. \@source_files:      a list of files to compile (array reference)
     2. \@library_dirs:      a list of directories to search include files in (array reference)
     3. \%assembler_defines: assembler defines to set before compiling the source code (hash reference)
     4. $cpu:                the target CPU ("HC11", "HC12"/"S12", "S12X", "XGATE") (string)
     5. $verbose:            switch to enable progress messages (boolean)

=back

=head2 Outputs

=over 4

=item $asm_object->print_listing()

 Returns the listing of the assembler source code (string).

=item $asm_object->print_lin_srec($string,
                                  $srec_format,
                                  $srec_length,
                                  $s5,
                                  $fill_bytes)

 Returns a linear S-Record of the compiled code (string).
 This method requires five arguments:
     1. $string:      S0 header                        (string)
     2. $srec_format: address format: S19, S28, or S37 (string)
     3. $srec_length: nuber of data bytes in S-Record  (integer)
     4. $fill_bytes:  add fill bytes                   (boolean)

=item $asm_object->print_pag_srec($string,
                                  $srec_format,
                                  $srec_length,
                                  $s5,
                                  $fill_bytes)

 Returns a paged S-Record of the compiled code (string).
 This method requires five arguments:
     1. $string:      S0 header                        (string)
     2. $srec_format: address format: S19, S28, or S37 (string)
     3. $srec_length: nuber of data bytes in S-Record  (integer)
     4. $fill_bytes:  add fill bytes                   (boolean)

=item $asm_object->print_pag_srec($string,
                                  $srec_format,
                                  $srec_length,
                                  $s5,
                                  $fill_bytes)

 Returns a paged S-Record of the compiled code (string).
 This method requires five arguments:
     1. $string:      S0 header                        (string)
     2. $srec_format: address format: S19, S28, or S37 (string)
     3. $srec_length: nuber of data bytes in S-Record  (integer)
     4. $fill_bytes:  add fill bytes                   (boolean)

=back

=head2 Misc

=over 4

=item $asm_object->reload(boolean)
 This method requires one argument:
     1. $verbose:  switch to enable progress messages (boolean)

 Recompiles the source code files.

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

=item V00.00 - Feb 9, 2003

 initial release

=item V00.01 - Feb 23, 2003

 -fixed BCC opcode
 -fixed relative address mode
 -replacing tabs with Text::Tabs::expand()

=item V00.02 - Feb 24, 2003

 -fixed compiler symbol table

=item V00.03 - Feb 28, 2003

 -fixed IDX1 addressing mode
 -fixed IDX2 addressing mode
 -fixed REL9 addressing mode for DBEQ, DBNE, IBEQ, IBNE
 -fixed EXG and TFR command

=item V00.04 - Mar 2, 2003

 -fixed ascii expressions
 -allow value changes of symbols during compilation
 -fixed FCC pseudo opcode
 -fixed long hex codes in listing

=item V00.05 - Mar 11, 2003

 -new default mapping for linear PC:
  $0000 - $3FFF are mapped to flash page $3D

=item V00.06 - Mar 28, 2003

 -fixed S-Record output (data fields used to be one byte too short)

=item V00.07 - Apr 1, 2003

 -added options to configure the S-Record format, including "fill bytes"

=item V00.08 - Apr 23, 2003

 -fixed S0 record format
 -fixd fill byte insertion

=item V00.09 - Apr 29, 2003

 -added member variable "compile_count"
 -undefined symbols will now generate errors
 -accepting "_" on integer numbers
 -added a "verbose mode" to print out progress messages

=item V00.10 - May 6, 2003

 -bugfix in "evaluate_expression"

=item V00.11 - Jun 5, 2003

 -bugfix in "precompile"

=item V00.12 - Sep 22, 2003

 -allow more generic instruction tables

=item V00.13 - Sep 27, 2003

 -added HC11, S12X, and XGATE instruction tables

=item V00.14 - Sep 28, 2003

 -added XGATE pseudo instructions

=item V00.15 - Sep 30, 2003

 -added XGATE "IDO5" address mode

=item V00.16 - Nov 24, 2003

 -fixed relaxed error condition of "REL8" address mode

=item V00.17 - Nov 27, 2003

 -updated S12X SEX instruction

=item V00.18 - Jan 27, 2004

 -fixed missing S12X move address modes
 -various minor fixes

=item V00.19 - Feb 13, 2004

 -fixed regular expressions for parsing pseudo opcodes

=item V00.20 - Mar 9, 2004

 -detect auto in/decrement of PC

=item V00.21 - Aug 4, 2004

 -added XGATE command "TFR RD,PC"

=item V00.22 - Oct 28, 2004

 -fixed "TFR", "EXG", and "SEX" instructions
 -added pseudo opcodes which are to be ignored

=item V00.23 - Nov 26, 2004

 -fixed regular expression "TFR Rx,PC"
 -added 16-bit immediatate pseudo instructions

=item V00.24 - Apr 24, 2005

 -automatically turn branch instructions into long branches
  if out of range
 -added pseudo opcode "JOB" to automatically choose between
  "BRA rel8" and "JMP ext" opcodes
 -added pseudo opcode "JOBSR" to automatically choose between
  "BSR rel8" and "JSR ext" opcodes

=item V00.25 - Oct 19, 2005
 -added workaround for the XGATE "SSEM" bug
 -added "SSSEM" (single/spec conform SSEM) instruction

=item V00.26 - Oct 22, 2005
 -added macro support

=item V00.27 - Oct 27, 2005
 -fixed pseudo opcodes (especially "FILL")

=item V00.28 - Dec 22, 2005
 -fixed evaluation of local symbols (inside macros)

=item V00.29 - Mar 23, 2006
 -added functions print_lin_binary and print_pag_binary

=item V00.30 - Apr 11, 2006
 -fixed "[D,r]" address mode

=item V00.30 - Apr 11, 2006
 -fixed "[D,r]" address mode

=item V00.31 - Jun 23, 2006
 -fixed BGND instruction

=item V00.32 - Apr 9, 2009
 -fixed items on David Armstrongs's bug list
   -added ">"/"<" syntax to disable the automatic BRA/LBRA selection
   -finished implementing the SETDP pseudo-opcode

=item V00.33 - Apr 25, 2009
 -fixed one more item on David Armstrongs's bug list
   -CALL instruction no longer requires a page value for
    indexed-indirect address modes

=item V00.34 - Apr 27, 2009
 -added pseudo-opcode FCS, to generate strings which are terminated by
  setting the MSB in the last character

=item V00.35 - Apr 28, 2009
 -made up address mode "extended-indirect [ext]", which translates into
  indexed-indirect address mode with PC relative addressing

=item V00.36 - Apr 30, 2009
 -added hack to allow semicolons in strings. These strings must have the
  delimeters " or '

=item V00.37 - May 3, 2009
 -fixed regular expression $precomp_opcode. Got btoken in V00.37 (did not
  handle expressions with ascii chars correctly
  
=item V00.38 - May 7, 2009
 -macros now accept strings with commas and whitespaces
  
=item V00.39 - May 27, 2010
 -"./" is no longer treated as absolute path
  
=cut

#################
# Perl settings #
#################
#use warnings;
#use strict;

####################
# create namespace #
####################
package hsw12_asm;

###########
# modules #
###########
use IO::File;
use Fcntl;
use Text::Tabs;
use File::Basename;

####################
# global variables #
####################
#@source_files  (array)
#@libraies      (array)
#@initial_defs  (hash)
#$problems      (boolean)
#@code          (array)
#%precomp_defs  (hash)
#%comp_symbols  (hash)
#%lin_addrspace (hash)
#%pag_addrspace (hash)
#$compile_count (integer)
#$verbose       (boolean)

#############
# constants #
#############
###########
# version #
###########
*version = \"00.39";#"

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
#*path_absolute    = \qr/^\.?[\/\\]/;
*path_absolute    = \qr/^\[\/\\]/;

########################
# code entry structure #
########################
*code_entry_line   =  \0;
*code_entry_file   =  \1;
*code_entry_code   =  \2;
*code_entry_label  =  \3;
*code_entry_opcode =  \4;
*code_entry_args   =  \5;
*code_entry_lin_pc =  \6;
*code_entry_pag_pc =  \7;
*code_entry_hex    =  \8;
*code_entry_bytes  =  \9;
*code_entry_errors = \10;
*code_macros       = \11;
*code_sym_tabs     = \12;

###########################
# precompiler expressions #
###########################
*precomp_directive    = \qr/^\#(\w+)\s*([^\,\s\;]*|\(.*\))\s*[\s,]?\s*([^\,\s\;]*|\(.*\))\s*[;\*]?/;  #$1:directive $2:name $3:value
*precomp_define       = \qr/define/i;
*precomp_undef        = \qr/undef/i;
*precomp_ifdef        = \qr/ifdef/i;
*precomp_ifndef       = \qr/ifndef/i;
*precomp_if           = \qr/if/i;
*precomp_ifeq         = \qr/ifeq/i;
*precomp_ifneq        = \qr/ifneq/i;
*precomp_else         = \qr/else/i;
*precomp_endif        = \qr/endif/i;
*precomp_include      = \qr/include/i;
*precomp_macro        = \qr/macro/i;
*precomp_emac         = \qr/emac/i;
*precomp_blanc_line   = \qr/^\s*$/;
*precomp_comment_line = \qr/^\s*[\;\*]/;
#*precomp_opcode       = \qr/^([^\#]\w*\`?):?\s*([\w\.]*)\s*([^;]*)\s*[;\*]?/;        #$1:label $2:opcode $3:arguments
*precomp_opcode       = \qr/^([^\#]\w*\`?):?\s*([\w\.]*)\s*((?:\".*?\"|\'.*?\'|[^;])*)\s*[;\*]?/;        #$1:label $2:opcode $3:arguments

#############
# TFR codes #
#############
*tfr_s12               = \0;
*tfr_s12x              = \1;
*tfr_tfr               = \0;
*tfr_sex               = \1;
*tfr_exg               = \2;

############################
# address mode expressions #
############################
#operands (S12)
*op_keywords           = \qr/^\s*(A|B|D|X|Y|PC|SP|UNMAPPED|R[0-7])\s*$/i; #$1: keyword
#*del                  = \qr/\s*,\s*/;
*del                   = \qr/\s*[\s,]\s*/;
*op_expr               = \qr/([^\"\'\s\,\<\>\[][^\"\'\s\,]*\'?|\".*\"|\'.*\'|\(.*\))/i;
*op_offset             = \qr/([^\"\'\s\,]*\'?|\".*\"|\'.*\'|\(.*\))/i;
*op_imm                = \qr/\#$op_expr/i;
*op_dir                = \qr/\<?$op_expr/i;
*op_ext                = \qr/\>?$op_expr/i;
*op_idx                = \qr/$op_offset,([\+\-]?)(X|Y|SP|PC)([\+\-]?)/i;                                #$1:offset $2:preop $3:register $4:postop
*op_idx1               = \qr/$op_offset,(X|Y|SP|PC)/i;                                                  #$1:offset $2:register
*op_idx2               = \qr/$op_offset,\s*(X|Y|SP|PC)/i;                                               #$1:offset $2:register
*op_ididx              = \qr/\[\s*D\s*,\s*(X|Y|SP|PC)\s*\]/i;                                           #$1:register
*op_iidx2              = \qr/\[\s*$op_offset\s*,\s*(X|Y|SP|PC)\s*\]/i;                                  #$1:offset $2:register
*op_iext               = \qr/\[\s*$op_expr\s*\]/i;                                                      #$1:addresss
*op_pg                 = \qr/$op_expr/i;                                                                #$1:page
*op_rel                = \qr/$op_expr/i;                                                                #$1:address
*op_msk                = \qr/\#?$op_expr/i;                                                             #$1:mask
*op_trap               = \qr/$op_expr/i;                                                                #$1:value
*op_reg_src            = \qr/(A|B|D|X|XL|Y|YL|SP|SPL|CCR|CCRL|TMP3|TMP3L)/i;                            #$1:register
*op_reg_dst            = \qr/(A|B|D|X|XL|Y|YL|SP|SPL|CCR|CCRL|TMP2|TMP2L)/i;                            #$1:register
*op_reg_idx            = \qr/(A|B|D|X|Y|SP)/i;                                                          #$1:register
#operands (S12X)
*op_s12x_reg_src       = \qr/(A|B|D|X|XH|XL|Y|YH|YL|SP|SPH|SPL|CCR|CCRW|CCRH|CCRL|TMP1|TMP3|TMP3H|TMP3L)/i;#$1:register
*op_s12x_reg_dst       = \qr/(A|B|D|X|XH|XL|Y|YH|YL|SP|SPH|SPL|CCR|CCRW|CCRH|CCRL|TMP1|TMP2|TMP2H|TMP2L)/i;#$1:register
#operands (HC11)
*op_indx               = \qr/$op_offset$del[X]/i;                                                       #$1:offset $2:preop $3:register $4:postop
*op_indy               = \qr/$op_offset$del[Y]/i;                                                       #$1:offset $2:preop $3:register $4:postop
#operands (XGATE)
*op_xgate_reg_gpr      = \qr/(R[0-7])/i;                                                                #$1:register
*op_xgate_reg_src      = \qr/(R[0-7]|CCR)/i;                                                            #$1:register
*op_xgate_reg_dst      = \qr/(R[0-7]|CCR)/i;                                                            #$1:register
#operands (pseudo opcodes)
*op_psop               = \qr/$op_expr/i;                                                                #$1:operand

#S12 address modes
*amod_inh          = \qr/^\s*$/i;
*amod_imm8         = \qr/^\s*$op_imm\s*$/i;        #$1:data
*amod_imm16        = \$amod_imm8;
*amod_dir          = \qr/^\s*$op_dir\s*$/i;        #$1:address
*amod_ext          = \qr/^\s*$op_ext\s*$/i;        #$1:address
*amod_rel8         = \qr/^\s*\<?$op_rel\s*$/i;     #$1:address
*amod_rel16        = \qr/^\s*\>?$op_rel\s*$/i;     #$1:address
*amod_idx          = \qr/^\s*$op_idx\s*$/i;        #$1:offset $2:preop $3:register $4:postop
*amod_idx1         = \qr/^\s*$op_idx1\s*$/i;       #$1:offset $2:register
*amod_idx2         = \$amod_idx1;
*amod_ididx        = \qr/^\s*$op_ididx\s*$/i;      #$1:register
*amod_iidx2        = \qr/^\s*$op_iidx2\s*$/i;      #$1:offset $2:register
*amod_iext         = \qr/^\s*$op_iext\s*$/i;       #$1:address

*amod_dir_msk      = \qr/^\s*$op_dir$del$op_msk\s*$/i;  #$1:address $2:mask
*amod_ext_msk      = \qr/^\s*$op_ext$del$op_msk\s*$/i;  #$1:address $2:mask
*amod_idx_msk      = \qr/^\s*$op_idx$del$op_msk\s*$/i;  #$1:offset $2:preop $3:register $4:postop $4:mask
*amod_idx1_msk     = \qr/^\s*$op_idx1$del$op_msk\s*$/i; #$1:offset $2:register $3:mask
*amod_idx2_msk     = \$amod_idx1_msk;

*amod_dir_msk_rel  = \qr/^\s*$op_dir$del$op_msk$del$op_rel\s*$/i;  #$1:address $2:mask $3:address
*amod_ext_msk_rel  = \qr/^\s*$op_ext$del$op_msk$del$op_rel\s*$/i;  #$1:address $2:mask $3:address
*amod_idx_msk_rel  = \qr/^\s*$op_idx$del$op_msk$del$op_rel\s*$/i;  #$1:offset $2:preop $3:register $4:postop $5:mask $6:address
*amod_idx1_msk_rel = \qr/^\s*$op_idx1$del$op_msk$del$op_rel\s*$/i; #$1:offset $2:register $3:mask $4:address
*amod_idx2_msk_rel = \$amod_idx1_msk_rel;

*amod_ext_pgimpl   = \qr/^\s*$op_ext\s*$/i;             #$1:address
*amod_ext_pg       = \qr/^\s*$op_ext$del$op_pg\s*$/i;   #$1:address $2:page
*amod_idx_pg       = \qr/^\s*$op_idx$del$op_pg\s*$/i;   #$1:offset $2:preop $3:register $4:postop $5:page
*amod_idx1_pg      = \qr/^\s*$op_idx1$del$op_pg\s*$/i;  #$1:offset $2:register $3:page
*amod_idx2_pg      = \$amod_idx1_pg;

*amod_imm8_ext     = \qr/^\s*$op_imm$del$op_ext\s*$/i; #$1:data $2:address
*amod_imm8_idx     = \qr/^\s*$op_imm$del$op_idx\s*$/i; #$1:data $2:offset $3:preop $4:register $5:postop
*amod_imm16_ext    = \$amod_imm8_ext;
*amod_imm16_idx    = \$amod_imm8_idx;
*amod_ext_ext      = \qr/^\s*$op_ext$del$op_ext\s*$/i; #$1:address $2:address
*amod_ext_idx      = \qr/^\s*$op_ext$del$op_idx\s*$/i; #$1:address $2:offset $3:preop $4:register $5:postop
*amod_idx_ext      = \qr/^\s*$op_idx$del$op_ext\s*$/i; #$1:offset $1:preop $3:register $4:postop $5:address
*amod_idx_idx      = \qr/^\s*$op_idx$del$op_idx\s*$/i; #$1:offset $2:preop $3:register $4:postop #$5:offset $6:preop $7:register $8:postop

*amod_exg          = \qr/^\s*$op_reg_src$del$op_reg_dst\s*$/i; #$1:register $1:register
*amod_tfr          = \$amod_exg;                           #$1:register $1:register

*amod_dbeq         = \qr/^\s*$op_reg_idx$del$op_rel\s*$/i;   #$1:register $1:address
*amod_dbne         = \$amod_dbeq;
*amod_tbeq         = \$amod_dbeq;
*amod_tbne         = \$amod_dbeq;
*amod_ibeq         = \$amod_dbeq;
*amod_ibne         = \$amod_dbeq;

*amod_trap         = \qr/^\s*$op_trap\s*$/i; #$1:value

#HC11 address modes
*amod_hc11_indx         = \qr/^\s*$op_indx\s*$/i; #$1:offset
*amod_hc11_indy         = \qr/^\s*$op_indy\s*$/i; #$1:offset
*amod_hc11_indx_msk     = \qr/^\s*$op_indx$del$op_msk\s*$/i; #$1:offset $2:mask
*amod_hc11_indy_msk     = \qr/^\s*$op_indy$del$op_msk\s*$/i; #$1:offset $2:mask
*amod_hc11_indx_msk_rel = \qr/^\s*$op_indx$del$op_msk$del$op_rel\s*$/i; #$1:offset $2:mask $3:address
*amod_hc11_indy_msk_rel = \qr/^\s*$op_indy$del$op_msk$del$op_rel\s*$/i; #$1:offset $2:mask $3:address

#S12X address modes
*amod_s12x_dir          = \$amod_dir;
*amod_s12x_dir_msk      = \$amod_dir_msk;
*amod_s12x_dir_msk_rel  = \$amod_dir_msk_rel;

*amod_imm8_idx1         = \qr/^\s*$op_imm$del$op_idx1\s*$/i; #$1:data $2:offset $3:register;
*amod_imm8_idx2         = \$amod_imm8_idx1;
*amod_imm8_ididx        = \qr/^\s*$op_imm$del$op_ididx\s*$/i; #$1:data $2:register;
*amod_imm8_iidx2        = \qr/^\s*$op_imm$del$op_iidx2\s*$/i; #$1:data $2:offset $3:register;
*amod_imm8_iext         = \qr/^\s*$op_imm$del$op_iext\s*$/i;  #$1:data $2:address;

*amod_imm16_idx1        = \$amod_imm8_idx1;
*amod_imm16_idx2        = \$amod_imm8_idx2;
*amod_imm16_ididx       = \$amod_imm8_ididx;
*amod_imm16_iidx2       = \$amod_imm8_iidx2;
*amod_imm16_iext        = \$amod_imm8_iext;

*amod_ext_idx1          = \qr/^\s*$op_ext$del$op_idx1\s*$/i;  #$1:address $2:offset $3:register;
*amod_ext_idx2          = \$amod_ext_idx1;
*amod_ext_ididx         = \qr/^\s*$op_ext$del$op_ididx\s*$/i; #$1:address $2:register;
*amod_ext_iidx2         = \qr/^\s*$op_ext$del$op_iidx2\s*$/i; #$1:address $2:offset $3:register;
*amod_ext_iext          = \qr/^\s*$op_ext$del$op_iext\s*$/i;  #$1:address $2:address;

*amod_idx_idx1          = \qr/^\s*$op_idx$del$op_idx1\s*$/i;  #$1:offset $2:preop $3:register $4:postop $5:offset $6:register;
*amod_idx_idx2          = \$amod_idx_idx1;
*amod_idx_ididx         = \qr/^\s*$op_idx$del$op_ididx\s*$/i; #$1:offset $2:preop $3:register $4:postop $5:register;
*amod_idx_iidx2         = \qr/^\s*$op_idx$del$op_iidx2\s*$/i; #$1:offset $2:preop $3:register $4:postop $5:offset $6:register;
*amod_idx_iext          = \qr/^\s*$op_idx$del$op_iext\s*$/i;  #$1:offset $2:preop $3:register $4:postop $5:address;

*amod_idx1_ext          = \qr/^\s*$op_idx1$del$op_ext\s*$/i;  #$1:offset $2:register $3:address;
*amod_idx1_idx          = \qr/^\s*$op_idx1$del$op_idx\s*$/i;  #$1:offset $2:register $3:offset $4:preop $5:register $6:postop;
*amod_idx1_idx1         = \qr/^\s*$op_idx1$del$op_idx1\s*$/i; #$1:offset $2:register $3:offset $4:register;
*amod_idx1_idx2         = \$amod_idx1_idx1;
*amod_idx1_ididx        = \qr/^\s*$op_idx1$del$op_ididx\s*$/i;#1$:offset $2:register $3:register;
*amod_idx1_iidx2        = \qr/^\s*$op_idx1$del$op_iidx2\s*$/i;#1$:offset $2:register $3:offset $4:register;
*amod_idx1_iext         = \qr/^\s*$op_idx1$del$op_iext\s*$/i; #1$:offset $2:register $3:address;

*amod_idx2_ext          = \$amod_idx1_ext;
*amod_idx2_idx          = \$amod_idx1_idx;
*amod_idx2_idx1         = \$amod_idx1_idx1;
*amod_idx2_idx2         = \$amod_idx1_idx1;
*amod_idx2_ididx        = \$amod_idx1_ididx;
*amod_idx2_iidx2        = \$amod_idx1_iidx2;
*amod_idx2_iext         = \$amod_idx1_iext;

*amod_ididx_ext         = \qr/^\s*$op_ididx$del$op_ext\s*$/i;  #$1:register $2:address;
*amod_ididx_idx         = \qr/^\s*$op_ididx$del$op_idx\s*$/i;  #$1:register $2:offset $3:preop $4:register $5:postop;
*amod_ididx_idx1        = \qr/^\s*$op_ididx$del$op_idx1\s*$/i; #$1:register $2:offset $3:register;
*amod_ididx_idx2        = \$amod_ididx_idx1;
*amod_ididx_ididx       = \qr/^\s*$op_ididx$del$op_ididx\s*$/i;#$1:register $2:register;
*amod_ididx_iidx2       = \qr/^\s*$op_ididx$del$op_iidx2\s*$/i;#$1:register $2:offset $3:register;
*amod_ididx_iext        = \qr/^\s*$op_ididx$del$op_iext\s*$/i; #$1:register $2:address;

*amod_iidx2_ext         = \qr/^\s*$op_iidx2$del$op_ext\s*$/i;  #$1:offset $2:register $3:address;
*amod_iidx2_idx         = \qr/^\s*$op_iidx2$del$op_idx\s*$/i;  #$1:offset $2:register $3:offset $4:preop $5:register $6:postop;
*amod_iidx2_idx1        = \qr/^\s*$op_iidx2$del$op_idx1\s*$/i; #$1:offset $2:register $3:offset $4:register;
*amod_iidx2_idx2        = \$amod_iidx2_idx1;
*amod_iidx2_ididx       = \qr/^\s*$op_iidx2$del$op_ididx\s*$/i;#$1:offset $2:register $3:register;
*amod_iidx2_iidx2       = \qr/^\s*$op_iidx2$del$op_iidx2\s*$/i;#$1:offset $2:register $3:offset $4:register;
*amod_iidx2_iext        = \qr/^\s*$op_iidx2$del$op_iext\s*$/i; #$1:offset $2:register $3:address;

*amod_iext_ext          = \qr/^\s*$op_iext$del$op_ext\s*$/i;  #$1:address $2:address;
*amod_iext_idx          = \qr/^\s*$op_iext$del$op_idx\s*$/i;  #$1:address $2:offset $3:preop $4:register $5:postop;
*amod_iext_idx1         = \qr/^\s*$op_iext$del$op_idx1\s*$/i; #$1:address $2:offset $3:register;
*amod_iext_idx2         = \$amod_iext_idx1;
*amod_iext_ididx        = \qr/^\s*$op_iext$del$op_ididx\s*$/i;#$1:address $2:register;
*amod_iext_iidx2        = \qr/^\s*$op_iext$del$op_iidx2\s*$/i;#$1:address $2:offset $3:register;
*amod_iext_iext         = \qr/^\s*$op_iext$del$op_iext\s*$/i; #$1:address $2:address;

*amod_s12x_exg          = \qr/^\s*$op_s12x_reg_src$del$op_s12x_reg_dst\s*$/i; #$1:register $1:register
*amod_s12x_tfr          = \$amod_s12x_exg;                                    #$1:register $1:register

*amod_s12x_trap         = \$amod_trap;

#XGATE address modes
*amod_xgate_imm3        = \qr/^\s*$op_imm\s*$/i;                                                                  #$1:value
*amod_xgate_imm4        = \qr/^\s*$op_xgate_reg_gpr$del$op_imm\s*$/i;                                             #$1:register $2:value
*amod_xgate_imm8        = \$amod_xgate_imm4;
*amod_xgate_imm16       = \$amod_xgate_imm4;
*amod_xgate_mon         = \qr/^\s*$op_xgate_reg_gpr\s*$/i;                                                        #$1:register
*amod_xgate_dya         = \qr/^\s*$op_xgate_reg_gpr$del$op_xgate_reg_gpr\s*$/i;                                   #$1:register
*amod_xgate_tri         = \qr/^\s*$op_xgate_reg_gpr$del$op_xgate_reg_gpr$del$op_xgate_reg_gpr\s*$/i;              #$1:register
*amod_xgate_rel9        = \qr/^\s*$op_rel\s*$/i;                                                                  #$1:address
*amod_xgate_rel10       = \$amod_xgate_rel9;
*amod_xgate_ido5        = \qr/^\s*$op_xgate_reg_gpr$del\(\s*$op_xgate_reg_gpr\s*,\s*$op_imm\s*\)\s*$/i;             #$1:register $2:register $3:offset
*amod_xgate_idr         = \qr/^\s*$op_xgate_reg_gpr$del\(\s*$op_xgate_reg_gpr\s*,\s*$op_xgate_reg_gpr\s*\)\s*$/i;   #$1:register $2:register $3:register
*amod_xgate_idri        = \qr/^\s*$op_xgate_reg_gpr$del\(\s*$op_xgate_reg_gpr\s*,\s*$op_xgate_reg_gpr[+]\s*\)\s*$/i;#$1:register $2:register $3:register
*amod_xgate_idrd        = \qr/^\s*$op_xgate_reg_gpr$del\(\s*$op_xgate_reg_gpr\s*,\s*[-]$op_xgate_reg_gpr\s*\)\s*$/i;#$1:register $2:register $3:register
*amod_xgate_tfr_rd_ccr  = \qr/^\s*$op_xgate_reg_gpr$del\CCR\s*$/i;                                                  #$1:register
*amod_xgate_tfr_ccr_rs  = \qr/^\s*CCR$del$op_xgate_reg_gpr\s*$/i;                                                   #$1:register
*amod_xgate_tfr_rd_pc   = \qr/^\s*$op_xgate_reg_gpr$del[P]C\s*$/i;                                                  #$1:register

##############################
# pseudo opcocde expressions #
##############################
*psop_no_arg      = \qr/^\s*$/i; #
*psop_1_arg       = \qr/^\s*$op_psop\s*$/i; #$1:arg
*psop_2_args      = \qr/^\s*$op_psop$del$op_psop\s*$/i; #$1:arg $2:arg
*psop_3_args      = \qr/^\s*$op_psop$del$op_psop$del$op_psop\s*$/i; #$1:arg $2:arg $3:arg
*psop_string      = \qr/^\s*(.+)\s*$/i; #$1:string

#######################
# operand expressions #
#######################
*op_unmapped           = \qr/^\s*UNMAPPED\s*$/i;
*op_oprtr              = \qr/\-|\+|\*|\/|%|&|\||~|<<|>>/;
*op_no_oprtr           = \qr/[^\-\+\/%&\|~<>\s]/;
*op_term               = \qr/\%[01]+|[0-9]+|\$[0-9a-fA-F]+|\"(\w)\"|\*|\@/;
*op_binery             = \qr/^\s*([~\-]?)\s*\%([01_]+)\s*$/; #$1:complement $2:binery number
*op_dec                = \qr/^\s*([~\-]?)\s*([0-9_]+)\s*$/; #$1:complement $2:decimal number
*op_hex                = \qr/^\s*([~\-]?)\s*\$([0-9a-fA-F_]+)\s*$/; #$1:complement $2:hex number
*op_ascii              = \qr/^\s*([~\-]?)\s*[\'\"](.+)[\'\"]\s*$/; #$1:complement $2:ASCII caracter
*op_symbol             = \qr/^\s*([~\-]?)\s*([\w]+[\`]?)\s*$/; #$1:complement $2:symbol
#*op_symbol             = \qr/^\s*([~\-]?)\s*([\w]+[\`]?|[\`])\s*$/; #$1:complement $2:symbol
*op_curr_lin_pc        = \qr/^\s*([~\-]?)\s*\@\s*$/;
*op_curr_pag_pc        = \qr/^\s*([~\-]?)\s*\*\s*$/;
*op_formula            = \qr/^\s*($op_psop)\s*$/; #$1:formula
*op_formula_pars       = \qr/^\s*(.*)\s*\(\s*([^\(\)]+)\s*\)\s*(.*)\s*$/; #$1:leftside $2:inside $3:rightside
*op_formula_complement = \qr/^\s*([~\-])\s*([~\-].*)\s*$/; #$1:leftside $2:rightside
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

########################
# compiler expressions #
########################
*cmp_no_hexcode        = \qr/^\s*(.*?[^0-9a-fA-F\ ].*?)\s*$/; #$1:string

#############
# cpu types #
#############
*cpu_hc11               = \qr/^\s*HC11\s*$/i;
*cpu_s12                = \qr/^\s*((HC)|(S))12\s*$/i;
*cpu_s12x               = \qr/^\s*S12X\s*$/i;
*cpu_xgate              = \qr/^\s*XGATE\s*$/i;

#################
# opcode tables #
#################
#HC11:           MNEMONIC      ADDRESS MODE                                             OPCODE
*opctab_hc11 = \{"ABA"    => [[$amod_inh,               \&check_inh,                    "1B"   ]], #INH
                 "ABX"    => [[$amod_inh,               \&check_inh,                    "3A"   ]], #INH
                 "ABY"    => [[$amod_inh,               \&check_inh,                    "18 3A"]], #INH
                 "ADCA"   => [[$amod_imm8,              \&check_imm8,                   "89"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "99"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B9"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "A9"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 A9"]], #IND,Y
                 "ADCB"   => [[$amod_imm8,              \&check_imm8,                   "C9"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D9"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F9"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "E9"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 E9"]], #IND,Y
                 "ADDA"   => [[$amod_imm8,              \&check_imm8,                   "8B"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "9B"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BB"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "AB"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 AB"]], #IND,Y
                 "ADDB"   => [[$amod_imm8,              \&check_imm8,                   "CB"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "DB"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FB"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "EB"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 EB"]], #IND,Y
                 "ADDD"   => [[$amod_imm16,             \&check_imm16,                  "C3"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D3"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F3"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "E3"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 E3"]], #IND,Y
                 "ANDA"   => [[$amod_imm8,              \&check_imm8,                   "84"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "94"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B4"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "A4"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 A4"]], #IND,Y
                 "ANDB"   => [[$amod_imm8,              \&check_imm8,                   "C4"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D4"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F4"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "E4"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 E4"]], #IND,Y
                 "ASL"    => [[$amod_ext,               \&check_ext,                    "78"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "68"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 68"]], #IND,Y
                 "ASLA"   => [[$amod_inh,               \&check_inh,                    "48"   ]], #INH
                 "ASLB"   => [[$amod_inh,               \&check_inh,                    "58"   ]], #INH
                 "ASLD"   => [[$amod_inh,               \&check_inh,                    "05"   ]], #INH
                 "ASR"    => [[$amod_ext,               \&check_ext,                    "77"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "67"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 67"]], #IND,Y
                 "ASRA"   => [[$amod_inh,               \&check_inh,                    "47"   ]], #INH
                 "ASRB"   => [[$amod_inh,               \&check_inh,                    "57"   ]], #INH
                 "BCC"    => [[$amod_rel8,              \&check_rel8,                   "24"   ]], #REL
                 "BCLR"   => [[$amod_dir_msk,           \&check_dir_msk,                "15"   ],  #DIR
                              [$amod_hc11_indx_msk,     \&check_hc11_indx_msk,          "1D"   ],  #IND,X
                              [$amod_hc11_indy_msk,     \&check_hc11_indy_msk,          "18 1D"]], #IND,Y
                 "BCS"    => [[$amod_rel8,              \&check_rel8,                   "25"   ]], #REL
                 "BEQ"    => [[$amod_rel8,              \&check_rel8,                   "27"   ]], #REL
                 "BGE"    => [[$amod_rel8,              \&check_rel8,                   "2C"   ]], #REL
                 "BGT"    => [[$amod_rel8,              \&check_rel8,                   "2E"   ]], #REL
                 "BHI"    => [[$amod_rel8,              \&check_rel8,                   "22"   ]], #REL
                 "BHS"    => [[$amod_rel8,              \&check_rel8,                   "24"   ]], #REL
                 "BITA"   => [[$amod_imm8,              \&check_imm8,                   "85"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "95"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B5"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "A5"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 A5"]], #IND,Y
                 "BITB"   => [[$amod_imm8,              \&check_imm8,                   "C5"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D5"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F5"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "E5"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 E5"]], #IND,Y
                 "BLE"    => [[$amod_rel8,              \&check_rel8,                   "2F"   ]], #REL
                 "BLO"    => [[$amod_rel8,              \&check_rel8,                   "25"   ]], #REL
                 "BLS"    => [[$amod_rel8,              \&check_rel8,                   "23"   ]], #REL
                 "BLT"    => [[$amod_rel8,              \&check_rel8,                   "2D"   ]], #REL
                 "BMI"    => [[$amod_rel8,              \&check_rel8,                   "2B"   ]], #REL
                 "BNE"    => [[$amod_rel8,              \&check_rel8,                   "26"   ]], #REL
                 "BPL"    => [[$amod_rel8,              \&check_rel8,                   "2A"   ]], #REL
                 "BRA"    => [[$amod_rel8,              \&check_rel8,                   "20"   ]], #REL
                 "BRCLR"  => [[$amod_dir_msk_rel,       \&check_dir_msk_rel,            "13"   ],  #DIR
                              [$amod_hc11_indx_msk_rel, \&check_hc11_indx_msk_rel,      "1F"   ],  #IND,X
                              [$amod_hc11_indy_msk_rel, \&check_hc11_indy_msk_rel,      "18 1F"]], #IND,Y
                 "BRN"    => [[$amod_rel8,              \&check_rel8,                   "21"   ]], #REL
                 "BRSET"  => [[$amod_dir_msk_rel,       \&check_dir_msk_rel,            "12"   ],  #DIR
                              [$amod_hc11_indx_msk_rel, \&check_hc11_indx_msk_rel,      "1E"   ],  #IND,X
                              [$amod_hc11_indy_msk_rel, \&check_hc11_indy_msk_rel,      "18 1E"]], #IND,Y
                 "BSET"   => [[$amod_dir_msk,           \&check_dir_msk,                "14"   ],  #DIR
                              [$amod_hc11_indx_msk,     \&check_hc11_indx_msk,          "1C"   ],  #IND,X
                              [$amod_hc11_indy_msk,     \&check_hc11_indy_msk,          "18 1C"]], #IND,Y
                 "BSR"    => [[$amod_rel8,              \&check_rel8,                   "8D"   ]], #REL
                 "BVC"    => [[$amod_rel8,              \&check_rel8,                   "28"   ]], #REL
                 "BVS"    => [[$amod_rel8,              \&check_rel8,                   "29"   ]], #REL
                 "CBA"    => [[$amod_inh,               \&check_inh,                    "11"   ]], #INH
                 "CLC"    => [[$amod_inh,               \&check_inh,                    "0C"   ]], #INH
                 "CLI"    => [[$amod_inh,               \&check_inh,                    "0E"   ]], #INH
                 "CLR"    => [[$amod_ext,               \&check_ext,                    "7F"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "6F"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 6F"]], #IND,Y
                 "CLRA"   => [[$amod_inh,               \&check_inh,                    "4F"   ]], #INH
                 "CLRB"   => [[$amod_inh,               \&check_inh,                    "5F"   ]], #INH
                 "CLV"    => [[$amod_inh,               \&check_inh,                    "0A"   ]], #INH
                 "CMPA"   => [[$amod_imm8,              \&check_imm8,                   "81"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "91"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B1"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "A1"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 A1"]], #IND,Y
                 "CMPB"   => [[$amod_imm8,              \&check_imm8,                   "C1"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D1"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F1"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "E1"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 E1"]], #IND,Y
                 "COM"    => [[$amod_ext,               \&check_ext,                    "73"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "63"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 63"]], #IND,Y
                 "COMA"   => [[$amod_inh,               \&check_inh,                    "43"   ]], #INH
                 "COMB"   => [[$amod_inh,               \&check_inh,                    "53"   ]], #INH
                 "CPD"    => [[$amod_imm16,             \&check_imm16,                  "1A 83"],  #IMM
                              [$amod_dir,               \&check_dir,                    "1A 93"],  #DIR
                              [$amod_ext,               \&check_ext,                    "1A B3"],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "1A A3"],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "CD A3"]], #IND,Y
                 "CPX"    => [[$amod_imm16,             \&check_imm16,                  "8C"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "9C"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BC"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "AC"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "CD AC"]], #IND,Y
                 "CPY"    => [[$amod_imm16,             \&check_imm16,                  "18 8D"],  #IMM
                              [$amod_dir,               \&check_dir,                    "18 9D"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 BD"],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "1A AC"],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 AC"]], #IND,Y
                 "DAA"    => [[$amod_inh,               \&check_inh,                    "19"   ]], #INH
                 "DEC"    => [[$amod_ext,               \&check_ext,                    "7A"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "6A"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 6A"]], #IND,Y
                 "DECA"   => [[$amod_inh,               \&check_inh,                    "4A"   ]], #INH
                 "DECB"   => [[$amod_inh,               \&check_inh,                    "5A"   ]], #INH
                 "DES"    => [[$amod_inh,               \&check_inh,                    "34"   ]], #INH
                 "DEX"    => [[$amod_inh,               \&check_inh,                    "09"   ]], #INH
                 "DEY"    => [[$amod_inh,               \&check_inh,                    "18 09"]], #INH
                 "EORA"   => [[$amod_imm8,              \&check_imm8,                   "88"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "98"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B8"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "A8"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 A8"]], #IND,Y
                 "EORB"   => [[$amod_imm8,              \&check_imm8,                   "C8"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D8"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F8"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "E8"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 E8"]], #IND,Y
                 "FDIV"   => [[$amod_inh,               \&check_inh,                    "03"   ]], #INH
                 "IDIV"   => [[$amod_inh,               \&check_inh,                    "02"   ]], #INH
                 "INC"    => [[$amod_ext,               \&check_ext,                    "7C"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "6C"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 6C"]], #IND,Y
                 "INCA"   => [[$amod_inh,               \&check_inh,                    "4C"   ]], #INH
                 "INCB"   => [[$amod_inh,               \&check_inh,                    "5C"   ]], #INH
                 "INS"    => [[$amod_inh,               \&check_inh,                    "31"   ]], #INH
                 "INX"    => [[$amod_inh,               \&check_inh,                    "08"   ]], #INH
                 "INY"    => [[$amod_inh,               \&check_inh,                    "18 08"]], #INH
                 "JMP"    => [[$amod_ext,               \&check_ext,                    "7E"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "6E"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 6E"]], #IND,Y
                 "JSR"    => [[$amod_dir,               \&check_dir,                    "9D"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BD"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "AD"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 AD"]], #IND,Y
                 "LDAA"   => [[$amod_imm8,              \&check_imm8,                   "86"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "96"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B6"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "A6"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 A6"]], #IND,Y
                 "LDAB"   => [[$amod_imm8,              \&check_imm8,                   "C6"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D6"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F6"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "E6"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 E6"]], #IND,Y
                 "LDD"    => [[$amod_imm16,             \&check_imm16,                  "CC"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "DC"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FC"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "EC"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 EC"]], #IND,Y
                 "LDS"    => [[$amod_imm16,             \&check_imm16,                  "8E"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "9E"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BE"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "AE"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 AE"]], #IND,Y
                 "LDX"    => [[$amod_imm16,             \&check_imm16,                  "CE"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "DE"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FE"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "EE"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "CD EE"]], #IND,Y
                 "LDY"    => [[$amod_imm16,             \&check_imm16,                  "18 CE"],  #IMM
                              [$amod_dir,               \&check_dir,                    "18 DE"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 FE"],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "1A EE"],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 EE"]], #IND,Y
                 "LSL"    => [[$amod_ext,               \&check_ext,                    "78"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "68"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 68"]], #IND,Y
                 "LSLA"   => [[$amod_inh,               \&check_inh,                    "48"   ]], #INH
                 "LSLB"   => [[$amod_inh,               \&check_inh,                    "58"   ]], #INH
                 "LSLD"   => [[$amod_inh,               \&check_inh,                    "05"   ]], #INH
                 "LSR"    => [[$amod_ext,               \&check_ext,                    "74"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "64"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 64"]], #IND,Y
                 "LSRA"   => [[$amod_inh,               \&check_inh,                    "44"   ]], #INH
                 "LSRB"   => [[$amod_inh,               \&check_inh,                    "54"   ]], #INH
                 "LSRD"   => [[$amod_inh,               \&check_inh,                    "04"   ]], #INH
                 "MUL"    => [[$amod_inh,               \&check_inh,                    "3D"   ]], #INH
                 "NEG"    => [[$amod_ext,               \&check_ext,                    "70"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "60"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 60"]], #IND,Y
                 "NEGA"   => [[$amod_inh,               \&check_inh,                    "40"   ]], #INH
                 "NEGB"   => [[$amod_inh,               \&check_inh,                    "50"   ]], #INH
                 "NOP"    => [[$amod_inh,               \&check_inh,                    "01"   ]], #INH
                 "ORAA"   => [[$amod_imm8,              \&check_imm8,                   "8A"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "9A"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BA"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "AA"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 AA"]], #IND,Y
                 "ORAB"   => [[$amod_imm8,              \&check_imm8,                   "CA"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "DA"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FA"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "EA"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 EA"]], #IND,Y
                 "PSHA"   => [[$amod_inh,               \&check_inh,                    "36"   ]], #INH
                 "PSHB"   => [[$amod_inh,               \&check_inh,                    "37"   ]], #INH
                 "PSHX"   => [[$amod_inh,               \&check_inh,                    "3C"   ]], #INH
                 "PSHY"   => [[$amod_inh,               \&check_inh,                    "18 3C"]], #INH
                 "PULA"   => [[$amod_inh,               \&check_inh,                    "32"   ]], #INH
                 "PULB"   => [[$amod_inh,               \&check_inh,                    "33"   ]], #INH
                 "PULX"   => [[$amod_inh,               \&check_inh,                    "38"   ]], #INH
                 "PULY"   => [[$amod_inh,               \&check_inh,                    "18 38"]], #INH
                 "ROL"    => [[$amod_ext,               \&check_ext,                    "79"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "69"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 69"]], #IND,Y
                 "ROLA"   => [[$amod_inh,               \&check_inh,                    "49"   ]], #INH
                 "ROLB"   => [[$amod_inh,               \&check_inh,                    "59"   ]], #INH
                 "ROR"    => [[$amod_ext,               \&check_ext,                    "76"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "66"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 66"]], #IND,Y
                 "RORA"   => [[$amod_inh,               \&check_inh,                    "46"   ]], #INH
                 "RORB"   => [[$amod_inh,               \&check_inh,                    "56"   ]], #INH
                 "RTI"    => [[$amod_inh,               \&check_inh,                    "3B"   ]], #INH
                 "RTS"    => [[$amod_inh,               \&check_inh,                    "39"   ]], #INH
                 "SBA"    => [[$amod_inh,               \&check_inh,                    "10"   ]], #INH
                 "SBCA"   => [[$amod_imm8,              \&check_imm8,                   "82"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "92"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B2"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "A2"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 A2"]], #IND,Y
                 "SBCB"   => [[$amod_imm8,              \&check_imm8,                   "C2"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D2"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F2"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "E2"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 E2"]], #IND,Y
                 "SEC"    => [[$amod_inh,               \&check_inh,                    "0D"   ]], #INH
                 "SEI"    => [[$amod_inh,               \&check_inh,                    "0F"   ]], #INH
                 "SEV"    => [[$amod_inh,               \&check_inh,                    "0B"   ]], #INH
                 "STAA"   => [[$amod_dir,               \&check_dir,                    "97"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B7"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "A7"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 A7"]], #IND,Y
                 "STAB"   => [[$amod_dir,               \&check_dir,                    "D7"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F7"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "E7"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 E7"]], #IND,Y
                 "STD"    => [[$amod_dir,               \&check_dir,                    "DD"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FD"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "ED"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 ED"]], #IND,Y
                 "STOP"   => [[$amod_inh,               \&check_inh,                    "18 3E"]], #INH
                 "STS"    => [[$amod_dir,               \&check_dir,                    "9F"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BF"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "AF"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 AF"]], #IND,Y
                 "STX"    => [[$amod_dir,               \&check_dir,                    "DF"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FF"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "EF"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "CD EF"]], #IND,Y
                 "STY"    => [[$amod_dir,               \&check_dir,                    "18 DF"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 FF"],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "1A EF"],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 EF"]], #IND,Y
                 "SUBA"   => [[$amod_imm8,              \&check_imm8,                   "80"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "90"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B0"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "A0"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 A0"]], #IND,Y
                 "SUBB"   => [[$amod_imm8,              \&check_imm8,                   "C0"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D0"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F0"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "E0"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 E0"]], #IND,Y
                 "SUBD"   => [[$amod_imm16,             \&check_imm16,                  "83"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "93"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B3"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "A3"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 A3"]], #IND,Y
                 "SWI"    => [[$amod_inh,               \&check_inh,                    "3F"   ]], #INH
                 "TAB"    => [[$amod_inh,               \&check_inh,                    "16"   ]], #INH
                 "TAP"    => [[$amod_inh,               \&check_inh,                    "06"   ]], #INH
                 "TBA"    => [[$amod_inh,               \&check_inh,                    "17"   ]], #INH
                 "TEST"   => [[$amod_inh,               \&check_inh,                    "00"   ]], #INH
                 "TPA"    => [[$amod_inh,               \&check_inh,                    "07"   ]], #INH
                 "TST"    => [[$amod_ext,               \&check_ext,                    "7D"   ],  #EXT
                              [$amod_hc11_indx,         \&check_hc11_indx,              "6D"   ],  #IND,X
                              [$amod_hc11_indy,         \&check_hc11_indy,              "18 6D"]], #IND,Y
                 "TSTA"   => [[$amod_inh,               \&check_inh,                    "4D"   ]], #INH
                 "TSTB"   => [[$amod_inh,               \&check_inh,                    "5D"   ]], #INH
                 "TSX"    => [[$amod_inh,               \&check_inh,                    "30"   ]], #INH
                 "TSY"    => [[$amod_inh,               \&check_inh,                    "18 30"]], #INH
                 "TXS"    => [[$amod_inh,               \&check_inh,                    "35"   ]], #INH
                 "TYS"    => [[$amod_inh,               \&check_inh,                    "18 35"]], #INH
                 "WAI"    => [[$amod_inh,               \&check_inh,                    "3E"   ]], #INH
                 "XGDX"   => [[$amod_inh,               \&check_inh,                    "8F"   ]], #INH
                 "XGDY"   => [[$amod_inh,               \&check_inh,                    "18 8F"]]};#INH

#HC12/S12:      MNEMONIC      ADDRESS MODE                                              OPCODE
*opctab_s12 =  \{"ABA"    => [[$amod_inh,               \&check_inh,                    "18 06"]], #INH
                 "ABX"    => [[$amod_inh,               \&check_inh,                    "1A E5"]], #INH
                 "ABY"    => [[$amod_inh,               \&check_inh,                    "19 ED"]], #INH
                 "ADCA"   => [[$amod_imm8,              \&check_imm8,                   "89"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "99"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B9"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A9"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A9"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A9"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A9"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A9"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A9"   ]], #[EXT]
                 "ADCB"   => [[$amod_imm8,              \&check_imm8,                   "C9"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D9"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F9"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E9"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E9"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E9"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E9"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E9"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E9"   ]], #[EXT]
                 "ADDA"   => [[$amod_imm8,              \&check_imm8,                   "8B"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "9B"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BB"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "AB"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "AB"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "AB"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "AB"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "AB"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "AB"   ]], #[EXT]
                 "ADDB"   => [[$amod_imm8,              \&check_imm8,                   "CB"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "DB"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FB"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "EB"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "EB"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "EB"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "EB"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "EB"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "EB"   ]], #[EXT]
                 "ADDD"   => [[$amod_imm16,             \&check_imm16,                  "C3"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D3"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F3"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E3"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E3"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E3"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E3"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E3"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E3"   ]], #[EXT]
                 "ANDA"   => [[$amod_imm8,              \&check_imm8,                   "84"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "94"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B4"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A4"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A4"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A4"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A4"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A4"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A4"   ]], #[EXT]
                 "ANDB"   => [[$amod_imm8,              \&check_imm8,                   "C4"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D4"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F4"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E4"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E4"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E4"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E4"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E4"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E4"   ]], #[EXT]
                 "ANDCC"  => [[$amod_imm8,              \&check_imm8,                   "10"   ]], #IMM
                 "ASL"    => [[$amod_ext,               \&check_ext,                    "78"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "68"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "68"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "68"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "68"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "68"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "68"   ]], #[EXT]
                 "ASLA"   => [[$amod_inh,               \&check_inh,                    "48"   ]], #INH
                 "ASLB"   => [[$amod_inh,               \&check_inh,                    "58"   ]], #INH
                 "ASLD"   => [[$amod_inh,               \&check_inh,                    "59"   ]], #INH
                 "ASR"    => [[$amod_ext,               \&check_ext,                    "77"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "67"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "67"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "67"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "67"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "67"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "67"   ]], #[EXT]
                 "ASRA"   => [[$amod_inh,               \&check_inh,                    "47"   ]], #INH
                 "ASRB"   => [[$amod_inh,               \&check_inh,                    "57"   ]], #INH
                 "BCC"    => [[$amod_rel8,              \&check_rel8,                   "24"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 24"]], #REL
                 "BCLR"   => [[$amod_dir_msk,           \&check_dir_msk,                "4D"   ],  #DIR
                              [$amod_ext_msk,           \&check_ext_msk,                "1D"   ],  #EXT
                              [$amod_idx_msk,           \&check_idx_msk,                "0D"   ],  #IDX
                              [$amod_idx1_msk,          \&check_idx1_msk,               "0D"   ],  #IDX1
                              [$amod_idx2_msk,          \&check_idx2_msk,               "0D"   ]], #IDX2
                 "BCS"    => [[$amod_rel8,              \&check_rel8,                   "25"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 25"]], #REL
                 "BEQ"    => [[$amod_rel8,              \&check_rel8,                   "27"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 27"]], #REL
                 "BGE"    => [[$amod_rel8,              \&check_rel8,                   "2C"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 2C"]], #REL
                 "BGND"   => [[$amod_inh,               \&check_inh,                    "00"   ]], #INH
                 "BGT"    => [[$amod_rel8,              \&check_rel8,                   "2E"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 2E"]], #REL
                 "BHI"    => [[$amod_rel8,              \&check_rel8,                   "22"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 22"]], #REL
                 "BHS"    => [[$amod_rel8,              \&check_rel8,                   "24"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 24"]], #REL
                 "BITA"   => [[$amod_imm8,              \&check_imm8,                   "85"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "95"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B5"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A5"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A5"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A5"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A5"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A5"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A5"   ]], #[EXT]
                 "BITB"   => [[$amod_imm8,              \&check_imm8,                   "C5"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D5"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F5"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E5"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E5"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E5"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E5"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E5"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E5"   ]], #[EXT]
                 "BLE"    => [[$amod_rel8,              \&check_rel8,                   "2F"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 2F"]], #REL
                 "BLO"    => [[$amod_rel8,              \&check_rel8,                   "25"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 25"]], #REL
                 "BLS"    => [[$amod_rel8,              \&check_rel8,                   "23"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 23"]], #REL
                 "BLT"    => [[$amod_rel8,              \&check_rel8,                   "2D"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 2D"]], #REL
                 "BMI"    => [[$amod_rel8,              \&check_rel8,                   "2B"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 2B"]], #REL
                 "BNE"    => [[$amod_rel8,              \&check_rel8,                   "26"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 26"]], #REL
                 "BPL"    => [[$amod_rel8,              \&check_rel8,                   "2A"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 2A"]], #REL
                 "BRA"    => [[$amod_rel8,              \&check_rel8,                   "20"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 20"]], #REL
                 "BRCLR"  => [[$amod_dir_msk_rel,       \&check_dir_msk_rel,            "4F"   ],  #DIR
                              [$amod_ext_msk_rel,       \&check_ext_msk_rel,            "1F"   ],  #EXT
                              [$amod_idx_msk_rel,       \&check_idx_msk_rel,            "0F"   ],  #IDX
                              [$amod_idx1_msk_rel,      \&check_idx1_msk_rel,           "0F"   ],  #IDX1
                              [$amod_idx2_msk_rel,      \&check_idx2_msk_rel,           "0F"   ]], #IDX2
                 "BRN"    => [[$amod_rel8,              \&check_rel8,                   "21"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 21"]], #REL
                 "BRSET"  => [[$amod_dir_msk_rel,       \&check_dir_msk_rel,            "4E"   ],  #DIR
                              [$amod_ext_msk_rel,       \&check_ext_msk_rel,            "1E"   ],  #EXT
                              [$amod_idx_msk_rel,       \&check_idx_msk_rel,            "0E"   ],  #IDX
                              [$amod_idx1_msk_rel,      \&check_idx1_msk_rel,           "0E"   ],  #IDX1
                              [$amod_idx2_msk_rel,      \&check_idx2_msk_rel,           "0E"   ]], #IDX2
                 "BSET"   => [[$amod_dir_msk,           \&check_dir_msk,                "4C"   ],  #DIR
                              [$amod_ext_msk,           \&check_ext_msk,                "1C"   ],  #EXT
                              [$amod_idx_msk,           \&check_idx_msk,                "0C"   ],  #IDX
                              [$amod_idx1_msk,          \&check_idx1_msk,               "0C"   ],  #IDX1
                              [$amod_idx2_msk,          \&check_idx2_msk,               "0C"   ]], #IDX2
                 "BSR"    => [[$amod_rel8,              \&check_rel8,                   "07"   ]], #REL
                 "BVC"    => [[$amod_rel8,              \&check_rel8,                   "28"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 28"]], #REL
                 "BVS"    => [[$amod_rel8,              \&check_rel8,                   "29"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 29"]], #REL
                 "CALL"   => [[$amod_ext_pgimpl,        \&check_ext_pgimpl,             "4A"   ],  #EXT
                              [$amod_ext_pg,            \&check_ext_pg,                 "4A"   ],  #EXT
                              [$amod_idx_pg,            \&check_idx_pg,                 "4B"   ],  #IDX
                              [$amod_idx1_pg,           \&check_idx1_pg,                "4B"   ],  #IDX1
                              [$amod_idx2_pg,           \&check_idx2_pg,                "4B"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "4B"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "4B"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "4B"   ]], #[EXT]
                 "CBA"    => [[$amod_inh,               \&check_inh,                    "18 17"]], #INH
                 "CLC"    => [[$amod_inh,               \&check_inh,                    "10 FE"]], #INH
                 "CLI"    => [[$amod_inh,               \&check_inh,                    "10 EF"]], #INH
                 "CLR"    => [[$amod_ext,               \&check_ext,                    "79"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "69"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "69"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "69"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "69"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "69"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "69"   ]], #[EXT]
                 "CLRA"   => [[$amod_inh,               \&check_inh,                    "87"   ]], #INH
                 "CLRB"   => [[$amod_inh,               \&check_inh,                    "C7"   ]], #INH
                 "CLV"    => [[$amod_inh,               \&check_inh,                    "10 FD"]], #INH
                 "CMPA"   => [[$amod_imm8,              \&check_imm8,                   "81"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "91"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B1"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A1"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A1"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A1"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A1"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A1"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A1"   ]], #[EXT]
                 "CMPB"   => [[$amod_imm8,              \&check_imm8,                   "C1"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D1"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F1"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E1"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E1"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E1"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E1"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E1"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E1"   ]], #[EXT]
                 "COM"    => [[$amod_ext,               \&check_ext,                    "71"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "61"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "61"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "61"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "61"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "61"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "61"   ]], #[EXT]
                 "COMA"   => [[$amod_inh,               \&check_inh,                    "41"   ]], #INH
                 "COMB"   => [[$amod_inh,               \&check_inh,                    "51"   ]], #INH
                 "CPD"    => [[$amod_imm16,             \&check_imm16,                  "8C"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "9C"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BC"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "AC"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "AC"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "AC"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "AC"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "AC"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "AC"   ]], #[EXT]
                 "CPS"    => [[$amod_imm16,             \&check_imm16,                  "8F"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "9F"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BF"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "AF"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "AF"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "AF"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "AF"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "AF"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "AF"   ]], #[EXT]
                 "CPX"    => [[$amod_imm16,             \&check_imm16,                  "8E"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "9E"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BE"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "AE"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "AE"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "AE"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "AE"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "AE"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "AE"   ]], #[EXT]
                 "CPY"    => [[$amod_imm16,             \&check_imm16,                  "8D"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "9D"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BD"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "AD"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "AD"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "AD"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "AD"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "AD"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "AD"   ]], #[EXT]
                 "DAA"    => [[$amod_inh,               \&check_inh,                    "18 07"]], #INH
                 "DBEQ"   => [[$amod_dbeq,              \&check_dbeq,                   "04"   ]], #REL
                 "DBNE"   => [[$amod_dbne,              \&check_dbne,                   "04"   ]], #REL
                 "DEC"    => [[$amod_ext,               \&check_ext,                    "73"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "63"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "63"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "63"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "63"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "63"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "63"   ]], #[EXT]
                 "DECA"   => [[$amod_inh,               \&check_inh,                    "43"   ]], #INH
                 "DECB"   => [[$amod_inh,               \&check_inh,                    "53"   ]], #INH
                 "DES"    => [[$amod_inh,               \&check_inh,                    "1B 9F"]], #INH
                 "DEX"    => [[$amod_inh,               \&check_inh,                    "09"   ]], #INH
                 "DEY"    => [[$amod_inh,               \&check_inh,                    "03"   ]], #INH
                 "EDIV"   => [[$amod_inh,               \&check_inh,                    "11"   ]], #INH
                 "EDIVS"  => [[$amod_inh,               \&check_inh,                    "18 14"]], #INH
                 "EMACS"  => [[$amod_ext,               \&check_ext,                    "18 12"]], #EXT
                 "EMAXD"  => [[$amod_idx,               \&check_idx,                    "18 1A"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 1A"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 1A"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 1A"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 1A"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 1A"]], #[EXT]
                 "EMAXM"  => [[$amod_idx,               \&check_idx,                    "18 1E"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 1E"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 1E"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 1E"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 1E"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 1E"]], #[EXT]
                 "EMIND"  => [[$amod_idx,               \&check_idx,                    "18 1B"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 1B"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 1B"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 1B"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 1B"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 1B"]], #[EXT]
                 "EMINM"  => [[$amod_idx,               \&check_idx,                    "18 1F"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 1F"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 1F"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 1F"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 1F"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 1F"]], #[EXT]
                 "EMUL"   => [[$amod_inh,               \&check_inh,                    "13"   ]], #INH
                 "EMULS"  => [[$amod_inh,               \&check_inh,                    "18 13"]], #INH
                 "EORA"   => [[$amod_imm8,              \&check_imm8,                   "88"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "98"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B8"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A8"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A8"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A8"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A8"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A8"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A8"   ]], #[EXT]
                 "EORB"   => [[$amod_imm8,              \&check_imm8,                   "C8"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D8"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F8"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E8"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E8"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E8"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E8"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E8"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E8"   ]], #[EXT]
                 "ETBL"   => [[$amod_idx,               \&check_idx,                    "18 3F"]], #IDX
                 "EXG"    => [[$amod_exg,               \&check_exg,                    "B7"   ]], #INH
                 "FDIV"   => [[$amod_inh,               \&check_inh,                    "18 11"]], #INH
                 "IBEQ"   => [[$amod_ibeq,              \&check_ibeq,                   "04"   ]], #REL
                 "IBNE"   => [[$amod_ibne,              \&check_ibne,                   "04"   ]], #REL
                 "IDIV"   => [[$amod_inh,               \&check_inh,                    "18 10"]], #INH
                 "IDIVS"  => [[$amod_inh,               \&check_inh,                    "18 15"]], #INH
                 "INC"    => [[$amod_ext,               \&check_ext,                    "72"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "62"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "62"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "62"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "62"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "62"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "62"   ]], #[EXT]
                 "INCA"   => [[$amod_inh,               \&check_inh,                    "42"   ]], #INH
                 "INCB"   => [[$amod_inh,               \&check_inh,                    "52"   ]], #INH
                 "INS"    => [[$amod_inh,               \&check_inh,                    "1B 81"]], #INH
                 "INX"    => [[$amod_inh,               \&check_inh,                    "08"   ]], #INH
                 "INY"    => [[$amod_inh,               \&check_inh,                    "02"   ]], #INH
                 "JMP"    => [[$amod_ext,               \&check_ext,                    "06"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "05"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "05"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "05"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "05"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "05"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "05"   ]], #[EXT]
                 "JOB"    => [[$amod_rel8,              \&check_rel8,                   "20"   ],  #REL
                              [$amod_ext,               \&check_ext,                    "06"   ]], #EXT
                 "JOBSR"  => [[$amod_rel8,              \&check_rel8,                   "07"   ],  #REL
                              [$amod_ext,               \&check_ext,                    "16"   ]], #EXT
                 "JSR"    => [[$amod_dir,               \&check_dir,                    "17"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "16"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "15"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "15"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "15"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "15"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "15"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "15"   ]], #[EXT]
                 "LBCC"   => [[$amod_rel16,             \&check_rel16,                  "18 24"]], #REL
                 "LBCS"   => [[$amod_rel16,             \&check_rel16,                  "18 25"]], #REL
                 "LBEQ"   => [[$amod_rel16,             \&check_rel16,                  "18 27"]], #REL
                 "LBGE"   => [[$amod_rel16,             \&check_rel16,                  "18 2C"]], #REL
                 "LBGT"   => [[$amod_rel16,             \&check_rel16,                  "18 2E"]], #REL
                 "LBHI"   => [[$amod_rel16,             \&check_rel16,                  "18 22"]], #REL
                 "LBHS"   => [[$amod_rel16,             \&check_rel16,                  "18 24"]], #REL
                 "LBLE"   => [[$amod_rel16,             \&check_rel16,                  "18 2F"]], #REL
                 "LBLO"   => [[$amod_rel16,             \&check_rel16,                  "18 25"]], #REL
                 "LBLS"   => [[$amod_rel16,             \&check_rel16,                  "18 23"]], #REL
                 "LBLT"   => [[$amod_rel16,             \&check_rel16,                  "18 2D"]], #REL
                 "LBMI"   => [[$amod_rel16,             \&check_rel16,                  "18 2B"]], #REL
                 "LBNE"   => [[$amod_rel16,             \&check_rel16,                  "18 26"]], #REL
                 "LBPL"   => [[$amod_rel16,             \&check_rel16,                  "18 2A"]], #REL
                 "LBRA"   => [[$amod_rel16,             \&check_rel16,                  "18 20"]], #REL
                 "LBRN"   => [[$amod_rel16,             \&check_rel16,                  "18 21"]], #REL
                 "LBVC"   => [[$amod_rel16,             \&check_rel16,                  "18 28"]], #REL
                 "LBVS"   => [[$amod_rel16,             \&check_rel16,                  "18 29"]], #REL
                 "LDAA"   => [[$amod_imm8,              \&check_imm8,                   "86"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "96"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B6"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A6"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A6"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A6"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A6"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A6"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A6"   ]], #[EXT]
                 "LDAB"   => [[$amod_imm8,              \&check_imm8,                   "C6"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D6"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F6"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E6"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E6"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E6"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E6"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E6"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E6"   ]], #[EXT]
                 "LDD"    => [[$amod_imm16,             \&check_imm16,                  "CC"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "DC"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FC"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "EC"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "EC"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "EC"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "EC"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "EC"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "EC"   ]], #[EXT]
                 "LDS"    => [[$amod_imm16,             \&check_imm16,                  "CF"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "DF"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FF"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "EF"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "EF"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "EF"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "EF"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "EF"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "EF"   ]], #[EXT]
                 "LDX"    => [[$amod_imm16,             \&check_imm16,                  "CE"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "DE"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FE"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "EE"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "EE"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "EE"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "EE"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "EE"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "EE"   ]], #[EXT]
                 "LDY"    => [[$amod_imm16,             \&check_imm16,                  "CD"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "DD"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FD"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "ED"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "ED"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "ED"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "ED"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "ED"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "ED"   ]], #[EXT]
                 "LEAS"   => [[$amod_idx,               \&check_idx,                    "1B"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "1B"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "1B"   ]], #IDX2
                 "LEAX"   => [[$amod_idx,               \&check_idx,                    "1A"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "1A"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "1A"   ]], #IDX2
                 "LEAY"   => [[$amod_idx,               \&check_idx,                    "19"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "19"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "19"   ]], #IDX2
                 "LSL"    => [[$amod_ext,               \&check_ext,                    "78"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "68"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "68"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "68"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "68"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "68"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "68"   ]], #[EXT]
                 "LSLA"   => [[$amod_inh,               \&check_inh,                    "48"   ]], #INH
                 "LSLB"   => [[$amod_inh,               \&check_inh,                    "58"   ]], #INH
                 "LSLD"   => [[$amod_inh,               \&check_inh,                    "59"   ]], #INH
                 "LSR"    => [[$amod_ext,               \&check_ext,                    "74"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "64"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "64"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "64"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "64"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "64"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "64"   ]], #[EXT]
                 "LSRA"   => [[$amod_inh,               \&check_inh,                    "44"   ]], #INH
                 "LSRB"   => [[$amod_inh,               \&check_inh,                    "54"   ]], #INH
                 "LSRD"   => [[$amod_inh,               \&check_inh,                    "49"   ]], #INH
                 "MAXA"   => [[$amod_idx,               \&check_idx,                    "18 18"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 18"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 18"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 18"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 18"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 18"]], #[EXT]
                 "MAXM"   => [[$amod_idx,               \&check_idx,                    "18 1C"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 1C"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 1C"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 1C"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 1C"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 1C"]], #[EXT]
                 "MEM"    => [[$amod_inh,               \&check_inh,                    "01"   ]], #INH
                 "MINA"   => [[$amod_idx,               \&check_idx,                    "18 19"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 19"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 19"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 19"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 19"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 19"]], #[EXT]
                 "MINM"   => [[$amod_idx,               \&check_idx,                    "18 1D"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 1D"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 1D"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 1D"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 1D"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 1D"]], #[EXT]
                 "MOVB"   => [[$amod_imm8_ext,          \&check_imm8_ext,               "18 0B"],  #IMM-EXT
                              [$amod_imm8_idx,          \&check_imm8_idx,               "18 08"],  #IMM-IDX
                              [$amod_ext_ext,           \&check_ext_ext,                "18 0C"],  #EXT-EXT
                              [$amod_ext_idx,           \&check_ext_idx,                "18 09"],  #EXT-IDX
                              [$amod_idx_ext,           \&check_idx_ext,                "18 0D"],  #IDX-EXT
                              [$amod_idx_idx,           \&check_idx_idx,                "18 0A"]], #IDX-IDX
                 "MOVW"   => [[$amod_imm16_ext,         \&check_imm16_ext,              "18 03"],  #IMM-EXT
                              [$amod_imm16_idx,         \&check_imm16_idx,              "18 00"],  #IMM-IDX
                              [$amod_ext_ext,           \&check_ext_ext,                "18 04"],  #EXT-EXT
                              [$amod_ext_idx,           \&check_ext_idx,                "18 01"],  #EXT-IDX
                              [$amod_idx_ext,           \&check_idx_ext,                "18 05"],  #IDX-EXT
                              [$amod_idx_idx,           \&check_idx_idx,                "18 02"]], #IDX-IDX
                 "MUL"    => [[$amod_inh,               \&check_inh,                    "12"   ]], #INH
                 "NEG"    => [[$amod_ext,               \&check_ext,                    "70"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "60"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "60"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "60"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "60"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "60"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "60"   ]], #[EXT]
                 "NEGA"   => [[$amod_inh,               \&check_inh,                    "40"   ]], #INH
                 "NEGB"   => [[$amod_inh,               \&check_inh,                    "50"   ]], #INH
                 "NOP"    => [[$amod_inh,               \&check_inh,                    "A7"   ]], #INH
                 "ORAA"   => [[$amod_imm8,              \&check_imm8,                   "8A"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "9A"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BA"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "AA"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "AA"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "AA"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "AA"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "AA"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "AA"   ]], #[EXT]
                 "ORAB"   => [[$amod_imm8,              \&check_imm8,                   "CA"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "DA"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FA"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "EA"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "EA"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "EA"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "EA"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "EA"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "EA"   ]], #[EXT]
                 "ORCC"   => [[$amod_imm8,              \&check_imm8,                   "14"   ]], #INH
                 "PSHA"   => [[$amod_inh,               \&check_inh,                    "36"   ]], #INH
                 "PSHB"   => [[$amod_inh,               \&check_inh,                    "37"   ]], #INH
                 "PSHC"   => [[$amod_inh,               \&check_inh,                    "39"   ]], #INH
                 "PSHD"   => [[$amod_inh,               \&check_inh,                    "3B"   ]], #INH
                 "PSHX"   => [[$amod_inh,               \&check_inh,                    "34"   ]], #INH
                 "PSHY"   => [[$amod_inh,               \&check_inh,                    "35"   ]], #INH
                 "PULA"   => [[$amod_inh,               \&check_inh,                    "32"   ]], #INH
                 "PULB"   => [[$amod_inh,               \&check_inh,                    "33"   ]], #INH
                 "PULC"   => [[$amod_inh,               \&check_inh,                    "38"   ]], #INH
                 "PULD"   => [[$amod_inh,               \&check_inh,                    "3A"   ]], #INH
                 "PULX"   => [[$amod_inh,               \&check_inh,                    "30"   ]], #INH
                 "PULY"   => [[$amod_inh,               \&check_inh,                    "31"   ]], #INH
                 "REV"    => [[$amod_inh,               \&check_inh,                    "18 3A"]], #INH
                 "REVW"   => [[$amod_inh,               \&check_inh,                    "18 3B"]], #INH
                 "ROL"    => [[$amod_ext,               \&check_ext,                    "75"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "65"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "65"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "65"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "65"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "65"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "65"   ]], #[EXT]
                 "ROLA"   => [[$amod_inh,               \&check_inh,                    "45"   ]], #INH
                 "ROLB"   => [[$amod_inh,               \&check_inh,                    "55"   ]], #INH
                 "ROR"    => [[$amod_ext,               \&check_ext,                    "76"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "66"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "66"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "66"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "66"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "66"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "66"   ]], #[EXT]
                 "RORA"   => [[$amod_inh,               \&check_inh,                    "46"   ]], #INH
                 "RORB"   => [[$amod_inh,               \&check_inh,                    "56"   ]], #INH
                 "RTC"    => [[$amod_inh,               \&check_inh,                    "0A"   ]], #INH
                 "RTI"    => [[$amod_inh,               \&check_inh,                    "0B"   ]], #INH
                 "RTS"    => [[$amod_inh,               \&check_inh,                    "3D"   ]], #INH
                 "SBA"    => [[$amod_inh,               \&check_inh,                    "18 16"]], #INH
                 "SBCA"   => [[$amod_imm8,              \&check_imm8,                   "82"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "92"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B2"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A2"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A2"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A2"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A2"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A2"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A2"   ]], #[EXT]
                 "SBCB"   => [[$amod_imm8,              \&check_imm8,                   "C2"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D2"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F2"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E2"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E2"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E2"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E2"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E2"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E2"   ]], #[EXT]
                 "SEC"    => [[$amod_inh,               \&check_inh,                    "14 01"]], #INH
                 "SEI"    => [[$amod_inh,               \&check_inh,                    "14 10"]], #INH
                 "SEV"    => [[$amod_inh,               \&check_inh,                    "14 02"]], #INH
                 "SEX"    => [[$amod_tfr,               \&check_sex,                    "B7"   ]], #INH
                 "STAA"   => [[$amod_dir,               \&check_dir,                    "5A"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "7A"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "6A"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "6A"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "6A"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "6A"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "6A"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "6A"   ]], #[EXT]
                 "STAB"   => [[$amod_dir,               \&check_dir,                    "5B"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "7B"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "6B"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "6B"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "6B"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "6B"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "6B"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "6B"   ]], #[EXT]
                 "STD"    => [[$amod_dir,               \&check_dir,                    "5C"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "7C"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "6C"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "6C"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "6C"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "6C"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "6C"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "6C"   ]], #[EXT]
                 "STOP"   => [[$amod_inh,               \&check_inh,                    "18 3E"]], #INH
                 "STS"    => [[$amod_dir,               \&check_dir,                    "5F"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "7F"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "6F"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "6F"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "6F"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "6F"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "6F"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "6F"   ]], #[EXT]
                 "STX"    => [[$amod_dir,               \&check_dir,                    "5E"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "7E"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "6E"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "6E"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "6E"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "6E"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "6E"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "6E"   ]], #[EXT]
                 "STY"    => [[$amod_dir,               \&check_dir,                    "5D"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "7D"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "6D"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "6D"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "6D"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "6D"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "6D"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "6D"   ]], #[EXT]
                 "SUBA"   => [[$amod_imm8,              \&check_imm8,                   "80"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "90"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B0"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A0"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A0"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A0"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A0"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A0"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A0"   ]], #[EXT]
                 "SUBB"   => [[$amod_imm8,              \&check_imm8,                   "C0"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "D0"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F0"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E0"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E0"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E0"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E0"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E0"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E0"   ]], #[EXT]
                 "SUBD"   => [[$amod_imm16,             \&check_imm16,                  "83"   ],  #IMM
                              [$amod_dir,               \&check_dir,                    "93"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B3"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A3"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A3"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A3"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A3"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A3"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A3"   ]], #[EXT]
                 "SWI"    => [[$amod_inh,               \&check_inh,                    "3F"   ]], #INH
                 "TAB"    => [[$amod_inh,               \&check_inh,                    "18 0E"]], #INH
                 "TAP"    => [[$amod_inh,               \&check_inh,                    "B7 02"]], #INH
                 "TBA"    => [[$amod_inh,               \&check_inh,                    "18 0F"]], #INH
                 "TBEQ"   => [[$amod_tbeq,              \&check_tbeq,                   "04"   ]], #REL
                 "TBL"    => [[$amod_idx,               \&check_idx,                    "18 3D"]], #IDX
                 "TBNE"   => [[$amod_tbne,              \&check_tbne,                   "04"   ]], #REL
                 "TFR"    => [[$amod_tfr,               \&check_tfr,                    "B7"   ]], #INH
                 "TPA"    => [[$amod_inh,               \&check_inh,                    "B7 20"]], #INH
                 "TRAP"   => [[$amod_trap,              \&check_trap,                   "18"   ]], #INH
                 "TST"    => [[$amod_ext,               \&check_ext,                    "F7"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E7"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E7"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E7"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E7"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E7"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E7"   ]], #[EXT]
                 "TSTA"   => [[$amod_inh,               \&check_inh,                    "97"   ]], #INH
                 "TSTB"   => [[$amod_inh,               \&check_inh,                    "D7"   ]], #INH
                 "TSX"    => [[$amod_inh,               \&check_inh,                    "B7 75"]], #INH
                 "TSY"    => [[$amod_inh,               \&check_inh,                    "B7 76"]], #INH
                 "TXS"    => [[$amod_inh,               \&check_inh,                    "B7 57"]], #INH
                 "TYS"    => [[$amod_inh,               \&check_inh,                    "B7 67"]], #INH
                 "WAI"    => [[$amod_inh,               \&check_inh,                    "3E"   ]], #INH
                 "WAV"    => [[$amod_inh,               \&check_inh,                    "18 3C"]], #INH
                 "WAVR"   => [[$amod_inh,               \&check_inh,                    "3C"   ]], #INH
                 "XGDX"   => [[$amod_inh,               \&check_inh,                    "B7 C5"]], #INH
                 "XGDY"   => [[$amod_inh,               \&check_inh,                    "B7 C6"]]};#INH

#S12X:           MNEMONIC     ADDRESS MODE                                               OPCODE
*opctab_s12x = \{"ABA"    => [[$amod_inh,               \&check_inh,                    "18 06"]], #INH
                 "ABX"    => [[$amod_inh,               \&check_inh,                    "1A E5"]], #INH
                 "ABY"    => [[$amod_inh,               \&check_inh,                    "19 ED"]], #INH
                 "ADCA"   => [[$amod_imm8,              \&check_imm8,                   "89"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "99"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B9"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A9"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A9"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A9"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A9"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A9"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A9"   ]], #[EXT]
                 "ADCB"   => [[$amod_imm8,              \&check_imm8,                   "C9"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "D9"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F9"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E9"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E9"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E9"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E9"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E9"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E9"   ]], #[EXT]
                 "ADED"   => [[$amod_imm16,             \&check_imm16,                  "18 C3"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 D3"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 F3"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 E3"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 E3"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 E3"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 E3"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 E3"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 E3"]], #[EXT]
                 "ADEX"   => [[$amod_imm16,             \&check_imm16,                  "18 89"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 99"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 B9"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 A9"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 A9"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 A9"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 A9"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 E3"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 E3"]], #[EXT]
                 "ADEY"   => [[$amod_imm16,             \&check_imm16,                  "18 C9"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 D9"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 F9"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 E9"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 E9"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 E9"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 E9"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 E9"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 E9"]], #[EXT]
                 "ADDA"   => [[$amod_imm8,              \&check_imm8,                   "8B"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "9B"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BB"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "AB"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "AB"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "AB"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "AB"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "AB"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "AB"   ]], #[EXT]
                 "ADDB"   => [[$amod_imm8,              \&check_imm8,                   "CB"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "DB"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FB"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "EB"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "EB"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "EB"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "EB"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "EB"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "EB"   ]], #[EXT]
                 "ADDD"   => [[$amod_imm16,             \&check_imm16,                  "C3"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "D3"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F3"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E3"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E3"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E3"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E3"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E3"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E3"   ]], #[EXT]
                 "ADDX"   => [[$amod_imm16,             \&check_imm16,                  "18 8B"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 9B"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 BB"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 AB"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 AB"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 AB"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 AB"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 AB"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 AB"]], #[EXT]
                 "ADDY"   => [[$amod_imm16,             \&check_imm16,                  "18 CB"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 DB"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 FB"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 EB"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 EB"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 EB"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 EB"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 EB"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 EB"]], #[EXT]
                 "ANDA"   => [[$amod_imm8,              \&check_imm8,                   "84"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "94"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B4"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A4"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A4"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A4"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A4"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A4"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A4"   ]], #[EXT]
                 "ANDB"   => [[$amod_imm8,              \&check_imm8,                   "C4"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "D4"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F4"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E4"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E4"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E4"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E4"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E4"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E4"   ]], #[EXT]
                 "ANDX"   => [[$amod_imm16,             \&check_imm16,                  "18 84"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 94"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 B4"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 A4"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 A4"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 A4"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 A4"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 A4"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 A4"]], #[EXT]
                 "ANDY"   => [[$amod_imm16,             \&check_imm16,                  "18 C4"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 D4"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 F4"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 E4"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 E4"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 E4"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 E4"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 E4"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 E4"]], #[EXT]
                 "ANDCC"  => [[$amod_imm8,              \&check_imm8,                   "10"   ]], #IMM
                 "ASL"    => [[$amod_ext,               \&check_ext,                    "78"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "68"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "68"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "68"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "68"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "68"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "68"   ]], #[EXT]
                 "ASLA"   => [[$amod_inh,               \&check_inh,                    "48"   ]], #INH
                 "ASLB"   => [[$amod_inh,               \&check_inh,                    "58"   ]], #INH
                 "ANDCC"  => [[$amod_imm8,              \&check_imm8,                   "10"   ]], #IMM
                 "ASLW"   => [[$amod_ext,               \&check_ext,                    "18 78"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 68"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 68"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 68"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 68"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 68"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 68"]], #[EXT]
                 "ASLX"   => [[$amod_inh,               \&check_inh,                    "18 48"]], #INH
                 "ASLY"   => [[$amod_inh,               \&check_inh,                    "18 58"]], #INH
                 "ASLD"   => [[$amod_inh,               \&check_inh,                    "59"   ]], #INH
                 "ASR"    => [[$amod_ext,               \&check_ext,                    "77"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "67"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "67"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "67"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "67"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "67"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "67"   ]], #[EXT]
                 "ASRA"   => [[$amod_inh,               \&check_inh,                    "47"   ]], #INH
                 "ASRB"   => [[$amod_inh,               \&check_inh,                    "57"   ]], #INH
                 "ASRW"   => [[$amod_ext,               \&check_ext,                    "18 77"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 67"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 67"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 67"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 67"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 67"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 67"]], #[EXT]
                 "ASRX"   => [[$amod_inh,               \&check_inh,                    "18 47"]], #INH
                 "ASRY"   => [[$amod_inh,               \&check_inh,                    "18 57"]], #INH
                 "BCC"    => [[$amod_rel8,              \&check_rel8,                   "24"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 24"]], #REL
                 "BCLR"   => [[$amod_s12x_dir_msk,      \&check_s12x_dir_msk,           "4D"   ],  #DIR
                              [$amod_ext_msk,           \&check_ext_msk,                "1D"   ],  #EXT
                              [$amod_idx_msk,           \&check_idx_msk,                "0D"   ],  #IDX
                              [$amod_idx1_msk,          \&check_idx1_msk,               "0D"   ],  #IDX1
                              [$amod_idx2_msk,          \&check_idx2_msk,               "0D"   ]], #IDX2
                 "BCS"    => [[$amod_rel8,              \&check_rel8,                   "25"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 25"]], #REL
                 "BEQ"    => [[$amod_rel8,              \&check_rel8,                   "27"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 27"]], #REL
                 "BGE"    => [[$amod_rel8,              \&check_rel8,                   "2C"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 2C"]], #REL
                 "BGND"   => [[$amod_inh,               \&check_inh,                    "00"   ]], #INH
                 "BGT"    => [[$amod_rel8,              \&check_rel8,                   "2E"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 2E"]], #REL
                 "BHI"    => [[$amod_rel8,              \&check_rel8,                   "22"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 22"]], #REL
                 "BHS"    => [[$amod_rel8,              \&check_rel8,                   "24"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 24"]], #REL
                 "BITA"   => [[$amod_imm8,              \&check_imm8,                   "85"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "95"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B5"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A5"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A5"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A5"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A5"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A5"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A5"   ]], #[EXT]
                 "BITB"   => [[$amod_imm8,              \&check_imm8,                   "C5"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "D5"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F5"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E5"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E5"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E5"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E5"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E5"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E5"   ]], #[EXT]
                 "BITX"   => [[$amod_imm16,             \&check_imm16,                  "18 85"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 95"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 B5"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 A5"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 A5"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 A5"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 A5"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 A5"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 A5"]], #[EXT]
                 "BITY"   => [[$amod_imm16,             \&check_imm16,                  "18 C5"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 D5"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 F5"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 E5"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 E5"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 E5"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 E5"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 E5"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 E5"]], #[EXT]
                 "BLE"    => [[$amod_rel8,              \&check_rel8,                   "2F"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 2F"]], #REL
                 "BLO"    => [[$amod_rel8,              \&check_rel8,                   "25"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 25"]], #REL
                 "BLS"    => [[$amod_rel8,              \&check_rel8,                   "23"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 23"]], #REL
                 "BLT"    => [[$amod_rel8,              \&check_rel8,                   "2D"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 2D"]], #REL
                 "BMI"    => [[$amod_rel8,              \&check_rel8,                   "2B"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 2B"]], #REL
                 "BNE"    => [[$amod_rel8,              \&check_rel8,                   "26"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 26"]], #REL
                 "BPL"    => [[$amod_rel8,              \&check_rel8,                   "2A"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 2A"]], #REL
                 "BRA"    => [[$amod_rel8,              \&check_rel8,                   "20"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 20"]], #REL
                 "BRCLR"  => [[$amod_s12x_dir_msk_rel,  \&check_s12x_dir_msk_rel,       "4F"   ],  #DIR
                              [$amod_ext_msk_rel,       \&check_ext_msk_rel,            "1F"   ],  #EXT
                              [$amod_idx_msk_rel,       \&check_idx_msk_rel,            "0F"   ],  #IDX
                              [$amod_idx1_msk_rel,      \&check_idx1_msk_rel,           "0F"   ],  #IDX1
                              [$amod_idx2_msk_rel,      \&check_idx2_msk_rel,           "0F"   ]], #IDX2
                 "BRN"    => [[$amod_rel8,              \&check_rel8,                   "21"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 21"]], #REL
                 "BRSET"  => [[$amod_s12x_dir_msk_rel,  \&check_s12x_dir_msk_rel,       "4E"   ],  #DIR
                              [$amod_ext_msk_rel,       \&check_ext_msk_rel,            "1E"   ],  #EXT
                              [$amod_idx_msk_rel,       \&check_idx_msk_rel,            "0E"   ],  #IDX
                              [$amod_idx1_msk_rel,      \&check_idx1_msk_rel,           "0E"   ],  #IDX1
                              [$amod_idx2_msk_rel,      \&check_idx2_msk_rel,           "0E"   ]], #IDX2
                 "BSET"   => [[$amod_s12x_dir_msk,      \&check_s12x_dir_msk,           "4C"   ],  #DIR
                              [$amod_ext_msk,           \&check_ext_msk,                "1C"   ],  #EXT
                              [$amod_idx_msk,           \&check_idx_msk,                "0C"   ],  #IDX
                              [$amod_idx1_msk,          \&check_idx1_msk,               "0C"   ],  #IDX1
                              [$amod_idx2_msk,          \&check_idx2_msk,               "0C"   ]], #IDX2
                 "BSR"    => [[$amod_rel8,              \&check_rel8,                   "07"   ]], #REL
                 "BVC"    => [[$amod_rel8,              \&check_rel8,                   "28"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 28"]], #REL
                 "BVS"    => [[$amod_rel8,              \&check_rel8,                   "29"   ],  #REL
                              [$amod_rel16,             \&check_rel16,                  "18 29"]], #REL
                 "BTAS"   => [[$amod_s12x_dir_msk,      \&check_s12x_dir_msk,           "18 35"],  #DIR
                              [$amod_ext_msk,           \&check_ext_msk,                "18 36"],  #EXT
                              [$amod_idx_msk,           \&check_idx_msk,                "18 37"],  #IDX
                              [$amod_idx1_msk,          \&check_idx1_msk,               "18 37"],  #IDX1
                              [$amod_idx2_msk,          \&check_idx2_msk,               "18 37"]], #IDX2
                 "CALL"   => [[$amod_ext_pgimpl,        \&check_ext_pgimpl,             "4A"   ],  #EXT
                              [$amod_ext_pg,            \&check_ext_pg,                 "4A"   ],  #EXT
                              [$amod_idx_pg,            \&check_idx_pg,                 "4B"   ],  #IDX
                              [$amod_idx1_pg,           \&check_idx1_pg,                "4B"   ],  #IDX1
                              [$amod_idx2_pg,           \&check_idx2_pg,                "4B"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "4B"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "4B"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "4B"   ]], #[EXT]
                 "CBA"    => [[$amod_inh,               \&check_inh,                    "18 17"]], #INH
                 "CLC"    => [[$amod_inh,               \&check_inh,                    "10 FE"]], #INH
                 "CLI"    => [[$amod_inh,               \&check_inh,                    "10 EF"]], #INH
                 "CLR"    => [[$amod_ext,               \&check_ext,                    "79"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "69"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "69"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "69"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "69"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "69"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "69"   ]], #[EXT]
                 "CLRA"   => [[$amod_inh,               \&check_inh,                    "87"   ]], #INH
                 "CLRB"   => [[$amod_inh,               \&check_inh,                    "C7"   ]], #INH
                 "CLRW"   => [[$amod_ext,               \&check_ext,                    "18 79"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 69"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 69"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 69"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 69"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 69"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 69"]], #[EXT]
                 "CLRX"   => [[$amod_inh,               \&check_inh,                    "18 87"]], #INH
                 "CLRY"   => [[$amod_inh,               \&check_inh,                    "18 C7"]], #INH
                 "CLV"    => [[$amod_inh,               \&check_inh,                    "10 FD"]], #INH
                 "CMPA"   => [[$amod_imm8,              \&check_imm8,                   "81"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "91"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B1"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A1"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A1"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A1"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A1"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A1"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A1"   ]], #[EXT]
                 "CMPB"   => [[$amod_imm8,              \&check_imm8,                   "C1"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "D1"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F1"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E1"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E1"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E1"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E1"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E1"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E1"   ]], #[EXT]
                 "COM"    => [[$amod_ext,               \&check_ext,                    "71"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "61"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "61"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "61"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "61"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "61"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "61"   ]], #[EXT]
                 "COMA"   => [[$amod_inh,               \&check_inh,                    "41"   ]], #INH
                 "COMB"   => [[$amod_inh,               \&check_inh,                    "51"   ]], #INH
                 "COMW"   => [[$amod_ext,               \&check_ext,                    "18 71"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 61"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 61"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 61"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 61"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 61"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 61"]], #[EXT]
                 "COMX"   => [[$amod_inh,               \&check_inh,                    "18 41"]], #INH
                 "COMY"   => [[$amod_inh,               \&check_inh,                    "18 51"]], #INH
                 "CPED"   => [[$amod_imm16,             \&check_imm16,                  "18 8C"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 9C"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 BC"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 AC"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 AC"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 AC"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 AC"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 AC"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 AC"]], #[EXT]
                 "CPES"   => [[$amod_imm16,             \&check_imm16,                  "18 8F"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 9F"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 BF"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 AF"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 AF"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 AF"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 AF"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 AF"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 AF"]], #[EXT]
                 "CPEX"   => [[$amod_imm16,             \&check_imm16,                  "18 8E"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 9E"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 BE"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 AE"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 AE"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 AE"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 AE"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 AE"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 AE"]], #[EXT]
                 "CPEY"   => [[$amod_imm16,             \&check_imm16,                  "18 8D"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 9D"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 BD"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 AD"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 AD"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 AD"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 AD"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 AD"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 AD"]], #[EXT]
                 "CPD"    => [[$amod_imm16,             \&check_imm16,                  "8C"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "9C"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BC"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "AC"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "AC"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "AC"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "AC"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "AC"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "AC"   ]], #[EXT]
                 "CPS"    => [[$amod_imm16,             \&check_imm16,                  "8F"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "9F"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BF"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "AF"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "AF"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "AF"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "AF"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "AF"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "AF"   ]], #[EXT]
                 "CPX"    => [[$amod_imm16,             \&check_imm16,                  "8E"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "9E"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BE"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "AE"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "AE"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "AE"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "AE"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "AE"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "AE"   ]], #[EXT]
                 "CPY"    => [[$amod_imm16,             \&check_imm16,                  "8D"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "9D"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BD"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "AD"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "AD"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "AD"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "AD"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "AD"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "AD"   ]], #[EXT]
                 "DAA"    => [[$amod_inh,               \&check_inh,                    "18 07"]], #INH
                 "DBEQ"   => [[$amod_dbeq,              \&check_dbeq,                   "04"   ]], #REL
                 "DBNE"   => [[$amod_dbne,              \&check_dbne,                   "04"   ]], #REL
                 "DEC"    => [[$amod_ext,               \&check_ext,                    "73"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "63"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "63"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "63"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "63"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "63"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "63"   ]], #[EXT]
                 "DECA"   => [[$amod_inh,               \&check_inh,                    "43"   ]], #INH
                 "DECB"   => [[$amod_inh,               \&check_inh,                    "53"   ]], #INH
                 "DECW"   => [[$amod_ext,               \&check_ext,                    "18 73"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 63"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 63"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 63"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 63"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 63"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 63"]], #[EXT]
                 "DECX"   => [[$amod_inh,               \&check_inh,                    "18 43"]], #INH
                 "DECY"   => [[$amod_inh,               \&check_inh,                    "18 53"]], #INH
                 "DES"    => [[$amod_inh,               \&check_inh,                    "1B 9F"]], #INH
                 "DEX"    => [[$amod_inh,               \&check_inh,                    "09"   ]], #INH
                 "DEY"    => [[$amod_inh,               \&check_inh,                    "03"   ]], #INH
                 "EDIV"   => [[$amod_inh,               \&check_inh,                    "11"   ]], #INH
                 "EDIVS"  => [[$amod_inh,               \&check_inh,                    "18 14"]], #INH
                 "EMACS"  => [[$amod_ext,               \&check_ext,                    "18 12"]], #EXT
                 "EMAXD"  => [[$amod_idx,               \&check_idx,                    "18 1A"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 1A"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 1A"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 1A"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 1A"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 1A"]], #[EXT]
                 "EMAXM"  => [[$amod_idx,               \&check_idx,                    "18 1E"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 1E"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 1E"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 1E"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 1E"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 1E"]], #[EXT]
                 "EMIND"  => [[$amod_idx,               \&check_idx,                    "18 1B"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 1B"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 1B"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 1B"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 1B"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 1B"]], #[EXT]
                 "EMINM"  => [[$amod_idx,               \&check_idx,                    "18 1F"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 1F"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 1F"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 1F"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 1F"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 1F"]], #[EXT]
                 "EMUL"   => [[$amod_inh,               \&check_inh,                    "13"   ]], #INH
                 "EMULS"  => [[$amod_inh,               \&check_inh,                    "18 13"]], #INH
                 "EORA"   => [[$amod_imm8,              \&check_imm8,                   "88"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "98"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B8"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A8"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A8"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A8"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A8"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A8"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A8"   ]], #[EXT]
                 "EORB"   => [[$amod_imm8,              \&check_imm8,                   "C8"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "D8"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F8"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E8"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E8"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E8"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E8"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E8"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "e8"   ]], #[EXT]
                 "EORX"   => [[$amod_imm16,             \&check_imm16,                  "18 88"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 98"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 B8"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 A8"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 A8"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 A8"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 A8"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 A8"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 A8"]], #[EXT]
                 "EORY"   => [[$amod_imm16,             \&check_imm16,                  "18 C8"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 D8"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 F8"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 E8"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 E8"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 E8"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 E8"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 E8"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 E8"]], #[EXT]
                 "ETBL"   => [[$amod_idx,               \&check_idx,                    "18 3F"]], #IDX
                 "EXG"    => [[$amod_s12x_exg,          \&check_s12x_exg,               "B7"   ]], #INH
                 "FDIV"   => [[$amod_inh,               \&check_inh,                    "18 11"]], #INH
                 "GLDAA"  => [[$amod_s12x_dir,          \&check_s12x_dir,               "18 96"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 B6"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 A6"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 A6"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 A6"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 A6"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 A6"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 A6"]], #[EXT]
                 "GLDAB"  => [[$amod_s12x_dir,          \&check_s12x_dir,               "18 D6"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 F6"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 E6"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 E6"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 E6"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 E6"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 E6"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 E6"]], #[EXT]
                 "GLDD"   => [[$amod_s12x_dir,          \&check_s12x_dir,               "18 DC"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 FC"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 EC"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 EC"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 EC"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 EC"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 EC"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 EC"]], #[EXT]
                 "GLDS"   => [[$amod_s12x_dir,          \&check_s12x_dir,               "18 DF"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 FF"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 EF"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 EF"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 EF"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 EF"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 EF"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 EF"]], #[EXT]
                 "GLDX"   => [[$amod_s12x_dir,          \&check_s12x_dir,               "18 DE"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 FE"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 EE"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 EE"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 EE"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 EE"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 EE"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 EE"]], #[EXT]
                 "GLDY"   => [[$amod_s12x_dir,          \&check_s12x_dir,               "18 DD"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 FD"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 ED"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 ED"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 ED"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 ED"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 ED"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 ED"]], #[EXT]
                 "GSTAA"  => [[$amod_s12x_dir,          \&check_s12x_dir,               "18 5A"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 7A"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 6A"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 6A"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 6A"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 6A"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 6A"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 6A"]], #[EXT]
                 "GSTAB"  => [[$amod_s12x_dir,          \&check_s12x_dir,               "18 5B"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 7B"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 6B"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 6B"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 6B"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 6B"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 6B"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 6B"]], #[EXT]
                 "GSTD"   => [[$amod_s12x_dir,          \&check_s12x_dir,               "18 5C"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 7C"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 6C"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 6C"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 6C"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 6C"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 6C"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 6C"]], #[EXT]
                 "GSTS"   => [[$amod_s12x_dir,          \&check_s12x_dir,               "18 5F"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 7F"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 6F"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 6F"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 6F"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 6F"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 6F"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 6F"]], #[EXT]
                 "GSTX"   => [[$amod_s12x_dir,          \&check_s12x_dir,               "18 5E"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 7E"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 6E"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 6E"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 6E"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 6E"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 6E"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 6E"]], #[EXT]
                 "GSTY"   => [[$amod_s12x_dir,          \&check_s12x_dir,               "18 5D"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 7D"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 6D"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 6D"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 6D"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 6D"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 6D"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 6D"]], #[EXT]
                 "IBEQ"   => [[$amod_ibeq,              \&check_ibeq,                   "04"   ]], #REL
                 "IBNE"   => [[$amod_ibne,              \&check_ibne,                   "04"   ]], #REL
                 "IDIV"   => [[$amod_inh,               \&check_inh,                    "18 10"]], #INH
                 "IDIVS"  => [[$amod_inh,               \&check_inh,                    "18 15"]], #INH
                 "INC"    => [[$amod_ext,               \&check_ext,                    "72"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "62"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "62"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "62"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "62"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "62"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "62"   ]], #[EXT]
                 "INCA"   => [[$amod_inh,               \&check_inh,                    "42"   ]], #INH
                 "INCB"   => [[$amod_inh,               \&check_inh,                    "52"   ]], #INH
                 "INCW"   => [[$amod_ext,               \&check_ext,                    "18 72"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 62"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 62"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 62"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 62"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 62"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 62"]], #[EXT]
                 "INCX"   => [[$amod_inh,               \&check_inh,                    "18 42"]], #INH
                 "INCY"   => [[$amod_inh,               \&check_inh,                    "18 52"]], #INH
                 "INS"    => [[$amod_inh,               \&check_inh,                    "1B 81"]], #INH
                 "INX"    => [[$amod_inh,               \&check_inh,                    "08"   ]], #INH
                 "INY"    => [[$amod_inh,               \&check_inh,                    "02"   ]], #INH
                 "JMP"    => [[$amod_ext,               \&check_ext,                    "06"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "05"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "05"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "05"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "05"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "05"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "05"   ]], #[EXT]
                 "JOB"    => [[$amod_rel8,              \&check_rel8,                   "20"   ],  #REL
                              [$amod_ext,               \&check_ext,                    "06"   ]], #EXT
                 "JOBSR"  => [[$amod_rel8,              \&check_rel8,                   "07"   ],  #REL
                              [$amod_ext,               \&check_ext,                    "16"   ]], #EXT
                 "JSR"    => [[$amod_s12x_dir,          \&check_s12x_dir,               "17"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "16"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "15"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "15"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "15"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "15"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "15"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "15"   ]], #[EXT]
                 "LBCC"   => [[$amod_rel16,             \&check_rel16,                  "18 24"]], #REL
                 "LBCS"   => [[$amod_rel16,             \&check_rel16,                  "18 25"]], #REL
                 "LBEQ"   => [[$amod_rel16,             \&check_rel16,                  "18 27"]], #REL
                 "LBGE"   => [[$amod_rel16,             \&check_rel16,                  "18 2C"]], #REL
                 "LBGT"   => [[$amod_rel16,             \&check_rel16,                  "18 2E"]], #REL
                 "LBHI"   => [[$amod_rel16,             \&check_rel16,                  "18 22"]], #REL
                 "LBHS"   => [[$amod_rel16,             \&check_rel16,                  "18 24"]], #REL
                 "LBLE"   => [[$amod_rel16,             \&check_rel16,                  "18 2F"]], #REL
                 "LBLO"   => [[$amod_rel16,             \&check_rel16,                  "18 25"]], #REL
                 "LBLS"   => [[$amod_rel16,             \&check_rel16,                  "18 23"]], #REL
                 "LBLT"   => [[$amod_rel16,             \&check_rel16,                  "18 2D"]], #REL
                 "LBMI"   => [[$amod_rel16,             \&check_rel16,                  "18 2B"]], #REL
                 "LBNE"   => [[$amod_rel16,             \&check_rel16,                  "18 26"]], #REL
                 "LBPL"   => [[$amod_rel16,             \&check_rel16,                  "18 2A"]], #REL
                 "LBRA"   => [[$amod_rel16,             \&check_rel16,                  "18 20"]], #REL
                 "LBRN"   => [[$amod_rel16,             \&check_rel16,                  "18 21"]], #REL
                 "LBVC"   => [[$amod_rel16,             \&check_rel16,                  "18 28"]], #REL
                 "LBVS"   => [[$amod_rel16,             \&check_rel16,                  "18 29"]], #REL
                 "LDAA"   => [[$amod_imm8,              \&check_imm8,                   "86"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "96"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B6"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A6"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A6"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A6"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A6"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A6"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A6"   ]], #[EXT]
                 "LDAB"   => [[$amod_imm8,              \&check_imm8,                   "C6"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "D6"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F6"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E6"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E6"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E6"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E6"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E6"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E6"   ]], #[EXT]
                 "LDD"    => [[$amod_imm16,             \&check_imm16,                  "CC"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "DC"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FC"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "EC"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "EC"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "EC"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "EC"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "EC"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "EC"   ]], #[EXT]
                 "LDS"    => [[$amod_imm16,             \&check_imm16,                  "CF"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "DF"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FF"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "EF"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "EF"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "EF"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "EF"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "EF"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "EF"   ]], #[EXT]
                 "LDX"    => [[$amod_imm16,             \&check_imm16,                  "CE"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "DE"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FE"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "EE"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "EE"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "EE"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "EE"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "EE"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "EE"   ]], #[EXT]
                 "LDY"    => [[$amod_imm16,             \&check_imm16,                  "CD"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "DD"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FD"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "ED"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "ED"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "ED"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "ED"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "ED"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "ED"   ]], #[EXT]
                 "LEAS"   => [[$amod_idx,               \&check_idx,                    "1B"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "1B"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "1B"   ]], #IDX2
                 "LEAX"   => [[$amod_idx,               \&check_idx,                    "1A"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "1A"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "1A"   ]], #IDX2
                 "LEAY"   => [[$amod_idx,               \&check_idx,                    "19"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "19"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "19"   ]], #IDX2
                 "LSL"    => [[$amod_ext,               \&check_ext,                    "78"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "68"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "68"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "68"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "68"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "68"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "68"   ]], #[EXT]
                 "LSLA"   => [[$amod_inh,               \&check_inh,                    "48"   ]], #INH
                 "LSLB"   => [[$amod_inh,               \&check_inh,                    "58"   ]], #INH
                 "LSLW"   => [[$amod_ext,               \&check_ext,                    "18 78"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 68"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 68"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 68"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 68"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 68"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 68"]], #[EXT]
                 "LSLX"   => [[$amod_inh,               \&check_inh,                    "18 48"]], #INH
                 "LSLY"   => [[$amod_inh,               \&check_inh,                    "18 58"]], #INH
                 "LSLD"   => [[$amod_inh,               \&check_inh,                    "59"   ]], #INH
                 "LSR"    => [[$amod_ext,               \&check_ext,                    "74"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "64"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "64"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "64"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "64"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "64"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "64"   ]], #[EXT]
                 "LSRA"   => [[$amod_inh,               \&check_inh,                    "44"   ]], #INH
                 "LSRB"   => [[$amod_inh,               \&check_inh,                    "54"   ]], #INH
                 "LSRW"   => [[$amod_ext,               \&check_ext,                    "18 74"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 64"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 64"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 64"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 64"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 64"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 64"]], #[EXT]
                 "LSRX"   => [[$amod_inh,               \&check_inh,                    "18 44"]], #INH
                 "LSRY"   => [[$amod_inh,               \&check_inh,                    "18 54"]], #INH
                 "LSRD"   => [[$amod_inh,               \&check_inh,                    "49"   ]], #INH
                 "MAXA"   => [[$amod_idx,               \&check_idx,                    "18 18"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 18"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 18"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 18"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 18"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 18"]], #[EXT]
                 "MAXM"   => [[$amod_idx,               \&check_idx,                    "18 1C"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 1C"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 1C"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 1C"],  #[D,IDX]
                              [$amod_iext,              \&check_iext,                   "18 1C"]], #[EXT]
                 "MEM"    => [[$amod_inh,               \&check_inh,                    "01"   ]], #INH
                 "MINA"   => [[$amod_idx,               \&check_idx,                    "18 19"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 19"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 19"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 19"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 19"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 19"]], #[EXT]
                 "MINM"   => [[$amod_idx,               \&check_idx,                    "18 1D"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 1D"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 1D"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 1D"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 1D"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 1D"]], #[EXT]
                 "MOVB"   => [[$amod_imm8_ext,          \&check_imm8_ext,               "18 0B"],  #IMM-EXT
                              [$amod_imm8_idx,          \&check_imm8_idx,               "18 08"],  #IMM-IDX
                              [$amod_imm8_idx1,         \&check_imm8_idx1,              "18 08"],  #IMM-IDX1
                              [$amod_imm8_idx2,         \&check_imm8_idx2,              "18 08"],  #IMM-IDX2
                              [$amod_imm8_ididx,        \&check_imm8_ididx,             "18 08"],  #IMM-[D,IDX]
                              [$amod_imm8_iidx2,        \&check_imm8_iidx2,             "18 08"],  #IMM-[IDX2]
                              [$amod_imm8_iext,         \&check_imm8_iext,              "18 08"],  #IMM-[EXT]
                              [$amod_ext_ext,           \&check_ext_ext,                "18 0C"],  #EXT-EXT
                              [$amod_ext_idx,           \&check_ext_idx,                "18 09"],  #EXT-IDX
                              [$amod_ext_idx1,          \&check_ext_idx1,               "18 09"],  #EXT-IDX1
                              [$amod_ext_idx2,          \&check_ext_idx2,               "18 09"],  #EXT-IDX2
                              [$amod_ext_ididx,         \&check_ext_ididx,              "18 09"],  #EXT-[D,IDX]
                              [$amod_ext_iidx2,         \&check_ext_iidx2,              "18 09"],  #EXT-[IDX2]
                              [$amod_ext_iext,          \&check_ext_iext,               "18 09"],  #EXT-[EXT]
                              [$amod_idx_ext,           \&check_idx_ext,                "18 0D"],  #IDX-EXT
                              [$amod_idx_idx,           \&check_idx_idx,                "18 0A"],  #IDX-IDX
                              [$amod_idx_idx1,          \&check_idx_idx1,               "18 0A"],  #IDX-IDX1
                              [$amod_idx_idx2,          \&check_idx_idx2,               "18 0A"],  #IDX-IDX2
                              [$amod_idx_ididx,         \&check_idx_ididx,              "18 0A"],  #IDX-[D,IDX]
                              [$amod_idx_iidx2,         \&check_idx_iidx2,              "18 0A"],  #IDX-[IDX2]
                              [$amod_idx_iext,          \&check_idx_iext,               "18 0A"],  #IDX-[EXT]
                              [$amod_idx1_ext,          \&check_idx1_ext,               "18 0D"],  #IDX1-EXT
                              [$amod_idx1_idx,          \&check_idx1_idx,               "18 0A"],  #IDX1-IDX
                              [$amod_idx1_idx1,         \&check_idx1_idx1,              "18 0A"],  #IDX1-IDX1
                              [$amod_idx1_idx2,         \&check_idx1_idx2,              "18 0A"],  #IDX1-IDX2
                              [$amod_idx1_ididx,        \&check_idx1_ididx,             "18 0A"],  #IDX1-[D,IDX]
                              [$amod_idx1_iidx2,        \&check_idx1_iidx2,             "18 0A"],  #IDX1-[IDX2]
                              [$amod_idx1_iext,         \&check_idx1_iext,              "18 0A"],  #IDX1-[EXT]
                              [$amod_idx2_ext,          \&check_idx2_ext,               "18 0D"],  #IDX1-EXT
                              [$amod_idx2_idx,          \&check_idx2_idx,               "18 0A"],  #IDX2-IDX
                              [$amod_idx2_idx1,         \&check_idx2_idx1,              "18 0A"],  #IDX2-IDX1
                              [$amod_idx2_idx2,         \&check_idx2_idx2,              "18 0A"],  #IDX2-IDX2
                              [$amod_idx2_ididx,        \&check_idx2_ididx,             "18 0A"],  #IDX2-[D,IDX]
                              [$amod_idx2_iidx2,        \&check_idx2_iidx2,             "18 0A"],  #IDX2-[IDX2]
                              [$amod_idx2_iext,         \&check_idx2_iext,              "18 0A"],  #IDX2-[EXT]
                              [$amod_ididx_ext,         \&check_ididx_ext,              "18 0D"],  #[D,IDX]-EXT
                              [$amod_ididx_idx,         \&check_ididx_idx,              "18 0A"],  #[D,IDX]-IDX
                              [$amod_ididx_idx1,        \&check_ididx_idx1,             "18 0A"],  #[D,IDX]-IDX1
                              [$amod_ididx_idx2,        \&check_ididx_idx2,             "18 0A"],  #[D,IDX]-IDX2
                              [$amod_ididx_ididx,       \&check_ididx_ididx,            "18 0A"],  #[D,IDX]-[D,IDX]
                              [$amod_ididx_iidx2,       \&check_ididx_iidx2,            "18 0A"],  #[D,IDX]-[IDX2]
                              [$amod_ididx_iext,        \&check_ididx_iext,             "18 0A"],  #[D,IDX]-[EXT]
                              [$amod_iidx2_ext,         \&check_iidx2_ext,              "18 0D"],  #[IDX2]-EXT
                              [$amod_iidx2_idx,         \&check_iidx2_idx,              "18 0A"],  #[IDX2]-IDX
                              [$amod_iidx2_idx1,        \&check_iidx2_idx1,             "18 0A"],  #[IDX2]-IDX1
                              [$amod_iidx2_idx2,        \&check_iidx2_idx2,             "18 0A"],  #[IDX2]-IDX2
                              [$amod_iidx2_ididx,       \&check_iidx2_ididx,            "18 0A"],  #[IDX2]-[D,IDX]
                              [$amod_iidx2_iidx2,       \&check_iidx2_iidx2,            "18 0A"],  #[IDX2]-[IDX2]
                              [$amod_iidx2_iext,        \&check_iidx2_iext,             "18 0A"],  #[IDX2]-[EXT]
                              [$amod_iext_ext,          \&check_iext_ext,               "18 0D"],  #[EXT]-EXT
                              [$amod_iext_idx,          \&check_iext_idx,               "18 0A"],  #[EXT]-IDX
                              [$amod_iext_idx1,         \&check_iext_idx1,              "18 0A"],  #[EXT]-IDX1
                              [$amod_iext_idx2,         \&check_iext_idx2,              "18 0A"],  #[EXT]-IDX2
                              [$amod_iext_ididx,        \&check_iext_ididx,             "18 0A"],  #[EXT]-[D,IDX]
                              [$amod_iext_iidx2,        \&check_iext_iidx2,             "18 0A"],  #[EXT]-[IDX2]
                              [$amod_iext_iext,         \&check_iext_iext,              "18 0A"]], #[EXT]-[EXT]
                "MOVW"    => [[$amod_imm16_ext,         \&check_imm16_ext,              "18 03"],  #IMM-EXT
                              [$amod_imm16_idx,         \&check_imm16_idx,              "18 00"],  #IMM-IDX
                              [$amod_imm16_idx1,        \&check_imm16_idx1,             "18 00"],  #IMM-IDX1
                              [$amod_imm16_idx2,        \&check_imm16_idx2,             "18 00"],  #IMM-IDX2
                              [$amod_imm16_ididx,       \&check_imm16_ididx,            "18 00"],  #IMM-[D,IDX]
                              [$amod_imm16_iidx2,       \&check_imm16_iidx2,            "18 00"],  #IMM-[IDX2]
                              [$amod_imm16_iext,        \&check_imm16_iext,             "18 00"],  #IMM-[EXT]
                              [$amod_ext_ext,           \&check_ext_ext,                "18 04"],  #EXT-EXT
                              [$amod_ext_idx,           \&check_ext_idx,                "18 01"],  #EXT-IDX
                              [$amod_ext_idx1,          \&check_ext_idx1,               "18 01"],  #EXT-IDX1
                              [$amod_ext_idx2,          \&check_ext_idx2,               "18 01"],  #EXT-IDX2
                              [$amod_ext_ididx,         \&check_ext_ididx,              "18 01"],  #EXT-[D,IDX]
                              [$amod_ext_iidx2,         \&check_ext_iidx2,              "18 01"],  #EXT-[IDX2]
                              [$amod_ext_iext,          \&check_ext_iext,               "18 01"],  #EXT-[EXT]
                              [$amod_idx_ext,           \&check_idx_ext,                "18 05"],  #IDX-EXT
                              [$amod_idx_idx,           \&check_idx_idx,                "18 02"],  #IDX-IDX
                              [$amod_idx_idx1,          \&check_idx_idx1,               "18 02"],  #IDX-IDX1
                              [$amod_idx_idx2,          \&check_idx_idx2,               "18 02"],  #IDX-IDX2
                              [$amod_idx_ididx,         \&check_idx_ididx,              "18 02"],  #IDX-[D,IDX]
                              [$amod_idx_iidx2,         \&check_idx_iidx2,              "18 02"],  #IDX-[IDX2]
                              [$amod_idx_iext,          \&check_idx_iext,               "18 02"],  #IDX-[EXT]
                              [$amod_idx1_ext,          \&check_idx1_ext,               "18 05"],  #IDX1-EXT
                              [$amod_idx1_idx,          \&check_idx1_idx,               "18 02"],  #IDX1-IDX
                              [$amod_idx1_idx1,         \&check_idx1_idx1,              "18 02"],  #IDX1-IDX1
                              [$amod_idx1_idx2,         \&check_idx1_idx2,              "18 02"],  #IDX1-IDX2
                              [$amod_idx1_ididx,        \&check_idx1_ididx,             "18 02"],  #IDX1-[D,IDX]
                              [$amod_idx1_iidx2,        \&check_idx1_iidx2,             "18 02"],  #IDX1-[IDX2]
                              [$amod_idx1_iext,         \&check_idx1_iext,              "18 02"],  #IDX1-[EXT]
                              [$amod_idx2_ext,          \&check_idx2_ext,               "18 05"],  #IDX1-EXT
                              [$amod_idx2_idx,          \&check_idx2_idx,               "18 02"],  #IDX2-IDX
                              [$amod_idx2_idx1,         \&check_idx2_idx1,              "18 02"],  #IDX2-IDX1
                              [$amod_idx2_idx2,         \&check_idx2_idx2,              "18 02"],  #IDX2-IDX2
                              [$amod_idx2_ididx,        \&check_idx2_ididx,             "18 02"],  #IDX2-[D,IDX]
                              [$amod_idx2_iidx2,        \&check_idx2_iidx2,             "18 02"],  #IDX2-[IDX2]
                              [$amod_idx2_iext,         \&check_idx2_iext,              "18 02"],  #IDX2-[EXT]
                              [$amod_ididx_ext,         \&check_ididx_ext,              "18 05"],  #[D,IDX]-EXT
                              [$amod_ididx_idx,         \&check_ididx_idx,              "18 02"],  #[D,IDX]-IDX
                              [$amod_ididx_idx1,        \&check_ididx_idx1,             "18 02"],  #[D,IDX]-IDX1
                              [$amod_ididx_idx2,        \&check_ididx_idx2,             "18 02"],  #[D,IDX]-IDX2
                              [$amod_ididx_ididx,       \&check_ididx_ididx,            "18 02"],  #[D,IDX]-[D,IDX]
                              [$amod_ididx_iidx2,       \&check_ididx_iidx2,            "18 02"],  #[D,IDX]-[IDX2]
                              [$amod_ididx_iext,        \&check_ididx_iext,             "18 02"],  #[D,IDX]-[EXT]
                              [$amod_iidx2_ext,         \&check_iidx2_ext,              "18 05"],  #[IDX2]-EXT
                              [$amod_iidx2_idx,         \&check_iidx2_idx,              "18 02"],  #[IDX2]-IDX
                              [$amod_iidx2_idx1,        \&check_iidx2_idx1,             "18 02"],  #[IDX2]-IDX1
                              [$amod_iidx2_idx2,        \&check_iidx2_idx2,             "18 02"],  #[IDX2]-IDX2
                              [$amod_iidx2_ididx,       \&check_iidx2_ididx,            "18 02"],  #[IDX2]-[D,IDX]
                              [$amod_iidx2_iidx2,       \&check_iidx2_iidx2,            "18 02"],  #[IDX2]-[IDX2]
                              [$amod_iidx2_iext,        \&check_iidx2_iext,             "18 02"],  #[IDX2]-[EXT]
                              [$amod_iext_ext,          \&check_iext_ext,               "18 05"],  #[EXT]-EXT
                              [$amod_iext_idx,          \&check_iext_idx,               "18 02"],  #[EXT]-IDX
                              [$amod_iext_idx1,         \&check_iext_idx1,              "18 02"],  #[EXT]-IDX1
                              [$amod_iext_idx2,         \&check_iext_idx2,              "18 02"],  #[EXT]-IDX2
                              [$amod_iext_ididx,        \&check_iext_ididx,             "18 02"],  #[EXT]-[D,IDX]
                              [$amod_iext_iidx2,        \&check_iext_iidx2,             "18 02"],  #[EXT]-[IDX2]
                              [$amod_iext_iext,         \&check_iext_iext,              "18 02"]], #[EXT]-[EXT]
                 "MUL"    => [[$amod_inh,               \&check_inh,                    "12"   ]], #INH
                 "NEG"    => [[$amod_ext,               \&check_ext,                    "70"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "60"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "60"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "60"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "60"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "60"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "60"   ]], #[EXT]
                 "NEGA"   => [[$amod_inh,               \&check_inh,                    "40"   ]], #INH
                 "NEGB"   => [[$amod_inh,               \&check_inh,                    "50"   ]], #INH
                 "NEGW"   => [[$amod_ext,               \&check_ext,                    "18 70"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 60"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 60"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 60"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 60"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 60"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 60"]], #[EXT]
                 "NEGX"   => [[$amod_inh,               \&check_inh,                    "18 40"]], #INH
                 "NEGY"   => [[$amod_inh,               \&check_inh,                    "18 50"]], #INH
                 "NOP"    => [[$amod_inh,               \&check_inh,                    "A7"   ]], #INH
                 "ORAA"   => [[$amod_imm8,              \&check_imm8,                   "8A"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "9A"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "BA"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "AA"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "AA"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "AA"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "AA"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "AA"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "AA"   ]], #[EXT]
                 "ORAB"   => [[$amod_imm8,              \&check_imm8,                   "CA"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "DA"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "FA"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "EA"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "EA"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "EA"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "EA"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "EA"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "EA"   ]], #[EXT]
                 "ORX"    => [[$amod_imm16,             \&check_imm16,                  "18 8A"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 9A"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 BA"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 AA"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 AA"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 AA"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 AA"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 AA"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 AA"]], #[EXT]
                 "ORY"    => [[$amod_imm16,             \&check_imm16,                  "18 CA"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 DA"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 FA"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 EA"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 EA"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 EA"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 EA"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 EA"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 EA"]], #[EXT]
                 "ORCC"   => [[$amod_imm8,              \&check_imm8,                   "14"   ]], #INH
                 "PSHA"   => [[$amod_inh,               \&check_inh,                    "36"   ]], #INH
                 "PSHB"   => [[$amod_inh,               \&check_inh,                    "37"   ]], #INH
                 "PSHC"   => [[$amod_inh,               \&check_inh,                    "39"   ]], #INH
                 "PSHCW"  => [[$amod_inh,               \&check_inh,                    "18 39"]], #INH
                 "PSHD"   => [[$amod_inh,               \&check_inh,                    "3B"   ]], #INH
                 "PSHX"   => [[$amod_inh,               \&check_inh,                    "34"   ]], #INH
                 "PSHY"   => [[$amod_inh,               \&check_inh,                    "35"   ]], #INH
                 "PULA"   => [[$amod_inh,               \&check_inh,                    "32"   ]], #INH
                 "PULB"   => [[$amod_inh,               \&check_inh,                    "33"   ]], #INH
                 "PULC"   => [[$amod_inh,               \&check_inh,                    "38"   ]], #INH
                 "PULCW"  => [[$amod_inh,               \&check_inh,                    "18 38"]], #INH
                 "PULD"   => [[$amod_inh,               \&check_inh,                    "3A"   ]], #INH
                 "PULX"   => [[$amod_inh,               \&check_inh,                    "30"   ]], #INH
                 "PULY"   => [[$amod_inh,               \&check_inh,                    "31"   ]], #INH
                 "REV"    => [[$amod_inh,               \&check_inh,                    "18 3A"]], #INH
                 "REVW"   => [[$amod_inh,               \&check_inh,                    "18 3B"]], #INH
                 "ROL"    => [[$amod_ext,               \&check_ext,                    "75"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "65"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "65"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "65"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "65"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "65"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "65"   ]], #[EXT]
                 "ROLA"   => [[$amod_inh,               \&check_inh,                    "45"   ]], #INH
                 "ROLB"   => [[$amod_inh,               \&check_inh,                    "55"   ]], #INH
                 "ROLW"   => [[$amod_ext,               \&check_ext,                    "18 75"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 65"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 65"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 65"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 65"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 65"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 65"]], #[EXT]
                 "ROLX"   => [[$amod_inh,               \&check_inh,                    "18 45"]], #INH
                 "ROLY"   => [[$amod_inh,               \&check_inh,                    "18 55"]], #INH
                 "ROR"    => [[$amod_ext,               \&check_ext,                    "76"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "66"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "66"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "66"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "66"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "66"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "66"   ]], #[EXT]
                 "RORA"   => [[$amod_inh,               \&check_inh,                    "46"   ]], #INH
                 "RORB"   => [[$amod_inh,               \&check_inh,                    "56"   ]], #INH
                 "RORW"   => [[$amod_ext,               \&check_ext,                    "18 76"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 66"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 66"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 66"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 66"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 66"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 66"]], #[EXT]
                 "RORX"   => [[$amod_inh,               \&check_inh,                    "18 46"]], #INH
                 "RORY"   => [[$amod_inh,               \&check_inh,                    "18 56"]], #INH
                 "RTC"    => [[$amod_inh,               \&check_inh,                    "0A"   ]], #INH
                 "RTI"    => [[$amod_inh,               \&check_inh,                    "0B"   ]], #INH
                 "RTS"    => [[$amod_inh,               \&check_inh,                    "3D"   ]], #INH
                 "SBA"    => [[$amod_inh,               \&check_inh,                    "18 16"]], #INH
                 "SBCA"   => [[$amod_imm8,              \&check_imm8,                   "82"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "92"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B2"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A2"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A2"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A2"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A2"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A2"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A2"   ]], #[EXT]
                 "SBCB"   => [[$amod_imm8,              \&check_imm8,                   "C2"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "D2"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F2"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E2"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E2"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E2"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E2"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E2"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E2"   ]], #[EXT]
                 "SBED"   => [[$amod_imm16,             \&check_imm16,                  "18 83"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 93"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 B3"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 A3"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 A3"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 A3"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 A3"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 A3"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 A3"]], #[EXT]
                 "SBEX"   => [[$amod_imm16,             \&check_imm16,                  "18 82"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 92"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 B2"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 A2"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 A2"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 A2"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 A2"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 A2"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 A2"]], #[EXT]
                 "SBEY"   => [[$amod_imm16,             \&check_imm16,                  "18 C2"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 D2"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 F2"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 E2"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 E2"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 E2"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 E2"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 E2"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 E2"]], #[EXT]
                 "SEC"    => [[$amod_inh,               \&check_inh,                    "14 01"]], #INH
                 "SEI"    => [[$amod_inh,               \&check_inh,                    "14 10"]], #INH
                 "SEV"    => [[$amod_inh,               \&check_inh,                    "14 02"]], #INH
                 "SEX"    => [[$amod_s12x_tfr,          \&check_s12x_sex,               "B7"   ]], #INH
                 "STAA"   => [[$amod_s12x_dir,          \&check_s12x_dir,               "5A"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "7A"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "6A"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "6A"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "6A"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "6A"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "6A"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "6A"   ]], #[EXT]
                 "STAB"   => [[$amod_s12x_dir,          \&check_s12x_dir,               "5B"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "7B"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "6B"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "6B"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "6B"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "6B"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "6B"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "6B"   ]], #[EXT]
                 "STD"    => [[$amod_s12x_dir,          \&check_s12x_dir,               "5C"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "7C"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "6C"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "6C"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "6C"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "6C"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "6C"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "6C"   ]], #[EXT]
                 "STOP"   => [[$amod_inh,               \&check_inh,                    "18 3E"]], #INH
                 "STS"    => [[$amod_s12x_dir,          \&check_s12x_dir,               "5F"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "7F"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "6F"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "6F"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "6F"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "6F"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "6F"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "6F"   ]], #[EXT]
                 "STX"    => [[$amod_s12x_dir,          \&check_s12x_dir,               "5E"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "7E"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "6E"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "6E"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "6E"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "6E"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "6E"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "6E"   ]], #[EXT]
                 "STY"    => [[$amod_s12x_dir,          \&check_s12x_dir,               "5D"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "7D"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "6D"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "6D"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "6D"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "6D"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "6D"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "6D"   ]], #[EXT]
                 "SUBA"   => [[$amod_imm8,              \&check_imm8,                   "80"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "90"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B0"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A0"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A0"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A0"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A0"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A0"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A0"   ]], #[EXT]
                 "SUBB"   => [[$amod_imm8,              \&check_imm8,                   "C0"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "D0"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "F0"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E0"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E0"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E0"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E0"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E0"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E0"   ]], #[EXT]
                 "SUBD"   => [[$amod_imm16,             \&check_imm16,                  "83"   ],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "93"   ],  #DIR
                              [$amod_ext,               \&check_ext,                    "B3"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "A3"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "A3"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "A3"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "A3"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "A3"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "A3"   ]], #[EXT]
                 "SUBX"   => [[$amod_imm16,             \&check_imm16,                  "18 80"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 90"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 B0"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 A0"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 A0"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 A0"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 A0"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 A0"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 A0"]], #[EXT]
                 "SUBY"   => [[$amod_imm16,             \&check_imm16,                  "18 C0"],  #IMM
                              [$amod_s12x_dir,          \&check_s12x_dir,               "18 D0"],  #DIR
                              [$amod_ext,               \&check_ext,                    "18 F0"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 E0"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 E0"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 E0"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 E0"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 E0"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 E0"]], #[EXT]
                 "SWI"    => [[$amod_inh,               \&check_inh,                    "3F"   ]], #INH
                 "TAB"    => [[$amod_inh,               \&check_inh,                    "18 0E"]], #INH
                 "TAP"    => [[$amod_inh,               \&check_inh,                    "B7 02"]], #INH
                 "TBA"    => [[$amod_inh,               \&check_inh,                    "18 0F"]], #INH
                 "TBEQ"   => [[$amod_tbeq,              \&check_tbeq,                   "04"   ]], #REL
                 "TBL"    => [[$amod_idx,               \&check_idx,                    "18 3D"]], #IDX
                 "TBNE"   => [[$amod_tbne,              \&check_tbne,                   "04"   ]], #REL
                 "TFR"    => [[$amod_s12x_tfr,          \&check_s12x_tfr,               "B7"   ]], #INH
                 "TPA"    => [[$amod_inh,               \&check_inh,                    "B7 20"]], #INH
                 "TRAP"   => [[$amod_s12x_trap,         \&check_s12x_trap,              "18"   ]], #INH
                 "TST"    => [[$amod_ext,               \&check_ext,                    "F7"   ],  #EXT
                              [$amod_idx,               \&check_idx,                    "E7"   ],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "E7"   ],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "E7"   ],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "E7"   ],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "E7"   ],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "E7"   ]], #[EXT]
                 "TSTA"   => [[$amod_inh,               \&check_inh,                    "97"   ]], #INH
                 "TSTB"   => [[$amod_inh,               \&check_inh,                    "D7"   ]], #INH
                 "TSTW"   => [[$amod_ext,               \&check_ext,                    "18 F7"],  #EXT
                              [$amod_idx,               \&check_idx,                    "18 E7"],  #IDX
                              [$amod_idx1,              \&check_idx1,                   "18 E7"],  #IDX1
                              [$amod_idx2,              \&check_idx2,                   "18 E7"],  #IDX2
                              [$amod_ididx,             \&check_ididx,                  "18 E7"],  #[D,IDX]
                              [$amod_iidx2,             \&check_iidx2,                  "18 E7"],  #[IDX2]
                              [$amod_iext,              \&check_iext,                   "18 E7"]], #[EXT]
                 "TSTX"   => [[$amod_inh,               \&check_inh,                    "18 97"]], #INH
                 "TSTY"   => [[$amod_inh,               \&check_inh,                    "18 D7"]], #INH
                 "TSX"    => [[$amod_inh,               \&check_inh,                    "B7 75"]], #INH
                 "TSY"    => [[$amod_inh,               \&check_inh,                    "B7 76"]], #INH
                 "TXS"    => [[$amod_inh,               \&check_inh,                    "B7 57"]], #INH
                 "TYS"    => [[$amod_inh,               \&check_inh,                    "B7 67"]], #INH
                 "WAI"    => [[$amod_inh,               \&check_inh,                    "3E"   ]], #INH
                 "WAV"    => [[$amod_inh,               \&check_inh,                    "18 3C"]], #INH
                 "WAVR"   => [[$amod_inh,               \&check_inh,                    "3C"   ]], #INH
                 "XGDX"   => [[$amod_inh,               \&check_inh,                    "B7 C5"]], #INH
                 "XGDY"   => [[$amod_inh,               \&check_inh,                    "B7 C6"]]};#INH

#XGATE:           MNEMONIC      ADDRESS MODE                                            OPCODE
*opctab_xgate = \{"ADC"    => [[$amod_xgate_tri,        \&check_xgate_tri,              "18 03"]],       #TRI
                  "ADD"    => [[$amod_xgate_tri,        \&check_xgate_tri,              "18 02"],        #TRI
                               [$amod_xgate_imm16,      \&check_xgate_imm16,            "E0 00 E8 00"]], #IMM16 pseudo opcode
                  "ADDH"   => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "E8 00"]],       #IMM8
                  "ADDL"   => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "E0 00"]],       #IMM8
                  "AND"    => [[$amod_xgate_tri,        \&check_xgate_tri,              "10 00"],        #TRI
                               [$amod_xgate_imm16,      \&check_xgate_imm16,            "80 00 88 00"]], #IMM16 pseudo opcode
                  "ANDH"   => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "88 00"]],       #IMM8
                  "ANDL"   => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "80 00"]],       #IMM8
                  "ASR"    => [[$amod_xgate_imm4,       \&check_xgate_imm4,             "08 09"],        #IMM4
                               [$amod_xgate_dya,        \&check_xgate_dya,              "08 11"]],       #DYA
                  "BCC"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "20 00"]],       #REL9
                  "BCS"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "22 00"]],       #REL9
                  "BEQ"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "26 00"]],       #REL9
                  "BFEXT"  => [[$amod_xgate_tri,        \&check_xgate_tri,              "60 03"]],       #TRI
                  "BFFO"   => [[$amod_xgate_dya,        \&check_xgate_dya,              "08 10"]],       #DYA
                  "BFINS"  => [[$amod_xgate_tri,        \&check_xgate_tri,              "68 03"]],       #TRI
                  "BFINSI" => [[$amod_xgate_tri,        \&check_xgate_tri,              "70 03"]],       #TRI
                  "BFINSX" => [[$amod_xgate_tri,        \&check_xgate_tri,              "78 03"]],       #TRI
                  "BGE"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "34 00"]],       #REL9
                  "BGT"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "38 00"]],       #REL9
                  "BHI"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "30 00"]],       #REL9
                  "BHS"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "20 00"]],       #REL9 pseudo opcode
                  "BITH"   => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "98 00"]],       #IMM8
                  "BITL"   => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "90 00"]],       #IMM8
                  "BLE"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "3A 00"]],       #REL9
                  "BLO"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "22 00"]],       #REL9 pseudo opcode
                  "BLS"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "32 00"]],       #REL9
                  "BLT"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "36 00"]],       #REL9
                  "BMI"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "2A 00"]],       #REL9
                  "BNE"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "24 00"]],       #REL9
                  "BPL"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "28 00"]],       #REL9
                  "BRA"    => [[$amod_xgate_rel10,      \&check_xgate_rel10,            "3C 00"]],       #REL10
                  "BRK"    => [[$amod_inh,              \&check_inh,                    "00 00"]],       #INH
                  "BVC"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "2C 00"]],       #REL9
                  "BVS"    => [[$amod_xgate_rel9,       \&check_xgate_rel9,             "2E 00"]],       #REL9
                  "COM"    => [[$amod_xgate_mon,        \&check_xgate_com_mon,          "10 03"],        #TRI pseudo opcode
                               [$amod_xgate_dya,        \&check_xgate_com_dya,          "10 03"]],       #TRI pseudo opcode
                  "CMP"    => [[$amod_xgate_dya,        \&check_xgate_cmp_dya,          "18 00"],        #TRI pseudo opcode
                               [$amod_xgate_imm16,      \&check_xgate_imm16,            "D0 00 D8 00"]], #IMM16 pseudo opcode
                  "CMPL"   => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "D0 00"]],       #IMM8
                  "CPC"    => [[$amod_xgate_dya,        \&check_xgate_cmp_dya,          "18 01"]],       #TRI pseudo opcode
                  "CPCH"   => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "D8 00"]],       #IMM8
                  "CSEM"   => [[$amod_xgate_mon,        \&check_xgate_mon,              "00 F1"],        #MON
                               [$amod_xgate_imm3,       \&check_xgate_imm3,             "00 F0"]],       #IMM3
                  "CSL"    => [[$amod_xgate_imm4,       \&check_xgate_imm4,             "08 0A"],        #IMM4
                               [$amod_xgate_dya,        \&check_xgate_dya,              "08 12"]],       #DYA
                  "CSR"    => [[$amod_xgate_imm4,       \&check_xgate_imm4,             "08 0B"],        #IMM4
                               [$amod_xgate_dya,        \&check_xgate_dya,              "08 13"]],       #DYA
                  "JAL"    => [[$amod_xgate_mon,        \&check_xgate_mon,              "00 F6"]],       #MON
                  "LDB"    => [[$amod_xgate_ido5,       \&check_xgate_ido5,             "40 00"],        #IDO5
                               [$amod_xgate_idr,        \&check_xgate_idr,              "60 00"],        #IDR
                               [$amod_xgate_idri,       \&check_xgate_idri,             "60 01"],        #IDR+
                               [$amod_xgate_idrd,       \&check_xgate_idrd,             "60 02"]],       #-IDR
                  "LDH"    => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "F8 00"]],       #IMM8
                  "LDL"    => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "F0 00"]],       #IMM8
                  "LDW"    => [[$amod_xgate_ido5,       \&check_xgate_ido5,             "48 00"],        #IDO5
                               [$amod_xgate_idr,        \&check_xgate_idr,              "68 00"],        #IDR
                               [$amod_xgate_idri,       \&check_xgate_idri,             "68 01"],        #IDR+
                               [$amod_xgate_idrd,       \&check_xgate_idrd,             "68 02"],        #-IDR
                               [$amod_xgate_imm16,      \&check_xgate_imm16,            "F0 00 F8 00"]], #IMM16 pseudo opcode
                  "LSL"    => [[$amod_xgate_imm4,       \&check_xgate_imm4,             "08 0C"],        #IMM4
                               [$amod_xgate_dya,        \&check_xgate_dya,              "08 14"]],       #DYA
                  "LSR"    => [[$amod_xgate_imm4,       \&check_xgate_imm4,             "08 0D"],        #IMM4
                               [$amod_xgate_dya,        \&check_xgate_dya,              "08 15"]],       #DYA
                  "MOV"    => [[$amod_xgate_dya,        \&check_xgate_com_dya,          "10 02"]],       #TRI pseudo opcode
                  "NEG"    => [[$amod_xgate_mon,        \&check_xgate_com_mon,          "18 00"],        #TRI pseudo opcode
                               [$amod_xgate_dya,        \&check_xgate_com_dya,          "18 00"]],       #TRI pseudo opcode
                  "NOP"    => [[$amod_inh,              \&check_inh,                    "01 00"]],       #INH
                  "OR"     => [[$amod_xgate_tri,        \&check_xgate_tri,              "10 02"],        #TRI
                               [$amod_xgate_imm16,      \&check_xgate_imm16,            "A0 00 A8 00"]], #IMM16 pseudo opcode
                  "ORH"    => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "A8 00"]],       #IMM8
                  "ORL"    => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "A0 00"]],       #IMM8
                  "PAR"    => [[$amod_xgate_mon,        \&check_xgate_mon,              "00 F5"]],       #MON
                  "ROL"    => [[$amod_xgate_imm4,       \&check_xgate_imm4,             "08 0E"],        #IMM4
                               [$amod_xgate_dya,        \&check_xgate_dya,              "08 16"]],       #DYA
                  "ROR"    => [[$amod_xgate_imm4,       \&check_xgate_imm4,             "08 0F"],        #IMM4
                               [$amod_xgate_dya,        \&check_xgate_dya,              "08 17"]],       #DYA
                  "RTS"    => [[$amod_inh,              \&check_inh,                    "02 00"]],       #INH
                  "SBC"    => [[$amod_xgate_tri,        \&check_xgate_tri,              "18 01"]],       #TRI
                  "SEX"    => [[$amod_xgate_mon,        \&check_xgate_mon,              "00 F4"]],       #MON
                  "SIF"    => [[$amod_inh,              \&check_inh,                    "03 00"],        #INH
                               [$amod_xgate_mon,        \&check_xgate_mon,              "00 F7"]],       #MON
                  "SSSEM"  => [[$amod_xgate_mon,        \&check_xgate_mon,              "00 f3"],        #MON
                  	       [$amod_xgate_imm3,       \&check_xgate_imm3,             "00 F2"]],       #IMM3
                  "SSEM"   => [[$amod_xgate_mon,        \&check_xgate_mon_twice,        "00 f3"],        #MON
                               [$amod_xgate_imm3,       \&check_xgate_imm3_twice,       "00 F2"]],       #IMM3
                  "STB"    => [[$amod_xgate_ido5,       \&check_xgate_ido5,             "50 00"],        #IDO5
                               [$amod_xgate_idr,        \&check_xgate_idr,              "70 00"],        #IDR
                               [$amod_xgate_idri,       \&check_xgate_idri,             "70 01"],        #IDR+
                               [$amod_xgate_idrd,       \&check_xgate_idrd,             "70 02"]],       #-IDR
                  "STW"    => [[$amod_xgate_ido5,       \&check_xgate_ido5,             "58 00"],        #IDO5
                               [$amod_xgate_idr,        \&check_xgate_idr,              "78 00"],        #IDR
                               [$amod_xgate_idri,       \&check_xgate_idri,             "78 01"],        #IDR+
                               [$amod_xgate_idrd,       \&check_xgate_idrd,             "78 02"]],       #-IDR
                  "SUB"    => [[$amod_xgate_tri,        \&check_xgate_tri,              "18 00"],        #TRI
                               [$amod_xgate_imm16,      \&check_xgate_imm16,            "C0 00 C8 00"]], #IMM16 opcode
                  "SUBH"   => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "C8 00"]],       #IMM8
                  "SUBL"   => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "C0 00"]],       #IMM8
                  "TST"    => [[$amod_xgate_mon,        \&check_xgate_tst_mon,          "18 00"]],       #TRI pseudo opcode
                  "TFR"    => [[$amod_xgate_tfr_rd_ccr, \&check_xgate_tfr_rd_ccr,       "00 F8"],        #MON
                               [$amod_xgate_tfr_ccr_rs, \&check_xgate_tfr_ccr_rs,       "00 F9"],        #MON
                               [$amod_xgate_tfr_rd_pc,  \&check_xgate_tfr_rd_pc,        "00 FA"]],       #MON
                  "XNOR"   => [[$amod_xgate_tri,        \&check_xgate_tri,              "10 03"],        #TRI
                               [$amod_xgate_imm16,      \&check_xgate_imm16,            "B0 00 B8 00"]], #IMM16 opcode
                  "XNORH"  => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "B8 00"]],       #IMM8
                  "XNORL"  => [[$amod_xgate_imm8,       \&check_xgate_imm8,             "B0 00"]]};      #IMM8

##################
# pseudo opcodes #
##################
#                   MNEMONIC       SUBROUTINE
*pseudo_opcodes = \{"ALIGN"    => \&psop_align,
                    "BSZ"      => \&psop_zmb,
                    "CPU"      => \&psop_cpu,
                    "DB"       => \&psop_db,
                    "DC.B"     => \&psop_db,
                    "DC.W"     => \&psop_dw,
                    "DS"       => \&psop_dsb,
                    "DS.B"     => \&psop_dsb,
                    "DS.W"     => \&psop_dsw,
                    "DW"       => \&psop_dw,
                    "EQU"      => \&psop_equ,
                    "FCB"      => \&psop_db,
                    "FCC"      => \&psop_fcc,
                    "FCS"      => \&psop_fcs,
                    "FDB"      => \&psop_dw,
                    "FILL"     => \&psop_fill,
                    "LOC"      => \&psop_loc,
                    "ORG"      => \&psop_org,
                    "RMB"      => \&psop_dsb,
                    "RMW"      => \&psop_dsw,
                    "UNALIGN"  => \&psop_unalign,
                    "ZMB"      => \&psop_zmb,
                    "SETDP"    => \&psop_setdp,
                    #pseudo opcodes to ignore
                    "NAME"     => \&psop_ignore,
                    "TTL"      => \&psop_ignore,
                    "VER"      => \&psop_ignore,
                    "VERSION"  => \&psop_ignore,
                    "PAG"      => \&psop_ignore,
                    "FUN"      => \&psop_ignore,
                    "FUNA"     => \&psop_ignore,
                    "END"      => \&psop_ignore};

###############
# constructor #
###############
sub new {
    my $proto            = shift @_;
    my $class            = ref($proto) || $proto;
    my $file_list        = shift @_;
    my $library_list     = shift @_;
    my $defines          = shift @_;
    my $cpu              = shift @_;
    my $verbose          = shift @_;
    my $self             = {};

    #initalize global variables
    $self->{source_files} = $file_list;
    $self->{libraries}    = $library_list;
    $self->{initial_defs} = $defines;
    $self->{precomp_defs} = $defines;
    $self->{cpu}          = $cpu;
    $self->{verbose}      = $verbose;

    #reset remaining global variables
    $self->{problems}         = "no code";
    $self->{code}             = [];
    $self->{comp_symbols}     = {};
    $self->{macros}           = {};
    $self->{macro_argcs}      = {};
    $self->{macro_symbols}    = {};
    $self->{lin_addrspace}    = {};
    $self->{pag_addrspace}    = {};
    $self->{compile_count}    = 0;
    $self->{opcode_table}     = $opctab_s12;
    $self->{dir_page}         = 0;

    #instantiate object
    bless $self, $class;
    #printf STDERR "libs: %s\n", join(", ", @$library_list);

    #compile code
    $self->compile($file_list, $library_list);

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
    $self->{precomp_defs}     = %{$self->{initial_defs}};
    $self->{comp_symbols}     = {};
    $self->{macros}           = {};
    $self->{macro_argcs}      = {};
    $self->{macro_symbols}    = {};
    $self->{lin_addrspace}    = {};
    $self->{pag_addrspace}    = {};
    $self->{compile_count}    = 0;
    if (defined $verbose) {
        $self->{verbose}      = $verbose;
    }

    #compile code
    $self->compile($self->{source_files}, $self->{libraries});
}

###########
# compile #
###########
sub compile {
    my $self         = shift @_;
    my $file_list    = shift @_;
    my $library_list = shift @_;
    #compile staus
    my $old_undef_count;
    my $new_undef_count;
    my $redef_count;
    my $error_count;
    my $compile_count;
    my $keep_compiling;
    my $result_ok;
    #compiler runs
    my $max_comp_runs = 90;

    ##############
    # precompile #
    ##############
    if (!$self->precompile($file_list, $library_list, [[1,1,1]], undef)) {
        #printf "precompiler symbols: %s\n", join("\n         ", keys %{$self->{comp_symbols}});
        #$self->{problems} = "precompiler";

        ##################################################
        # export precompiler defines to compiler symbols #
        ##################################################
        $self->export_precomp_defs();

        ###########
        # compile #
        ###########
        $self->{compile_count} = 0;
        $old_undef_count       = $#{$self->{code}};
        $redef_count           = 0;
        $keep_compiling        = 1;
        $result_ok             = 1;


        #print progress messages
        if ($self->{verbose}) {
            print STDOUT "\n";
            print STDOUT "COMPILE RUN  UNDEFINED SYMBOLS  REDEFINED SYMBOLS\n";
            print STDOUT "===========  =================  =================\n";
        }

        while ($keep_compiling) {
            $self->{compile_count} = ($self->{compile_count} + 1);
            #compile run
            ($error_count, $new_undef_count, $redef_count) = @{$self->compile_run()};
            #print progress messages
            if ($self->{verbose}) {
                printf STDOUT "%8d  %17d  %17d\n", $self->{compile_count}, $new_undef_count, $redef_count;
            }
            #printf STDERR "compile run: %d\n", $self->{compile_count};
            #printf STDERR "errors:      %d\n", $error_count;
            #printf STDERR "old undefs:  %d\n", $old_undef_count;
            #printf STDERR "new undefs:  %d\n", $new_undef_count;
            #printf STDERR "redefs:      %d\n", $redef_count;
            #printf STDERR "symbols: \"%s\"\n", join("\", \"", keys %{$self->{comp_symbols}});;

            #################
            # check results #
            #################
            if ($error_count > 0) {
                ###################
                # compiler errors #
                ###################
                $keep_compiling = 0;
                $result_ok      = 0;
                if ($error_count == 1) {
                    $self->{problems} = "1 compiler error!";
                } else {
                    $self->{problems} = sprintf("%d compiler errors!", $error_count);
                }
            } elsif ($self->{compile_count} >= $max_comp_runs) {
                ##########################
                # too many compiler runs #
                ##########################
                $keep_compiling = 0;
                $result_ok      = 0;
                $self->{problems} = sprintf("%d assembler runs and no success!", $max_comp_runs);
            #} elsif (($new_undef_count > 0) &&
            #          ($new_undef_count >= $old_undef_count)) {
            #    ######################
            #    # unresolved opcodes #
            #    ######################
            #    $keep_compiling = 0;
            #    $result_ok     = 0;
            #    $self->{problems} = sprintf("%d undefined opcodes!", $new_undef_count);
            } elsif (($new_undef_count == 0) &&
                      ($redef_count     == 0)) {
                ##########################
                # compilation successful #
                ##########################
                $keep_compiling = 0;
                $result_ok      = 1;
                $self->{problems} = 0;
            }
            ##########################
            # update old undef count #
            ##########################
            $old_undef_count = $new_undef_count;
        }

        #####################################
        # see if compilation was successful #
        #####################################
        if ($result_ok) {
            ############################
            # determine address spaces #
            ############################
            $self->determine_addrspaces();
        }
    } else {
        $self->{problems} = "precompiler error";
    }
    #print "error_count   = $error_count\n";
    #print "undef_count   = $new_undef_count\n";
    #print "compile_count = $self->{compile_count}\n";

}

##############
# precompile #
##############
sub precompile {
    my $self         = shift @_;
    my $file_list    = shift @_;
    my $library_list = shift @_;
    my $ifdef_stack  = shift @_;
    my $macro        = shift @_;
    #file
    my $file_handle;
    my $file_name;
    my $library_path;
    my $file;
    #errors
    my $error;
    my $error_count;
    #line
    my $line;
    my $line_count;
    my $label;
    my $opcode;
    my $arguments;
    my $directive;
    my $arg1;
    my $arg2;
    #source code
    my @srccode_sequence;
    #temporary
    my $match;
    my $error;
    my $value;

    #############
    # file loop #
    #############
    foreach $file_name (@$file_list) {
        ############################
        # determine full file name #
        ############################
        #printf "file_name: %s\n", $file_name;
        $error = 0;
        if ($file_name =~ /$path_absolute/) {
            #asolute path
            $file = $file_name;
            if (-e $file) {
                if (-r $file) {
                   if ($file_handle = IO::File->new($file, O_RDONLY)) {
                    } else {
                        $error = sprintf("unable to open file \"%s\" (%s)", $file, $!);
                        #print "$error\n";
                    }
                } else {
                    $error = sprintf("file \"%s\" is not readable", $file);
                    #print "$error\n";
                }
            } else {
                $error = sprintf("file \"%s\" does not exist", $file);
                #print "$error\n";
            }
        } else {
            #library path
            $match = 0;
            ################
            # library loop #
            ################
            #printf STDERR "PRECOMPILE: %s\n", join(":", @$library_list);
            foreach $library_path (@$library_list) {
                if (!$match && !$error) {
                    $file = sprintf("%s%s", $library_path, $file_name);
                    #printf STDERR "file: \"%s\"\n", $file;
                    if (-e $file) {
                        $match = 1;
                        if (-r $file) {
                            if ($file_handle = IO::File->new($file, O_RDONLY)) {
                            } else {
                                $error = sprintf("unable to open file \"%s\" (%s)", $file, $!);
                                #print "$error\n";
                            }
                        } else {
                            $error = sprintf("file \"%s\" is not readable", $file);
                            #print "$error\n";
                        }
                    }
                }
            }
            if (!$match) {
                $file  = $file_name;
                $error = sprintf("file \"%s\" does not exist in any library path", $file);
                #print "$error\n";
            }
        }
        #################
        # quit on error #
        #################
        if ($error) {
            #store error message
            push @{$self->{code}}, [undef,      #line count
                                    \$file,     #file name
                                    [],         #code sequence
                                    "",         #label
                                    "",         #opcode
                                    "",         #arguments
                                    undef,      #linear pc
                                    undef,      #paged pc
                                    undef,      #hex code
                                    undef,      #bytes
                                    [$error],   #errors
                                    undef,      #macros
				    undef];     #symbol tables
            return 1;
        }

        #reset variables
        $error            = 0;
        $error_count      = 0;
        $line_count       = 0;
        @srccode_sequence = ();
        #############
        # line loop #
        #############
        while ($line = <$file_handle>) {
            #trim line
            chomp $line;
            $line =~ s/\s*$//;

            #untabify line
            #print STDERR "before:  $line\n";
            $Text::Tabs::tabstop = 8;
            $line = Text::Tabs::expand($line);
            #print STDERR "after:   $line\n";

            #increment line count
            $line_count++;

            #printf "ifds: %d %d %d %d\n", ($#$ifdef_stack,
            #                              $ifdef_stack->[$#$ifdef_stack]->[0],
            #                              $ifdef_stack->[$#$ifdef_stack]->[1],
            #                              $ifdef_stack->[$#$ifdef_stack]->[2]);
            #printf "line: %s\n", $line;
            ##############
            # parse line #
            ##############
            for ($line) {
                ################
                # comment line #
                ################
                /$precomp_comment_line/ && do {
                    #print " => is comment\n";
                    #check ifdef stack
                    if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                        #store comment line
                        push @srccode_sequence, $line;
                    }
                    last;};
                ##########
                # opcode #
                ##########
                /$precomp_opcode/ && do {
                    #print " => is opcode\n";
                    #line =~  $precomp_opcode
                    $label     = $1;
                    $opcode    = $2;
                    $arguments = $3;
                    $label     =~ s/^\s*//;
                    $label     =~ s/\s*$//;
                    $opcode    =~ s/^\s*//;
                    $opcode    =~ s/\s*$//;
                    $arguments =~ s/^\s*//;
                    $arguments =~ s/\s*$//;

                    #printf " ===> \"%s\" \"%s\" \"%s\"\n", $label, $opcode, $arguments;
                    #check ifdef stack
                    if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                        #store source code line
                        push @srccode_sequence, $line;
			if (defined $macro) {
			    push @{$self->{macros}->{$macro}}, [$line_count,          #line count
								\$file,               #file name
								[@srccode_sequence],  #code sequence
								$label,               #label
								$opcode,              #opcode
								$arguments,           #arguments
								undef,                #linear pc
								undef,                #paged pc
								undef,                #hex code
								undef,                #bytes
								0,                    #errors
								undef,                #macros
								undef];               #symbol tables

			    #add label to precompiler defines (makes HSW12 behave a little more like AS12)
			    if ($label =~ /\S/) {
				$self->{macro_symbols}->{uc($macro)}->{uc($label)} = undef;
			    }
			} else {
			    push @{$self->{code}}, [$line_count,          #line count
						    \$file,               #file name
						    [@srccode_sequence],  #code sequence
						    $label,               #label
						    $opcode,              #opcode
						    $arguments,           #arguments
						    undef,                #linear pc
						    undef,                #paged pc
						    undef,                #hex code
						    undef,                #bytes
						    0,                    #errors
						    undef,                #macros
						    undef];               #symbol tables

			    #add label to precompiler defines (makes HSW12 behave a little more like AS12)
			    if ($label =~ /\S/) {
				$self->{precomp_defs}->{uc($label)} = "";
				#if ($label =~ /^SCI/i) {printf " ===> \"%s\" \"%s\" \"%s\"\n", $label, $opcode, $arguments;}
			    }
			}
                        #reset code buffer
                        @srccode_sequence = ();
                    }
                    last;};
                ##############
                # blanc line #
                ##############
                /$precomp_blanc_line/ && do {
                    #print " => is blanc line\n";
                    #check ifdef stack
                    if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                        #store comment line
                        #push @srccode_sequence, "";
                    }
                    last;};
                #########################
                # precompiler directive #
                #########################
                /$precomp_directive/ && do {
                    #print " => is precompiler directive\n";
                    #line =~  $precomp_directive
                    my $directive  = $1;
                    my $arg1       = $2;
                    my $arg2       = $3;
                    #printf "\"%s\" \"%s\" \"%s\"\n", $directive, $arg1, $arg2;

                    for ($directive) {
                        ##########
                        # define #
                        ##########
                        /$precomp_define/ && do {
                            #print "   => define\n";
                            #print "       $arg1 $arg2\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
				$self->{precomp_defs}->{uc($arg1)} = "";
				#printf "        ==> %s\n", $self->{precomp_defs}->{uc($arg1)};
                            }
                            last;};
                        #########
                        # undef #
                        #########
                        /$precomp_undef/ && do {
                            #print "   => undef\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                                if (exists $self->{precomp_defs}->{uc($arg1)}) {
                                    delete $self->{precomp_defs}->{uc($arg1)};
                                }
                            }
                            last;};
                        #########
                        # ifdef #
                        #########
                        /$precomp_ifdef/ && do {
			    #if ($arg1 =~ /^SCI/i) {printf " ifdef \"%s\" \"%s\"\n", $arg1, exists($self->{precomp_defs}->{uc($arg1)});}
                            #print "   => ifdef\n";
                            #printf "   => %s\n", join(", ", keys %{$self->{precomp_defs}});
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                                if (exists $self->{precomp_defs}->{uc($arg1)}) {
                                    push @$ifdef_stack, [1, 0, 1];
                                } else {
                                    push @$ifdef_stack, [0, 0, 1];
                                }
                            } else {
                                push @$ifdef_stack, [0, 0, 0];
                            }
                            last;};
                        ##########
                        # ifndef #
                        ##########
                        /$precomp_ifndef/ && do {
                            #print "   => ifndef\n";
                            #printf "   => %s\n", join(", ", keys %{$self->{precomp_defs}});
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                                if (! exists $self->{precomp_defs}->{uc($arg1)}) {
                                    push @$ifdef_stack, [1, 0, 1];
                                } else {
                                    push @$ifdef_stack, [0, 0, 1];
                                }
                            } else {
                                push @$ifdef_stack, [0, 0, 0];
                            }
                            last;};
                        ########
                        # else #
                        ########
                        /$precomp_else/ && do {
                            #print "   => else\n";
                            #check ifdef stack
                                if ($ifdef_stack->[$#$ifdef_stack]->[1]){
                                    #unexpected "else"
                                    $error = "unexpected \"#else\" directive";
                                    #print "   => ERROR! $error\n";
                                    #store source code line
                                    push @srccode_sequence, $line;
                                    #store error message
                                    push @{$self->{code}}, [$line_count,         #line count
                                                            \$file,              #file name
                                                            [@srccode_sequence], #code sequence
                                                            "",                  #label
                                                            "",                  #opcode
                                                            "",                  #arguments
                                                            undef,               #linear pc
                                                            undef,               #paged pc
                                                            undef,               #hex code
                                                            undef,               #bytes
                                                            [$error],            #errors
                                                            undef,               #macros
							    undef];              #symbol tables
                                    $file_handle->close();
                                    return ++$error_count;
                                } else {
                                    if ($ifdef_stack->[$#$ifdef_stack]->[2]){
                                        #set else-flag
                                        $ifdef_stack->[$#$ifdef_stack]->[1] = 1;
                                        #invert ifdef-flag
                                        $ifdef_stack->[$#$ifdef_stack]->[0] = (! $ifdef_stack->[$#$ifdef_stack]->[0]);
                                    }
                                }
                            last;};
                        #########
                        # endif #
                        #########
                        /$precomp_endif/ && do {
                            #print "   => endif\n";
                            #check ifdef stack
                            if ($#$ifdef_stack <= 0){
                                #unexpected "else"
                                $error = "unexpected \"#endif\" directive";
                                #print "   => ERROR! $error\n";
                                #store source code line
                                push @srccode_sequence, $line;
                                #store error message
                                push @{$self->{code}}, [$line_count,         #line count
                                                        \$file,              #file name
                                                        [@srccode_sequence], #code sequence
                                                        "",                  #label
                                                        "",                  #opcode
                                                        "",                  #arguments
                                                        undef,               #linear pc
                                                        undef,               #paged pc
                                                        undef,               #hex code
                                                        undef,               #bytes
                                                        [$error],            #errors
                                                        undef,               #macros
							undef];              #symbol tables
                                $file_handle->close();
                                return ++$error_count;
                            } else {
                                pop @$ifdef_stack;
                            }
                            last;};
                        ###########
                        # include #
                        ###########
                        /$precomp_include/ && do {
                            #print "   => include $arg1\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]) {
                                #precompile include file
                                #printf STDERR "INCLUDE: %s\n", join(":", (@$library_list, dirname($file_list->[0])));
                                $value = $self->precompile([$arg1], [@$library_list, sprintf("%s/", dirname($file_list->[0]))], $ifdef_stack, $macro);
                                if ($value) {
                                    $file_handle->close();
                                    return ($value + $error_count);
                                }
                            }
                            last;};
                        #########
                        # macro #
                        #########
                        /$precomp_macro/ && do {
			    #print "   => macro\n";
                            #print "       $arg1 $arg2\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
				if (defined $macro) {
                                    #unexpected "macro"
                                    $error = sprintf "unexpected \"#MACRO\" directive (no \"#EMAC\" for macro \"%s\")", uc($macro);
                                    #print "   => ERROR! $error\n";
                                    #store source code line
                                    push @srccode_sequence, $line;
                                    #store error message
                                    push @{$self->{code}}, [$line_count,         #line count
                                                            \$file,              #file name
                                                            [@srccode_sequence], #code sequence
                                                            "",                  #label
                                                            "",                  #opcode
                                                            "",                  #arguments
                                                            undef,               #linear pc
                                                            undef,               #paged pc
                                                            undef,               #hex code
                                                            undef,               #bytes
                                                            [$error],            #errors
                                                            undef,               #macros
							    undef];              #symbol tables
                                    $file_handle->close();
                                    return ++$error_count;
				} elsif (exists $self->{macros}->{uc($arg1)}) {
				    #macro redefined
                                    $error = sprintf "macro %s redefined", $arg1;
                                    #print "   => ERROR! $error\n";
                                    #store source code line
                                    push @srccode_sequence, $line;
                                    #store error message
                                    push @{$self->{code}}, [$line_count,         #line count
                                                            \$file,              #file name
                                                            [@srccode_sequence], #code sequence
                                                            "",                  #label
                                                            "",                  #opcode
                                                            "",                  #arguments
                                                            undef,               #linear pc
                                                            undef,               #paged pc
                                                            undef, ,             #hex code
                                                            undef,               #bytes
                                                            [$error],            #errors
                                                            undef,               #macros
							    undef];              #symbol tables
                                    $file_handle->close();
                                    return ++$error_count;
				} else {
				    ($error, $value) = @{$self->evaluate_expression($arg2, undef, undef, undef, undef)};
				    if (!defined $value) {
					#argument count undefined
					if (!$error) {
					    $error = "number of macro arguments not defined";
					}
					#print "   => ERROR! $error\n";
					#store source code line
					push @srccode_sequence, $line;
					#store error message
					push @{$self->{code}}, [$line_count,         #line count
								\$file,              #file name
								[@srccode_sequence], #code sequence
								"",                  #label
								"",                  #opcode
								"",                  #arguments
								undef,               #linear pc
								undef,               #paged pc
								undef,               #hex code
								undef,               #bytes
								[$error],            #errors
								undef,               #macros
								undef];              #symbol tables
					$file_handle->close();
					return ++$error_count;
				    } else {
					#define new macro
					$macro                           = uc($arg1);
					$self->{macro_symbols}->{$macro} = {}; 
					$self->{macro_argcs}->{$macro}   = $arg2;
					$self->{macros}->{$macro}        = [];
					#print "=> MACRO \"$macro\" defined\n";

				    }
				}
			    }
                            last;};
                        ########
                        # emac #
                        ########
                        /$precomp_emac/ && do {
			    #print "   => emac\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
				if (defined $macro) {
				    undef $macro;
				} else {
                                    #unexpected "emac"
                                    $error = "unexpected \"#EMAC\" directive";
                                    #print "   => ERROR! $error\n";
                                    #store source code line
                                    push @srccode_sequence, $line;
                                    #store error message
                                    push @{$self->{code}}, [$line_count,         #line count
                                                            \$file,              #file name
                                                            [@srccode_sequence], #code sequence
                                                            "",                  #label
                                                            "",                  #opcode
                                                            "",                  #arguments
                                                            undef,               #linear pc
                                                            undef,               #paged pc
                                                            undef,               #hex code
                                                            undef,               #bytes
                                                            [$error],            #errors
							    undef,               #macros
							    undef];              #symbol tables
                                    $file_handle->close();
                                    return ++$error_count;
				}
                            }
                            last;};
                        #################################
                        # invalid precompiler directive #
                        #################################
                        // && do {
                            #print "   => invalid precompiler directive\n";
                            #check ifdef stack
                            if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                                #unexpected "else"
                                $error = "invalid precompiler directive";
                                #store source code line
                                push @srccode_sequence, $line;
                                #store error message
                                push @{$self->{code}}, [$line_count,         #line count
                                                        \$file,              #file name
                                                        [@srccode_sequence], #code sequence
                                                        "",                  #label
                                                        "",                  #opcode
                                                        "",                  #arguments
                                                        undef,               #linear pc
                                                        undef,               #paged pc
                                                        undef,               #hex code
                                                        undef,               #bytes
                                                        [$error],            #errors
							undef,               #macros
							undef];              #symbol tables
				$file_handle->close();
				return ++$error_count;
                                #++$error_count;
                                #@srccode_sequence = ();
                            }
                        last;};
                    }
                    last;};

                ##################
                # invalid syntax #
                ##################
                // && do {
                    #print "   => invalid syntax\n";
                    #check ifdef stack
                    if ($ifdef_stack->[$#$ifdef_stack]->[0]){
                        #unexpected "else"
                        $error = "invalid syntax";
                        #store source code line
                        push @srccode_sequence, $line;
                        #store error message
                        push @{$self->{code}}, [$line_count,         #line count
                                                \$file,              #file name
                                                [@srccode_sequence], #code sequence
                                                "",                  #label
                                                "",                  #opcode
                                                "",                  #arguments
                                                undef,               #linear pc
                                                undef,               #paged pc
                                                undef,               #hex code
                                                undef,               #bytes
                                                [$error],            #errors
						undef,               #macros
						undef];              #symbol tables
			$file_handle->close();
			return ++$error_count;
                        #$error_count++;
                        #@srccode_sequence = ();
                    }
                    last;};
            }
        }
    }
    $file_handle->close();
    return $error_count;
}

#######################
# export_precomp_defs #
#######################
sub export_precomp_defs {
    my $self = shift @_;
    my $key;
    my $string;
    my $error;
    my $value;

    ###########################
    # precompiler define loop #
    ###########################
    foreach $key (keys %{$self->{precomp_defs}}) {
        $string = $self->{precomp_defs}->{uc($key)};
        #default value
        if (!defined $string) {
            #$string = "1";
            $string = undef;
        } elsif ($string =~ /^\s*$/) {
            #$string = "1";
            $string = undef;
        }

        #check if symbol already exists
        if (! exists $self->{comp_symbols}->{uc($key)}) {

            if (!defined $string) {
                $error = 0;
                $value = undef;
            } else {
                ($error, $value) = @{$self->evaluate_expression($string, undef, undef, undef, undef)};
            }
            #export define
            $self->{comp_symbols}->{uc($key)} = $value;
            #printf "\"%s\" \"%s\" \"%s\"\n", $key, $string, $value;
        }
    }
}

###############
# compile_run #
###############
sub compile_run {
    my $self          = shift @_;

    #code
    my $code_entry;
    my $code_label;
    my $code_opcode;
    my $code_args;
    my $code_pc_lin;
    my $code_pc_pag;
    my $code_hex;
    my $code_byte_cnt;
    my $code_macros;
    my $code_sym_tab;
    my $code_sym_tab_key;
    my $code_sym_tab_val;
    my $code_sym_tabs;
    my $code_sym_tab_cnt;
    #opcode
    my $opcode_entries;
    my $opcode_entry;
    my $opcode_entry_cnt;
    my $opcode_entry_total;
    my $opcode_amode_expr;
    my $opcode_amode_check;
    my $opcode_amode_opcode;
    #macros
    my $maro_name;
    my @macro_args;
    my $macro_arg;
    my $macro_argc;
    my $macro_arg_replace;
    my $macro_hierarchy;
    my $maro_sym_tab;
    my $maro_sym_tabs;
    my $macro_symbol;
    my $macro_entries;
    my $macro_entry;
    my @macro_code_list;
    #label
    my @label_stack;
    my $prev_macro_depth;
    my $cur_macro_depth;

    my $label_value;
    my $label_ok;
    #program counters
    my $pc_lin;
    my $pc_pag;
    #loc count
    my $loc_cnt;
    #problem counters
    my $error_count;
    my $undef_count;
    my $redef_count;
    #temporary
    my $result;
    my $error;
    my $match;

    #######################
    # initialize counters #
    #######################
    $pc_lin      = undef;
    $pc_pag      = undef;
    $loc_cnt     = 0;
    $error_count = 0;
    $undef_count = 0;
    $redef_count = 0;

    #####################
    # reset labels hash #
    #####################
    @label_stack      = ({});
    $prev_macro_depth = 0;

    #####################
    # reset direct page #
    #####################
    $self->{dir_page} = 0;

    #############
    # code loop #
    #############
    #print "compile_run:\n";

    #foreach $code_entry (@{$self->{code}}) {
    for ($code_entry_cnt = 0;
	 $code_entry_cnt <= $#{$self->{code}};
	 $code_entry_cnt++) {
	$code_entry = $self->{code}->[$code_entry_cnt];
	
        $code_label    = $code_entry->[3];
        $code_opcode   = $code_entry->[4];
        $code_args     = $code_entry->[5];
        $code_pc_lin   = $code_entry->[6];
        $code_pc_pag   = $code_entry->[7];
        $code_hex      = $code_entry->[8];
        $code_byte_cnt = $code_entry->[9];
        $code_macros   = $code_entry->[11];
        $code_sym_tabs = $code_entry->[12];

        #print  STDERR "error_count = $error_count\n";
        #print  STDERR "undef_count = $undef_count\n";
	#if (defined $code_macros) {
	#    printf STDERR "%-8s %-8s %s (%s)\n", $code_label, $code_opcode, $code_args, join(",", @$code_macros);
	#} else {
	#    printf STDERR "%-8s %-8s %s\n", $code_label, $code_opcode, $code_args;
	#}
	#if (defined $code_sym_tabs) {
	#    printf "               sym_tabs defined: (%d)\n", ($#$code_sym_tabs+1);
	#    foreach $code_sym_tab (@{$code_sym_tabs}) {
	#	 print "               -> ";
	#	 foreach $code_sym_tab_key (keys %{$code_sym_tab}) {
	#	     $code_sym_tab_val = $code_sym_tab->{$code_sym_tab_key};
	#	     if (defined $code_sym_tab_val) {
	#		 printf "%s=%x ", $code_sym_tab_key, $code_sym_tab_val;
	#	     } else {
	#		 printf "%s=? ", $code_sym_tab_key;
	#	     }
	#	 }
	#	 print "\n";
	#    }
	#} else {
	#    #print "sym_tabs not defined!\n";
	#}

        ########################
        # set program counters #
        ########################
        if (defined $pc_lin) {
            $code_entry->[6] = $pc_lin;
        }
        if (defined $pc_pag) {
            $code_entry->[7] = $pc_pag;
        }

        ###################
        # set label_value #
        ###################
        $label_value = $pc_pag;

        #####################
        # determine hexcode #
        #####################
        if (exists $self->{opcode_table}->{uc($code_opcode)}) {
            ################
            # valid opcode #
            ################
            $opcode_entries = $self->{opcode_table}->{uc($code_opcode)};
            $match   = 0;
            $error   = 0;
            $result  = 0;
            foreach $opcode_entry (@$opcode_entries) {
                if (!$match && !$error) {
                    $opcode_amode_expr   = $opcode_entry->[0];
                    $opcode_amode_check  = $opcode_entry->[1];
                    $opcode_amode_opcode = $opcode_entry->[2];
                    #check address mode
                    #printf STDERR "valid opcode: %s %s (%s)\n", $code_opcode, $code_args, $opcode_amode_opcode;
                    if ($code_args =~ $opcode_amode_expr) {
                        $error  = 0;
                        $result = 0;
                        #printf STDERR "valid arg format: %s \"%s\" (%s)\n", $code_opcode, $1, $opcode_amode_opcode;
                        if (&{$opcode_amode_check}($self,
                                                   [$1,$2,$3,$4,$5,$6,$7,$8],
                                                   $pc_lin, $pc_pag, $loc_cnt,
                                                   $code_sym_tabs,
                                                   \$opcode_entry->[2],
                                                   \$error,
                                                   \$result)) {
                            #printf STDERR "valid args: %s (%s)\n", $code_opcode, $opcode_amode_opcode;
                            $match = 1;
                            if ($error) {
                                #syntax error
                                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                                $error_count++;
                                #printf STDERR "ERROR: %s %s %s\n", $code_opcode, $opcode_amode_opcode, $opcode_amode_expr;
                            } elsif ($result) {
                                #opcode found
                                $code_entry->[8] = $result;
                                $code_entry->[9] = split " ", $result;
                                if (defined $pc_lin) {
                                    #increment linear PC
                                    $pc_lin = $pc_lin + $code_entry->[9];
                                }
                                if (defined $pc_pag) {
                                    #######################################
                                    # check if a 16k boundary is chrossed #
                                    #######################################
                                    if (($pc_pag >> 14) !=
                                        (($pc_pag + $code_entry->[9]) >> 14)) {
                                        $error = sprintf("16k boundary crossed: %.6X -> %.6X", ($pc_pag,
                                                                                                ($pc_pag + $code_entry->[9])));
                                        $code_entry->[10] = [@{$code_entry->[10]}, $error];
                                        $error_count++;
                                        $pc_lin = undef;
                                    }
                                    #increment paged PC
                                    $pc_pag = $pc_pag + $code_entry->[9];
                                    if ($result =~ $cmp_no_hexcode) {
                                        $undef_count++;
                                        #print "$opcode_hexargs\n";
                                    }
                                } else {
                                    # undefined PC
                                    $undef_count++;
                                }
                            } else {
                                #opcode undefined
                                #$pc_lin = undef; #Better results if program counter keep an approximate value
                                #$pc_pag = undef;
                                $undef_count++;
                                #printf STDERR "OPCODE UNDEFINED\n";
                            }
                        }
                    }#else {printf STDERR "MISMATCH: \"%s\" \"%s\"\n", $code_args, $opcode_amode_expr;}
                }
            }
            if (!$match) {
                if (!$error) {
                    $error = sprintf("invalid address mode for opcode \"%s\" (%s)", (uc($code_opcode),
                                                                                     $code_args));
                }
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $error_count++;
            }
        } elsif (exists $pseudo_opcodes->{uc($code_opcode)}) {
            #######################
            # valid pseudo opcode #
            #######################
            #print "valid pseudo opcode: $code_opcode ($code_entry->[0])\n";
            $pseudo_opcodes->{uc($code_opcode)}($self,
                                                \$pc_lin,
                                                \$pc_pag,
                                                \$loc_cnt,
                                                \$error_count,
                                                \$undef_count,
                                                \$label_value,
                                                $code_entry);
        } elsif (exists $self->{macros}->{uc($code_opcode)}) {
            #########
            # macro #
            #########
	    #set "MACRO" identifier
	    $code_entry->[8] = "MACRO";

	    #determine macro name
	    $maro_name = uc($code_opcode);

	    #check for recursive macro call
	    if (defined $code_macros) {
		$result = grep {$maro_name eq $_} @$code_macros;
		#printf "macros \"%s\", %b: %s\n", $maro_name, $result, join(", ", @$code_macros);
	    } else {
		$result = -1;
	    }

	    if ($result <= 0) {
		#check macro_args
		#@macro_args = split($del, $code_args);
	        @macro_args = ();
		while ($code_args =~ /^[,\s]*(\".*?\"|\'.*?\'|[^\s,]+)/) {
		  push @macro_args, $1;
		  $code_args = $';
		  #printf "macros arg:\"%s\, \"%s\"\n", $1, $,;
		}
		#printf "macros args: \"%s\" (%d,%d) => %s\n", $code_args, $#macro_args, $self->{macro_argcs}->{$maro_name}, join(", ", @macro_args);
		if (($#macro_args+1) == $self->{macro_argcs}->{$maro_name}) {
		    #determine macro hierarchy
		    if (defined $code_macros) {
			$macro_hierarchy = [$maro_name, @$code_macros];
		    } else {
			$macro_hierarchy = [$maro_name];
		    }
		    #printf "macros hierarchy: %s\n", join("/", @$macro_hierarchy);

		    #create a new local symbol table
		    $maro_sym_tab = {};
		    foreach $macro_symbol (keys %{$self->{macro_symbols}->{$maro_name}}) {
			$maro_sym_tab->{$macro_symbol} = undef;
			$undef_count++;
		    }
		    #printf "new macro table (%s): (%s) (%s)\n", $maro_name, join(",", keys %$maro_sym_tab), join(",", keys %{$self->{macro_symbols}->{$maro_name}});

		    if (defined $code_sym_tabs) {
			$macro_sym_tabs = [$maro_sym_tab, @$code_sym_tabs];
		    } else {
			$macro_sym_tabs = [$maro_sym_tab];
		    }
		    #printf "macro tables (%s): (%s)\n", join("/", @$macro_hierarchy), ($#$macro_sym_tabs+1);

		    #copy macro elements
		    #printf "macros: %d\n", ($#{$self->{macros}->{$maro_name}}+1);
		    $macro_entries = []; 
		    foreach $macro_entry (@{$self->{macros}->{$maro_name}}) {

			#replace macro args
			$macro_arg = $macro_entry->[5];
			foreach $macro_argc (1..$self->{macro_argcs}->{$maro_name}) {
			    $macro_arg_replace = $macro_args[$macro_argc-1];
			    $macro_arg =~ s/\\$macro_argc/$macro_arg_replace/g;
			    #printf "replace macro arg: %d \"%s\", \"%s\" => \"%s\"\n", $macro_argc, $macro_entry->[5], $macro_arg_replace, $macro_arg;
			}

			#copy macro element
			push @$macro_entries , [$macro_entry->[0],
						$macro_entry->[1],
						$macro_entry->[2],
						$macro_entry->[3],
						$macro_entry->[4],
						$macro_arg,
						$macro_entry->[6],
						$macro_entry->[7],
						$macro_entry->[8],
						$macro_entry->[9],
						$macro_entry->[10],
						$macro_hierarchy,
						$macro_sym_tabs];
			#printf "copy macro entries: \"%s\" \"%s\" (\"%s\")\n", $macro_entry->[4], $macro_arg, $macro_entry->[5];

		    }
		    
		    #insert macro into code
		    @macro_code_list = splice @{$self->{code}}, $code_entry_cnt+1;
		    push @{$self->{code}}, @$macro_entries;
		    push @{$self->{code}}, @macro_code_list;

		    #remove opcode and args from macro entry
		    $code_entry->[4] = "";
		    $code_entry->[5] = "";

		} else {
		    #wrong number of arguments
                    $error = sprintf("wrong number of arguments for macro \"%s\" (%s)", (uc($code_opcode),
                                                                                         $code_args));
		    $code_entry->[10] = [@{$code_entry->[10]}, $error];
		    $error_count++;
		}
	    } else {
		#nested macro call detected
		$error = sprintf("recursive call of  macro \"%s\"", (uc($code_opcode)));
		$code_entry->[10] = [@{$code_entry->[10]}, $error];
		$error_count++;
	    }
        } elsif ($code_opcode =~ /^\s*$/) {
            ###############
            # plain label #
            ###############
	    if (defined $code_entry->[8]) {
		if ($code_entry->[8] ne "MACRO") {
		    $code_entry->[8] = "";
		}
	    } else {
		$code_entry->[8] = "";
	    }
        } else {
            ##################
            # invalid opcode #
            ##################
            $error = sprintf("invalid opcode \"%s\"", $code_opcode);
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $error_count++;
            $pc_lin = undef;
            $pc_pag = undef;
            #print "$error\n";
        }

	######################
	# update label stack #
	######################
	if (defined $code_macros) {
	    $cur_macro_depth = $#$code_macros + 1;
	} else {
	    $cur_macro_depth = 0;
	}	    
	#printf "macro depth: %d (%d)\n", $cur_macro_depth, $prev_macro_depth;
	if ($prev_macro_depth < $cur_macro_depth) {
	    #nested macro started
	    unshift @label_stack, {};
	    #printf "macro started: (%d), %s\n", $cur_macro_depth, join(", ", @$code_macros);
	}
	if ($prev_macro_depth > $cur_macro_depth) {
	    #nested macro ended
	    shift @label_stack;
	    #if (defined  $code_macros) {
	    #	 printf "macro ended: (%d), %s\n", $cur_macro_depth, join(", ", @$code_macros);
	    #} else {
	    #	 printf "macro ended: (%d)\n", $cur_macro_depth;
	    #}
	}	    
	$prev_macro_depth = $cur_macro_depth;
	    
        #############
        # set label #
        #############
        if ($code_label =~ /\S/) {

            #use upper case symbol names
            $code_label = uc($code_label);
            #substitute LOC count
            if ($code_label =~ /^\s*(.+)\`\s*$/) {
                $code_label = uc(sprintf("%s%.4d", $1, $loc_cnt));
            }

            #################################
            # check for label redefinitions #
            #################################
            $label_ok = 1;
            if (exists $label_stack[0]->{$code_label}) {
                if (defined $label_stack[0]->{$code_label}) {
                    if (defined $label_value) {
                        if ($label_stack[0]->{$code_label} != $label_value) {
                            $error = sprintf("illegal redefinition of symbol \"%s\" (\$%X -> \$%X)", ($code_label,
                                                                                                      $label_stack[0]->{$code_label},
                                                                                                      $label_value));
                            $code_entry->[10] = [@{$code_entry->[10]}, $error];
                            $error_count++;
                            $label_ok = 0;
                        }
                    }
                }
            } else {
                $label_stack[0]->{$code_label} = $label_value;
            }

            if ($label_ok == 1) {
                ###############
                # check label #
                ###############
		if (defined $code_sym_tabs) {
		    $code_sym_tab_cnt = $#$code_sym_tabs;
		} else {
		    $code_sym_tab_cnt = -1;
		}
		if ($code_sym_tab_cnt < 0) {
		    #main code
		    if (exists $self->{comp_symbols}->{$code_label}) {
			if (defined $self->{comp_symbols}->{$code_label}) {
			    if (defined $label_value) {
				if ($self->{comp_symbols}->{$code_label} != $label_value) {
				    ######################
				    # label redefinition #
				    ######################
				    #if ($self->{compile_count} >= 20) {
				    #        printf STDERR "REDEF: %s %s %s (%s %s)\n", ($code_label,
				    #                                                    $self->{comp_symbols}->{$code_label},
				    #                                                    $label_value,
				    #                                                    ${$code_entry->[1]},
				    #                                                    $code_entry->[0]);
				    #}
				    $redef_count++;
				    $self->{comp_symbols}->{$code_label} = $label_value;
				}
			    } else {
				######################
				# label redefinition #
				######################
				#if ($self->{compile_count} >= 20) {
				#    printf STDERR "REDEF: %s %s undef (%s %s)\n", ($code_label,
				#                                               $self->{comp_symbols}->{$code_label},
				#                                               ${$code_entry->[1]},
				#                                               $code_entry->[0]);
				#}
				$redef_count++;
				$self->{comp_symbols}->{$code_label} = undef;
			    }
			} else {
			    ####################
			    # label definition #
			    ####################
			    $self->{comp_symbols}->{$code_label} = $label_value;
			}
		    } else {
			########################
			# new label definition #
			########################
			$self->{comp_symbols}->{$code_label} = $label_value;
		    }
		} else {
		    #macro label
		    if (exists $code_sym_tabs->[0]->{$code_label}) {
			if (defined $code_sym_tabs->[0]->{$code_label}) {
			    if (defined $label_value) {
				if ($code_sym_tabs->[0]->{$code_label} != $label_value) {
				    ######################
				    # label redefinition #
				    ######################
				    #if ($self->{compile_count} >= 20) {
				    #        printf STDERR "REDEF: %s %s %s (%s %s)\n", ($code_label,
				    #                                                    $code_sym_tabs->[0]->{$code_label},
				    #                                                    $label_value,
				    #                                                    ${$code_entry->[1]},
				    #                                                    $code_entry->[0]);
				    #}
				    $redef_count++;
				    $code_sym_tabs->[0]->{$code_label} = $label_value;
				}
			    } else {
				######################
				# label redefinition #
				######################
				#if ($self->{compile_count} >= 20) {
				#    printf STDERR "REDEF: %s %s undef (%s %s)\n", ($code_label,
				#                                               $code_sym_tabs->[0]->{$code_label},
				#                                               ${$code_entry->[1]},
				#                                               $code_entry->[0]);
				#}
				$redef_count++;
				$code_sym_tabs->[0]->{$code_label} = undef;
			    }
			} else {
			    ####################
			    # label definition #
			    ####################
			    $code_sym_tabs->[0]->{$code_label} = $label_value;
			}
		    } else {
			########################
			# new label definition #
			########################
			$code_sym_tabs->[0]->{$code_label} = $label_value;
		    }
		}
            }
        }
    }
    return [$error_count, $undef_count, $redef_count];
}

####################
# set_opcode_table #
####################
sub set_opcode_table {
    my $self    = shift @_;
    my $cpu     = shift @_;
    #print STDERR "CPU: $cpu\n";

    for ($cpu) {
        ########
        # HC11 #
        ########
        /$cpu_hc11/ && do {
            $self->{opcode_table} = $opctab_hc11;
            return 0; last;};
        ############
        # HC12/S12 #
        ############
        /$cpu_s12/ && do {
            $self->{opcode_table} = $opctab_s12;
            return 0; last;};
        ########
        # S12X #
        ########
        /$cpu_s12x/ && do {
             $self->{opcode_table} = $opctab_s12x;
            return 0; last;};
        #########
        # XGATE #
        #########
        /$cpu_xgate/ && do {
            $self->{opcode_table} = $opctab_xgate;
            return 0; last;};
        ###############
        # DEFAULT CPU #
        ###############
        $self->{opcode_table} = $opctab_s12;
        return sprintf "invalid CPU \"%s\". Using S12 opcode map instead.", $cpu;
    }
}

#######################
# evaluate_expression #
#######################
sub evaluate_expression {
    my $self     = shift @_;
    my $expr     = shift @_;
    my $pc_lin   = shift @_;
    my $pc_pag   = shift @_;
    my $loc_cnt  = shift @_;
    my $sym_tabs = shift @_;

    #terminal
    my $complement;
    my $string;
    #binery conversion
    my $binery_value;
    my $binery_char;
    #ascii conversion
    my $ascii_value;
    my $ascii_char;
    #symbol lookup
    my @symbol_tabs;
    my $symbol_tab;
    my $symbol_name;
    #formula
    my $formula;
    my $formula_left;
    my $formula_middle;
    my $formula_right;
    my $formula_resolved_left;
    my $formula_resolved_middle;
    my $formula_resolved_right;
    my $formula_error;
    #printf "evaluate_expression: \"%s\"\n", $expr;

    if (defined $expr) {
        #trim expression
        #$expr =~ s/^\s*//;
        #$expr =~ s/\s*$//;

        for ($expr) {
            #################
            # binary number #
            #################
            /$op_binery/ && do {
                $complement = $1;
                $string     = $2;
                #printf "terminal bin: \"%s\" \"%s\"\n", $complement, $string;
                $binery_value = 0;
                foreach $binery_char (split //, $string) {
                    if ($binery_char =~ /^[01]$/) {
                        $binery_value = $binery_value << 1;
                        if ($binery_char ne "0") {
                            $binery_value++;
                        }
                    }
                }
                for ($complement) {
                    /^~$/ && do {
                        #1's complement
                        return [0, (~$binery_value)];
                        last;};
                    /^\-$/ && do {
                        #2's complement
                        return [0, ($binery_value * -1)];
                        last;};
                    /^\s*$/ && do {
                        #no complement
                        return [0, $binery_value];
                        last;};
                    #syntax error
                    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
                }
                last;};
            ##################
            # decimal number #
            ##################
            /$op_dec/ && do {
                $complement = $1;
                $string     = $2;
                $string =~ s/_//g;
                #printf "terminal dec: \"%s\" \"%s\"\n", $complement, $string;
                for ($complement) {
                    /^~$/ && do {
                        #1's complement
                        return [0, (~(int(sprintf("%d", $string))))];
                        last;};
                    /^\-$/ && do {
                        #2's complement
                        return [0, (int(sprintf("%d", $string)) * (-1))];
                        last;};
                    /^\s*$/ && do {
                        #no complement
                        return [0, int(sprintf("%d", $string))];
                        last;};
                    #syntax error
                    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
                }
                last;};
            ######################
            # hexadecimal number #
            ######################
            /$op_hex/ && do {
                $complement = $1;
                $string     = $2;
                $string =~ s/_//g;
                #printf "terminal hex: \"%s\" \"%s\"\n", $complement, $string;
                for ($complement) {
                    /^~$/ && do {
                        #1's complement
                        return [0, (~(hex($string)))];
                        last;};
                    /^\-$/ && do {
                        #2's complement
                        return [0, (hex($string) * (-1))];
                        last;};
                    /^\s*$/ && do {
                        #no complement
                        return [0, hex($string)];
                        last;};
                    #syntax error
                    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
                }
                last;};
            ###################
            # ASCII character #
            ###################
            /$op_ascii/ && do {
                $complement = $1;
                $string     = $2;
                #printf "terminal ascii: \"%s\" \"%s\"\n", $complement, $string;

                #replace escaped characters
                $string =~ s/\\,/,/g;   #escaped commas
                #$string =~ s/\\\ /\ /g; #escaped spaces
                #$string =~ s/\\\t/\t/g; #escaped tabss

                $ascii_value = 0;
                foreach $ascii_char (split //, $string) {
                    $ascii_value = $ascii_value << 8;
                    $ascii_value = $ascii_value | ord($ascii_char);
                }
                for ($complement) {
                    /^~$/ && do {
                        #1's complement
                        return [0, (~$ascii_value)];
                        last;};
                    /^\-$/ && do {
                        #2's complement
                        return [0, ($ascii_value * (-1))];
                        last;};
                    /^\s*$/ && do {
                        #no complement
                        return [0, $ascii_value];
                        last;};
                    #syntax error
                    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
                }
                last;};
            ####################
            # current linear PC #
            ####################
            /$op_curr_lin_pc/ && do {
                $complement = $1;
                #printf "terminal addr: \"%s\" \"%s\"\n", $complement, $comp_pc_paged;
                for ($complement) {
                    /^~$/ && do {
                        #1's complement
                        return [0, (~$pc_lin)];
                        last;};
                    /^\-$/ && do {
                        #2's complement
                        return [0, ($pc_lin * (-1))];
                        last;};
                    /^\s*$/ && do {
                        #no complement
                        return [0, $pc_lin];
                        last;};
                    #syntax error
                    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
                }
                last;};
            ####################
            # current paged PC #
            ####################
            /$op_curr_pag_pc/ && do {
                $complement = $1;
                #printf "terminal addr: \"%s\" \"%s\"\n", $complement, $comp_pc_paged;
                for ($complement) {
                    /^~$/ && do {
                        #1's complement
                        return [0, (~$pc_pag)];
                        last;};
                    /^\-$/ && do {
                        #2's complement
                        return [0, ($pc_pag * (-1))];
                        last;};
                    /^\s*$/ && do {
                        #no complement
                        return [0, $pc_pag];
                        last;};
                    #syntax error
                    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
                }
                last;};
            ###################
            # compiler symbol #
            ###################
            /$op_symbol/ && do {
                $complement = $1;
                $string     = uc($2);
                ########################
                # substitute loc count #
                ########################
                #substitute LOC count
                if ($string =~ /^\s*(.+)\`\s*$/) {
                #if ($string =~ /^\s*(.*)\`\s*$/) {
                    $string = sprintf("%s%.4d", $1, $loc_cnt);
                }
                #printf "terminal symb: \"%s\" \"%s\"\n", $complement, $string;
                if ($string !~ $op_keywords) {
		    if (defined $sym_tabs) {
			@symbol_tabs = (@$sym_tabs, $self->{comp_symbols});
			#printf "symbol_tabs: %d\n", ($#symbol_tabs+1);
		    } else {
			@symbol_tabs = ($self->{comp_symbols});
			#printf "symbol_tabs: %d (no sym_tabs)\n", ($#symbol_tabs+1);
		    }
		    
		    foreach $symbol_tab (@symbol_tabs) {
			#printf "\"%s\" -> \"%s\": %s\n", $expr, $string, join(",", keys %$symbol_tab);
			if (exists $symbol_tab->{uc($string)}) {
			    if (defined $symbol_tab->{uc($string)}) {
				#printf STDERR "symbol: \"%s\" \"%s\"\n", uc($string), $symbol_tab->{uc($string)};

				for ($complement) {
				    /^~$/ && do {
					#1's complement
					return [0, (~$symbol_tab->{uc($string)})];
					last;};
				    /^\-$/ && do {
					#2's complement
					return [0, ($symbol_tab->{uc($string)} * (-1))];
					last;};
				    /^\s*$/ && do {
					#no complement
					return [0, $symbol_tab->{uc($string)}];
					last;};
				    #syntax error
				    return [sprintf("wrong syntax \"%s%s\"", $complement, $string), undef];
				}
			    } else {
				#printf STDERR "symbol: \"%s\" undefined\n", uc($string);
				return [0, undef];
			    }
			}
		    }

                    if (! exists $self->{compile_count}) {
                        return [sprintf("unknown symbol \"%s\"", $string), undef];
                    } elsif ($self->{compile_count} > 1) {
                        return [sprintf("unknown symbol \"%s\"", $string), undef];
                    } else {
                        return [0, undef];
                    }
                } else {
                    return [sprintf("invalid use of keyword \"%s\"", $string), undef];
                }
                last;};
            ###############
            # parenthesis #
            ###############
            /$op_formula_pars/ && do {
                $formula_left   = $1;
                $formula_middle = $2;
                $formula_right  = $3;
                ($formula_error, $formula_resolved_middle) = @{$self->evaluate_expression($formula_middle, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_middle) {
                    return [0, undef];
                } else {
                    $formula = sprintf("%s%d%s", ($formula_left,
                                                  $formula_resolved_middle,
                                                  $formula_right));

                    return $self->evaluate_expression($formula, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs);
                }
                last;};
            #############################
            # double negation/invertion #
            #############################
            /$op_formula_complement/ && do {
                $complement     = $1;
                $formula_right  = $2;
                ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_right) {
                    return [0, undef];
                } else {
                    for ($complement) {
                        /^~$/ && do {
                            #1's complement
                            return [0, (~$formula_resolved_right)];
                            last;};
                        /^\-$/ && do {
                            #2's complement
                            return [0, ($formula_resolved_right * (-1))];
                            last;};
                        #syntax error
                        return [sprintf("wrong syntax \"%s%s\"", $complement, $formula_right), undef];
                    }
                }
                last;};
            #######
            # and #
            #######
            /$op_formula_and/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve ANDs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left & $formula_resolved_right)];
                    }
                }
                last;};
            ######
            # or #
            ######
            /$op_formula_or/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve ORs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left | $formula_resolved_right)];
                    }
                }
                last;};
            ########
            # exor #
            ########
            /$op_formula_exor/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve EXORs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left ^ $formula_resolved_right)];
                    }
                }
                last;};
            ##############
            # rightshift #
            ##############
            /$op_formula_rightshift/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve RIGHTSHIFTSs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left >> $formula_resolved_right)];
                    }
                }
                last;};
            #############
            # leftshift #
            #############
            /$op_formula_leftshift/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve LEFTSHIFTs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left << $formula_resolved_right)];
                    }
                }
                last;};
            ##################
            # multiplication #
            ##################
            /$op_formula_mul/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve MULs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left * $formula_resolved_right)];
                    }
                }
                last;};
            ############
            # division #
            ############
            /$op_formula_div/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve DIVs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, int($formula_resolved_left / $formula_resolved_right)];
                    }
                }
                last;};
            ###########
            # modulus #
            ###########
            /$op_formula_mod/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve MODs: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left % $formula_resolved_right)];
                    }
                }
                last;};
            ########
            # plus #
            ########
            /$op_formula_plus/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve PLUSes: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left + $formula_resolved_right)];
                    }
                }
                last;};
            #########
            # minus #
            #########
            /$op_formula_minus/ && do {
                $formula_left   = $1;
                $formula_right  = $2;
                #printf "resolve MINUSes: \"%s\" \"%s\"\n", $formula_left, $formula_right;

                #evaluate left formula
                ($formula_error, $formula_resolved_left) = @{$self->evaluate_expression($formula_left, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                if ($formula_error) {
                    return [$formula_error, undef];
                } elsif (! defined $formula_resolved_left) {
                    return [0, undef];
                } else {
                    #evaluate right formula
                    ($formula_error, $formula_resolved_right) = @{$self->evaluate_expression($formula_right, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
                    if ($formula_error) {
                        return [$formula_error, undef];
                    } elsif (! defined $formula_resolved_right) {
                        return [0, undef];
                    } else {
                        return [0, ($formula_resolved_left - $formula_resolved_right)];
                    }
                }
                last;};
            ##############
            # whitespace #
            ##############
            /$op_whitespace/ && do {
                return [0, undef];
                last;};
            ##################
            # unknown syntax #
            ##################
            return [sprintf("wrong syntax \"%s\"", $expr), undef];
            #return [sprintf("wrong syntax", $expr), undef];
            }
    } else {
        return [0, undef];
    }
    return [0, undef];
}

########################
# determine_addrspaces #
########################
sub determine_addrspaces {
    my $self      = shift @_;

    #code
    my $code_pc_lin;
    my $code_pc_pag;
    #data
    my $address;
    my $byte;
    my $first_byte;

    ########################
    # reset address spaces #
    ########################
    $self->{lin_addrspace} = {};
    $self->{pag_addrspace} = {};

    #############
    # code loop #
    #############
    #print "compile_run:\n";
    foreach $code_entry (@{$self->{code}}) {
        $code_pc_lin   = $code_entry->[6];
        $code_pc_pag   = $code_entry->[7];
        $code_hex      = $code_entry->[8];

        ########################
        # linear address space #
        ########################
        if (defined $code_pc_lin) {
            $address = $code_pc_lin;
            if (($code_hex !~ /$cmp_no_hexcode/) &&
                ($code_hex !~ /^\s*$/)) {
		$first_byte = 1;
                foreach $byte (split /\s+/, $code_hex) {
                    $self->{lin_addrspace}->{$address} = [hex($byte),
                                                          $code_entry,
							  $first_byte];
		    $first_byte = 0;
                    $address++;
                }
            }
        }

        #######################
        # paged address space #
        #######################
        if (defined $code_pc_pag) {
            $address = $code_pc_pag;
            if (($code_hex !~ /$cmp_no_hexcode/) &&
                ($code_hex !~ /^\s*$/)) {
		$first_byte = 1;
                foreach $byte (split /\s+/, $code_hex) {
                    $self->{pag_addrspace}->{$address} = [hex($byte),
                                                          $code_entry,
							  $first_byte];
		    $first_byte = 0;
                    $address++;
                }
            }
        }
    }
}

###########
# outputs #
###########
#################
# print_listing #
#################
sub print_listing {
    my $self      = shift @_;

    #code
    my $code_entry;
    my $code_file;
    my $code_line;
    my $code_comments;
    my $code_pc_lin;
    my $code_pc_pag;
    my $code_hex;
    my $code_errors;
    my $code_error;
    my $code_macros;
    my $code_pc_lin_string;
    my $code_pc_pag_string;
    my @code_hex_bytes;
    my @code_hex_strings;
    my $code_hex_string;
    #comments
    my @cmt_lines;
    my $cmt_line;
    my $cmt_last_line;
    #output
    my $out_string;

    ############################
    # initialize output string #
    ############################
    $out_string = "";

    #############
    # code loop #
    #############
    foreach $code_entry (@{$self->{code}}) {

        $code_line     = $code_entry->[0];
        $code_file     = $code_entry->[1];
        $code_comments = $code_entry->[2];
        $code_pc_lin   = $code_entry->[6];
        $code_pc_pag   = $code_entry->[7];
        $code_hex      = $code_entry->[8];
        $code_errors   = $code_entry->[10];
        $code_macros   = $code_entry->[11];

        #convert integers to strings
        if (defined $code_pc_lin) {
            $code_pc_lin_string = sprintf("%.6X", $code_pc_lin);
        } else {
            #$code_pc_lin_string = "??????";
            $code_pc_lin_string = "      ";

        }
        if (defined $code_pc_pag) {
            $code_pc_pag_string = sprintf("%.6X", $code_pc_pag);
        } else {
            $code_pc_pag_string = "??????";
        }

        if (defined $code_hex) {
            for ($code_hex) {
                ##################################
                # whitespaces instead of hexcode #
                ##################################
                /^\s*$/ && do {
                    @code_hex_strings = ("");
                    last;};
                #############################
                # string instead of hexcode #
                #############################
                /$cmp_no_hexcode/ && do {
                    @code_hex_strings = ($1);
                    last;};
                ###########
                # hexcode #
                ###########
                @code_hex_strings = ();
                @code_hex_bytes = split /\s+/, $code_hex;
                while ($#code_hex_bytes >= 0) {
                    $code_hex_string = "";
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
                                                                                     (shift @code_hex_bytes)));}
                    #trim string
                    $code_hex_string =~ s/^\s*//;
                    $code_hex_string =~ s/\s*$//;
                    push @code_hex_strings, $code_hex_string;
                }
            }
	    #printf "\"%s\" \"%s\" (%s)\n", $code_hex, $code_hex_strings[0], $code_comments->[0]
        } else {
            @code_hex_strings = ("??");
        }

        ##################
        # print comments #
        ##################
        @cmt_lines = @$code_comments;
        $cmt_last_line = pop @cmt_lines;
        foreach $cmt_line (@cmt_lines) {
	    if (defined $code_macros) {
		if ($#$code_macros < 0) {
		    $out_string .= sprintf("%-6s %-6s %-23s %ls\n", "", "", "", $cmt_line);
		} else {
		    $out_string .= sprintf("%-6s %-6s %-23s %-80s (%ls)\n", "", "", "", $cmt_line, join("/", reverse @$code_macros));
		}
	    } else {
		$out_string .= sprintf("%-6s %-6s %-23s %ls\n", "", "", "", $cmt_line);
	    }
        }

        ###################
        # print code line #
        ###################
	if (defined $code_macros ) {
	    if ($#$code_macros < 0) {
		$out_string .= sprintf("%-6s %-6s %-23s %ls\n", ($code_pc_pag_string,
								 $code_pc_lin_string,
								 shift @code_hex_strings,
								 $cmt_last_line));
	    } else {
		$out_string .= sprintf("%-6s %-6s %-23s %-80s (%ls)\n", ($code_pc_pag_string,
									 $code_pc_lin_string,
									 shift @code_hex_strings,
									 $cmt_last_line,
				                                         join("/", reverse @$code_macros)));
	    }
	} else {
	    $out_string .= sprintf("%-6s %-6s %-23s %ls\n", ($code_pc_pag_string,
							     $code_pc_lin_string,
							     shift @code_hex_strings,
							     $cmt_last_line));
	} 

        ##############################
        # print additional hex bytes #
        ##############################
        foreach $code_hex_string (@code_hex_strings) {
            $out_string .= sprintf("%-6s %-6s %-23s %ls\n", "", "", $code_hex_string, "");
        }

        ################
        # print errors #
        ################
        foreach $code_error (@$code_errors) {
            $out_string .= sprintf("%-6s %-6s %-23s ERROR! %s (%s, line: %d)\n", ("", "", "",
                                                                                  $code_error,
                                                                                  $$code_file,
                                                                                  $code_line));
        }
    }
    return $out_string;
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

    #S-records
    my $srec_count;
    my @srec_bytes;
    my $srec_address;
    #memoryspace
    my $mem_addr;
    my $mem_entry;
    my $mem_byte;
    #output
    my $out_string;

    ############################
    # initialize output string #
    ############################
    $out_string = "";

    ################
    # print header #
    ################
    $out_string .= sprintf("%s", $self->gen_header_srec($string, $srec_data_length));

    ################
    # address loop #
    ################
    $srec_count = 0;
    @srec_bytes = ();
    foreach $mem_addr (sort {$a <=> $b} keys %{$self->{lin_addrspace}}) {
        $mem_entry = $self->{lin_addrspace}->{$mem_addr};
        $mem_byte  = $mem_entry->[0];


        #printf STDERR "address: %X\n", $mem_addr;
        if ($#srec_bytes < 0) {
            ##########################
            # new group of S-records #
            ##########################
            #print STDERR "new S-Record\n";
            if ($srec_word_entries && ($mem_addr & 1)) {
                ######################################
                # odd start address => add fill byte #
                ######################################
                #print STDERR "  => odd start address!\n";
                $srec_address = $mem_addr - 1;
                push @srec_bytes, $srec_def_fill_byte;
                push @srec_bytes, $mem_byte;
            } else {
                ######################
                # even start address #
                ######################
                #print STDERR "  => even start address!\n";
                $srec_address = $mem_addr;
                push @srec_bytes, $mem_byte;
            }
        } elsif ($mem_addr == ($srec_address + $#srec_bytes + 1)) {
            #######################################
            # add data byte to group of S-records #
            #######################################
            #printf STDERR "  => add byte (%X %X)\n", $srec_address, ($#srec_bytes + 1);
            push @srec_bytes, $mem_byte;
        } elsif ($srec_word_entries &&
                 ($mem_addr == ($srec_address + $#srec_bytes + 2))) {
            ####################################################
            # add one fill byte and data to group of S-records #
            ####################################################
            #printf STDERR "  => add 1 fill byte (%X %X)\n", $srec_address, ($#srec_bytes + 1);
            push @srec_bytes, $srec_def_fill_byte;
            push @srec_bytes, $mem_byte;
        } elsif ($srec_word_entries &&
                 ($mem_addr & 1) &&
                 ($mem_addr == ($srec_address + $#srec_bytes + 3))) {
            #####################################################
            # add two fill bytes and data to group of S-records #
            #####################################################
            #printf STDERR "  => add 2 fill bytes (%X %X)\n", $srec_address, ($#srec_bytes + 1);
            push @srec_bytes, $srec_def_fill_byte;
            push @srec_bytes, $srec_def_fill_byte;
            push @srec_bytes, $mem_byte;
        } else {
            ############################
            # print group of S-records #
            ############################
            if ($srec_word_entries && (($#srec_bytes + 1) & 1)) {
                ############################################
                # add fill byte at the end of the S-Record #
                ############################################
                #printf STDERR "  => add ending fill bytes (%X)\n", ($#srec_bytes + 1);
                push @srec_bytes, $srec_def_fill_byte;
            }
            while ($#srec_bytes >= 0) {
                if (($#srec_bytes + 1) <= $srec_data_length) {
                    $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_address,
                                                                        \@srec_bytes,
                                                                        $srec_format));
                    @srec_bytes = ();
                } else {
                    $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_address,
                                                                        [splice(@srec_bytes, 0,
                                                                                $srec_data_length)],
                                                                        $srec_format));
                    $srec_address = $srec_address + $srec_data_length;
                }
                $srec_count++;
                if (($srec_add_s5 > 0) &&
                    ($srec_add_s5 <= $srec_count)) {
                    $out_string .= sprintf("%s\n", $self->gen_s5rec($srec_count));
                    $srec_count = 0;
                }
            }
            ##########################
            # new group of S-records #
            ##########################
            #print STDERR "next S-Record\n";
            if ($srec_word_entries && ($mem_addr & 1)) {
                ######################################
                # odd start address => add fill byte #
                ######################################
                #print STDERR "  => odd start address!\n";
                $srec_address = $mem_addr - 1;
                push @srec_bytes, $srec_def_fill_byte;
                push @srec_bytes, $mem_byte;
            } else {
                ######################
                # even start address #
                ######################
                #print STDERR "  => even start address!\n";
                $srec_address = $mem_addr;
                push @srec_bytes, $mem_byte;
            }
        }
    }
    #############################
    # print remaining S-records #
    #############################
    if ($srec_word_entries && (($#srec_bytes + 1) & 1)) {
        ############################################
        # add fill byte at the end of the S-Record #
        ############################################
        #printf STDERR "  => add ending fill bytes (%X)\n", ($#srec_bytes + 1);
        push @srec_bytes, $srec_def_fill_byte;
    }
    while ($#srec_bytes >= 0) {
        if (($#srec_bytes + 1) <= $srec_data_length) {
            $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_address,
                                                                \@srec_bytes,
                                                                $srec_format));
            @srec_bytes = ();
        } else {
            $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_address,
                                                                [splice(@srec_bytes, 0,
                                                                        $srec_data_length)],
                                                                $srec_format));
            $srec_address = $srec_address + $srec_data_length;
        }
        $srec_count++;
        if (($srec_add_s5 > 0) &&
            ($srec_add_s5 <= $srec_count)) {
            $out_string .= sprintf("%s\n", $self->gen_s5rec($srec_count));
            $srec_count = 0;
        }
    }
    ####################################
    # print S5 for remaining S-records #
    ####################################
    if (($srec_add_s5 > 0) &&
        ($srec_count  > 0)) {
        $out_string .= sprintf("%s\n", $self->gen_s5rec($srec_count));
    }

    ################
    # print ending #
    ################
    $out_string .= sprintf("%s\n", $self->gen_end_srec($srec_format));
    return $out_string;
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

    #S-records
    my $srec_count;
    my @srec_bytes;
    my $srec_address;
    #memoryspace
    my $mem_addr;
    my $mem_entry;
    my $mem_byte;
    #output
    my $out_string;

    ############################
    # initialize output string #
    ############################
    $out_string = "";

    ################
    # print header #
    ################
    $out_string .= sprintf("%s", $self->gen_header_srec($string, $srec_data_length));

    ################
    # address loop #
    ################
    $srec_count = 0;
    @srec_bytes = ();
    foreach $mem_addr (sort {$a <=> $b} keys %{$self->{pag_addrspace}}) {
        $mem_entry = $self->{pag_addrspace}->{$mem_addr};
        $mem_byte  = $mem_entry->[0];

        #printf STDERR "address: %X\n", $mem_addr;
        if ($#srec_bytes < 0) {
            ##########################
            # new group of S-records #
            ##########################
            #print STDERR "new S-Record\n";
            if ($srec_word_entries && ($mem_addr & 1)) {
                ######################################
                # odd start address => add fill byte #
                ######################################
                #print STDERR "  => odd start address!\n";
                $srec_address = $mem_addr - 1;
                push @srec_bytes, $srec_def_fill_byte;
                push @srec_bytes, $mem_byte;
            } else {
                ######################
                # even start address #
                ######################
                #print STDERR "  => even start address!\n";
                $srec_address = $mem_addr;
                push @srec_bytes, $mem_byte;
            }
        } elsif ($mem_addr == ($srec_address + $#srec_bytes + 1)) {
            #######################################
            # add data byte to group of S-records #
            #######################################
            #printf STDERR "  => add byte (%X %X)\n", $srec_address, ($#srec_bytes + 1);
            push @srec_bytes, $mem_byte;
        } elsif ($srec_word_entries &&
                 ($mem_addr == ($srec_address + $#srec_bytes + 2))) {
            ####################################################
            # add one fill byte and data to group of S-records #
            ####################################################
            #printf STDERR "  => add 1 fill byte (%X %X)\n", $srec_address, ($#srec_bytes + 1);
            push @srec_bytes, $srec_def_fill_byte;
            push @srec_bytes, $mem_byte;
        } elsif ($srec_word_entries &&
                 ($mem_addr & 1) &&
                 ($mem_addr == ($srec_address + $#srec_bytes + 3))) {
            #####################################################
            # add two fill bytes and data to group of S-records #
            #####################################################
            #printf STDERR "  => add 2 fill bytes (%X %X)\n", $srec_address, ($#srec_bytes + 1);
            push @srec_bytes, $srec_def_fill_byte;
            push @srec_bytes, $srec_def_fill_byte;
            push @srec_bytes, $mem_byte;
        } else {
            ############################
            # print group of S-records #
            ############################
            if ($srec_word_entries && (($#srec_bytes + 1) & 1)) {
                ############################################
                # add fill byte at the end of the S-Record #
                ############################################
                #printf STDERR "  => add ending fill bytes (%X)\n", ($#srec_bytes + 1);
                push @srec_bytes, $srec_def_fill_byte;
            }
            while ($#srec_bytes >= 0) {
                if (($#srec_bytes + 1) <= $srec_data_length) {
                    $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_address,
                                                                        \@srec_bytes,
                                                                        $srec_format));
                    @srec_bytes = ();
                } else {
                    $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_address,
                                                                        [splice(@srec_bytes, 0,
                                                                                $srec_data_length)],
                                                                        $srec_format));
                    $srec_address = $srec_address + $srec_data_length;
                }
                $srec_count++;
                if (($srec_add_s5 > 0) &&
                    ($srec_add_s5 <= $srec_count)) {
                    $out_string .= sprintf("%s\n", $self->gen_s5rec($srec_count));
                    $srec_count = 0;
                }
            }
            ##########################
            # new group of S-records #
            ##########################
            #print STDERR "next S-Record\n";
            if ($srec_word_entries && ($mem_addr & 1)) {
                ######################################
                # odd start address => add fill byte #
                ######################################
                #print STDERR "  => odd start address!\n";
                $srec_address = $mem_addr - 1;
                push @srec_bytes, $srec_def_fill_byte;
                push @srec_bytes, $mem_byte;
            } else {
                ######################
                # even start address #
                ######################
                #print STDERR "  => even start address!\n";
                $srec_address = $mem_addr;
                push @srec_bytes, $mem_byte;
            }
        }
    }
    #############################
    # print remaining S-records #
    #############################
    if ($srec_word_entries && (($#srec_bytes + 1) & 1)) {
        ############################################
        # add fill byte at the end of the S-Record #
        ############################################
        #printf STDERR "  => add ending fill bytes (%X)\n", ($#srec_bytes + 1);
        push @srec_bytes, $srec_def_fill_byte;
    }
    while ($#srec_bytes >= 0) {
        if (($#srec_bytes + 1) <= $srec_data_length) {
            $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_address,
                                                                \@srec_bytes,
                                                                $srec_format));
            @srec_bytes = ();
        } else {
            $out_string .= sprintf("%s\n", $self->gen_data_srec($srec_address,
                                                                [splice(@srec_bytes, 0,
                                                                        $srec_data_length)],
                                                                $srec_format));
            $srec_address = $srec_address + $srec_data_length;
        }
        $srec_count++;
        if (($srec_add_s5 > 0) &&
            ($srec_add_s5 <= $srec_count)) {
            $out_string .= sprintf("%s\n", $self->gen_s5rec($srec_count));
            $srec_count = 0;
        }
    }
    ####################################
    # print S5 for remaining S-records #
    ####################################
    if (($srec_add_s5 > 0) &&
        ($srec_count          > 0)) {
        $out_string .= sprintf("%s\n", $self->gen_s5rec($srec_count));
    }

    ################
    # print ending #
    ################
    $out_string .= sprintf("%s\n", $self->gen_end_srec($srec_format));
    return $out_string;
}

###################
# gen_header_srec #
###################
sub gen_header_srec {
    my $self             = shift @_;
    my $string           = shift @_;
    my $srec_data_length = shift @_;

    #data
    my $char;
    #hex codes
    my @hex_string;
    my @hex_line;
    my $hex_code;
    #checksum
    my $sum;
    #S-record
    my $record;

    ########################
    # conver string to hex #
    ########################
    @hex_string = ();
    foreach $char (split //, $string) {
        push @hex_string, ord($char);
    }
    #printf STDERR "hex string length: %s \"%s\"\n", $#hex_string, $string;

    #################
    # hex code loop #
    #################
    while ($#hex_string >= 0) {
        @hex_line = splice @hex_string, 0, $srec_data_length;
        #printf STDERR "srec_data_length: \"%s\"\n", $srec_data_length;
        #printf STDERR "hex line: \"%s\"\n", join("\", \"", @hex_line);
        #printf STDERR "hex line length: %s\n", $#hex_line;

        #####################
        # add address field #
        #####################
        unshift @hex_line, 0;
        unshift @hex_line, 0;

        ####################
        # add length field #
        ####################
        unshift @hex_line, ($#hex_line + 2);

        ######################
        # add checksum field #
        ######################
        $sum = 0;
        foreach $hex_code (@hex_line) {
            $sum = $sum + $hex_code;
        }
        push @hex_line, (0xff - ($sum & 0xff));

        #####################
        # generate S-record #
        #####################
        $record = "S0";
        foreach $hex_code (@hex_line) {
            $record = sprintf("%s%.2X", $record, $hex_code);
        }
        $record = sprintf("%s\n", $record);
    }

    ########################
    # return header string #
    ########################
    return $record;
}

#################
# gen_data_srec #
#################
sub gen_data_srec {
    my $self      = shift @_;
    my $address   = shift @_;
    my $data      = shift @_;
    my $format    = shift @_;

    #hex codes
    my @hex_codes;
    my $hex_code;
    #checksum
    my $sum;
    #S-record
    my $record;

    #######################
    # write address field #
    #######################
    for ($format) {
        /^S3.$/i && do {
            #############
            # S3 record #
            #############
            $record = "S3";
            @hex_codes = ((($address >> 24) & 0xff),
                          (($address >> 16) & 0xff),
                          (($address >>  8) & 0xff),
                          ( $address        & 0xff));
            last;};
        /^S2.$/i && do {
            #############
            # S2 record #
            #############
            $record = "S2";
            @hex_codes = ((($address >> 16) & 0xff),
                          (($address >>  8) & 0xff),
                          ( $address        & 0xff));
            last;};
        /^S1.$/i && do {
            #############
            # S1 record #
            #############
            $record = "S1";
            @hex_codes = ((($address >>  8) & 0xff),
                          ( $address        & 0xff));
            last;};
        ##################
        # invalid format #
        ##################
        return 0;
    }

    ##################
    # add data field #
    ##################
    push @hex_codes, @$data;

    ####################
    # add length field #
    ####################
    unshift @hex_codes, ($#hex_codes + 2);

    ######################
    # add checksum field #
    ######################
    $sum = 0;
    foreach $hex_code (@hex_codes) {
        $sum = $sum + $hex_code;
    }
    push @hex_codes, (0xff - ($sum & 0xff));

    #####################
    # generate S-record #
    #####################
    foreach $hex_code (@hex_codes) {
        $record = sprintf("%s%.2X", $record, $hex_code);
    }

    ########################
    # return header string #
    ########################
    return $record;
}

#############
# gen_s5rec #
#############
sub gen_s5rec {
    my $self      = shift @_;
    my $number    = shift @_;

    #hex codes
    my @hex_codes;
    my $hex_code;
    #checksum
    my $sum;
    #S-record
    my $record;

    #######################
    # write address field #
    #######################
    @hex_codes = ((($number >>  8) & 0xff),
                  ( $number        & 0xff));

    ####################
    # add length field #
    ####################
    unshift @hex_codes, 3;

    ######################
    # add checksum field #
    ######################
    $sum = 0;
    foreach $hex_code (@hex_codes) {
        $sum = $sum + $hex_code;
    }
    push @hex_codes, (0xff - ($sum & 0xff));

    #####################
    # generate S-record #
    #####################
    $record = "S5";
    foreach $hex_code (@hex_codes) {
        $record = sprintf("%s%.2X", $record, $hex_code);
    }

    ########################
    # return header string #
    ########################
    return $record;
}

################
# gen_end_srec #
################
sub gen_end_srec {
    my $self      = shift @_;
    my $format    = shift @_;

    for ($format) {
        /^S.7$/i && do {
            #############
            # S7 record #
            #############
            return "S70500000000FA";
            last;};
        /^S.8$/i && do {
            #############
            # S8 record #
            #############
            return "S804000000FB";
            last;};
        /^S.9$/i && do {
            #############
            # S9 record #
            #############
            return "S9030000FC";
            last;};
        ##################
        # invalid format #
        ##################
        return 0;
    }
}

####################
# print_lin_binary #
####################
sub print_lin_binary {
    my $self              = shift @_;
    my $start_addr        = shift @_;
    my $end_addr          = shift @_;

    #memoryspace
    my $mem_addr;
    my $mem_entry;
    my $mem_byte;
    #output
    my @out_list;

    ##########################
    # initialize output list #
    ##########################
    $out_list = ();

    ################
    # address loop #
    ################
    for ($mem_addr =  $start_addr; 
	 $mem_addr <= $end_addr;
	 $mem_addr++) {

	if (exists $self->{lin_addrspace}->{$mem_addr}) {
	    $mem_entry = $self->{lin_addrspace}->{$mem_addr};
	    $mem_byte  = hex($mem_entry->[0]);
	} else {
	    $mem_byte  = 0;
	}

	push  @out_list, $mem_byte;
	
	return pack "C*", @out_list;   
    }
}

####################
# print_pag_binary #
####################
sub print_pag_binary {
    my $self              = shift @_;
    my $start_addr        = shift @_;
    my $end_addr          = shift @_;

    #memoryspace
    my $mem_addr;
    my $mem_entry;
    my $mem_byte;
    #output
    my @out_list;

    ##########################
    # initialize output list #
    ##########################
    $out_list = ();

    ################
    # address loop #
    ################
    for ($mem_addr =  $start_addr; 
	 $mem_addr <= $end_addr;
	 $mem_addr++) {

	if (exists $self->{pag_addrspace}->{$mem_addr}) {
	    $mem_entry = $self->{pag_addrspace}->{$mem_addr};
	    $mem_byte  = hex($mem_entry->[0]);
	} else {
	    $mem_byte  = 0;
	}

	push  @out_list, $mem_byte;
	
	return pack "C*", @out_list;   
    }
}

##############
## print_elf #
##############
#sub print_elf {
#    my $self              = shift @_;
#
#    #output
#    my $@elf_header;
#    
#    ###########################
#    # determine program entry #
#    ###########################
#    my $entry_point;
#    if ((exists $self->{pag_addrspace}->{0xfffe}) &&
#	 (exists $self->{pag_addrspace}->{0xffff})) {
#	 $entry_point =  [$self->{pag_addrspace}->{0xfffe}->[0],
#			  $self->{pag_addrspace}->{0xffff}->[0]];
#    } else {
#	 $entry_point =  [0x00, 0x00];
#    }
#
#    ##############
#    # ELF header #
#    ##############
#    @elf_header = ();
#
#    #e_ident
#    push @elf_header,  0x07,                  #ID
#			ord("E"),            
#			ord("L"),            
#			ord("F")	            
#			0x01,                  #ELFCLASS32
#			0x02,                  #ELFDATA2MSB
#			0x01,                  #Version
#			0x00,
#			0x00,
#			0x00,
#			0x00,
#			0x00,
#			0x00,
#			0x00,
#			0x00,
#			0x00;
#    #e_type	       
#    push @elf_header,  0x00, 0x02             #ET_EXEC
#    #e_machine	       		              
#    push @elf_header,  0x00, 70               #EM_HC11
#    #push @elf_header, 0x00, 53               #EM_HC12
#    #e_version
#    push @elf_header,  0x00, 0x00, 0x00, 0x01 #EV_CURRENT
#    #e_entry
#    push @elf_header, $entry_point->[0], $entry_point->[1];
#    #e_phoff
#
#
#    #e_shoff
#    #e_flags
#	  my $e_ehsize
#	  my $e_phentsize
#
#
#}

#########################
# pseudo opcode handler #
#########################
##############
# psop_align #
##############
sub psop_align {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $bit_mask;
    my $bit_mask_res;
    my $fill_byte;
    my $fill_byte_res;
    #hex code
    my @hex_code;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];
    $code_args =~ s/^\s*//;
    $code_args =~ s/\s*$//;
    for ($code_args) {
        ############
        # bit mask #
        ############
        /$psop_1_arg/ && do {
            $bit_mask        = $1;
            #printf STDERR "ALLIGN: \"%X\"\n", $bit_mask;

            ######################
            # determine bit mask #
            ######################
            ($error, $bit_mask_res) = @{$self->evaluate_expression($bit_mask,
                                                                   $$pc_lin_ref,
                                                                   $$pc_pag_ref,
                                                                   $$loc_cnt_ref,
								   $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } elsif (! defined $bit_mask_res) {
                ###################
                # undefined value #
                ###################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } elsif (! defined $$pc_pag_ref) {
                ######################
                # undefined paged PC #
                ######################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } else {
                ##################
                # valid bit mask #
                ##################
                while ($$pc_pag_ref & $bit_mask_res) {
                    if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
                    if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
                }
                $code_entry->[6]  = $$pc_lin_ref;
                $code_entry->[7]  = $$pc_pag_ref;
                $code_entry->[8]  = "";
                $$label_value_ref = $$pc_pag_ref;
            }
            last;};
        #######################
        # bit mask, fill byte #
        #######################
        /$psop_2_args/ && do {
            $bit_mask  = $1;
            $fill_byte = $2;
            ######################
            # determine bit mask #
            ######################
            ($error, $bit_mask_res) = @{$self->evaluate_expression($bit_mask,
                                                                   $$pc_lin_ref,
                                                                   $$pc_pag_ref,
                                                                   $$loc_cnt_ref,
								   $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $$label_value_ref = undef;
            } elsif (! defined $bit_mask_res) {
                ###################
                # undefined value #
                ###################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $$label_value_ref = undef;
                $$undef_count++;
            } else {
                ##################
                # valid bit mask #
                ##################
                #######################
                # determine fill byte #
                #######################
                ($error, $fill_byte_res) = @{$self->evaluate_expression($fill_byte,
                                                                        $$pc_lin_ref,
                                                                        $$pc_pag_ref,
                                                                        $$loc_cnt_ref,
								        $code_entry->[12])};
                if ($error) {
                    ################
                    # syntax error #
                    ################
                    $code_entry->[10] = [@{$code_entry->[10]}, $error];
                    $$error_count_ref++;
                    return;
                } elsif (! defined $fill_byte_res) {
                    ###################
                    # undefined value #
                    ###################
                    while ($$pc_pag_ref & $bit_mask_res) {
                        if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
                        if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
                    }
                    $$label_value_ref = $$pc_pag_ref;
                    #undefine hexcode
                    $code_entry->[8] = undef;
                    $$undef_count++;
                } else {
                    ###################
                    # valid fill byte #
                    ###################
                    @hex_code = ();
                    while ($$pc_pag_ref & $bit_mask_res) {
                        if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
                        if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
                        push @hex_code, sprintf("%.2X", ($fill_byte_res & 0xff));
                    }
                    #set hex code and byte count
                    $code_entry->[8]  = join " ", @hex_code;
                    $code_entry->[9]  = ($#hex_code + 1);
                }
            }
            last;};
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode ALIGN (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
        $$pc_lin_ref     = undef;
        $$pc_pag_ref     = undef;
        $code_entry->[8] = undef;
    }
}

############
# psop_cpu #
############
sub psop_cpu {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_label = $code_entry->[1];
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$psop_1_arg/) {
        ################
        # one argument #
        ################
        $value = $1;
        #print STDERR "CPU: $value\n";
        $error = $self->set_opcode_table($value);
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
        } else {
            ##################
            # valid argument #
            ##################
            #check if symbol already exists
            $code_entry->[8]  = sprintf("%s CODE:", $value);
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode CPU (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

###########
# psop_db #
###########
sub psop_db {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $code_arg;
    my @code_args_res;
    my $code_args_defined;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];

    #####################
    # resolve arguments #
    #####################
    @code_args_res     = ();
    $code_args_defined = 1;
    foreach $code_arg (split $del, $code_args) {
        ($error, $value) = @{$self->evaluate_expression($code_arg,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
            if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
            push @code_args_res, 0;
            $code_args_defined = 0;
        } elsif (! defined $value) {
            ###################
            # undefined value #
            ###################
            if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
            push @code_args_res, 0;
            $code_args_defined = 0;
        } else {
            ##################
            # valid argument #
            ##################
            if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
            push @code_args_res, sprintf("%.2X", ($value & 0xff));
        }
    }

    #set hex code and byte count
    if ($code_args_defined) {
        $code_entry->[8] = join " ", @code_args_res;
    } else {
        $$undef_count_ref++;
    }
    $code_entry->[9] = ($#code_args_res + 1);
}

###########
# psop_dw #
###########
sub psop_dw {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref   = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;


    #arguments
    my $code_args;
    my $code_arg;
    my @code_args_res;
    my $code_args_defined;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];

    #####################
    # resolve arguments #
    #####################
    @code_args_res     = ();
    $code_args_defined = 1;
    foreach $code_arg (split $del, $code_args) {
        ($error, $value) = @{$self->evaluate_expression($code_arg,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
            if (defined $$pc_lin_ref) {$$pc_lin_ref += 2;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref += 2;}
            push @code_args_res, 0;
            $code_args_defined = 0;
        } elsif (! defined $value) {
            ###################
            # undefined value #
            ###################
            if (defined $$pc_lin_ref) {$$pc_lin_ref += 2;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref += 2;}
            push @code_args_res, 0;
            $code_args_defined = 0;
        } else {
            ##################
            # valid argument #
            ##################
            if (defined $$pc_lin_ref) {$$pc_lin_ref += 2;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref += 2;}
            push @code_args_res, sprintf("%.2X", (($value >> 8) & 0xff));
            push @code_args_res, sprintf("%.2X", ( $value       & 0xff));
        }
    }

    #set hex code and byte count
    if ($code_args_defined) {
        $code_entry->[8] = join " ", @code_args_res;
    } else {
        $$undef_count_ref++;
    }
    $code_entry->[9] = ($#code_args_res + 1);
}


############
# psop_dsb #
############
sub psop_dsb {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref   = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$psop_1_arg/) {
        ################
        # one argument #
        ################
        ($error, $value) = @{$self->evaluate_expression($1,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
            $$pc_lin_ref = undef;
            $$pc_pag_ref = undef;
        } elsif (! defined $value) {
            ###################
            # undefined value #
            ###################
            $$pc_lin_ref = undef;
            $$pc_pag_ref = undef;
        } else {
            ##################
            # valid argument #
            ##################
            if (defined $$pc_lin_ref) {$$pc_lin_ref = $$pc_lin_ref + $value;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref = $$pc_pag_ref + $value;}
            $code_entry->[8] = "";
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode DS (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
        $$pc_lin_ref = undef;
        $$pc_pag_ref = undef;
    }
}

############
# psop_dsw #
############
sub psop_dsw {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref   = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$psop_1_arg/) {
        ################
        # one argument #
        ################
        ($error, $value) = @{$self->evaluate_expression($1,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
            $$pc_lin_ref = undef;
            $$pc_pag_ref = undef;
        } elsif (! defined $value) {
            ###################
            # undefined value #
            ###################
            $$pc_lin_ref = undef;
            $$pc_pag_ref = undef;
        } else {
            ##################
            # valid argument #
            ##################
            if (defined $$pc_lin_ref) {$$pc_lin_ref = $$pc_lin_ref + ($value * 2);}
            if (defined $$pc_pag_ref) {$$pc_pag_ref = $$pc_pag_ref + ($value * 2);}
            $code_entry->[8] = "";
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode DS.W (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
        $$pc_lin_ref = undef;
        $$pc_pag_ref = undef;
    }
}

############
# psop_equ #
############
sub psop_equ {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_label;
    my $code_args;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_label = $code_entry->[1];
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$psop_1_arg/) {
        ################
        # one argument #
        ################
        ($error, $value) = @{$self->evaluate_expression($1,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
        } elsif (! defined $value) {
            ###################
            # undefined value #
            ###################
            $$label_value_ref = undef;
            $code_entry->[8]  = sprintf("-> ????", $value);
        } else {
            ##################
            # valid argument #
            ##################
            #check if symbol already exists
            $$label_value_ref = $value;
            $code_entry->[8]  = sprintf("-> \$%.4X", $value);
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode EQU (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

############
# psop_fcc #
############
sub psop_fcc {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $string;
    my $first_char;
    #hex code
    my $char;
    my @hex_code;
    #temporary

    ##################
    # read arguments #
    ##################
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$psop_string/) {
        $string = $1;

        #trim string
        $string =~ s/^\s*//;
        $string =~ s/\s*$//;

        #trim first character
        $string     =~ s/^(.)//;
        $first_char = $1;

        #trim send of string
        if ($string =~ /^(.*)$first_char/) {$string = $1;}
        #printf STDERR "fcc: \"%s\" \"%s\"\n", $first_char, $string;

        #convert string
        @hex_code = ();
        foreach $char (split //, $string) {
            push @hex_code, sprintf("%.2X", ord($char));
            if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
        }
        #set hex code and byte count
        $code_entry->[8] = join " ", @hex_code;
        $code_entry->[9] = ($#hex_code + 1);

    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode FCC (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

############
# psop_fcs #
############
sub psop_fcs {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $string;
    my $first_char;
    #hex code
    my $char;
    my @hex_code;
    #temporary

    ##################
    # read arguments #
    ##################
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$psop_string/) {
        $string = $1;

        #trim string
        $string =~ s/^\s*//;
        $string =~ s/\s*$//;

        #trim first character
        $string     =~ s/^(.)//;
        $first_char = $1;

        #trim send of string
        if ($string =~ /^(.*)$first_char/) {$string = $1;}
        #printf STDERR "fcs: \"%s\" \"%s\"\n", $first_char, $string;

        #trim last character
        $string     =~ s/(.)$//;
        $last_char = $1;
	
        #convert string
        @hex_code = ();
        foreach $char (split //, $string) {
            push @hex_code, sprintf("%.2X", ord($char));
            if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
            if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
        }

        #convert last character
        push @hex_code, sprintf("%.2X", (ord($last_char)|0x80));
        if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
        if (defined $$pc_pag_ref) {$$pc_pag_ref++;}

        #set hex code and byte count
        $code_entry->[8] = join " ", @hex_code;
        $code_entry->[9] = ($#hex_code + 1);

    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode FCS (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

#############
# psop_fill #
#############
sub psop_fill {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $byte_count;
    my $byte_count_res;
    my $fill_byte;
    my $fill_byte_res;
    #hex code
    my @hex_code;
    #temporary
    my $error;
    my $value;
    my $i;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];
    if ($code_args =~ /$psop_2_args/) {
        $fill_byte  = $1;
        $byte_count = $2;

        ########################
        # determine byte count #
        ########################
        ($error, $byte_count_res) = @{$self->evaluate_expression($byte_count,
                                                                 $$pc_lin_ref,
                                                                 $$pc_pag_ref,
                                                                 $$loc_cnt_ref,
						                 $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
        } elsif (! defined $byte_count_res) {
            ###################
            # undefined value #
            ###################
            $$pc_lin_ref      = undef;
            $$pc_pag_ref      = undef;
            $$label_value_ref = undef;
            $$undef_count++;
        } else {
            ####################
            # valid byte count #
            ####################
            #######################
            # determine fill byte #
            #######################
            ($error, $fill_byte_res) = @{$self->evaluate_expression($fill_byte,
                                                                    $$pc_lin_ref,
                                                                    $$pc_pag_ref,
                                                                    $$loc_cnt_ref,
						                    $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                return;
            } elsif (! defined $fill_byte_res) {
                ###################
                # undefined value #
                ###################
                if (defined $$pc_lin_ref) {$$pc_lin_ref = $$pc_lin_ref + $byte_count_res;}
                if (defined $$pc_pag_ref) {$$pc_pag_ref = $$pc_pag_ref + $byte_count_res;}
                #undefine hexcode
                $code_entry->[8] = undef;
                $$undef_count++;
            } else {
                ###################
                # valid fill byte #
                ###################
                @hex_code = ();
                foreach $i (1..$byte_count_res) {
                    push @hex_code, sprintf("%.2X", ($fill_byte_res & 0xff));
                }
                if (defined $$pc_lin_ref) {$$pc_lin_ref = $$pc_lin_ref + $byte_count_res;}
                if (defined $$pc_pag_ref) {$$pc_pag_ref = $$pc_pag_ref + $byte_count_res;}
                #set hex code and byte count
                $code_entry->[8] = join " ", @hex_code;
                $code_entry->[9] = ($#hex_code + 1);
            }
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode FILL (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
        $$pc_lin_ref = undef;
        $$pc_pag_ref = undef;
    }
}

############
# psop_loc #
############
sub psop_loc {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref   = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;

    ##################
    # read arguments #
    ##################
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$psop_no_arg/) {

        #increment LOC count
        $$loc_cnt_ref++;

        $code_entry->[8]  = sprintf("\"`\" = %.4d", $$loc_cnt_ref);

    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode LOC (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

############
# psop_org #
############
sub psop_org {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $pc_lin;
    my $pc_lin_res;
    my $pc_pag;
    my $pc_pag_res;
    #hex code
    my @hex_code;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];
    for ($code_args) {
        ############
        # paged pc #
        ############
        /$psop_1_arg/ && do {
            $pc_pag          = $1;
            $code_entry->[8] = "";
            ######################
            # determine paged PC #
            ######################
            ($error, $pc_pag_res) = @{$self->evaluate_expression($pc_pag,
                                                                 $$pc_lin_ref,
                                                                 $$pc_pag_ref,
                                                                 $$loc_cnt_ref,
						                 $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                #print "$error\n";
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
            } elsif (! defined $pc_pag_res) {
                ###################
                # undefined value #
                ###################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } else {
                ##################
                # valid paged pc #
                ##################
                $$pc_pag_ref      = $pc_pag_res;
                $code_entry->[7]  = $pc_pag_res;
                $$label_value_ref = $pc_pag_res;
                #######################
                # determine linear pc #
                #######################
                if ((($pc_pag_res & 0xffff) >= 0x0000) &&
                    (($pc_pag_res & 0xffff) <  0x4000)) {
                    #####################
                    # fixed page => $3D #
                    #####################
                    $$pc_lin_ref      = ((0x3d * 0x4000) + (($pc_pag_res - 0x0000) & 0xffff));
                    $code_entry->[6]  = $$pc_lin_ref;
                } elsif ((($pc_pag_res & 0xffff) >= 0x4000) &&
                         (($pc_pag_res & 0xffff) <  0x8000)) {
                    #####################
                    # fixed page => $3E #
                    #####################
                    $$pc_lin_ref      = ((0x3e * 0x4000) + (($pc_pag_res - 0x4000) & 0xffff));
                    $code_entry->[6]  = $$pc_lin_ref;
                } elsif ((($pc_pag_res & 0xffff) >= 0x8000) &&
                         (($pc_pag_res & 0xffff) <  0xC000)) {
                    #####################
                    # paged memory area #
                    #####################
                    $$pc_lin_ref      = (((($pc_pag_res >> 16) & 0xff) * 0x4000) + (($pc_pag_res - 0x8000) & 0xffff));
                    $code_entry->[6]  = $$pc_lin_ref;
                } else {
                    ####################
                    # fixed page => 3F #
                    ####################
                    $$pc_lin_ref      = ((0x3f * 0x4000) + (($pc_pag_res - 0xc000) & 0xffff));
                    $code_entry->[6]  = $$pc_lin_ref;
                }
            }
            last;};
        #######################
        # paged and linear PC #
        #######################
        /$psop_2_args/ && do {
            $pc_pag = $1;
            $pc_lin = $2;
            #printf STDERR "ORG %s ->\n",  $code_args;
            #printf STDERR "ORG %s %s ->\n",  $pc_pag, $pc_lin;
            $code_entry->[8]  = "";
            ######################
            # determine paged PC #
            ######################
            ($error, $pc_pag_res) = @{$self->evaluate_expression($pc_pag,
                                                                 $$pc_lin_ref,
                                                                 $$pc_pag_ref,
                                                                 $$loc_cnt_ref,
						                 $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                #print "$error\n";
                $$pc_pag_ref      = undef;
                $code_entry->[7]  = undef;
            } elsif (! defined $pc_pag_res) {
                ###################
                # undefined value #
                ###################
                $$pc_pag_ref      = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } else {
                ##################
                # valid paged pc #
                ##################
                $$pc_pag_ref      = $pc_pag_res;
                $code_entry->[7]  = $pc_pag_res;
                $$label_value_ref = $pc_pag_res;
            }
            #######################
            # determine linear PC #
            #######################
            if ($pc_lin =~ /$op_unmapped/) {
                #########################
                # linear pc is unmapped #
                #########################
                $$pc_lin_ref      = undef;
                $code_entry->[6]  = undef;
            } else {
                #######################
                # evaluate expression #
                #######################
                ($error, $pc_lin_res) = @{$self->evaluate_expression($pc_lin,
                                                                     $$pc_lin_ref,
                                                                     $$pc_pag_ref,
                                                                     $$loc_cnt_ref,
						                     $code_entry->[12])};
                if ($error) {
                    ################
                    # syntax error #
                    ################
                    $code_entry->[10] = [@{$code_entry->[10]}, $error];
                    $$error_count_ref++;
                    #print "$error\n";
                    $$pc_lin_ref      = undef;
                    $code_entry->[6]  = undef;
                } elsif (! defined $pc_pag_res) {
                    ###################
                    # undefined value #
                    ###################
                    $$pc_lin_ref      = undef;
                    $code_entry->[6]  = undef;
                } else {
                    ###################
                    # valid linear pc #
                    ###################
                    $$pc_lin_ref      = $pc_lin_res;
                    $code_entry->[6]  = $pc_lin_res;
                }
            }
            #printf STDERR "ORG %X %X\n",  $pc_pag_res, $pc_lin_res;
            last;};
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode ORG (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        #print "$error\n";
        $$error_count_ref++;
        $$pc_lin_ref     = undef;
        $$pc_pag_ref     = undef;
        $code_entry->[6] = undef;
        $code_entry->[7] = undef;
        $code_entry->[8] = undef;
    }
}

##############
# psop_setdp #
##############
sub psop_setdp {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_label = $code_entry->[1];
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$psop_1_arg/) {
        ################
        # one argument #
        ################
        ($error, $value) = @{$self->evaluate_expression($1,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
        } else {
            ##################
            # valid argument #
            ##################
            #set direct page
            $self->{dir_page} = $value;
            $code_entry->[8]  = sprintf("DIRECT PAGE = \$%2X:", $value);
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode CPU (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

################
# psop_unalign #
################
sub psop_unalign {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref     = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_args;
    my $bit_mask;
    my $bit_mask_res;
    my $fill_byte;
    my $fill_byte_res;
    #hex code
    my @hex_code;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args = $code_entry->[5];
    for ($code_args) {
        ############
        # bit mask #
        ############
        /$psop_1_arg/ && do {
            $bit_mask         = $1;
            ######################
            # determine bit mask #
            ######################
            ($error, $bit_mask_res) = @{$self->evaluate_expression($bit_mask,
                                                                   $$pc_lin_ref,
                                                                   $$pc_pag_ref,
                                                                   $$loc_cnt_ref,
						                   $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } elsif (! defined $bit_mask_res) {
                ###################
                # undefined value #
                ###################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } elsif (! defined $$pc_pag_ref) {
                ######################
                # undefined paged PC #
                ######################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $code_entry->[6]  = undef;
                $code_entry->[7]  = undef;
                $$label_value_ref = undef;
            } else {
                ##################
                # valid bit mask #
                ##################
                while (~$$pc_pag_ref & $bit_mask_res) {
                    if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
                    if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
                }
                $code_entry->[6]  = $$pc_lin_ref;
                $code_entry->[7]  = $$pc_pag_ref;
                $code_entry->[8]  = "";
                $$label_value_ref = $$pc_pag_ref;
            }
            last;};
        #######################
        # bit mask, fill byte #
        #######################
        /$psop_2_args/ && do {
            $bit_mask = $1;
            $fill_byte = $2;
            ######################
            # determine bit mask #
            ######################
            ($error, $bit_mask_res) = @{$self->evaluate_expression($bit_mask,
                                                                   $$pc_lin_ref,
                                                                   $$pc_pag_ref,
                                                                   $$loc_cnt_ref,
						                   $code_entry->[12])};
            if ($error) {
                ################
                # syntax error #
                ################
                $code_entry->[10] = [@{$code_entry->[10]}, $error];
                $$error_count_ref++;
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $$label_value_ref = undef;
            } elsif (! defined $bit_mask_res) {
                ###################
                # undefined value #
                ###################
                $$pc_lin_ref      = undef;
                $$pc_pag_ref      = undef;
                $$label_value_ref = undef;
                $$undef_count++;
            } else {
                ##################
                # valid bit mask #
                ##################
                #######################
                # determine fill byte #
                #######################
                ($error, $fill_byte_res) = @{$self->evaluate_expression($fill_byte,
                                                                        $$pc_lin_ref,
                                                                        $$pc_pag_ref,
                                                                        $$loc_cnt_ref,
						                        $code_entry->[12])};
                if ($error) {
                    ################
                    # syntax error #
                    ################
                    $code_entry->[10] = [@{$code_entry->[10]}, $error];
                    $$error_count_ref++;
                    return;
                } elsif (! defined $fill_byte_res) {
                    ###################
                    # undefined value #
                    ###################
                    while (~$$pc_pag_ref & $bit_mask_res) {
                        if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
                        if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
                    }
                    $$label_value_ref = $$pc_pag_ref;
                    #undefine hexcode
                    $code_entry->[8] = undef;
                    $$undef_count++;
                } else {
                    ###################
                    # valid fill byte #
                    ###################
                    @hex_code = ();
                    while (~$$pc_pag_ref & $bit_mask_res) {
                        if (defined $$pc_lin_ref) {$$pc_lin_ref++;}
                        if (defined $$pc_pag_ref) {$$pc_pag_ref++;}
                        push @hex_code, sprintf("%.2X", ($fill_byte_res & 0xff));
                    }
                    #set hex code and byte count
                    $code_entry->[8] = join " ", @hex_code;
                    $code_entry->[9] = ($#hex_code + 1);
                }
            }
            last;};
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode UNALIGN (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
        $$pc_lin_ref = undef;
        $$pc_pag_ref = undef;
        $code_entry->[8] = undef;
    }
}

############
# psop_zmb #
############
sub psop_zmb {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref   = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    #arguments
    my $code_label;
    my $code_args;
    #byte count
    my $byte_count;
    #hex code
    my @hex_code;
    #temporary
    my $error;
    my $value;

    ##################
    # read arguments #
    ##################
    $code_args  = $code_entry->[5];

    ##################
    # check argument #
    ##################
    if ($code_args =~ /$psop_1_arg/) {
        ################
        # one argument #
        ################
        ($error, $value) = @{$self->evaluate_expression($1,
                                                        $$pc_lin_ref,
                                                        $$pc_pag_ref,
                                                        $$loc_cnt_ref,,
						        $code_entry->[12])};
        if ($error) {
            ################
            # syntax error #
            ################
            $code_entry->[10] = [@{$code_entry->[10]}, $error];
            $$error_count_ref++;
            $$pc_lin_ref = undef;
            $$pc_pag_ref = undef;
        } elsif (! defined $value) {
            ###################
            # undefined value #
            ###################
            #undefine hexcode
            $$undef_count++;
            $$pc_lin_ref = undef;
            $$pc_pag_ref = undef;
        } else {
            ##################
            # valid argument #
            ##################
            @hex_code = ();
            foreach $byte_count (1..$value) {
                push @hex_code, "00";
            }
            if (defined $$pc_lin_ref) {$$pc_lin_ref = ($$pc_lin_ref + $value);}
            if (defined $$pc_pag_ref) {$$pc_pag_ref = ($$pc_lin_ref + $value);}
            #set hex code and byte count
            $code_entry->[8] = join " ", @hex_code;
            $code_entry->[9] = ($#hex_code + 1);
        }
    } else {
        ################
        # syntax error #
        ################
        $error = sprintf("invalid argument for pseudo opcode ZMB (%s)",$code_args);
        $code_entry->[10] = [@{$code_entry->[10]}, $error];
        $$error_count_ref++;
    }
}

###############
# psop_ignore #
###############
sub psop_ignore {
    my $self            = shift @_;
    my $pc_lin_ref      = shift @_;
    my $pc_pag_ref      = shift @_;
    my $loc_cnt_ref   = shift @_;
    my $error_count_ref = shift @_;
    my $undef_count_ref = shift @_;
    my $label_value_ref = shift @_;
    my $code_entry      = shift @_;

    ##################
    # valid argument #
    ##################
    #check if symbol already exists
    $code_entry->[8]  = sprintf("IGNORED!");
}

########################
# address mode ckecker #
########################
#############
# check_inh #
#############
sub check_inh {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;

    $$result_ref = $$hex_ref;
    return 1;
}

##############
# check_imm8 #
##############
sub check_imm8 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

###############
# check_imm16 #
###############
sub check_imm16 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

#############
# check_dir #
#############
sub check_dir {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    if ($self->get_dir(0, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_s12x_dir #
##################
sub check_s12x_dir {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    if ($self->get_dir($self->{dir_page}, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#############
# check_ext #
#############
sub check_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

##############
# check_rel8 #
##############
sub check_rel8 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    #printf STDERR "check_rel8: %s\n", $arg_ref->[0];
    if ($self->get_rel8(2, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_rel8_job #
##################
#sub check_rel8_job {
#    my $self       = shift @_;
#    my $arg_ref    = shift @_;
#    my $pc_lin     = shift @_;
#    my $pc_pag     = shift @_;
#    my $loc_cnt    = shift @_;
#    my $sym_tabs   = shift @_;
#    my $hex_ref    = shift @_;
#    my $error_ref  = shift @_;
#    my $result_ref = shift @_;
#    #temporary
#    my $value;
#
#    #printf STDERR "check_rel8_job: %s\n", $arg_ref->[0];
#    if ($self->get_rel8_job(2, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
#        if (defined $value) {
#            $$result_ref = join(" ", ($$hex_ref, $value));
#        } else {
#            $$result_ref = undef;
#        }
#        return 1;
#    }
#    return 0;
#}

###############
# check_rel16 #
###############
sub check_rel16 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    $self->get_rel16(4, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

#############
# check_idx #
#############
sub check_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    #printf STDERR "IDX: \"%s\"\n", join("\", \"",
    #                                     $arg_ref->[0],
    #                                     $arg_ref->[1],
    #                                     $arg_ref->[2],
    #                                     $arg_ref->[3]);

    if ($self->get_idx(\$arg_ref->[0],
                       \$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_idx1 #
##############
sub check_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_idx1(\$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_idx2 #
##############
sub check_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    #printf STDERR "check_idx2: \"%s\"\n", join("\", \"", $arg_ref->[0],
    #                                                     $arg_ref->[1]);

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###############
# check_ididx #
###############
sub check_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###############
# check_iidx2 #
###############
sub check_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_iext #
##############
sub check_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $offset;
    my $value;

    $offset = 3 + split(" ", $$hex_ref); 
    #printf "check_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[0],
                        $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_dir_msk #
#################
sub check_dir_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_dir(0, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

######################
# check_s12x_dir_msk #
######################
sub check_s12x_dir_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_dir($self->{dir_page}, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_ext_msk #
#################
sub check_ext_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
    return 1;
}

#################
# check_idx_msk #
#################
sub check_idx_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    $self->get_byte(\$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_idx(\$arg_ref->[0],
                       \$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_idx1_msk #
##################
sub check_idx1_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    $self->get_byte(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_idx1(\$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_idx2_msk #
##################
sub check_idx2_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    $self->get_byte(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_idx2(0xe2,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#####################
# check_dir_msk_rel #
#####################
sub check_dir_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    if ($self->get_dir(0, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
       $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
       $self->get_rel8(4, \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel);
       if ((defined $rel) && (defined $mask) && (defined $address)) {
          $$result_ref = join(" ", ($$hex_ref, $address, $mask, $rel));
       } else {
          $$result_ref = undef;
       }
       return 1;
    }
    return 0;
}

##########################
# check_s12x_dir_msk_rel #
##########################
sub check_s12x_dir_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    #printf STDERR "check_s12x_dir_msk_rel: \"%s\" %X\n", $arg_ref->[0], $dir_pag;
    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    if ($self->get_dir($self->{dir_page}, \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
        $self->get_rel8(4, \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel);
        if ((defined $rel) && (defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask, $rel));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#####################
# check_ext_msk_rel #
#####################
sub check_ext_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    $self->get_rel8(5, \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel);
    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    if ((defined $rel) && (defined $mask) && (defined $address)) {
       $$result_ref = join(" ", ($$hex_ref, $address, $mask, $rel));
    } else {
       $$result_ref = undef;
    }
    return 1;
}

#####################
# check_idx_msk_rel #
#####################
sub check_idx_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    $self->get_rel8(4, \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel);
    $self->get_byte(\$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_idx(\$arg_ref->[0],
                       \$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
       if ((defined $rel) && (defined $mask) && (defined $address)) {
          $$result_ref = join(" ", ($$hex_ref, $address, $mask, $rel));
       } else {
          $$result_ref = undef;
       }
       return 1;
    }
    return 0;
}

######################
# check_idx1_msk_rel #
######################
sub check_idx1_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    $self->get_rel8(5, \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel);
    $self->get_byte(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_idx1(\$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
       if ((defined $rel) && (defined $mask) && (defined $address)) {
          $$result_ref = join(" ", ($$hex_ref, $address, $mask, $rel));
       } else {
          $$result_ref = undef;
       }
       return 1;
    }
    return 0;
}

######################
# check_idx2_msk_rel #
######################
sub check_idx2_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    $self->get_rel8(6, \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel);
    $self->get_byte(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    if ($self->get_idx2(0xe2,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
       if ((defined $rel) && (defined $mask) && (defined $address)) {
          $$result_ref = join(" ", ($$hex_ref, $address, $mask, $rel));
       } else {
          $$result_ref = undef;
       }
       return 1;
    }
    return 0;
}

####################
# check_ext_pgimpl #
####################
sub check_ext_pgimpl {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $address;

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    $self->get_ext_pgimpl(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    if (defined $address) {
        $$result_ref = join(" ", ($$hex_ref, $address));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

################
# check_ext_pg #
################
sub check_ext_pg {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $page;
    my $address;

    #printf "check_ext_pg: \"%s\", \"%s\"\n", $arg_ref->[0], $arg_ref->[1];
    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$page);
    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    $$result_ref = join(" ", ($$hex_ref, $address, $page));
    return 1;
}

################
# check_idx_pg #
################
sub check_idx_pg {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $page;
    my $address;

    #printf "check_idx_pg: \"%s\", \"%s\", \"%s\", \"%s\", \"%s\"\n", $arg_ref->[0], 
    #                                                                 $arg_ref->[1], 
    #                                                                 $arg_ref->[2], 
    #                                                                 $arg_ref->[3], 
    #                                                                 $arg_ref->[4];
    $self->get_byte(\$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$page);
    if ($self->get_idx(\$arg_ref->[0],
                       \$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $page) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $page));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_idx1_pg #
#################
sub check_idx1_pg {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $page;
    my $address;

    #printf "check_idx1_pg: \"%s\", \"%s\", \"%s\"\n", $arg_ref->[0], $arg_ref->[1], $arg_ref->[2];
    $self->get_byte(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$page);
    if ($self->get_idx1(\$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $page) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $page));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_idx2_pg #
#################
sub check_idx2_pg {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $page;
    my $address;

    #printf "check_idx2_pg: \"%s\", \"%s\", \"%s\"\n", $arg_ref->[0], $arg_ref->[1], $arg_ref->[2];
    $self->get_byte(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$page);
    if ($self->get_idx2(0xe2,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        if ((defined $page) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $page));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_imm8_ext #
##################
sub check_imm8_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($arg_ref->[1] =~ $op_keywords) {return 0;}
    $self->get_word(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
    if ((defined $data) && (defined $address)) {
        $$result_ref = join(" ", ($$hex_ref, $data, $address));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

##################
# check_imm8_idx #
##################
sub check_imm8_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx(\$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_imm8_idx1 #
###################
sub check_imm8_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx1(\$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_imm8_idx2 #
###################
sub check_imm8_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

####################
# check_imm8_ididx #
####################
sub check_imm8_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_ididx(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

####################
# check_imm8_iidx2 #
####################
sub check_imm8_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_imm8_iext #
###################
sub check_imm8_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_imm8_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[1], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_imm16_ext #
###################
sub check_imm16_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($arg_ref->[1] =~ $op_keywords) {return 0;}
    $self->get_word(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
    if ((defined $data) && (defined $address)) {
        $$result_ref = join(" ", ($$hex_ref, $data, $address));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

###################
# check_imm16_idx #
###################
sub check_imm16_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx(\$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

####################
# check_imm16_idx1 #
####################
sub check_imm16_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx1(\$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

####################
# check_imm16_idx2 #
####################
sub check_imm16_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#####################
# check_imm16_ididx #
#####################
sub check_imm16_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_ididx(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#####################
# check_imm16_iidx2 #
#####################
sub check_imm16_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

####################
# check_imm16_iext #
####################
sub check_imm16_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $data;
    my $address;
    my $offset;

    $offset = 5 + split(" ", $$hex_ref); 
    #printf "check_imm16_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[1], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$data);
        if ((defined $data) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $data));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_ext_ext #
#################
sub check_ext_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    if ($arg_ref->[1] =~ $op_keywords) {return 0;}
    $self->get_word(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
    if ((defined $addr0) && (defined $addr1)) {
        $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

#################
# check_ext_idx #
#################
sub check_ext_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    #printf STDERR "check_ext_idx: \"$arg_ref->[0]\" \"$arg_ref->[1]\" \"$arg_ref->[2]\" \"$arg_ref->[3]\" \"$arg_ref->[4]\"\n";

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    if ($self->get_idx(\$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
        if ((defined $addr1) && (defined $addr0)) {
            $$result_ref = join(" ", ($$hex_ref, $addr1, $addr0));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_ext_idx1 #
##################
sub check_ext_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    #printf STDERR "check_ext_idx1: \"$arg_ref->[0]\" \"$arg_ref->[1]\" \"$arg_ref->[2]\"\n";

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    if ($self->get_idx1(\$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
        if ((defined $addr1) && (defined $addr0)) {
            $$result_ref = join(" ", ($$hex_ref, $addr1, $addr0));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_ext_idx2 #
##################
sub check_ext_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    #printf STDERR "check_ext_idx2: \"$arg_ref->[0]\" \"$arg_ref->[1]\" \"$arg_ref->[2]\"\n";

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    if ($self->get_idx2(0xe2,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
        if ((defined $addr1) && (defined $addr0)) {
            $$result_ref = join(" ", ($$hex_ref, $addr1, $addr0));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_ext_ididx #
###################
sub check_ext_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    #printf STDERR "check_ext_ididx: \"$arg_ref->[0]\" \"$arg_ref->[1]\"\n";

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    if ($self->get_ididx(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
        if ((defined $addr1) && (defined $addr0)) {
            $$result_ref = join(" ", ($$hex_ref, $addr1, $addr0));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_ext_iidx2 #
###################
sub check_ext_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    #printf STDERR "check_ext_iidx2: \"$arg_ref->[0]\" \"$arg_ref->[1]\" \"$arg_ref->[2]\"\n";

    if ($arg_ref->[0] =~ $op_keywords) {return 0;}
    if ($self->get_idx2(0xe3,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
        if ((defined $addr1) && (defined $addr0)) {
            $$result_ref = join(" ", ($$hex_ref, $addr1, $addr0));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_ext_iext #
##################
sub check_ext_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 5 + split(" ", $$hex_ref); 
    #printf "check_ext_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[1], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        $self->get_word(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0);
        if ((defined $addr1) && (defined $addr0)) {
            $$result_ref = join(" ", ($$hex_ref, $addr1, $addr0));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_idx_ext #
#################
sub check_idx_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($arg_ref->[4] =~ $op_keywords) {return 0;}
    $self->get_word(\$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    if ($self->get_idx(\$arg_ref->[0],
                       \$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#################
# check_idx_idx #
#################
sub check_idx_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx(\$arg_ref->[4],
                       \$arg_ref->[5],
                       \$arg_ref->[6],
                       \$arg_ref->[7], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx(\$arg_ref->[0],
                           \$arg_ref->[1],
                           \$arg_ref->[2],
                           \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

##################
# check_idx_idx1 #
##################
sub check_idx_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx1(\$arg_ref->[4],
                        \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx(\$arg_ref->[0],
                           \$arg_ref->[1],
                           \$arg_ref->[2],
                           \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

##################
# check_idx_idx2 #
##################
sub check_idx_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[4],
                        \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx(\$arg_ref->[0],
                           \$arg_ref->[1],
                           \$arg_ref->[2],
                           \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx_ididx #
###################
sub check_idx_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_ididx(\$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx(\$arg_ref->[0],
                           \$arg_ref->[1],
                           \$arg_ref->[2],
                           \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx_iidx2 #
###################
sub check_idx_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    #printf "check_idx_iidx2: %s, %s, %s, %s, %s, %s\n", $arg_ref->[0],
    #                                                    $arg_ref->[1],
    #                                                    $arg_ref->[2],
    #                                                    $arg_ref->[3],
    #                                                    $arg_ref->[4],
    #                                                    $arg_ref->[5];
    if ($self->get_idx2(0xe3,
                        \$arg_ref->[4],
                        \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx(\$arg_ref->[0],
                           \$arg_ref->[1],
                           \$arg_ref->[2],
                           \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {

            #printf "check_idx_iidx2 result: \"%s\", \"%s\"\n", (defined $addr0) ? $addr0 : "undefined", 
            #                                                   (defined $addr1) ? $addr1 : "undefined";

            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
        #printf "check_idx_iidx2: fail idx!\n";
    }
    #printf "check_idx_iidx2: fail!\n";
    return 0;
}

##################
# check_idx_iext #
##################
sub check_idx_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_idx_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[4], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx(\$arg_ref->[0],
                           \$arg_ref->[1],
                           \$arg_ref->[2],
                           \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {

            #printf "check_idx_iidx2 result: \"%s\", \"%s\"\n", (defined $addr0) ? $addr0 : "undefined", 
            #                                                   (defined $addr1) ? $addr1 : "undefined";

            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
        #printf "check_idx_iidx2: fail idx!\n";
    }
    #printf "check_idx_iidx2: fail!\n";
    return 0;
}

##################
# check_idx1_ext #
##################
sub check_idx1_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($arg_ref->[2] =~ $op_keywords) {return 0;}
    $self->get_word(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    if ($self->get_idx1(\$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_idx1_idx #
##################
sub check_idx1_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx(\$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4],
                       \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx1(\$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx1_idx1 #
###################
sub check_idx1_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx1(\$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx1(\$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx1_idx2 #
###################
sub check_idx1_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx1(\$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_idx1_ididx #
####################
sub check_idx1_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_ididx(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx1(\$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_idx1_iidx2 #
####################
sub check_idx1_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx1(\$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx1_iext #
###################
sub check_idx1_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 5 + split(" ", $$hex_ref); 
    #printf "check_idx1_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[2], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx1(\$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

##################
# check_idx2_ext #
##################
sub check_idx2_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    #printf "check_idx2_ext: %s, %s, %s\n", $arg_ref->[0],
    #                                       $arg_ref->[1],
    #                                       $arg_ref->[2];

    if ($arg_ref->[2] =~ $op_keywords) {return 0;}
    $self->get_word(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    if ($self->get_idx2(0xe2,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    printf "check_idx2_ext: addr1=%s, addr2=%s\n", $addr1, $addr2;
    return 0;
}

##################
# check_idx2_idx #
##################
sub check_idx2_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx(\$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4],
                       \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe2,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx2_idx1 #
###################
sub check_idx2_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx1(\$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe2,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx2_idx2 #
###################
sub check_idx2_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe2,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_idx2_ididx #
####################
sub check_idx2_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_ididx(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe2,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_idx2_iidx2 #
####################
sub check_idx2_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe2,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_idx2_iext #
###################
sub check_idx2_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 6 + split(" ", $$hex_ref); 
    #printf "check_idx2_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[2], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe2,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_ididx_ext #
###################
sub check_ididx_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($arg_ref->[1] =~ $op_keywords) {return 0;}
    $self->get_word(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_ididx_idx #
###################
sub check_ididx_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx(\$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_ididx_idx1 #
####################
sub check_ididx_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx1(\$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_ididx_idx2 #
####################
sub check_ididx_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

#####################
# check_ididx_ididx #
#####################
sub check_ididx_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_ididx(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

#####################
# check_ididx_iidx2 #
#####################
sub check_ididx_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_ididx_iext #
####################
sub check_ididx_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_ididx_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[1], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_ididx(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

###################
# check_iidx2_ext #
###################
sub check_iidx2_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($arg_ref->[2] =~ $op_keywords) {return 0;}
    $self->get_word(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    if ($self->get_idx2(0xe3,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###################
# check_iidx2_idx #
###################
sub check_iidx2_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx(\$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4],
                       \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe3,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_iidx2_idx1 #
####################
sub check_iidx2_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx1(\$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe3,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_iidx2_idx2 #
####################
sub check_iidx2_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe3,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

#####################
# check_iidx2_ididx #
#####################
sub check_iidx2_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_ididx(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe3,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

#####################
# check_iidx2_iidx2 #
#####################
sub check_iidx2_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[2],
                        \$arg_ref->[3], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe3,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

####################
# check_iidx2_iext #
####################
sub check_iidx2_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;

    $offset = 6 + split(" ", $$hex_ref); 
    #printf "check_iidx2_iext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[2], $offset;

    if ($self->get_iext($offset,
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
        if ($self->get_idx2(0xe3,
                            \$arg_ref->[0],
                            \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
            if ((defined $addr0) && (defined $addr1)) {
                $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
            } else {
                $$result_ref = undef;
            }
            return 1;
        }
    }
    return 0;
}

##################
# check_iext_ext #
##################
sub check_iext_ext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 5 + split(" ", $$hex_ref); 
    #printf "check_iext_ext: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($arg_ref->[1] =~ $op_keywords) {return 0;}
    $self->get_word(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1);
    if ($self->get_iext($offset,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_iext_idx #
##################
sub check_iext_idx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_iext_idx: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($self->get_idx(\$arg_ref->[1],
                       \$arg_ref->[2],
                       \$arg_ref->[3],
                       \$arg_ref->[4], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
    if ($self->get_iext($offset,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
      }
  }
  return 0;
}

###################
# check_iext_idx1 #
###################
sub check_iext_idx1 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_iext_idx1: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($self->get_idx1(\$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
    if ($self->get_iext($offset,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
      }
  }
  return 0;
}

####################
# check_iext_idx2 #
####################
sub check_iext_idx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_iext_idx1: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($self->get_idx2(0xe2,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
    if ($self->get_iext($offset,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
      }
  }
  return 0;
}

####################
# check_iext_ididx #
####################
sub check_iext_ididx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_iext_idx1: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($self->get_ididx(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
    if ($self->get_iext($offset,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
      }
  }
  return 0;
}

####################
# check_iext_iidx2 #
####################
sub check_iext_iidx2 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset;

    $offset = 4 + split(" ", $$hex_ref); 
    #printf "check_iext_iidx2: hex0=%s,  pcpag=%x, dest=%s, offset=%d\n", $$hex_ref, $pc_pag, $arg_ref->[0], $offset;

    if ($self->get_idx2(0xe3,
                        \$arg_ref->[1],
                        \$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
    if ($self->get_iext($offset,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
      }
  }
  return 0;
}

###################
# check_iext_iext #
###################
sub check_iext_iext {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $addr0;
    my $addr1;
    my $offset0;
    my $offset1;

    $offset0 = 4 + split(" ", $$hex_ref); 
    $offset1 = 6 + split(" ", $$hex_ref); 
    #printf "check_iext_idx1: hex0=%s,  pcpag=%x, dest=%s, offse0t=%d, offset1=%d\n", $$hex_ref, 
    #                                                                                 $pc_pag,
    #                                                                                 $arg_ref->[0],
    #                                                                                 $offset0,
    #                                                                                 $offset1;

    if ($self->get_iext($offset1,
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr1)) {
    if ($self->get_iext($offset0,
                        \$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$addr0)) {
        if ((defined $addr0) && (defined $addr1)) {
            $$result_ref = join(" ", ($$hex_ref, $addr0, $addr1));
        } else {
            $$result_ref = undef;
        }
        return 1;
      }
  }
  return 0;
}

#############
# check_exg #
#############
sub check_exg {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_tfr($tfr_s12,
                       $tfr_exg,
                       \$arg_ref->[0],
                       \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_s12x_exg #
##################
sub check_s12x_exg {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_tfr($tfr_s12x,
                       $tfr_exg,
                       \$arg_ref->[0],
                       \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#############
# check_tfr #
#############
sub check_tfr {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_tfr($tfr_s12,
                       $tfr_tfr,
                       \$arg_ref->[0],
                       \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_s12x_tfr #
##################
sub check_s12x_tfr {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_tfr($tfr_s12x,
                       $tfr_tfr,
                       \$arg_ref->[0],
                       \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

#############
# check_sex #
#############
sub check_sex {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_tfr($tfr_s12,
                       $tfr_sex,
                       \$arg_ref->[0],
                       \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##################
# check_s12x_sex #
##################
sub check_s12x_sex {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_tfr($tfr_s12x,
                       $tfr_sex,
                       \$arg_ref->[0],
                       \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_dbeq #
##############
sub check_dbeq {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_dbeq(0x00,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_dbne #
##############
sub check_dbne {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_dbeq(0x20,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_tbeq #
##############
sub check_tbeq {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_dbeq(0x40,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_tbne #
##############
sub check_tbne {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_dbeq(0x60,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_ibeq #
##############
sub check_ibeq {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_dbeq(0x80,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_ibne #
##############
sub check_ibne {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($self->get_dbeq(0xa0,
                        \$arg_ref->[0],
                        \$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value)) {
        if (defined $value) {
            $$result_ref = join(" ", ($$hex_ref, $value));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

##############
# check_trap #
##############
sub check_trap {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    $self->get_trap(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

###################
# check_s12x_trap #
###################
sub check_s12x_trap {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    $self->get_s12x_trap(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

###################
# check_hc11_indx #
###################
sub check_hc11_indx {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    #printf STDERR "check_hc11_indx: %s \"%s\"\n", $#$arg_ref, $arg_ref->[0];
    if ($arg_ref->[0] =~ /^\s*$/) {
        $value = "00";
    } else {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    }
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

###################
# check_hc11_indy #
###################
sub check_hc11_indy {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if ($arg_ref->[0] =~ /^\s*$/) {
        $value = "00";
    } else {
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    }
    if (defined $value) {
        $$result_ref = join(" ", ($$hex_ref, $value));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

#######################
# check_hc11_indx_msk #
#######################
sub check_hc11_indx_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    if ((defined $mask) && (defined $address)) {
        $$result_ref = join(" ", ($$hex_ref, $address, $mask));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

#######################
# check_hc11_indy_msk #
#######################
sub check_hc11_indy_msk {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $mask;
    my $address;

    $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
    $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
    if ((defined $mask) && (defined $address)) {
        $$result_ref = join(" ", ($$hex_ref, $address, $mask));
    } else {
        $$result_ref = undef;
    }
    return 1;
}

###########################
# check_hc11_indx_msk_rel #
###########################
sub check_hc11_indx_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    if ($self->get_rel8(4, \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel)) {
        $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
        $self->get_byte(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

###########################
# check_hc11_indy_msk_rel #
###########################
sub check_hc11_indy_msk_rel {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $rel;
    my $mask;
    my $address;

    if ($self->get_rel8(5, \$arg_ref->[5], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$rel)) {
        $self->get_byte(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$mask);
        $self->get_bute(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$address);
        if ((defined $mask) && (defined $address)) {
            $$result_ref = join(" ", ($$hex_ref, $address, $mask));
        } else {
            $$result_ref = undef;
        }
        return 1;
    }
    return 0;
}

####################
# check_xgate_imm3 #
####################
sub check_xgate_imm3 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $hex;

    $self->get_xgate_imm(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    $hex = $$hex_ref;
    $hex =~ s/\s//g;
    $hex = hex($hex);
    if (defined $value) {
        if ($value == ($value & 0x7)) {
            $value = (($value<<8) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        } else {
            $$error_ref = "invalid semaphore index";
            return 1;
        }
    } else {
        $$result_ref = sprintf("%.1X? %.2X", (($hex>>12) & 0xf), ($hex & 0xff));
        return 1;
    }
}

##########################
# check_xgate_imm3_twice #
##########################
sub check_xgate_imm3_twice {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $hex;

    $self->get_xgate_imm(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    $hex = $$hex_ref;
    $hex =~ s/\s//g;
    $hex = hex($hex);
    if (defined $value) {
        if ($value == ($value & 0x7)) {
            $value = (($value<<8) | $hex);
            $$result_ref = sprintf("%.2X %.2X %.2X %.2X", (($value>>8) & 0xff), 
				                           ($value     & 0xff),
                                                          (($value>>8) & 0xff), 
				                           ($value & 0xff));
            return 1;
        } else {
            $$error_ref = "invalid semaphore index";
            return 1;
        }
    } else {
        $$result_ref = sprintf("%.1X? %.2X %.1X? %.2X", (($hex>>12) & 0xf), 
                                                         ($hex      & 0xff),
                                                        (($hex>>12) & 0xf), 
                                                         ($hex & 0xff));
        return 1;
    }
}

####################
# check_xgate_imm4 #
####################
sub check_xgate_imm4 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $reg;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg)) {
        $self->get_xgate_imm(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
        $hex = $$hex_ref;
        $hex =~ s/\s//g;
        $hex = hex($hex);
        if (defined $value) {
            $value = $value & 0xf;
            $value = (($reg<<8) | ($value<<4) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        } else {
            $value       = (($reg<<8) | $hex);
            $$result_ref = sprintf("%.2X ?%.1X", (($value>>8) & 0xff), ($value & 0x0f));
            return 1;
        }
    }
    return 0;
}

####################
# check_xgate_imm8 #
####################
sub check_xgate_imm8 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $reg;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg)) {
        $self->get_xgate_imm(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
        $hex = $$hex_ref;
        $hex =~ s/\s//g;
        $hex = hex($hex);
        if (defined $value) {
            $value = $value & 0xff;
            $value = (($reg<<8) | $value | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        } else {
            $$result_ref = sprintf("%.1X? ??", (($hex>>12) & 0x0f));
            return 1;
        }
    }
    return 0;
}

#####################
# check_xgate_imm16 #
#####################
sub check_xgate_imm16 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $lvalue;
    my $hvalue;
    my $reg;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg)) {
        $self->get_xgate_imm(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
        $hex = $$hex_ref;
        $hex =~ s/\s//g;
        $hex = hex($hex);
        if (defined $value) {
            $lvalue = $value      & 0xff;
            $hvalue = ($value>>8) & 0xff;
            $value = (($reg<<24) | ($lvalue<<16) | ($reg<<8) | $hvalue | $hex);
            $$result_ref = sprintf("%.2X %.2X %.2X %.2X", ((($value>>24) & 0xff),
                                                           (($value>>16) & 0xff),
                                                           (($value>>8)  & 0xff),
                                                            ($value      & 0xff)));
            return 1;
        } else {
            $$result_ref = sprintf("%.1X? ?? %.1X? ??", ((($hex>>28) & 0xf),
                                                         (($hex>>12) & 0x0f)));
            return 1;
        }
    }
    return 0;
}

###################
# check_xgate_mon #
###################
sub check_xgate_mon {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;

        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<8) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
    }
    return 0;
}

#########################
# check_xgate_mon_twice #
#########################
sub check_xgate_mon_twice {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;

        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<8) | $hex);
            $$result_ref = sprintf("%.2X %.2X %.2X %.2X", (($value>>8) & 0xff), 
                                                           ($value     & 0xff),
                                                          (($value>>8) & 0xff), 
                                                           ($value     & 0xff));
            return 1;
    }
    return 0;
}

###################
# check_xgate_dya #
###################
sub check_xgate_dya {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<8) | ($reg2<<5) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        }
    }
    return 0;
}

###################
# check_xgate_tri #
###################
sub check_xgate_tri {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $reg3;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg3)) {
        if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
            if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
                $hex = $$hex_ref;
                $hex =~ s/\s//g;
                $hex = hex($hex);
                $value = (($reg1<<8) | ($reg2<<5) | ($reg3<<2) | $hex);
                $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
                return 1;
            }
        }
    }
    return 0;
}

####################
# check_xgate_rel9 #
####################
sub check_xgate_rel9 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $hex;

    $self->get_xgate_rel(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    $hex = $$hex_ref;
    $hex =~ s/\s//g;
    $hex = hex($hex);
    if (defined $value) {
        if (($value <= 511) && ($value >= -512)) {
            $value = (($value & 0x1ff) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        } else {
            #$$error_ref = sprintf("branch address is out of range (%d bytes)", $value);
            $$result_ref = sprintf("%.1X? ??", (($hex>>12) & 0xf));
            return 1;
        }
    } else {
        $$result_ref = sprintf("%.1X? ??", (($hex>>12) & 0xf));
        return 1;
    }
}

#####################
# check_xgate_rel10 #
#####################
sub check_xgate_rel10 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $hex;

    $self->get_xgate_rel(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
    $hex = $$hex_ref;
    $hex =~ s/\s//g;
    $hex = hex($hex);
    if (defined $value) {
        if (($value <= 1023) && ($value >= -1024)) {
            $value = (($value & 0x3ff) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        } else {
            #$$error_ref = sprintf("branch address is out of range (%d bytes)", $value);
            $$result_ref = sprintf("%.1X? ??", (($hex>>12) & 0xf));
            return 1;
        }
    } else {
        $$result_ref = sprintf("%.1X? ??", (($hex>>12) & 0xf));
        return 1;
    }
}

####################
# check_xgate_ido5 #
####################
sub check_xgate_ido5 {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;
    my $reg1;
    my $reg2;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $self->get_xgate_imm(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$value);
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            #printf STDERR "check_xgate_ido5: \"%s\" -> %X\n", $arg_ref->[2], $value;

            if (defined $value) {
                $value = $value & 0x1f;
                $value = (($reg1<<8) | ($reg2<<5) | $value | $hex);
                $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
                return 1;
            } else {
                $value = (($reg1<<8) | $hex);
                $$result_ref = sprintf("%.2X ??", (($value>>8) & 0xff));
                return 1;
            }
        }
    }
    return 0;
}

###################
# check_xgate_idr #
###################
sub check_xgate_idr {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $reg3;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg3)) {
        if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
            if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
                $hex = $$hex_ref;
                $hex =~ s/\s//g;
                $hex = hex($hex);
                $value = (($reg1<<8) | ($reg2<<5) | ($reg3<<2) | $hex);
                $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
                return 1;
            }
        }
    }
    return 0;
}

####################
# check_xgate_idri #
####################
sub check_xgate_idri {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $reg3;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg3)) {
        if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
            if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
                $hex = $$hex_ref;
                $hex =~ s/\s//g;
                $hex = hex($hex);
                $value = (($reg1<<8) | ($reg2<<5) | ($reg3<<2) | $hex);
                $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
                return 1;
            }
        }
    }
    return 0;
}
####################
# check_xgate_idrd #
####################
sub check_xgate_idrd {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $reg3;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[2], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg3)) {
        if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
            if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
                $hex = $$hex_ref;
                $hex =~ s/\s//g;
                $hex = hex($hex);
                $value = (($reg1<<8) | ($reg2<<5) | ($reg3<<2) | $hex);
                $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
                return 1;
            }
        }
    }
    return 0;
}

##########################
# check_xgate_tfr_rd_ccr #
##########################
sub check_xgate_tfr_rd_ccr {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;

        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<8) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
    }
    return 0;
}

##########################
# check_xgate_tfr_ccr_rs #
##########################
sub check_xgate_tfr_ccr_rs {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;

         if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
             $hex = $$hex_ref;
             $hex =~ s/\s//g;
             $hex = hex($hex);
             $value = (($reg1<<8) | $hex);
             $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
             return 1;
    }
    return 0;
}

#########################
# check_xgate_tfr_rd_pc #
#########################
sub check_xgate_tfr_rd_pc {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;

         if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
             $hex = $$hex_ref;
             $hex =~ s/\s//g;
             $hex = hex($hex);
             $value = (($reg1<<8) | $hex);
             $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
             return 1;
    }
    #printf STDERR "check_xgate_tfr_rd_pc failed!\n";
    return 0;
}

#######################
# check_xgate_com_mon #
#######################
sub check_xgate_com_mon {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;

        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<8) | ($reg1<<2) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
    }
    return 0;
}

#######################
# check_xgate_tst_mon #
#######################
sub check_xgate_tst_mon {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $hex;

        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<5) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
    }
    return 0;
}

#######################
# check_xgate_com_dya #
#######################
sub check_xgate_com_dya {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<8) | ($reg2<<2) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        }
    }
    return 0;
}

#######################
# check_xgate_cmp_dya #
#######################
sub check_xgate_cmp_dya {
    my $self       = shift @_;
    my $arg_ref    = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $hex_ref    = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $reg1;
    my $reg2;
    my $hex;

    if ($self->get_xgate_gpr(\$arg_ref->[1], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg2)) {
        if ($self->get_xgate_gpr(\$arg_ref->[0], $pc_lin, $pc_pag, $loc_cnt, $sym_tabs, $error_ref, \$reg1)) {
            $hex = $$hex_ref;
            $hex =~ s/\s//g;
            $hex = hex($hex);
            $value = (($reg1<<5) | ($reg2<<2) | $hex);
            $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
            return 1;
        }
    }
    return 0;
}

############
# get_byte #
############
sub get_byte {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $value;
    my $eval;

    #printf STDERR "get_byte: \"%s\"\n", $$string_ref;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
        $$result_ref = sprintf("%.2X", ($value & 0xff));
    } else {
        $$result_ref = "??";
    }
}

############
# get_word #
############
sub get_word {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $value;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
        $$result_ref = sprintf("%.2X %.2X", (($value>>8) & 0xff), ($value & 0xff));
    } else {
        $$result_ref = "?? ??";
    }
}

###########
# get_dir #
###########
sub get_dir {
    my $self       = shift @_;
    my $dir_page   = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $value;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    #printf STDERR "DIR: %X %X\n", (($value>>8) & 0xff), ($dir_page & 0xff);
    if (defined $value) {
        if ((($value>>8) & 0xff) == ($dir_page & 0xff)) {
            $$result_ref = sprintf("%.2X", ($value & 0xff));
            return 1;
        } else {
            return 0;
        }
    }
    #$$result_ref = "??";
    #return 1;
    return 0;
}

############
# get_rel8 #
############
sub get_rel8 {
    my $self       = shift @_;
    my $offset     = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $reladdr;
    my $value;

    #printf STDERR "get_rel8: %s\n", $$string_ref;
    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
         if (defined $pc_pag) {
             $reladdr = ((int($value & 0xffff) - int($pc_pag & 0xffff)) - $offset);
             if (($reladdr >= -128) && ($reladdr <= 127)) {
                 $$result_ref = sprintf("%.2X", ($reladdr & 0xff));
                 return 1;
             } else {
                 $$result_ref = "??";
                 #return 1;
                 return 0;
             }
         }
     }
    $$result_ref = "??";
    #return 0;
    return 1;
}

################
# get_rel8_job #
################
#sub get_rel8_job {
#    my $self       = shift @_;
#    my $offset     = shift @_;
#    my $string_ref = shift @_;
#    my $pc_lin     = shift @_;
#    my $pc_pag     = shift @_;
#    my $loc_cnt    = shift @_;
#    my $sym_tabs   = shift @_;
#    my $error_ref  = shift @_;
#    my $result_ref = shift @_;
#    #temporary
#    my $error;
#    my $reladdr;
#    my $value;
#
#    #printf STDERR "get_rel8_job: %s\n", $$string_ref;
#    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
#    if ($error) {$$error_ref = $error;}
#    if (defined $value) {
#         if (defined $pc_pag) {
#             $reladdr = ((int($value & 0xffff) - int($pc_pag & 0xffff)) - $offset);
#             if (($reladdr >= -128) && ($reladdr <= 127)) {
#                 $$result_ref = sprintf("%.2X", ($reladdr & 0xff));
#                 return 1;
#             } else {
#                 $$result_ref = "??";
#                 #return 1;
#                 return 0;
#             }
#         }
#     }
#    $$result_ref = "??";
#    #return 0;
#    return 1;
#}

#############
# get_rel16 #
#############
sub get_rel16 {
    my $self       = shift @_;
    my $offset     = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $reladdr;
    my $value;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
     if (defined $value) {
        if (defined $pc_pag) {
            $reladdr = ((int($value & 0xffff) - int($pc_pag & 0xffff)) - $offset);
            $$result_ref = sprintf("%.2X %.2X", ((($reladdr >> 8) & 0xff),
                                                 ($reladdr        & 0xff)));
            return 1;
        }
    }
    $$result_ref = "?? ??";
    return 1;
}

###########
# get_idx #
###########
sub get_idx {
    my $self         = shift @_;
    my $offset_ref   = shift @_;
    my $preinc_ref   = shift @_;
    my $reg_ref      = shift @_;
    my $postinc_ref  = shift @_;
    my $pc_lin       = shift @_;
    my $pc_pag       = shift @_;
    my $loc_cnt      = shift @_;
    my $sym_tabs     = shift @_;
    my $error_ref    = shift @_;
    my $result_ref   = shift @_;
    my $indexreg_code = 0x00;
    my $post_byte     = 0x00;
    #temporary
    my $error;
    my $value;

    #printf STDERR "get_idx: \"%s\"\n", join("\", \"",
    #                                          $$offset_ref,
    #                                          $$preinc_ref,
    #                                          $$reg_ref,
    #                                          $$postinc_ref);

    ############################
    # determine index register #
    ############################
    for ($$reg_ref) {
        ###########
        # INDEX X #
        ###########
        /^\s*X\s*$/i && do {
            $indexreg_code = 0x00;
            last;};
        ###########
        # INDEX Y #
        ###########
        /^\s*Y\s*$/i && do {
            $indexreg_code = 0x01;
            last;};
        ######
        # SP #
        ######
        /^\s*SP\s*$/i && do {
            $indexreg_code = 0x02;
            last;};
        ######
        # PC #
        ######
        /^\s*PC\s*$/i && do {
            if (($$preinc_ref  !~ /^\s*$/) ||
                ($$postinc_ref !~ /^\s*$/)) {
                #illegal address mode
                #$$error_ref = "Illegal auto in/decrement of PC";
                return 0;
            }
            $indexreg_code = 0x03;
            last;};
        ############
        # no match #
        ############
        return 0;
    }

    ####################
    # determine offset #
    ####################
    for ($$offset_ref) {
        ##########
        # ACCU A #
        ##########
        /^\s*A\s*$/i && do {
            if (($$preinc_ref  !~ /^\s*$/) ||
                ($$postinc_ref !~ /^\s*$/)) {
                return 0;
            } else {
                $post_byte = 0xe4 | ($indexreg_code << 3);
                $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                return 1;
            }
            last;};
        ##########
        # ACCU B #
        ##########
        /^\s*B\s*$/i && do {
            if (($$preinc_ref  !~ /^\s*$/) ||
                ($$postinc_ref !~ /^\s*$/)) {
                return 0;
            } else {
                $post_byte   = 0xe5 | ($indexreg_code << 3);
                $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                return 1;
            }
            last;};
        ##########
        # ACCU D #
        ##########
        /^\s*D\s*$/i && do {
            if (($$preinc_ref  !~ /^\s*$/) ||
                ($$postinc_ref !~ /^\s*$/)) {
                return 0;
            } else {
                $post_byte   = 0xe6 | ($indexreg_code << 3);
                $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                return 1;
            }
            last;};

        ###################
        # constant offset #
        ###################
        if ($$offset_ref =~ /^\s*$/) {
            $value = 0;
        } else {
            ($error, $value) = @{$self->evaluate_expression($$offset_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
            if ($error) {$$error_ref = $error;}
        }
        if (defined $value) {
            ###############################
            # determine pre/postincrement #
            ###############################
            if (($$preinc_ref  =~ /^\s*$/) &&
                ($$postinc_ref =~ /^\s*$/)) {
                ###########################
                # no pre or postincrement #
                ###########################
                if (($value >= -16) && ($value <= 15)) {
                    $post_byte   = ($indexreg_code << 6) | ($value & 0x1f);
                    $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                    return 1;
                } else {
                    #offset too big
                    return 0;
                }
            } else {
                ########################
                # pre or postincrement #
                ########################
                if ((($value >= -8) && ($value <= -1)) ||
                    (($value >=  1) && ($value <=  8))) {

                    if (($$preinc_ref  =~ /^\s*\+\s*$/) &&
                        ($$postinc_ref =~ /^\s*$/)) {
                        ################
                        # preincrement #
                        ################
                        if ($value > 0) {
                            $post_byte = (0x20 |
                                          ($indexreg_code << 6) |
                                          (($value - 1) & 0x0f));
                        } else {
                            $post_byte = (0x28 |
                                          ($indexreg_code << 6) |
                                          ($value & 0x0f));
                        }
                        $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                        return 1;
                    } elsif (($$preinc_ref  =~ /^\s*\-\s*$/) &&
                             ($$postinc_ref =~ /^\s*$/)) {
                        ################
                        # predecrement #
                        ################
                        if ($value > 0) {
                            $post_byte = (0x28 |
                                          ($indexreg_code << 6) |
                                          ((-1 * $value) & 0x0f));
                        } else {
                            $post_byte = (0x20 |
                                          ($indexreg_code << 6) |
                                          (((-1 * $value) - 1) & 0x0f));
                        }
                        $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                        return 1;
                    } elsif (($$preinc_ref  =~ /^\s*$/) &&
                             ($$postinc_ref =~ /^\s*\+\s*$/)) {
                        #################
                        # postincrement #
                        #################
                        if ($value > 0) {
                            $post_byte = (0x30 |
                                          ($indexreg_code << 6) |
                                          (($value - 1) & 0x0f));
                        } else {
                            $post_byte = (0x38 |
                                          ($indexreg_code << 6) |
                                          ($value & 0x0f));
                        }
                        $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                        return 1;
                    } elsif (($$preinc_ref  =~ /^\s*$/) &&
                             ($$postinc_ref =~ /^\s*\-\s*$/)) {
                        #################
                        # postdecrement #
                        #################
                        if ($value > 0) {
                            $post_byte = (0x38 |
                                          ($indexreg_code << 6) |
                                          ((-1 * $value) & 0x0f));
                        } else {
                            $post_byte = (0x30 |
                                          ($indexreg_code << 6) |
                                          (((-1 * $value) - 1) & 0x0f));
                        }
                        $$result_ref = sprintf("%.2X", ($post_byte & 0xff));
                        return 1;
                    } else {
                        #######################
                        # invalid combination #
                        #######################
                        return 0;
                    }
                } else {
                    #offset too big (or zero)
                    return 0;
                }
            }
        } else {
            return [0, "??"];
        }
    }
}

############
# get_idx1 #
############
sub get_idx1 {
    my $self          = shift @_;
    my $offset_ref    = shift @_;
    my $reg_ref       = shift @_;
    my $pc_lin        = shift @_;
    my $pc_pag        = shift @_;
    my $loc_cnt       = shift @_;
    my $sym_tabs      = shift @_;
    my $error_ref     = shift @_;
    my $result_ref    = shift @_;
    my $indexreg_code = 0x00;
    my $post_byte     = 0x00;
    #temporary
    my $error;
    my $value;

    #printf STDERR "get_idx1: \"%s\"\n", join("\", \"",
    #                                         $$offset_ref,
    #                                         $$reg_ref);

    ################
    # check offset #
    ################
    if ($$offset_ref =~ $op_keywords) {
        return 0;
    }

    ############################
    # determine index register #
    ############################
    for ($$reg_ref) {
        ###########
        # INDEX X #
        ###########
        /^\s*X\s*$/i && do {
            $indexreg_code = 0x00;
            last;};
        ###########
        # INDEX Y #
        ###########
        /^\s*Y\s*$/i && do {
            $indexreg_code = 0x01;
            last;};
        ######
        # SP #
        ######
        /^\s*SP\s*$/i && do {
            $indexreg_code = 0x02;
            last;};
        ######
        # PC #
        ######
        /^\s*PC\s*$/i && do {
            $indexreg_code = 0x03;
            last;};
        ############
        # no match #
        ############
        return 0;
    }

    ####################
    # determine offset #
    ####################
    if ($$offset_ref =~ /^\s*$/) {
        $value = 0;
    } else {
        ($error, $value) = @{$self->evaluate_expression($$offset_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
        if ($error) {$$error_ref = $error;}
    }
    if (defined $value) {
        #print STDERR "value: $value\n";
        if (($value >= -256) && ($value <= 255)) {
            ######################
            # determine hex code #
            ######################
            if ($value >= 0) {
                $post_byte = (0xe0 |
                              ($indexreg_code << 3));
            } else {
                $post_byte = (0xe1 |
                              ($indexreg_code << 3));
            }
            $$result_ref = sprintf("%.2X %.2X", (($post_byte & 0xff),
                                                 ($value & 0xff)));
            return 1;
        } else {
            #offset too big
            return 0;
        }
    } else {
        $$result_ref = "?? ??";
        return 1;
    }
}

############
# get_idx2 #
############
sub get_idx2 {
    my $self           = shift @_;
    my $post_byte_base = shift @_; 
    my $offset_ref     = shift @_;
    my $reg_ref        = shift @_;
    my $pc_lin         = shift @_;
    my $pc_pag         = shift @_;
    my $loc_cnt        = shift @_;
    my $sym_tabs       = shift @_;
    my $error_ref      = shift @_;
    my $result_ref     = shift @_;
    my $indexreg_code  = 0x00;
    my $post_byte      = 0x00;
    #temporary
    my $error;
    my $value;

    #printf STDERR "get_idx2: \"%s\"\n", join("\", \"",
    #                                         $$offset_ref,
    #                                         $$reg_ref);

    ################
    # check offset #
    ################
    if ($$offset_ref =~ $op_keywords) {
        return 0;
    }

    ############################
    # determine index register #
    ############################
    for ($$reg_ref) {
        ###########
        # INDEX X #
        ###########
        /^\s*X\s*$/i && do {
            $indexreg_code = 0x00;
            last;};
        ###########
        # INDEX Y #
        ###########
        /^\s*Y\s*$/i && do {
            $indexreg_code = 0x01;
            last;};
        ######
        # SP #
        ######
        /^\s*SP\s*$/i && do {
            $indexreg_code = 0x02;
            last;};
        ######
        # PC #
        ######
        /^\s*PC\s*$/i && do {
            $indexreg_code = 0x03;
            last;};
        ############
        # no match #
        ############
        return 0;
    }

    ####################
    # determine offset #
    ####################
    if ($$offset_ref =~ /^\s*$/) {
        $value = 0;
    } else {
        ($error, $value) = @{$self->evaluate_expression($$offset_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
        if ($error) {$$error_ref = $error;}
    }
    if (defined $value) {
        #print STDERR "value: $value\n";
        ######################
        # determine hex code #
        ######################
        $post_byte = ($post_byte_base |
                      ($indexreg_code << 3));
        $$result_ref = sprintf("%.2X %.2X %.2X", (($post_byte & 0xff),
                                                 (($value >> 8) & 0xff),
                                                 ($value        & 0xff)));
        return 1;
    } else {
        $$result_ref = "?? ?? ??";
        return 1;
    }
}

#############
# get_ididx #
#############
sub get_ididx {
    my $self           = shift @_;
    my $reg_ref        = shift @_;
    my $pc_lin         = shift @_;
    my $pc_pag         = shift @_;
    my $loc_cnt        = shift @_;
    my $sym_tabs       = shift @_;
    my $error_ref      = shift @_;
    my $result_ref     = shift @_;
    my $indexreg_code  = 0x00;
    my $post_byte      = 0x00;
    #temporary
    my $value;

    ############################
    # determine index register #
    ############################
    for ($$reg_ref) {
        ###########
        # INDEX X #
        ###########
        /^\s*X\s*$/i && do {
            $$result_ref = sprintf("%.2X", 0xe7);
            return 1;
            last;};
        ###########
        # INDEX Y #
        ###########
        /^\s*Y\s*$/i && do {
            $$result_ref = sprintf("%.2X", 0xef);
            return 1;
            last;};
        ######
        # SP #
        ######
        /^\s*SP\s*$/i && do {
            $$result_ref = sprintf("%.2X", 0xf7);
            return 1;
            last;};
        ######
        # PC #
        ######
        /^\s*PC\s*$/i && do {
            $$result_ref = sprintf("%.2X", 0xff);
            return 1;
            last;};
        ############
        # no match #
        ############
        return 0;
    }
}

############
# get_iext #
############
sub get_iext {
    my $self           = shift @_;
    my $offset         = shift @_;
    my $string_ref     = shift @_;
    my $pc_lin         = shift @_;
    my $pc_pag         = shift @_;
    my $loc_cnt        = shift @_;
    my $sym_tabs       = shift @_;
    my $error_ref      = shift @_;
    my $result_ref     = shift @_;
    my $indexreg_code  = 0x00;
    my $post_byte      = 0x00;
    #temporary
    my $error;
    my $value;

    #printf STDERR "get_iext: \"%s\"\n", $$string_ref;
    ##################
    # check argument #
    ##################
    if ($$string_ref =~ $op_keywords) {
        return 0;
    }

    #################################
    # determine destination address #
    #################################
    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}

    if (defined $value) {
        #printf STDERR "value:%x \n", $value;
   
        ##########################
        # subtract offset and PC #
        ##########################
	$value -= $offset;
	$value -= $pc_pag;
	
        ######################
        # determine hex code #
        ######################
        $$result_ref = sprintf("FB %.2X %.2X", ((($value >> 8) & 0xff),
                                                 ($value       & 0xff)));
        return 1;
    } else {
        $$result_ref = "FB ?? ??";
        return 1;
    }
}

##################
# get_ext_pgimpl #
##################
sub get_ext_pgimpl {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $value;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
        $$result_ref = sprintf("%.2X %.2X %.2X", ((($value>>8)    & 0xff),
                                                  ($value         & 0xff),
                                                  (($value >> 16) & 0xff)));
    } else {
        $$result_ref = "?? ?? ??";
    }
}

###########
# get_tfr #
###########
sub get_tfr {
    my $self                = shift @_;
    my $cpu                 = shift @_;
    my $tfr_type            = shift @_;
    my $src_reg_ref         = shift @_;
    my $dst_reg_ref         = shift @_;
    my $pc_lin              = shift @_;
    my $pc_pag              = shift @_;
    my $loc_cnt             = shift @_;
    my $sym_tabs            = shift @_;
    my $error_ref           = shift @_;
    my $result_ref          = shift @_;
    my $extension_byte      = 0;
    my $error               = 0;
    #printf STDERR "S12X TFR: \"%s\" \"%s\"\n", $$src_reg_ref, $$dst_reg_ref;

    ##################
    # extension byte #
    ##################
    for ($tfr_type) {
        ($tfr_type == $tfr_tfr) && do {$extension_byte = 0x00;last;};
        ($tfr_type == $tfr_sex) && do {$extension_byte = 0x00;last;};
        ($tfr_type == $tfr_exg) && do {$extension_byte = 0x80;last;};
    }

    ###################
    # source register #
    ###################
    for ($$src_reg_ref) {
        ##########
        # ACCU A #
        ##########
        /^\s*(A)\s*$/i && do {
            for ($$dst_reg_ref) {
                ##########
                # A -> A #
                ##########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x00;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                ##########
                # A -> B #
                ##########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x01;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                #################
                # A -> CCR,CCRL #
                #################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x02;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                #############
                # A -> TMP2 #
                #############
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x03;
                    last;};
                ##########
                # A -> D #
                ##########
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x04;
                    last;};
                ##########
                # A -> X #
                ##########
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x05;
                    last;};
                ##########
                # A -> Y #
                ##########
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x06;
                    last;};
                ###########
                # A -> SP #
                ###########
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x07;
                    last;};
                #############
                # A -> CCRH #
                #############
                /^\s*(CCRH)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x0a;
                    if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
                    last;};
                ##############
                # A -> TMP2H #
                ##############
                /^\s*(TMP2H)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x0b;
                    if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
                    last;};
                ###########
                # A -> XH #
                ###########
                /^\s*(XH)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x0d;
                    if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
                    last;};
                ###########
                # A -> YH #
                ###########
                /^\s*(YH)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x0e;
                    if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
                    last;};
                ############
                # A -> SPH #
                ############
                /^\s*(SPH)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x0f;
                    if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
                    last;};
                ############
                # no match #
                ############
                $error   = 1;
            }
            last;};
        ##########
        # ACCU B #
        ##########
        /^\s*(B)\s*$/i && do {
            for ($$dst_reg_ref) {
                ##########
                # B -> A #
                ##########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x10;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                ##########
                # B -> B #
                ##########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x11;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                #################
                # B -> CCR,CCRL #
                #################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x12;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                #############
                # B -> TMP2 #
                #############
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x13;
                    last;};
                ##########
                # B -> D #
                ##########
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x14;
                    last;};
                ##########
                # B -> X #
                ##########
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x15;
                    last;};
                ##########
                # B -> Y #
                ##########
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x16;
                    last;};
                ###########
                # B -> SP #
                ###########
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x17;
                    last;};
                ##############
                # B -> TMP2L #
                ##############
                /^\s*(TMP2L)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x1b;
                    if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
                    last;};
                ###########
                # B -> XL #
                ###########
                /^\s*(XL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x1d;
                    if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
                    last;};
                ###########
                # B -> YL #
                ###########
                /^\s*(YL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x1e;
                    if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
                    last;};
                ############
                # B -> SPL #
                ############
                /^\s*(SPL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x1f;
                    if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
                    last;};
                ############
                # no match #
                ############
                $error = 1;;
            }
            last;};
        ############
        # CCR,CCRL #
        ############
        /^\s*(CCR|CCRL)\s*$/i && do {
            for ($$dst_reg_ref) {
                #################
                # CCR,CCRL -> A #
                #################
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x20;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                #################
                # CCR,CCRL -> B #
                #################
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x21;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                ########################
                # CCR,CCRL -> CCR,CCRL #
                ########################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x22;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                ####################
                # CCR,CCRL -> TMP2 #
                ####################
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x23;
                    last;};
                #################
                # CCR,CCRL -> D #
                #################
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x24;
                    last;};
                #################
                # CCR,CCRL -> X #
                #################
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x25;
                    last;};
                #################
                # CCR,CCRL -> Y #
                #################
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x26;
                    last;};
                ##################
                # CCR,CCRL -> SP #
                ##################
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x27;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ########
        # CCRH #
        ########
        /^\s*(CCRH)\s*$/i && do {
            if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
            for ($$dst_reg_ref) {
                #############
                # CCRH -> A #
                #############
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x28;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ########
        # CCRW #
        ########
        /^\s*(CCRW)\s*$/i && do {
            if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
            for ($$dst_reg_ref) {
                ################
                # CCRW -> CCRW #
                ################
                /^\s*(CCRW)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x2a;
                    last;};
                ################
                # CCRW -> TMP2 #
                ################
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x2b;
                    last;};
                #############
                # CCRW -> D #
                #############
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x2c;
                    last;};
                #############
                # CCRW -> X #
                #############
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x2d;
                    last;};
                #############
                # CCRW -> Y #
                #############
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x2e;
                    last;};
                ##############
                # CCRW -> SP #
                ##############
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x2f;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ########
        # TMP3 #
        ########
        /^\s*(TMP3)\s*$/i && do {
            if ($tfr_type == $tfr_sex) {$error = 1;}
            for ($$dst_reg_ref) {
                #############
                # TMP3 -> A #
                #############
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x30;
                    last;};
                #############
                # TMP3 -> B #
                #############
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x31;
                    last;};
                ####################
                # TMP3 -> CCR,CCRL #
                ####################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x32;
                    last;};
                ################
                # TMP3 -> TMP2 #
                ################
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x33;
                    last;};
                #############
                # TMP3 -> D #
                #############
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x34;
                    last;};
                #############
                # TMP3 -> X #
                #############
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x35;
                    last;};
                #############
                # TMP3 -> Y #
                #############
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x36;
                    last;};
                ##############
                # TMP3 -> SP #
                ##############
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x37;
                    last;};
                ################
                # TMP3 -> CCRW #
                ################
                /^\s*(CCRW)\s*$/i && do {
                    if ($cpu == $tfr_s12) {$error = 1;}
                    $extension_byte = $extension_byte | 0x3A;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        #########
        # TMP3L #
        #########
        /^\s*(TMP3L)\s*$/i && do {
            if ($tfr_type == $tfr_sex) {$error = 1;}
            for ($$dst_reg_ref) {
                ##############
                # TMP3L -> A #
                ##############
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x30;
                    last;};
                ##############
                # TMP3L -> B #
                ##############
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x31;
                    last;};
                ####################
                # TMP3 -> CCR,CCRL #
                ####################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x32;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        #########
        # TMP3H #
        #########
        /^\s*(TMP3H)\s*$/i && do {
            if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
            for ($$dst_reg_ref) {
                #############
                # CCRH -> A #
                #############
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x38;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ########
        # TMP1 #
        ########
        /^\s*(TMP1)\s*$/i && do {
            if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
            for ($$dst_reg_ref) {
                #############
                # CCRH -> D #
                #############
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x3C;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ##########
        # ACCU D #
        ##########
        /^\s*(D)\s*$/i && do {
            for ($$dst_reg_ref) {
                ##########
                # D -> A #
                ##########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x40;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                ##########
                # D -> B #
                ##########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x41;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                #################
                # D -> CCR,CCRL #
                #################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x42;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                #############
                # D -> TMP2 #
                #############
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x43;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                ##########
                # D -> D #
                ##########
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x44;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                ##########
                # D -> X #
                ##########
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x45;
                    last;};
                ##########
                # D -> Y #
                ##########
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x46;
                    last;};
                ###########
                # D -> SP #
                ###########
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x47;
                    if ($tfr_type == $tfr_sex) {$error = 1;}
                    last;};
                #############
                # D -> CCRW #
                #############
                /^\s*(CCRW)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x4a;
                    if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
                    last;};
                #############
                # D -> TMP1 #
                #############
                /^\s*(TMP1)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x4b;
                    if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
                    last;};
                ############
                # no match #
                ############
                $error   = 1;
            }
            last;};
        ###########
        # INDEX X #
        ###########
        /^\s*(X)\s*$/i && do {
            if ($tfr_type == $tfr_sex) {$error = 1;}
            for ($$dst_reg_ref) {
                ##########
                # X -> A #
                ##########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x50;
                    last;};
                ##########
                # X -> B #
                ##########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x51;
                    last;};
                #################
                # X -> CCR,CCRL #
                #################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x52;
                    last;};
                #############
                # X -> TMP2 #
                #############
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x53;
                    last;};
                ##########
                # X -> D #
                ##########
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x54;
                    last;};
                ##########
                # X -> X #
                ##########
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x55;
                    last;};
                ##########
                # X -> Y #
                ##########
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x56;
                    last;};
                ###########
                # X -> SP #
                ###########
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x57;
                    last;};
                #############
                # X -> CCRW #
                #############
                /^\s*(CCRW)\s*$/i && do {
                    if ($cpu == $tfr_s12) {$error = 1;}
                    $extension_byte = $extension_byte | 0x5A;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ############
        # INDEX XL #
        ############
        /^\s*(XL)\s*$/i && do {
            if ($tfr_type == $tfr_sex) {$error = 1;}
            for ($$dst_reg_ref) {
                ###########
                # XL -> A #
                ###########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x50;
                    last;};
                ###########
                # XL -> B #
                ###########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x51;
                    last;};
                ##################
                # XL -> CCR,CCRL #
                ##################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x52;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ############
        # INDEX XH #
        ############
        /^\s*(XH)\s*$/i && do {
            if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
            for ($$dst_reg_ref) {
                ###########
                # XH -> A #
                ###########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x58;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ###########
        # INDEX Y #
        ###########
        /^\s*(Y)\s*$/i && do {
            if ($tfr_type == $tfr_sex) {$error = 1;}
            for ($$dst_reg_ref) {
                ##########
                # Y -> A #
                ##########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x60;
                    last;};
                ##########
                # Y -> B #
                ##########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x61;
                    last;};
                #################
                # Y -> CCR,CCRL #
                #################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x62;
                    last;};
                #############
                # Y -> TMP2 #
                #############
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x63;
                    last;};
                ##########
                # Y -> D #
                ##########
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x64;
                    last;};
                ##########
                # Y -> X #
                ##########
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x65;
                    last;};
                ##########
                # Y -> Y #
                ##########
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x66;
                    last;};
                ###########
                # Y -> SP #
                ###########
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x67;
                    last;};
                #############
                # Y -> CCRW #
                #############
                /^\s*(CCRW)\s*$/i && do {
                    if ($cpu == $tfr_s12) {$error = 1;}
                    $extension_byte = $extension_byte | 0x6A;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ############
        # INDEX YL #
        ############
        /^\s*(YL)\s*$/i && do {
            if ($tfr_type == $tfr_sex) {$error = 1;}
            for ($$dst_reg_ref) {
                ###########
                # YL -> A #
                ###########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x60;
                    last;};
                ###########
                # YL -> B #
                ###########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x61;
                    last;};
                ##################
                # YL -> CCR,CCRL #
                ##################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x62;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ############
        # INDEX YH #
        ############
        /^\s*(YH)\s*$/i && do {
            if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
            for ($$dst_reg_ref) {
                ###########
                # YH -> A #
                ###########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x68;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        #################
        # STACK POINTER #
        #################
        /^\s*(SP)\s*$/i && do {
            if ($tfr_type == $tfr_sex) {$error = 1;}
            for ($$dst_reg_ref) {
                ###########
                # SP -> A #
                ###########
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x70;
                    last;};
                ###########
                # SP -> B #
                ###########
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x71;
                    last;};
                ##################
                # SP -> CCR,CCRL #
                ##################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x72;
                    last;};
                ##############
                # SP -> TMP2 #
                ##############
                /^\s*(TMP2)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x73;
                    last;};
                ###########
                # SP -> D #
                ###########
                /^\s*D\s*$/i && do {
                    $extension_byte = $extension_byte | 0x74;
                    last;};
                ###########
                # SP -> X #
                ###########
                /^\s*(X)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x75;
                    last;};
                ###########
                # SP -> Y #
                ###########
                /^\s*(Y)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x76;
                    last;};
                ############
                # SP -> SP #
                ############
                /^\s*(SP)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x77;
                    last;};
                ##############
                # SP -> CCRW #
                ##############
                /^\s*(CCRW)\s*$/i && do {
                    if ($cpu == $tfr_s12) {$error = 1;}
                    $extension_byte = $extension_byte | 0x7A;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        #######
        # SPL #
        #######
        /^\s*(SPL)\s*$/i && do {
            if ($tfr_type == $tfr_sex) {$error = 1;}
            for ($$dst_reg_ref) {
                ############
                # SPL -> A #
                ############
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x70;
                    last;};
                ############
                # SPL -> B #
                ############
                /^\s*B\s*$/i && do {
                    $extension_byte = $extension_byte | 0x71;
                    last;};
                ###################
                # SPL -> CCR,CCRL #
                ###################
                /^\s*(CCR|CCRL)\s*$/i && do {
                    $extension_byte = $extension_byte | 0x72;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        #######
        # SPH #
        #######
        /^\s*(SPH)\s*$/i && do {
            if (($cpu == $tfr_s12) || ($tfr_type == $tfr_sex)) {$error = 1;}
            for ($$dst_reg_ref) {
                ############
                # SPH -> A #
                ############
                /^\s*A\s*$/i && do {
                    $extension_byte = $extension_byte | 0x78;
                    last;};
                ############
                # no match #
                ############
                $error = 1;
            }
            last;};
        ############
        # no match #
        ############
        $error = 1;
    }
    $$result_ref = sprintf("%.2X", $extension_byte);
    if ($error) {
        $$error_ref = sprintf("invalid register transfer \"%s -> %s\"", uc($$src_reg_ref), uc($$dst_reg_ref));
    }
    return 1;
}

############
# get_dbeq #
############
sub get_dbeq {
    my $self           = shift @_;
    my $post_byte_base = shift @_;
    my $reg_ref        = shift @_;
    my $addr_ref       = shift @_;
    my $pc_lin         = shift @_;
    my $pc_pag         = shift @_;
    my $loc_cnt        = shift @_;
    my $sym_tabs       = shift @_;
    my $error_ref      = shift @_;
    my $result_ref     = shift @_;
    my $post_byte = $post_byte_base;
    #temporary
    my $error;
    my $value;
    my $rel_addr;

    ###################
    # resolve address #
    ###################
    ($error, $value) = @{$self->evaluate_expression($$addr_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
        if (defined $pc_pag) {
            #printf STDERR "expression:   \"%s\"\n", $$addr_ref;
            #printf STDERR "pc_pag:   \"%X\" \"%s\"\n", $pc_pag, $pc_pag;
            #printf STDERR "value:    \"%X\" \"%s\"\n", $value,  $value;
            $rel_addr = int($value & 0xffff)  - int($pc_pag & 0xffff) - 3;
            #printf STDERR "rel_addr: \"%X\" \"%s\"\n", $rel_addr, $rel_addr;
            if (($rel_addr >= -256) && ($rel_addr <= 255)) {
                if ($rel_addr < 0) {
                    $post_byte = $post_byte | 0x10;
                }
                ####################
                # resolve register #
                ####################
                for ($$reg_ref) {
                    ##########
                    # ACCU A #
                    ##########
                    /^\s*A\s*$/i && do {
                        $post_byte = $post_byte | 0x00;
                        last;};
                    ##########
                    # ACCU B #
                    ##########
                    /^\s*B\s*$/i && do {
                        $post_byte = $post_byte | 0x01;
                        last;};
                    ##########
                    # ACCU D #
                    ##########
                    /^\s*D\s*$/i && do {
                        $post_byte = $post_byte | 0x04;
                        last;};
                    ###########
                    # INDEX X #
                    ###########
                    /^\s*X\s*$/i && do {
                        $post_byte = $post_byte | 0x05;
                        last;};
                    ###########
                    # INDEX Y #
                    ###########
                    /^\s*Y\s*$/i && do {
                        $post_byte = $post_byte | 0x06;
                        last;};
                    ######
                    # SP #
                    ######
                    /^\s*SP\s*$/i && do {
                        $post_byte = $post_byte | 0x07;
                        last;};
                    ############
                    # no match #
                    ############
                    return 0;
                }

                ###################
                # return hex code #
                ###################
                $$result_ref = sprintf("%.2X %.2X", (($post_byte & 0xff),
                                                     ($rel_addr & 0xff)));
                return 1;
            } else {
                return 0;
            }
        } else {
            $$result_ref = "?? ??";
            return 1;
        }
    } else {
        $$result_ref = "?? ??";
        return 1;
    }
}

############
# get_trap #
############
sub get_trap {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $value;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
        $value = $value & 0xff;
        if ((($value >= 0x30) && ($value <= 0x39)) ||
            (($value >= 0x40) && ($value <= 0xff))) {
            $$result_ref = sprintf("%.2X", $value);
            return 1;
        } else {
            $$error_ref = sprintf("illegal trap number \$%.2X", $value);
            $$result_ref = "??";
            return 1;
        }
    } else {
        $$result_ref = "??";
        return 1;
    }
}

#################
# get_s12x_trap #
#################
sub get_s12x_trap {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $error;
    my $value;

    ($error, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    if ($error) {$$error_ref = $error;}
    if (defined $value) {
        $value = $value & 0xff;
        if ((($value >= 0x30) && ($value <= 0x34)) ||
            (($value >= 0x49) && ($value <= 0x4f)) ||
             ($value == 0x59)                      ||
             ($value == 0x81)                      ||
             ($value == 0x86)                      ||
             ($value == 0x91)                      ||
             ($value == 0xa1)                      ||
             ($value == 0xa7)                      ||
             ($value == 0xb1)                      ||
             ($value == 0xb7)                      ||
             ($value == 0xc1)                      ||
             ($value == 0xc6)                      ||
            (($value >= 0xcc) && ($value <= 0xcf)) ||
             ($value == 0xd1)                      ||
             ($value == 0xe1)                      ||
             ($value == 0xf1)) {
            $$result_ref = sprintf("%.2X", $value);
            return 1;
        } else {
            $$error_ref = sprintf("illegal trap number \$%.2X", $value);
            $$result_ref = "??";
            return 1;
        }
    } else {
        $$result_ref = "??";
        return 1;
    }
}

#################
# get_xgate_imm #
#################
sub get_xgate_imm {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;

    ($$error_ref, $$result_ref) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
    return 1;
}

#################
# get_xgate_gpr #
#################
sub get_xgate_gpr {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;

    ####################
    # resolve register #
    ####################
    if ($$string_ref =~ /\s*R([0-7])\s*$/i) {
        $$result_ref = $1 & 0x07;
        return 1;
    }
    return 0;
}

#################
# get_xgate_rel #
#################
sub get_xgate_rel {
    my $self       = shift @_;
    my $string_ref = shift @_;
    my $pc_lin     = shift @_;
    my $pc_pag     = shift @_;
    my $loc_cnt    = shift @_;
    my $sym_tabs   = shift @_;
    my $error_ref  = shift @_;
    my $result_ref = shift @_;
    #temporary
    my $value;

    if (defined $pc_pag) {
        ($$error_ref, $value) = @{$self->evaluate_expression($$string_ref, $pc_lin, $pc_pag, $loc_cnt, $sym_tabs)};
        if (defined $value) {
            $$result_ref = ((int($value & 0xffff) - (int($pc_pag & 0xffff) +2)) /2);
        } else {
            $$result_ref = undef;
        }
    } else {
            $$result_ref = undef;
    }
    return 1;
}
