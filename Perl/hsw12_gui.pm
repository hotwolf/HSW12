#! /usr/bin/env perl
##################################################################################
#                                    HSW12                                       #
##################################################################################
# file:    hsw12_gui.pm                                                          #
# author:  Dirk Heisswolf                                                        #
# purpose: This is the HSW12 GUI                                                 #
##################################################################################
# Copyright (C) 2003-2009 by Dirk Heisswolf. All rights reserved.                #
# This file is part of "HSW12". HSW12 is free software;                          #
# you can redistribute it and/or modify it under the same terms as Perl itself.  #
##################################################################################
=pod
=head1 NAME

hsw12_gui - HSW12 Graphical User Interface

=head1 SYNOPSIS

 require hsw12_gui

 $gui = hsw12_gui->new($file_name);

=head1 REQUIRES

perl5.005, hsw12_asm, hsw12_pod, Tk, Tk::ROText, Tk::Dialog, Data::Dumper, IO::File, Fcntl, File::Basename, FindBin, POSIX

=head1 DESCRIPTION

This module provides a GUI for the HSW12 IDE.

=head1 METHODS

=head2 Creation

=over 4

=item hsw12_gui->new($file_name);

 Creates and returns an hsw12_pod object. 
 This method requires one argument:
     1. $file_name: assembler source code (*.s) or HSW12 session file (*.hsw12) (string)

=back

=head1 AUTHOR

Dirk Heisswolf

=head1 VERSION HISTORY

=over 4

=item V00.00 - Feb 9, 2003

 initial release

=item V00.01 - Feb 18, 2003 

 -new window menu option "connect"

=item V00.02 - Feb 24, 2003 
r
 -improved "connect" option

=item V00.03 - Mar 11, 2003 

 -fixed "Save Linear S-Record" and "Save Linear S-Record" options
 -added macro commands "[upload linear]" and "[upload paged]"
 -command entry (terminal window) now evaluates macro commands

=item V00.04 - Mar 14, 2003 

 -added more baud rates to "I/O" menu
 -added ppage values to breakpoint entry

=item V00.05 - Mar 17, 2003 

 -fixed "Save List File", "Save Linear S-Record", and "Save Linear S-Record" options

=item V00.06 - Mar 28, 2003 

 -added <Key-Return> bindings to all entry fields
 -follows PC in source code window even if PPAGE is undefined

=item V00.07 - Apr 1, 2003 

 -upload button is disabled when it is unusable
 -S0 field in S-Records sais "HSW12" (short string)
 -tracking release number in about window
 -added "Preferences" menu
 -double_clicking source code invokes editor

=item V00.08 - Apr 23, 2003 

 -setting select color for check and radiobuttons
 -I/O device and baud selections are undefined if not connected 
 -fixed "Save List File" option 

=item V00.09 - Apr 25, 2003 

 -updated "launch_editor" subroutine

=item V00.10 - Apr 29, 2003 

 -added argument to the hsw12_asm::new() call
 -added error messages for illegal expressions

=item V00.11 - May 6, 2003 

 -fixed macro editor
 -show busy cursor during reload
 -fixed "follow PC" feature
 -update does not change the view in the register
  window anymore

=item V00.12 - Jun 6, 2003 

 -included HCS12 S-Record Importer

=item V00.13 - Oct 27, 2003 

 -supports hsw12_asm.pm V00.13

=item V00.14 - Dec 9, 2003 

 -added HCS12X S-Record import feature
 -accept source code ending ".asm"

=item V00.15 - Feb 19, 2004 

 -no more additional line feeds when editing macros
 -fixed library path when restoring a session
 -removed "Edit" button in Variables window,
  now <Double-Button-1> activates the editor
 -now removing escape characters when evaluating macros

=item V00.16 - Mar 10, 2004 

 -fixed S-Record import buttons

=item V00.17 - Aug 19, 2004 

 -fixed S-Record import buttons (S12X imports)

=item V00.18 - Sep 24, 2009 

 -fixed source code output
 -added support for Prolific PL2303 USB adapters 

=back

=cut

#################
# Perl settings #
#################
#use warnings;
#use strict;
use FindBin qw($RealBin);
use lib $RealBin;
require hsw12_asm;
require hsw12_pod;
require hsw12_srec_import;

####################
# create namespace #
####################
package hsw12_gui;

###########
# modules #
###########
use Tk;
use Tk::ROText;
use Tk::Dialog;
use Tk::FBox;
use Data::Dumper;
use IO::File;
use Fcntl;
use File::Basename;

####################
# global variables #
####################
#$gui            (ref)
#$session        (ref)
#$code           (ref)
#$pod            (ref)

#############
# constants #
#############
###########
# version #
###########
*version = \"00.18";#"
*release = \"00.50";#"

#####################
# macro expressions #
#####################
*macro_split_command         = \qr/^(.*?)(?<!\\)\[([^\[\]]*)(?<!\\)\](.*)$/isx; #$1:text $2:command $3:text
*macro_command_update        = \qr/^\s*(?:update)\s*$/isx; 
*macro_command_upload        = \qr/^\s*(?:upload|up|u)\s*$/isx; 
*macro_command_upload_linear = \qr/^\s*(?:upload|up|u)\s*(?:linear|lin|l)\s*$/isx; 
*macro_command_upload_paged  = \qr/^\s*(?:upload|up|u)\s*(?:paged|pag|p)\s*$/isx; 
*macro_command_recompile     = \qr/^\s*(?:recompile|recomp|r)\s*$/isx; 
*macro_command_evaluate      = \qr/^\s*(?:evaluate|eval|e)\s*(\S+)\s*(\d+)(b|d|h|a)\s*$/isx; #$1:expression $2:bits $3:format
*macro_command_lookup        = \qr/^\s*(?:lookup|look|l)\s*(\S+)\s*(\d+)(b|d|h|a)\s*$/isx;   #$1:expression $2:bits $3:format
*macro_format_bin            = \qr/^\s*(?:b)\s*$/isx; 
*macro_format_dec            = \qr/^\s*(?:d)\s*$/isx; 
*macro_format_hex            = \qr/^\s*(?:h)\s*$/isx; 
*macro_format_ascii          = \qr/^\s*(?:a)\s*$/isx; 

##############
# macro tags #
##############
*macro_tag_default   = \"default";#"
*macro_tag_error     = \"error";#"
*macro_tag_evaluate  = \"evaluate";#"
*macro_tag_lookup    = \"lookup";#"

###############
# macro_flags #
###############
*macro_allow_pod_reads = \0x01;
*macro_allow_update    = \0x02;
*macro_allow_upload    = \0x04;
*macro_allow_recompile = \0x08;
*macro_allow_evaluate  = \0x10;
*macro_allow_lookup    = \0x20;
*macro_error_text      = \0x40;
*macro_error_popup     = \0x80;

####################
# source code tags #
####################
*source_tag_address    = \"address";#"
*source_tag_hexcode    = \"hexcode";#"
*source_tag_label      = \"label";#"
*source_tag_mnemonic   = \"mnemonic";#"
*source_tag_args       = \"args";#"
*source_tag_comment    = \"comment";#"
*source_tag_error      = \"error";#"
*source_tag_highlight  = \"highlight";#"
*source_tag_highlight  = \"highlight";#"

######################
# terminal code tags #
######################
*terminal_tag_default   = \"default";#"
*terminal_tag_error     = \"error";#"
*terminal_tag_info      = \"info";#"

###############
# PPAGE rules #
###############
*ppage_always = \"always";#"
*ppage_range  = \"range";#"
*ppage_never  = \"never";#"

###########
# choices #
###########
*choices_enable      = \"enable";#"
*choices_disable     = \"disable";#"
*choices_yes         = \"yes";#"
*choices_no          = \"no";#"
*choices_on          = \"on";#"
*choices_off         = \"off";#"
*choices_none        = \"none";#"
*choices_always      = \"always";#"
*choices_ppage_range = \"\$8000-\$BFFF";#"
*choices_never       = \"never";#"

###############
# constructor #
###############
sub new {
    my $proto        = shift @_;
    my $class        = ref($proto) || $proto;
    my $file_name    = shift @_;
    my $self         = {};

    #instantiate object
    bless $self, $class;

    if (defined $file_name) {
	#######################
	# determine file type #
	#######################
	for ($file_name) {
	    ############
	    # ASM file #
	    ############
	    /\.(s|asm)$/ && do {
		#print "ASM file\n";
		$self->new_session();
		#save file name
		$self->{session}->{source_file} = $file_name;
		#assemble code
		$self->{code} = hsw12_asm->new([$file_name], [sprintf("%s/", dirname($file_name)), "./"], {}, "S12", 0);
		#auto-select variables
		$self->auto_select_variables();
		last;};
	    ################
	    # session file #
	    ################
	    /\.hsw12$/ && do {
		#print "HSW12 file\n";
		$self->new_session();
		$self->restore_session($file_name);
		last;};
	    #################
	    # S-Record file #
	    #################
	    /\.s(19|28|37|x)$/ && do {
		#print "ASM file\n";
		$self->new_session();
		#save file name
		$self->{session}->{source_file} = $file_name;
		#assemble code
		$self->{code} = hsw12_srec_import->new($file_name, $hsw12_srec_import::srec_type_pag);
		last;};
	    #####################
	    # unknown file type # 
	    #####################
	    $self->new_session();
	}
    } else {
	###################
	# no initial file # 
	###################
	$self->new_session();
    }	

    #############
    # build GUI #
    #############
    $self->build_gui();

    ##################
    # connect to pod #
    ##################
    $self->{pod} = hsw12_pod->new($self->{session}->{preferences}->{io}->{device},
				  $self->{session}->{preferences}->{io}->{baud},
				  $self->{gui}->{terminal}->{text_text},
				  $self->{gui}->{main},
				  [\&update_vars, $self],
				  [\&update_regs, $self]);    
    $self->{session}->{preferences}->{io}->{device} = $self->{pod}->{device};
    $self->{session}->{preferences}->{io}->{baud}   = $self->{pod}->{baud_rate};
}

##############
# destructor #
##############
#sub DESTROY {
#    my $self = shift @_;
#}

######################
# create_main_window #
######################
sub create_main_window {
    my $self     = shift @_;
    my $state;
    my @ttyS_devs;
    my @ttydot_devs;
        
    if (Tk::Exists($self->{gui}->{main})) {
	######################
	# redraw main window #
	######################
	
    } else {
	######################
	# create main window #
	######################
	$self->{gui}->{main} = MainWindow->new();
	if ($self->{session}->{file_name} =~ /^\s*$/) {
	    $self->{gui}->{main}->title("HSW12 - Main");
	} else {
	    $self->{gui}->{main}->title(sprintf("HSW12 - Main (%s)", $self->{session}->{file_name}));
	}  
	#$self->{gui}->{main}->gridColumnconfigure(0, -weight => 1);
	#$self->{gui}->{main}->gridRowconfigure(   0, -weight => 1);
	
	#################
	# set autofocus #
	#################
	$self->{gui}->{main}->focusFollowsMouse;

	###############
	# set appname #
	###############
	$self->{gui}->{main}->appname("HSW12");

	########
	# menu #
	########
	#"File"
	$self->{gui}->{menu}->{file}->{mbutton} = $self->{gui}->{main}->Menubutton(-text => "File",
										   -borderwidth => 2,
										   -tearoff     => 'false');
	#new session
	$self->{gui}->{menu}->{file}->{new_session} = 
	    $self->{gui}->{menu}->{file}->{mbutton}->command(-label   => "New Session",
							     -command => [\&main_window_new_session_cmd, $self]);
	#restore session
	$self->{gui}->{menu}->{file}->{restore_session} = 
	    $self->{gui}->{menu}->{file}->{mbutton}->command(-label   => "Restore Session",
							     -command => [\&main_window_restore_session_cmd, $self]);
	#save session
	$self->{gui}->{menu}->{file}->{save_session} = 
	    $self->{gui}->{menu}->{file}->{mbutton}->command(-label   => "Save Session",
							     -command => [\&main_window_save_session_cmd, $self]);
	#save session as...
	$self->{gui}->{menu}->{file}->{save_session_as} = 
	    $self->{gui}->{menu}->{file}->{mbutton}->command(-label   => "Save Session as...",
							     -command => [\&main_window_save_session_as_cmd, $self]);
	#separator
	$self->{gui}->{menu}->{file}->{mbutton}->separator;
	#load source code
	$self->{gui}->{menu}->{file}->{load_source_code} = 
	    $self->{gui}->{menu}->{file}->{mbutton}->command(-label   => "Load Source Code",
							     -command => [\&main_window_load_source_code_cmd, $self]);
	#recompile source code
	$self->{gui}->{menu}->{file}->{recompile_source_code} = 
	    $self->{gui}->{menu}->{file}->{mbutton}->command(-label   => "Recompile Source Code",
							     -command => [\&main_window_recompile_source_code_cmd, $self]);
	#separator
	$self->{gui}->{menu}->{file}->{mbutton}->separator;

	#save list file
	$self->{gui}->{menu}->{file}->{save_list_file} = 
	    $self->{gui}->{menu}->{file}->{mbutton}->command(-label   => "Save List File",
							     -command => [\&main_window_save_list_file_cmd, $self]);
	#save linear srecord
	$self->{gui}->{menu}->{file}->{save_linear_srecord} = 
	    $self->{gui}->{menu}->{file}->{mbutton}->command(-label   => "Save Linear S-Record",
							     -command => [\&main_window_save_linear_srecord_cmd, $self]);
	#save paged srecord
	$self->{gui}->{menu}->{file}->{save_paged_srecord} = 
	    $self->{gui}->{menu}->{file}->{mbutton}->command(-label   => "Save Paged S-Record",
							     -command => [\&main_window_save_paged_srecord_cmd, $self]);

	#separator
	$self->{gui}->{menu}->{file}->{mbutton}->separator;

	#import
	$self->{gui}->{menu}->{file}->{import_cascade} = 
	    $self->{gui}->{menu}->{file}->{mbutton}->cascade(-label   => "Import...",
							     -tearoff => 'false');
	#import_linear_s12
	$self->{gui}->{menu}->{file}->{import_linear_s12} = 
	    $self->{gui}->{menu}->{file}->{import_cascade}->command(-label   => "Linear HCS12 S-Record",
							            -command => [\&main_window_import_linear_s12_srecord_cmd, $self]);

	#import_paged_s12
	$self->{gui}->{menu}->{file}->{import_linear_s12} = 
	    $self->{gui}->{menu}->{file}->{import_cascade}->command(-label   => "Paged HCS12 S-Record",
							            -command => [\&main_window_import_paged_s12_srecord_cmd, $self]);
	#separator
	$self->{gui}->{menu}->{file}->{import_cascade}->separator;

	#import_linear_s12x
	$self->{gui}->{menu}->{file}->{import_linear_s12x} = 
	    $self->{gui}->{menu}->{file}->{import_cascade}->command(-label   => "Linear HCS12X S-Record",
							            -command => [\&main_window_import_linear_s12x_srecord_cmd, $self]);

	#import_paged_s12x
	$self->{gui}->{menu}->{file}->{import_linear_s12x} = 
	    $self->{gui}->{menu}->{file}->{import_cascade}->command(-label   => "Paged HCS12X S-Record",
							            -command => [\&main_window_import_paged_s12x_srecord_cmd, $self]);

	#separator
	$self->{gui}->{menu}->{file}->{mbutton}->separator;

	#quit
	$self->{gui}->{menu}->{file}->{quit} = 
	    $self->{gui}->{menu}->{file}->{mbutton}->command(-label   => "Quit",
							     -command => [\&main_window_quit_cmd, $self]);
	$self->{gui}->{menu}->{file}->{mbutton}->pack(-side => "left", -padx => 2, -pady => 2 );
	
	#"Preferences"
	$self->{gui}->{menu}->{pref}->{mbutton} = $self->{gui}->{main}->Menubutton(-text => "Preferences",
										   -borderwidth => 2,
										   -tearoff     => 'false');
	#term
	$self->{gui}->{menu}->{pref}->{term_cascade} = 
	    $self->{gui}->{menu}->{pref}->{mbutton}->cascade(-label   => "Terminal",
							     -tearoff => 'false');
	#term_port
	$self->{gui}->{menu}->{pref}->{term_port_cascade} = 
	    $self->{gui}->{menu}->{pref}->{term_cascade}->cascade(-label   => "Port",
								  -tearoff => 'false');

        #port selection
        @ttyS_devs   = </dev/ttyS*>;
        @ttydot_devs = </dev/cu.*>;
        foreach my $dev (@ttyS_devs, @ttydot_devs) {
	  $self->{gui}->{menu}->{pref}->{$dev} = 
	    $self->{gui}->{menu}->{pref}->{term_port_cascade}->radiobutton(-label       => $dev,
									   -variable    => \$self->{session}->{preferences}->{io}->{device},
									   -value       => $dev,
									   -command     => [\&main_window_set_serial_device_cmd, $self],
									   -selectcolor => $self->{session}->{colors}->{dark_red});
	}

	##term_port_com1
	#$self->{gui}->{menu}->{pref}->{term_port_com1} = 
	#    $self->{gui}->{menu}->{pref}->{term_port_cascade}->radiobutton(-label       => "COM1",
	#								   -variable    => \$self->{session}->{preferences}->{io}->{device},
	#								   -value       => "/dev/ttyS0",
	#								   -command     => [\&main_window_set_serial_device_cmd, $self],
	#								   -selectcolor => $self->{session}->{colors}->{dark_red});
	##term_port_com2
	#$self->{gui}->{menu}->{pref}->{term_port_com2} = 
	#    $self->{gui}->{menu}->{pref}->{term_port_cascade}->radiobutton(-label       => "COM2",
	#								   -variable    => \$self->{session}->{preferences}->{io}->{device},
	#								   -value       => "/dev/ttyS1",
	#								   -command     => [\&main_window_set_serial_device_cmd, $self],
	#								   -selectcolor => $self->{session}->{colors}->{dark_red});
	##term_port_com3
	#$self->{gui}->{menu}->{pref}->{term_port_com3} = 
	#    $self->{gui}->{menu}->{pref}->{term_port_cascade}->radiobutton(-label       => "COM3",
	#								   -variable    => \$self->{session}->{preferences}->{io}->{device},
	#								   -value       => "/dev/ttyS2",
	#								   -command     => [\&main_window_set_serial_device_cmd, $self],
	#								   -selectcolor => $self->{session}->{colors}->{dark_red});
	##term_port_com4
	#$self->{gui}->{menu}->{pref}->{term_port_com3} = 
	#    $self->{gui}->{menu}->{pref}->{term_port_cascade}->radiobutton(-label       => "COM4",
	#								   -variable    => \$self->{session}->{preferences}->{io}->{device},
	#								   -value       => "/dev/ttyS3",
	#								   -command     => [\&main_window_set_serial_device_cmd, $self],
	#								   -selectcolor => $self->{session}->{colors}->{dark_red});
	##term_port_cu_usbserial
	#$self->{gui}->{menu}->{pref}->{term_port_cu_usbserial} = 
	#    $self->{gui}->{menu}->{pref}->{term_port_cascade}->radiobutton(-label       => "USB Prolific PL2303 (cu.usbserial)",
	#								   -variable    => \$self->{session}->{preferences}->{io}->{device},
	#								    -value      => "/dev/cu.usbserial",
	#								   -command     => [\&main_window_set_serial_device_cmd, $self],
	#								   -selectcolor => $self->{session}->{colors}->{dark_red});
	##term_port_tty_PL2303-3B1
	#$self->{gui}->{menu}->{pref}->{term_port_tty_PL2303_3B1} = 
	#    $self->{gui}->{menu}->{pref}->{term_port_cascade}->radiobutton(-label       => "USB Prolific PL2303 (tty.PL2303-3B1)",
	#								   -variable    => \$self->{session}->{preferences}->{io}->{device},
	#								   -value       => "/dev/tty.PL2303-3B1",
	#								   -command     => [\&main_window_set_serial_device_cmd, $self],
	#								   -selectcolor => $self->{session}->{colors}->{dark_red});

	#term_baud
	$self->{gui}->{menu}->{pref}->{term_baud_cascade} = 
	    $self->{gui}->{menu}->{pref}->{term_cascade}->cascade(-label   => "Speed",
								  -tearoff => 'false');
	##term_baud_1536000
	#$self->{gui}->{menu}->{pref}->{term_baud_153600} = 
	#    $self->{gui}->{menu}->{pref}->{term_baud_cascade}->radiobutton(-label       => "153600 baud",
	#								    -variable    => \$self->{session}->{preferences}->{io}->{baud},
	#								    -value       => "153600",
	#								    -command     => [\&main_window_set_serial_speed_cmd, $self],
	#								    -selectcolor => $self->{session}->{colors}->{dark_red});
	##term_baud_76800
	#$self->{gui}->{menu}->{pref}->{term_baud_76800} = 
	#    $self->{gui}->{menu}->{pref}->{term_baud_cascade}->radiobutton(-label       => "76800 baud",
	#								    -variable    => \$self->{session}->{preferences}->{io}->{baud},
	#								    -value       => "76800",
	#								    -command     => [\&main_window_set_serial_speed_cmd, $self],
	#								    -selectcolor => $self->{session}->{colors}->{dark_red});
	#term_baud_38400
	$self->{gui}->{menu}->{pref}->{term_baud_38400} = 
	    $self->{gui}->{menu}->{pref}->{term_baud_cascade}->radiobutton(-label       => "38400 baud",
									   -variable    => \$self->{session}->{preferences}->{io}->{baud},
									   -value       => "38400",
									   -command     => [\&main_window_set_serial_speed_cmd, $self],
									   -selectcolor => $self->{session}->{colors}->{dark_red});
	#term_baud_19200
	$self->{gui}->{menu}->{pref}->{term_baud_19200} = 
	    $self->{gui}->{menu}->{pref}->{term_baud_cascade}->radiobutton(-label       => "19200 baud",
									   -variable    => \$self->{session}->{preferences}->{io}->{baud},
									   -value       => "19200",
									   -command     => [\&main_window_set_serial_speed_cmd, $self],
									   -selectcolor => $self->{session}->{colors}->{dark_red});
	#term_baud_9600
	$self->{gui}->{menu}->{pref}->{term_baud_9600} = 
	    $self->{gui}->{menu}->{pref}->{term_baud_cascade}->radiobutton(-label       => " 9600 baud",
									   -variable    => \$self->{session}->{preferences}->{io}->{baud},
									   -value       => "9600",
									   -command     => [\&main_window_set_serial_speed_cmd, $self],
									   -selectcolor => $self->{session}->{colors}->{dark_red});
	#term_baud_4800
	$self->{gui}->{menu}->{pref}->{term_baud_4800} = 
	    $self->{gui}->{menu}->{pref}->{term_baud_cascade}->radiobutton(-label       => " 4800 baud",
									   -variable    => \$self->{session}->{preferences}->{io}->{baud},
									   -value       => "4800",
									   -command     => [\&main_window_set_serial_speed_cmd, $self],
									   -selectcolor => $self->{session}->{colors}->{dark_red});
	#term_baud_2400
	$self->{gui}->{menu}->{pref}->{term_baud_2400} = 
	    $self->{gui}->{menu}->{pref}->{term_baud_cascade}->radiobutton(-label       => " 2400 baud",
									   -variable    => \$self->{session}->{preferences}->{io}->{baud},
									   -value       => "2400",
									   -command     => [\&main_window_set_serial_speed_cmd, $self],
									   -selectcolor => $self->{session}->{colors}->{dark_red});
	#term_baud_1200
	$self->{gui}->{menu}->{pref}->{term_baud_1200} = 
	    $self->{gui}->{menu}->{pref}->{term_baud_cascade}->radiobutton(-label       => " 1200 baud",
									   -variable    => \$self->{session}->{preferences}->{io}->{baud},
									   -value       => "1200",
									   -command     => [\&main_window_set_serial_speed_cmd, $self],
									   -selectcolor => $self->{session}->{colors}->{dark_red});
	#separator
	$self->{gui}->{menu}->{pref}->{mbutton}->separator;
	#srec
	$self->{gui}->{menu}->{pref}->{srec_cascade} = 
	    $self->{gui}->{menu}->{pref}->{mbutton}->cascade(-label   => "S-Record",
							     -tearoff => 'false');
	#srec_format
	$self->{gui}->{menu}->{pref}->{srec_format_cascade} = 
	    $self->{gui}->{menu}->{pref}->{srec_cascade}->cascade(-label   => "Address Format",
								  -tearoff => 'false');
	#srec_format_s37
	#$self->{gui}->{menu}->{pref}->{srec_format_s37} = 
	#    $self->{gui}->{menu}->{pref}->{srec_format_cascade}->radiobutton(-label       => "S37",
	#								      -variable    => \$self->{session}->{preferences}->{srec}->{format},
	#								      -value       => "S37",
	#								      -selectcolor => $self->{session}->{colors}->{dark_red});
	#srec_format_s28
	$self->{gui}->{menu}->{pref}->{srec_format_s28} = 
	    $self->{gui}->{menu}->{pref}->{srec_format_cascade}->radiobutton(-label       => "S28",
									     -variable    => \$self->{session}->{preferences}->{srec}->{format},
									     -value       => "S28",
									     -selectcolor => $self->{session}->{colors}->{dark_red});
	#srec_format_s19
	$self->{gui}->{menu}->{pref}->{srec_format_s19} = 
	    $self->{gui}->{menu}->{pref}->{srec_format_cascade}->radiobutton(-label       => "S19",
									     -variable    => \$self->{session}->{preferences}->{srec}->{format},
									     -value       => "S19",
									     -selectcolor => $self->{session}->{colors}->{dark_red});
	#srec_length
	$self->{gui}->{menu}->{pref}->{srec_length_cascade} = 
	    $self->{gui}->{menu}->{pref}->{srec_cascade}->cascade(-label   => "Data Length",
								  -tearoff => 'false');
	#srec_length_64
	$self->{gui}->{menu}->{pref}->{srec_length_64} = 
	    $self->{gui}->{menu}->{pref}->{srec_length_cascade}->radiobutton(-label       => "64 bytes",
									     -variable    => \$self->{session}->{preferences}->{srec}->{length},
									     -value       => 64,
									     -selectcolor => $self->{session}->{colors}->{dark_red});
	#srec_length_48
	$self->{gui}->{menu}->{pref}->{srec_length_48} = 
	    $self->{gui}->{menu}->{pref}->{srec_length_cascade}->radiobutton(-label       => "48 bytes",
									     -variable    => \$self->{session}->{preferences}->{srec}->{length},
									     -value       => 48,
									     -selectcolor => $self->{session}->{colors}->{dark_red});
	#srec_length_32
	$self->{gui}->{menu}->{pref}->{srec_length_32} = 
	    $self->{gui}->{menu}->{pref}->{srec_length_cascade}->radiobutton(-label       => "32 bytes",
									     -variable    => \$self->{session}->{preferences}->{srec}->{length},
									     -value       => 32,
									     -selectcolor => $self->{session}->{colors}->{dark_red});
	#srec_length_16
	$self->{gui}->{menu}->{pref}->{srec_length_16} = 
	    $self->{gui}->{menu}->{pref}->{srec_length_cascade}->radiobutton(-label       => "16 bytes",
									     -variable    => \$self->{session}->{preferences}->{srec}->{length},
									     -value       => 16,
									     -selectcolor => $self->{session}->{colors}->{dark_red});
	#srec_s5
	$self->{gui}->{menu}->{pref}->{srec_s5_cascade} = 
	    $self->{gui}->{menu}->{pref}->{srec_cascade}->cascade(-label   => "S5-Records",
								  -tearoff => 'false');
	#srec_s5_128
	$self->{gui}->{menu}->{pref}->{srec_s5_128} = 
	    $self->{gui}->{menu}->{pref}->{srec_s5_cascade}->radiobutton(-label       => "every 128 S-Records",
									 -variable    => \$self->{session}->{preferences}->{srec}->{s5},
									 -value       => 128,
									 -selectcolor => $self->{session}->{colors}->{dark_red});
	#srec_s5_64
	$self->{gui}->{menu}->{pref}->{srec_s5_64} = 
	    $self->{gui}->{menu}->{pref}->{srec_s5_cascade}->radiobutton(-label       => "every  64 S-Records",
									 -variable    => \$self->{session}->{preferences}->{srec}->{s5},
									 -value       => 64,
									 -selectcolor => $self->{session}->{colors}->{dark_red});
	#srec_s5_32
	$self->{gui}->{menu}->{pref}->{srec_s5_32} = 
	    $self->{gui}->{menu}->{pref}->{srec_s5_cascade}->radiobutton(-label       => "every  32 S-Records",
									 -variable    => \$self->{session}->{preferences}->{srec}->{s5},
									 -value       => 32,
									 -selectcolor => $self->{session}->{colors}->{dark_red});
	#srec_s5_16
	$self->{gui}->{menu}->{pref}->{srec_s5_16} = 
	    $self->{gui}->{menu}->{pref}->{srec_s5_cascade}->radiobutton(-label       => "every  16 S-Records",
									 -variable    => \$self->{session}->{preferences}->{srec}->{s5},
									 -value       => 16,
									 -selectcolor => $self->{session}->{colors}->{dark_red});
	#srec_s5_none
	$self->{gui}->{menu}->{pref}->{srec_s5_none} = 
	    $self->{gui}->{menu}->{pref}->{srec_s5_cascade}->radiobutton(-label       => "none",
									 -variable    => \$self->{session}->{preferences}->{srec}->{s5},
									 -value       => 0,
									 -selectcolor => $self->{session}->{colors}->{dark_red});
	#srec_fill_bytes
	$self->{gui}->{menu}->{pref}->{srec_fill_bytes_cascade} = 
	    $self->{gui}->{menu}->{pref}->{srec_cascade}->cascade(-label   => "Fill Bytes",
								  -tearoff => 'false');
	#srec_fill_bytes_checkbutton
	$self->{gui}->{menu}->{pref}->{srec_fill_bytes_checkbutton} = 
	    $self->{gui}->{menu}->{pref}->{srec_fill_bytes_cascade}->checkbutton(-label       => "enable",
										 -variable    => \$self->{session}->{preferences}->{srec}->{fill_bytes},
										 -onvalue     => 1,
										 -offvalue    => 0,
										 -selectcolor => $self->{session}->{colors}->{dark_red});
	#separator
	$self->{gui}->{menu}->{pref}->{mbutton}->separator;
	#addr
	$self->{gui}->{menu}->{pref}->{addr_cascade} = 
	    $self->{gui}->{menu}->{pref}->{mbutton}->cascade(-label   => "Address Mode",
							     -tearoff => 'false');
	#addr_checkbutton
	$self->{gui}->{menu}->{pref}->{addr_checkbutton} = 
	    $self->{gui}->{menu}->{pref}->{addr_cascade}->checkbutton(-label       => "enable paged addresses",
								      -variable    => \$self->{session}->{preferences}->{ppage},
								      -onvalue     => 1,
								      -offvalue    => 0,
								      -selectcolor => $self->{session}->{colors}->{dark_red});
	$self->{gui}->{menu}->{pref}->{mbutton}->pack(-side => "left", -padx => 2, -pady => 2 );

	#"Windows"
	$self->{gui}->{menu}->{windows}->{mbutton} = $self->{gui}->{main}->Menubutton(-text => "Windows",
										      -borderwidth => 2,
										      -tearoff     => 'false');
	#terminal
	$self->{gui}->{menu}->{windows}->{terminal} = 
	    $self->{gui}->{menu}->{windows}->{mbutton}->command(-label    => "Terminal",
								-command  => [\&main_window_show_terminal_window_cmd, $self]);
	#source code
	$self->{gui}->{menu}->{windows}->{source_code} = 
	    $self->{gui}->{menu}->{windows}->{mbutton}->command(-label    => "Source Code",
								-command  => [\&main_window_show_source_code_window_cmd, $self]);
	#variables
	$self->{gui}->{menu}->{windows}->{variables} = 
	    $self->{gui}->{menu}->{windows}->{mbutton}->command(-label    => "Variables",
								-command  => [\&main_window_show_variables_window_cmd, $self]);
	#registers
	$self->{gui}->{menu}->{windows}->{registers} = 
	    $self->{gui}->{menu}->{windows}->{mbutton}->command(-label    => "Registers",
								-command  => [\&main_window_show_registers_window_cmd, $self]);
	#control
	$self->{gui}->{menu}->{windows}->{control} = 
	    $self->{gui}->{menu}->{windows}->{mbutton}->command(-label    => "Control",
								-command  => [\&main_window_show_control_window_cmd, $self]);
	#separator
	$self->{gui}->{menu}->{windows}->{mbutton}->separator;
	#all windows
	$self->{gui}->{menu}->{windows}->{all} = 
	    $self->{gui}->{menu}->{windows}->{mbutton}->command(-label    => "All Windows",
								-command  => [\&main_window_show_all_windows_cmd, $self]);
	#separator
	$self->{gui}->{menu}->{windows}->{mbutton}->separator;
	#connect
	$self->{gui}->{menu}->{windows}->{connect} = 
	    $self->{gui}->{menu}->{windows}->{mbutton}->checkbutton(-label       => "connect",
								    #-onvalue     => 1,
								    #-onvalue     => 0,
								    -command     => [\&main_window_connect_cmd, $self],
								    -indicatoron => 1,
								    -selectcolor => $self->{session}->{colors}->{dark_red});

	$self->{gui}->{menu}->{windows}->{mbutton}->pack( -side => "left", -padx => 2, -pady => 2 );
	
	#"Help"
	$self->{gui}->{menu}->{help}->{mbutton} = $self->{gui}->{main}->Menubutton(-text => "Help",
										   -borderwidth => 2,
										   -tearoff     => 'false');
	#about
	$self->{gui}->{menu}->{help}->{about} = 
	    $self->{gui}->{menu}->{help}->{mbutton}->command(-label   => "About",
							     -command => [\&main_window_about_cmd, $self]);
	$self->{gui}->{menu}->{help}->{mbutton}->pack( -side => "right", -padx => 2, -pady => 2 );
    }

    #update main window
    $self->update_main_window();
}

######################
# update_main_window #
######################
sub update_main_window {
    my $self     = shift @_;
    
    #widget states
    my $code_loaded_state;
    my $code_error_free_state;
    #source file
    my $file_short;

    #############
    # set title #
    #############
    if ($self->{session}->{source_file} =~ /^\s*$/) {
	$self->{gui}->{main}->title("HSW12 - Main");
    } else {
	$file_short = $self->{session}->{source_file};
	$file_short =~ s/^.*\///;
	$self->{gui}->{main}->title(sprintf("HSW12 - Main (%s)", $file_short));
    }  

    #####################
    # configure widgets #
    #####################
    #code is loaded
    if (exists $self->{code}->{problems}) {
	$code_loaded_state = 'normal';
    } else {
	$code_loaded_state = 'disabled';
    }
    #code is error free
    if (exists $self->{code}->{problems}) {
	if (! $self->{code}->{problems}) {
	    $code_error_free_state = 'normal';
	} else {
	    $code_error_free_state = 'disabled';
	}       
    } else {
	$code_error_free_state = 'disabled';
    }

    #recompile source code
    $self->{gui}->{menu}->{file}->{recompile_source_code}->configure(-state => $code_loaded_state);
    #save list file
    $self->{gui}->{menu}->{file}->{save_list_file}->configure(-state => $code_loaded_state);
    #save linear srecord
    $self->{gui}->{menu}->{file}->{save_linear_srecord}->configure(-state => $code_error_free_state);
    #save paged srecord
    $self->{gui}->{menu}->{file}->{save_paged_srecord}->configure(-state => $code_error_free_state);
    #connect
    $self->{gui}->{menu}->{windows}->{connect}->configure(-variable    => \$self->{session}->{gui}->{main}->{connect});
    ##############
    # set colors #
    ##############
    #$self->{gui}->{main}->setPalette($self->{session}->{colors}->{background});

    ################
    # set geometry #
    ################
    $self->{gui}->{main}->geometry($self->{session}->{gui}->{main}->{geometry});
    if ($self->{session}->{gui}->{main}->{state} =~ /^iconic$/) {
	$self->{gui}->{main}->iconify();
    }

    ####################
    # connect callback #
    ####################
    $self->{gui}->{main}->bind('<Configure>', 
			       [\&geometry_callback, $self, "main"]);
    
    ##################
    # close callback #
    ##################
    #$self->{gui}->{main}->OnDestroy([\&main_window_destroy_callback, $self]);
    $self->{gui}->{main}->protocol('WM_DELETE_WINDOW', [\&main_window_destroy_callback, $self]);

    #############
    # lock size #
    #############
    #if ($self->{session}->{gui}->{main}->{connect}) {
    #	$self->{gui}->{main}->resizable(0, 0);
    #} else {
    #	$self->{gui}->{main}->resizable(1, 1);
    #}
}

################################
# main_window_destroy_callback #
################################
sub main_window_destroy_callback {
    my $self     = shift @_;
    
    #print "main_window_destroy_callback\n";
    #$self->main_window_save_session_as_cmd(),
    $self->{gui}->{main}->destroy();
}

###############################
# main_window_new_session_cmd #
###############################
sub main_window_new_session_cmd {
    my $self     = shift @_;

    $self->new_session();
    $self->build_gui();
}

###################################
# main_window_restore_session_cmd #
###################################
sub main_window_restore_session_cmd {
    my $self     = shift @_;

    my $file_name = $self->{gui}->{main}->getOpenFile(-title            => "Restore Session",
						      -defaultextension => ".hsw12",
						      -filetypes        => [["HSW12 Session", ".hsw12"],
									    ["All Files"    , '*']]);
    if (defined $file_name) {
	if ($self->restore_session($file_name)) {
	    $self->build_gui();
	}
    }
}

################################
# main_window_save_session_cmd #
################################
sub main_window_save_session_cmd {
    my $self     = shift @_;

    if ($self->{session}->{file_name} =~ /^\s*$/) {
	$self->main_window_save_session_as_cmd();
    } else {
	$self->save_session($self->{session}->{file_name});
    }
}

###################################
# main_window_save_session_as_cmd #
###################################
sub main_window_save_session_as_cmd {
    my $self     = shift @_;
    my $file_name;

    if ($self->{session}->{file_name} =~ /^\s*$/) {
	$file_name = $self->{gui}->{main}->getSaveFile(-title            => "Save Session as...",
						       -defaultextension => ".hsw12",
						       -filetypes        => [["HSW12 Session", ".hsw12"],
									     ["All Files"    , '*']]);
    } else {
	$file_name = $self->{gui}->{main}->getSaveFile(-title            => "Save Session as...",
						       -defaultextension => ".hsw12",
						       -initialfile      => $self->{session}->{file_name},
						       -filetypes        => [["HSW12 Session", ".hsw12"],
									     ["All Files"    , '*']]);
    }
    if (defined $file_name) {
	$self->{session}->{file_name} = $file_name;
	$self->save_session($file_name);
    }
}

####################################
# main_window_load_source_code_cmd #
####################################
sub main_window_load_source_code_cmd {
    my $self     = shift @_;
    #text window
    my $text;
    #file name
    my $file_name = $self->{gui}->{main}->getOpenFile(-title            => "Load Source Code",
						      -defaultextension => [".s", ".asm"],
						      -filetypes        => [["ASM Files", [".s", ".asm"]],
									    ["All Files", '*']]);
    if (defined $file_name) {
        $self->{gui}->{main}->Busy(-recurse => 1);
	$self->{session}->{source_file} = $file_name;
	#assemble code
	if (Exists $self->{gui}->{source_code}->{text_text}) {
	    #use source code window
	    $self->{code} = hsw12_asm->new([$file_name], [sprintf("%s/", dirname($file_name)), "./"], {}, "S12", 0);
	} else {
	    #use STDOUT
	    $self->{code} = hsw12_asm->new([$file_name], [sprintf("%s/", dirname($file_name)), "./"], {}, "S12", 0);
	}

	#auto-select variables
	$self->auto_select_variables();
	#build GUI
	#if (!self->{session}->{gui}->{main}->{connect}) {
	#  $self->save_geometries();
	#}
	$self->save_geometries();
	$self->build_gui();
        $self->{gui}->{main}->Unbusy();
    }
}

#########################################
# main_window_recompile_source_code_cmd #
#########################################
sub main_window_recompile_source_code_cmd {
    my $self     = shift @_;
    #text window
    my $text;

    if (exists $self->{code}->{problems}) {
        $self->{gui}->{main}->Busy(-recurse => 1);
	if (Exists $self->{gui}->{source_code}->{text_text}) {
	    #use source code window
	    $self->{code}->reload(0);
	} else {
	    #use STDOUT
	    $self->{code}->reload(0);
	}
	$self->save_geometries();
	$self->build_gui();
        $self->{gui}->{main}->Unbusy();
    }
}

##################################
# main_window_save_list_file_cmd #
##################################
sub main_window_save_list_file_cmd {
    my $self     = shift @_;

    #file
    my $file_handle;
    my $file_name;
    
    if (exists $self->{code}->{problems}) {
	#suggest file name
	$file_name = ${$self->{code}->{source_files}}[0];
	$file_name =~ s/\.+[^\.]*$//;
	$file_name .= ".lst";
	#select file name
	$file_name = $self->{gui}->{main}->getSaveFile(-title            => "Save List File",
						       -defaultextension => ".lst",
						       -initialfile      => $file_name,
						       -filetypes        => [["List File", ".lst"],
									     ["All Files", '*']]);
	if (defined $file_name) {
	    if ($file_handle = IO::File->new($file_name, O_CREAT|O_WRONLY)) {
		$file_handle->truncate(0);
		print $file_handle $self->{code}->print_listing();
		$file_handle->close();
	    } else {
		$self->show_error_message(sprintf("cannot open \"%s\"", $file_name));
	    }
	}
    }
}

#######################################
# main_window_save_linear_srecord_cmd #
#######################################
sub main_window_save_linear_srecord_cmd {
    my $self = shift @_;
    #print STDERR "main_window_save_linear_srecord_cmd\n";

    #file
    my $file_handle;
    my $file_name;
    my $srec_extension = sprintf(".%s", lc($self->{session}->{preferences}->{srec}->{format}));

    if (exists $self->{code}->{problems}) {
	if (! $self->{code}->{problems}) {

	    $file_name = ${$self->{code}->{source_files}}[0];
	    $file_name =~ s/\.+[^\.]*$//;
	    $file_name .= sprintf("_lin.%s", lc($self->{session}->{preferences}->{srec}->{format}));
	    #select file name
	    $file_name = $self->{gui}->{main}->getSaveFile(-title            => "Save Linear S-Record",
							   -defaultextension => $srec_extension,
							   -initialfile      => $file_name,
							   -filetypes        => [["S-Record File", [$srec_extension, ".sx"]],
										 ["All Files",     '*']]);

	    if (defined $file_name) {
		if ($file_handle = IO::File->new($file_name, O_CREAT|O_WRONLY)) {
		    $file_handle->truncate(0);
		    $file_name = ${$self->{code}->{source_files}}[0];
		    $file_name =~ s/^\s*//;
		    print $file_handle $self->{code}->print_lin_srec("HSW12",
								     $self->{session}->{preferences}->{srec}->{format},
								     $self->{session}->{preferences}->{srec}->{length},
								     $self->{session}->{preferences}->{srec}->{s5},
								     $self->{session}->{preferences}->{srec}->{fill_bytes});
		    $file_handle->close();
		} else {
		    $self->show_error_message(sprintf("cannot open \"%s\"", $file_name));
		}
	    }
	}
    }
}

#######################################
# main_window_save_paged_srecord_cmd #
#######################################
sub main_window_save_paged_srecord_cmd {
    my $self = shift @_;
    #print STDERR "main_window_save_paged_srecord_cmd\n";

    #file
    my $file_handle;
    my $file_name;
    my $srec_extension = sprintf(".%s", lc($self->{session}->{preferences}->{srec}->{format}));

    if (exists $self->{code}->{problems}) {
	if (! $self->{code}->{problems}) {

	    $file_name = ${$self->{code}->{source_files}}[0];
	    $file_name =~ s/\.+[^\.]*$//;
	    $file_name .= sprintf("_pag.%s", lc($self->{session}->{preferences}->{srec}->{format}));
	    #select file name
	    $file_name = $self->{gui}->{main}->getSaveFile(-title            => "Save Paged S-Record",
							   -defaultextension => $srec_extension,
							   -initialfile      => $file_name,
							   -filetypes        => [["S-Record File", [$srec_extension, ".sx"]],
										 ["All Files",     '*']]);

	    if (defined $file_name) {
		if ($file_handle = IO::File->new($file_name, O_CREAT|O_WRONLY)) {
		    $file_handle->truncate(0);
		    $file_name = ${$self->{code}->{source_files}}[0];
		    $file_name =~ s/^\s*//;
		    print $file_handle $self->{code}->print_pag_srec("HSW12",
								     $self->{session}->{preferences}->{srec}->{format},
								     $self->{session}->{preferences}->{srec}->{length},
								     $self->{session}->{preferences}->{srec}->{s5},
								     $self->{session}->{preferences}->{srec}->{fill_bytes});
		    $file_handle->close();
		} else {
		    $self->show_error_message(sprintf("cannot open \"%s\"", $file_name));
		}
	    }
	}
    }
}

#############################################
# main_window_import_linear_s12_srecord_cmd #
#############################################
sub main_window_import_linear_s12_srecord_cmd {
    my $self     = shift @_;
    #text window
    my $text;
    #file name
    my $file_name = $self->{gui}->{main}->getOpenFile(-title            => "Import Linear HCS12 S-Record",
						      -defaultextension => "*",
						      -filetypes        => [["S-Record Files", [".s19", 
												".s28", 
												".s37", 
												".sx"]],
									    ["All Files", '*']]);
    #print STDERR "main_window_import_linear_srecord_cmd\n";

    if (defined $file_name) {
        $self->{gui}->{main}->Busy(-recurse => 1);
	$self->{session}->{source_file} = $file_name;
	#assemble code
	if (Exists $self->{gui}->{source_code}->{text_text}) {
	    #use source code window
	    $self->{code} = hsw12_srec_import->new($file_name, $hsw12_srec_import::srec_type_lin_s12, 0);
	} else {
	    #use STDOUT
	    $self->{code} = hsw12_srec_import->new($file_name, $hsw12_srec_import::srec_type_lin_s12, 0);
	}

	#build GUI
	#if (!self->{session}->{gui}->{main}->{connect}) {
	#  $self->save_geometries();
	#}
	$self->save_geometries();
	$self->build_gui();
        $self->{gui}->{main}->Unbusy();
    }
}

############################################
# main_window_import_paged_s12_srecord_cmd #
############################################
sub main_window_import_paged_s12_srecord_cmd {
    my $self     = shift @_;
    #text window
    my $text;
    #file name
    my $file_name = $self->{gui}->{main}->getOpenFile(-title            => "Import Paged HCS12 S-Record",
						      -defaultextension => "*",
						      -filetypes        => [["S-Record Files", [".s19", 
												".s28", 
												".s37", 
												".sx"]],
									    ["All Files", '*']]);
    #print STDERR "main_window_import_paged_srecord_cmd\n";

    if (defined $file_name) {
        $self->{gui}->{main}->Busy(-recurse => 1);
	$self->{session}->{source_file} = $file_name;
	#assemble code
	if (Exists $self->{gui}->{source_code}->{text_text}) {
	    #use source code window
	    $self->{code} = hsw12_srec_import->new($file_name, $hsw12_srec_import::srec_type_pag_s12, 0);
	} else {
	    #use STDOUT
	    $self->{code} = hsw12_srec_import->new($file_name, $hsw12_srec_import::srec_type_pag_s12, 0);
	}

	#build GUI
	#if (!self->{session}->{gui}->{main}->{connect}) {
	#  $self->save_geometries();
	#}
	$self->save_geometries();
	$self->build_gui();
        $self->{gui}->{main}->Unbusy();
    }
}

##############################################
# main_window_import_linear_s12x_srecord_cmd #
##############################################
sub main_window_import_linear_s12x_srecord_cmd {
    my $self     = shift @_;
    #text window
    my $text;
    #file name
    my $file_name = $self->{gui}->{main}->getOpenFile(-title            => "Import Linear HCS12X S-Record",
						      -defaultextension => "*",
						      -filetypes        => [["S-Record Files", [".s19", 
												".s28", 
												".s37", 
												".sx"]],
									    ["All Files", '*']]);
    #print STDERR "main_window_import_linear_srecord_cmd\n";

    if (defined $file_name) {
        $self->{gui}->{main}->Busy(-recurse => 1);
	$self->{session}->{source_file} = $file_name;
	#assemble code
	if (Exists $self->{gui}->{source_code}->{text_text}) {
	    #use source code window
	    $self->{code} = hsw12_srec_import->new($file_name, $hsw12_srec_import::srec_type_lin_s12x, 0);
	} else {
	    #use STDOUT
	    $self->{code} = hsw12_srec_import->new($file_name, $hsw12_srec_import::srec_type_lin_s12x, 0);
	}

	#build GUI
	#if (!self->{session}->{gui}->{main}->{connect}) {
	#  $self->save_geometries();
	#}
	$self->save_geometries();
	$self->build_gui();
        $self->{gui}->{main}->Unbusy();
    }
}

#############################################
# main_window_import_paged_s12x_srecord_cmd #
#############################################
sub main_window_import_paged_s12x_srecord_cmd {
    my $self     = shift @_;
    #text window
    my $text;
    #file name
    my $file_name = $self->{gui}->{main}->getOpenFile(-title            => "Import Paged HCS12X S-Record",
						      -defaultextension => "*",
						      -filetypes        => [["S-Record Files", [".s19", 
												".s28", 
												".s37", 
												".sx"]],
									    ["All Files", '*']]);
    #print STDERR "main_window_import_paged_srecord_cmd\n";

    if (defined $file_name) {
        $self->{gui}->{main}->Busy(-recurse => 1);
	$self->{session}->{source_file} = $file_name;
	#assemble code
	if (Exists $self->{gui}->{source_code}->{text_text}) {
	    #use source code window
	    $self->{code} = hsw12_srec_import->new($file_name, $hsw12_srec_import::srec_type_pag_s12x, 0);
	} else {
	    #use STDOUT
	    $self->{code} = hsw12_srec_import->new($file_name, $hsw12_srec_import::srec_type_pag_s12x, 0);
	}

	#build GUI
	#if (!self->{session}->{gui}->{main}->{connect}) {
	#  $self->save_geometries();
	#}
	$self->save_geometries();
	$self->build_gui();
        $self->{gui}->{main}->Unbusy();
    }
}

########################
# main_window_quit_cmd #
########################
sub main_window_quit_cmd {
    my $self     = shift @_;
 
    $self->main_window_destroy_callback;
}

#####################################
# main_window_set_serial_device_cmd #
#####################################
sub main_window_set_serial_device_cmd {
    my $self     = shift @_;

    if (defined $self->{pod}) {
      $self->{session}->{preferences}->{io}->{device} =
	$self->{pod}->set_device($self->{session}->{preferences}->{io}->{device});
    }
}

####################################
# main_window_set_serial_speed_cmd #
####################################
sub main_window_set_serial_speed_cmd {
    my $self     = shift @_;

    if (defined $self->{pod}) {
      $self->{session}->{preferences}->{io}->{baud} =
	$self->{pod}->set_baud_rate($self->{session}->{preferences}->{io}->{baud});
    }
}

########################################
# main_window_show_terminal_window_cmd #
########################################
sub main_window_show_terminal_window_cmd {
    my $self     = shift @_;

    $self->{session}->{gui}->{terminal}->{state} = 'normal';
    if (Tk::Exists $self->{gui}->{terminal}->{toplevel}) {
	$self->{gui}->{terminal}->{toplevel}->deiconify();
	$self->{gui}->{terminal}->{toplevel}->raise();
    } else {
	$self->create_terminal_window();
    }
}

###########################################
# main_window_show_source_code_window_cmd #
###########################################
sub main_window_show_source_code_window_cmd {
    my $self     = shift @_;
    
    $self->{session}->{gui}->{source_code}->{state} = 'normal';
    if (Tk::Exists $self->{gui}->{source_code}->{toplevel}) {
	$self->{gui}->{source_code}->{toplevel}->deiconify();
	$self->{gui}->{source_code}->{toplevel}->raise();
    } else {
	$self->create_source_code_window();
    }
}

#########################################
# main_window_show_variables_window_cmd #
#########################################
sub main_window_show_variables_window_cmd {
    my $self     = shift @_;
    
    $self->{session}->{gui}->{variables}->{state} = 'normal';
    if (Tk::Exists $self->{gui}->{variables}->{toplevel}) {
	$self->{gui}->{variables}->{toplevel}->deiconify();
	$self->{gui}->{variables}->{toplevel}->raise();
    } else {
	$self->create_variables_window();
    }
}

#########################################
# main_window_show_registers_window_cmd #
#########################################
sub main_window_show_registers_window_cmd {
    my $self     = shift @_;
    
    $self->{session}->{gui}->{registers}->{state} = 'normal';
    if (Tk::Exists $self->{gui}->{registers}->{toplevel}) {
	$self->{gui}->{registers}->{toplevel}->deiconify();
	$self->{gui}->{registers}->{toplevel}->raise();
    } else {
	$self->create_registers_window();
    }
}

#######################################
# main_window_show_control_window_cmd #
#######################################
sub main_window_show_control_window_cmd {
    my $self     = shift @_;
    
    $self->{session}->{gui}->{control}->{state} = 'normal';
    if (Tk::Exists $self->{gui}->{control}->{toplevel}) {
	$self->{gui}->{control}->{toplevel}->deiconify();
	$self->{gui}->{control}->{toplevel}->raise();
    } else {
	$self->create_control_window();
    }
}

####################################
# main_window_show_all_windows_cmd #
####################################
sub main_window_show_all_windows_cmd {
    my $self     = shift @_;
    
    $self->main_window_show_terminal_window_cmd();
    $self->main_window_show_source_code_window_cmd();
    $self->main_window_show_variables_window_cmd();
    $self->main_window_show_registers_window_cmd();
    $self->main_window_show_control_window_cmd();
}

###########################
# main_window_connect_cmd #
###########################
sub main_window_connect_cmd {
    my $self = shift @_;

}

#########################
# main_window_about_cmd #
#########################
sub main_window_about_cmd {
    my $self     = shift @_;
    my $about_text;

    #about dialog
    $about_text  = sprintf("HSW12 IDE for HC(S)12 Microcontrollers\n");
    $about_text .= sprintf("\n");
    $about_text .= sprintf("Release..................%s\n", $hsw12_gui::release);
    $about_text .= sprintf("\n");
    $about_text .= sprintf("Versions:\n");
    $about_text .= sprintf("Assembler................%s\n", $hsw12_asm::version);
    $about_text .= sprintf("GUI......................%s\n", $hsw12_gui::version);
    $about_text .= sprintf("DBug12 Interface.........%s\n", $hsw12_pod::version);
    $about_text .= sprintf("HCS12 S-Record Importer..%s\n", $hsw12_srec_import::version);
    $about_text .= sprintf("Perl.....................%s\n", $]);
    $about_text .= sprintf("Tk.......................%s\n", $Tk::VERSION);
    $about_text .= sprintf("\n");
    $about_text .= sprintf("OS:               %s\n", $^O);
    $about_text .= sprintf("\n");
    $about_text .= sprintf("\n");
    $about_text .= sprintf("Dirk Heisswolf <hsw12\@mail.com>\n");

    $self->{gui}->{about_dialog}->{toplevel} = $self->{gui}->{main}->Toplevel(-title => "About HSW12...");
    $self->{gui}->{about_dialog}->{toplevel}->gridColumnconfigure(0, -weight => 1);
    $self->{gui}->{about_dialog}->{toplevel}->gridRowconfigure(   0, -weight => 1);
    $self->{gui}->{about_dialog}->{toplevel}->gridRowconfigure(   1, -weight => 0);
    #$self->{gui}->{about_dialog}->{text} = 
    #  $self->{gui}->{about_dialog}->{toplevel}->Scrolled('ROText', 
    #							  -scrollbars => 'osoe',
    #							  -wrap       => 'none');
    #$self->{gui}->{about_dialog}->{text}->grid(-column  => 0,
    #						-row     => 0, 
    #						-sticky  => 'nsew');
    #$self->{gui}->{about_dialog}->{text}->insert('end', $about_text);
    $self->{gui}->{about_dialog}->{label} = 
      $self->{gui}->{about_dialog}->{toplevel}->Label(-text    => $about_text,
						      -font    => 'Fixed',
						      -justify => 'left');
    $self->{gui}->{about_dialog}->{label}->grid(-column  => 0,
						-row     => 0, 
						-sticky  => 'nsew');
    $self->{gui}->{about_dialog}->{button} = 
      $self->{gui}->{about_dialog}->{toplevel}->Button(-text    => "Ok",
						       -command => sub {$self->{gui}->{about_dialog}->{toplevel}->destroy()});
    $self->{gui}->{about_dialog}->{button}->grid(-column  => 0,
						 -row     => 1, 
						 -sticky  => 'ns');
}

##########################
# create_terminal_window #
##########################
sub create_terminal_window {
    my $self         = shift @_;
    #macro button;
    my $macro_button;

    if ($self->{session}->{gui}->{terminal}->{state} !~ /^closed$/) {
	if (Tk::Exists($self->{gui}->{terminal}->{toplevel})) {
	    ##########################
	    # redraw terminal window #
	    ##########################
	    
	} else {
	    ########################## 
	    # create terminal window #
	    ##########################
	    #toplevel
	    $self->{gui}->{terminal}->{toplevel} = $self->{gui}->{main}->Toplevel;
	    $self->{gui}->{terminal}->{toplevel}->gridColumnconfigure(0, -weight => 1);
	    $self->{gui}->{terminal}->{toplevel}->gridRowconfigure(   0, -weight => 1);
	    $self->{gui}->{terminal}->{toplevel}->gridRowconfigure(   1, -weight => 0);
	    $self->{gui}->{terminal}->{toplevel}->gridRowconfigure(   2, -weight => 0);
	    
	    #text_frame
	    $self->{gui}->{terminal}->{text_frame} = $self->{gui}->{terminal}->{toplevel}->Frame(-relief => 'ridge', -border => 2);
	    $self->{gui}->{terminal}->{text_frame}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{terminal}->{text_frame}->gridColumnconfigure(0, -weight => 1);
	    $self->{gui}->{terminal}->{text_frame}->gridRowconfigure(   0, -weight => 1);
	    $self->{gui}->{terminal}->{text_text} = 
		$self->{gui}->{terminal}->{text_frame}->Scrolled('ROText', 
								 -scrollbars => 'osoe',
								 -wrap       => 'none');
	    $self->{gui}->{terminal}->{text_text}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{terminal}->{text_text}->bind('<KeyPress>', [sub {my $keysym = $Tk::event->K;
									    my $char   = $Tk::event->A;
									    if ($keysym eq "Return")   {$char = "\n";}
									    if ($keysym eq "KP_Enter") {$char = "\n";}
									    if (defined  $self->{pod}) {$self->{pod}->send_string($char);}}]);
	    
	    #input_frame
	    $self->{gui}->{terminal}->{input_frame} = $self->{gui}->{terminal}->{toplevel}->Frame(-relief => 'ridge', -border => 2);
	    $self->{gui}->{terminal}->{input_frame}->grid(-column => 0, -row => 1, -sticky => 'nsew');
	    $self->{gui}->{terminal}->{input_frame}->gridColumnconfigure(0, -weight => 1);
	    $self->{gui}->{terminal}->{input_frame}->gridColumnconfigure(1, -weight => 0);
	    $self->{gui}->{terminal}->{input_frame}->gridColumnconfigure(2, -weight => 0);
	    $self->{gui}->{terminal}->{input_frame}->gridColumnconfigure(3, -weight => 0);
	    $self->{gui}->{terminal}->{input_frame}->gridRowconfigure(   0, -weight => 0);
	    $self->{gui}->{terminal}->{input_entry} = $self->{gui}->{terminal}->{input_frame}->Entry(-textvariable => \$self->{session}->{gui}->{terminal}->{input_string});
	    $self->{gui}->{terminal}->{input_entry}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{terminal}->{input_entry}->bind('<Key-Return>', [sub {$self->terminal_send_line_cmd()}]);
	    $self->{gui}->{terminal}->{input_enter_button} = $self->{gui}->{terminal}->{input_frame}->Button(-text    => "ENTER",
													     -command => [\&terminal_send_line_cmd, $self],
													     -width   => 4);
	    $self->{gui}->{terminal}->{input_enter_button}->grid(-column => 1, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{terminal}->{input_upload_button} = $self->{gui}->{terminal}->{input_frame}->Button(-text    => "UPLOAD",
													      -command => [\&terminal_upload_code_cmd, $self],
													      -width   => 4);
	    $self->{gui}->{terminal}->{input_upload_button}->grid(-column => 2, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{terminal}->{input_clear_button} = $self->{gui}->{terminal}->{input_frame}->Button(-text    => "CLEAR",
													     -command => [\&terminal_clear_cmd, $self],
													     -width   => 4);
	    $self->{gui}->{terminal}->{input_clear_button}->grid(-column => 3, -row => 0, -sticky => 'nsew');
	    #macro_frame
	    $self->{gui}->{terminal}->{macro_frame} = $self->{gui}->{terminal}->{toplevel}->Frame(-relief => 'ridge', -border => 2);
	    $self->{gui}->{terminal}->{macro_frame}->grid(-column => 0, -row => 2, -sticky => 'nsew');
	    $self->{gui}->{terminal}->{macro_frame}->gridColumnconfigure(0, -weight => 1);
	    $self->{gui}->{terminal}->{macro_frame}->gridColumnconfigure(1, -weight => 1);
	    $self->{gui}->{terminal}->{macro_frame}->gridColumnconfigure(2, -weight => 1);
	    $self->{gui}->{terminal}->{macro_frame}->gridColumnconfigure(3, -weight => 1);
	    $self->{gui}->{terminal}->{macro_frame}->gridRowconfigure(   0, -weight => 0);
	    $self->{gui}->{terminal}->{macro_frame}->gridRowconfigure(   1, -weight => 0);
	    
	    #####################
	    # macro button loop #
	    #####################
	    foreach $macro_button (['macro1', 0, 0],
				   ['macro2', 1, 0],
				   ['macro3', 2, 0],
				   ['macro4', 3, 0],
				   ['macro5', 0, 1],
				   ['macro6', 1, 1],
				   ['macro7', 2, 1],
				   ['macro8', 3, 1]) {

		$self->{gui}->{terminal}->{$macro_button->[0]}->{button} = 
		    $self->{gui}->{terminal}->{macro_frame}->Button(-command => [\&terminal_execute_macro_cmd, $self, $macro_button->[0]]);	    
		$self->{gui}->{terminal}->{$macro_button->[0]}->{button}->grid(-column => $macro_button->[1],
									       -row    => $macro_button->[2],
									       -sticky => 'nsew');
		$self->{gui}->{terminal}->{$macro_button->[0]}->{button}->bind('<ButtonRelease-3>', [\&terminal_define_macro_cmd, 
												     $self, 
												     $macro_button->[0]]);
	    }
	    
	    #dialog
	    $self->{gui}->{terminal}->{macro_dialog} = 
		$self->{gui}->{terminal}->{macro_frame}->DialogBox(-title          => "Define Macro",
								   -buttons        => ["Ok", "Cancel"],
								   -default_button => "Ok");
	    
	    $self->{gui}->{terminal}->{macro_dialog_entry_variable} = "";
	    $self->{gui}->{terminal}->{macro_dialog_name_frame} =
		$self->{gui}->{terminal}->{macro_dialog}->add('Frame');
	    $self->{gui}->{terminal}->{macro_dialog_name_frame}->pack(-fill   => 'x',
								      -expand => 0);
	    $self->{gui}->{terminal}->{macro_dialog_name_frame}->gridColumnconfigure(0, -weight => 0);
	    $self->{gui}->{terminal}->{macro_dialog_name_frame}->gridColumnconfigure(1, -weight => 1);
	    $self->{gui}->{terminal}->{macro_dialog_name_frame}->gridRowconfigure(   0, -weight => 0);
	    $self->{gui}->{terminal}->{macro_dialog_name_label} = 
		$self->{gui}->{terminal}->{macro_dialog_name_frame}->Label(-text  => "Name:",
									   -width => 5);
	    $self->{gui}->{terminal}->{macro_dialog_name_label}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{terminal}->{macro_dialog_name_entry} = 
		$self->{gui}->{terminal}->{macro_dialog_name_frame}->Entry(#-background          => $self->{session}->{colors}->{white},
									   #-highlightbackground => $self->{session}->{colors}->{white},
									   -textvariable        => \$self->{gui}->{terminal}->{macro_dialog_entry_variable});
	    $self->{gui}->{terminal}->{macro_dialog_name_entry}->grid(-column => 1, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{terminal}->{macro_dialog_text} = 
		$self->{gui}->{terminal}->{macro_dialog}->add('Scrolled', 'Text', 
							      #-background          => $self->{session}->{colors}->{white},
							      #-highlightbackground => $self->{session}->{colors}->{white},
							      -scrollbars => 'osoe',
							      -wrap       => 'none');
	    #$self->{gui}->{terminal}->{macro_dialog_text}->grid(-column => 0, -row => 1, -sticky => 'nsew');
	    $self->{gui}->{terminal}->{macro_dialog_text}->pack(-fill   => 'both',
								-expand => 1);
	    $self->{gui}->{terminal}->{macro_dialog_text}->bind('<Key-Return>' => [sub {$_[0]->break;}]);

            ##################
	    # connect to pod #
	    ##################
	    if (defined $self->{pod}) {
	      $self->{pod}->{terminal_window} = $self->{gui}->{terminal}->{text_text};
	    }
	}	    

	################
	# set geometry #
	################
	$self->{gui}->{terminal}->{toplevel}->geometry($self->{session}->{gui}->{terminal}->{geometry});
	if ($self->{session}->{gui}->{terminal}->{state} =~ /^iconic$/) {
	    $self->{gui}->{main}->iconify();
	}
	
	####################
	# connect callback #
	####################
	$self->{gui}->{terminal}->{toplevel}->bind('<Configure>', 
						   [\&geometry_callback, $self, "terminal"]);
	
	##################
	# close callback #
	##################
	$self->{gui}->{terminal}->{toplevel}->OnDestroy([\&terminal_destroy_callback, $self]);

	##########################
	# update terminal window #
	##########################
	$self->update_terminal_window();

    } elsif (Tk::Exists($self->{gui}->{terminal}->{toplevel})) {
	#########################
	# close terminal window #
	#########################
	$self->{gui}->{terminal}->{toplevel}->destroy();
    }
}

##########################
# update_terminal_window #
##########################
sub update_terminal_window {
    my $self     = shift @_;

    #widget states
    my $macro;
    my $macro_state;
    my $code_loaded_state;
    my $code_error_free_state;
    #source file
    my $file_short;
    #colors
    my $color_text     = $self->{session}->{colors}->{purple};
    my $color_error    = $self->{session}->{colors}->{red};
    my $color_info     = $self->{session}->{colors}->{blue};

    if ($self->{session}->{gui}->{terminal}->{state} !~ /^closed$/) {

	#############
	# set title #
	#############
	if ($self->{session}->{source_file} =~ /^\s*$/) {
	    $self->{gui}->{terminal}->{toplevel}->title("HSW12 - Terminal");
	} else {
	    $file_short = $self->{session}->{source_file};
	    $file_short =~ s/^.*\///;
	    $self->{gui}->{terminal}->{toplevel}->title(sprintf("HSW12 - Terminal (%s)", $file_short));
	}  

	#####################
	# configure widgets #
	#####################
	#code is loaded
	if (exists $self->{code}->{problems}) {
	    $code_loaded_state = 'normal';
	} else {
	    $code_loaded_state = 'disabled';
	}
	#code is error free
	if (exists $self->{code}->{problems}) {
	    if (! $self->{code}->{problems}) {
		$code_error_free_state = 'normal';
	    } else {
		$code_error_free_state = 'disabled';
	    }       
	} else {
	    $code_error_free_state = 'disabled';
	}

	#upload button
	$self->{gui}->{terminal}->{input_upload_button}->configure(-state => $code_error_free_state);
	#text_frame
	#$self->{gui}->{terminal}->{text_text}->configure(-background         => $self->{session}->{colors}->{white},
	#						 -highlightbackground => $self->{session}->{colors}->{white});
	#input_frame
	#$self->{gui}->{terminal}->{input_entry}->configure(-background         => $self->{session}->{colors}->{white},
	#						   -highlightbackground => $self->{session}->{colors}->{white});
	#macro_frame
	foreach $macro ('macro1',
			'macro2',
			'macro3',
			'macro4',
			'macro5',
			'macro6',
			'macro7',
			'macro8') {
	    
	    if ($self->{session}->{gui}->{terminal}->{$macro}->{sequence} eq "") {
		$macro_state = 'disable';
	    } else {
		$macro_state = 'normal';
	    }
	    $self->{gui}->{terminal}->{$macro}->{button}->configure(-textvariable => \$self->{session}->{gui}->{terminal}->{$macro}->{name},
								    -state        => $macro_state);
	}

	######################
	# update text widget #
	######################	
	$self->{gui}->{terminal}->{text_text}->tagConfigure($terminal_tag_default,
							    -foreground => $color_text);
	$self->{gui}->{terminal}->{text_text}->tagConfigure($terminal_tag_error,
							    -foreground => $color_error);
	$self->{gui}->{terminal}->{text_text}->tagConfigure($terminal_tag_info,
							    -foreground => $color_info);

	#load content into the test widget
	#$self->{gui}->{terminal}->{text_text}->delete('0.0', 'end');
	#$self->{gui}->{terminal}->{text_text}->insert('end', $self->{session}->{gui}->{terminal}->{content});

	######################
	# update input entry #
	######################
	$self->{gui}->{terminal}->{input_entry}->configure(-textvariable => \$self->{session}->{gui}->{terminal}->{input_string});

	#############
	# lock size #
	#############
	#if ($self->{session}->{gui}->{main}->{connect}) {
	#    $self->{gui}->{terminal}->{toplevel}->resizable(0, 0);
	#} else {
	#    $self->{gui}->{terminal}->{toplevel}->resizable(1, 1);
	#}
    }
}

#############################
# terminal_destroy_callback #
#############################
sub terminal_destroy_callback {
    my $self     = shift @_;
    
    if ($self->{session}->{gui}->{terminal}->{state} !~ /^closed$/) {
	$self->{session}->{gui}->{terminal}->{geometry} = $self->{gui}->{terminal}->{toplevel}->geometry();
    }
    $self->{session}->{gui}->{terminal}->{state}    = 'closed';

    ############################
    # remove text input handle #
    ############################
    $self->{gui}->{terminal}->{text_handle} = undef;

}

##########################
# terminal_send_line_cmd #
##########################
sub terminal_send_line_cmd {
    my $self        = shift @_;
    #format
    my @text_components;
    my $text_component;
    my $text_component_text;
    my $text_component_tag;
    #output string
    my $output_string;
    my $error_occured;
    #macro_flags
    my $macro_flags = ($macro_allow_update    |
		       $macro_allow_upload    |
		       $macro_allow_recompile |
		       $macro_allow_evaluate  |
		       $macro_allow_lookup    |
		       $macro_error_popup);
    
    ##########################
    # evaluate format string #
    ##########################
    @text_components = @{$self->evaluate_macro(sprintf("%s\n", $self->{session}->{gui}->{terminal}->{input_string}),
					       $macro_flags)};
  
    ###########################
    # determine output string #
    ###########################
    $output_string = "";
    $error_occured = 0;
    foreach $text_component (@text_components) {
	if ($#$text_component >= 1) {
	    $text_component_text = $text_component->[0];
	    $text_component_tag  = $text_component->[1];
	    #printf STDERR "%s (%s)\n", $text_component_text, $text_component_tag;
	    
	    if ($text_component_tag eq $macro_tag_error) {
		$error_occured = 1;
	    } else {
		$output_string .= $text_component_text;
	    }
	} else {
	    $error_occured = 1;
	}
    }
    
    if ((defined $self->{pod}) &&
	(!$error_occured)) {
	$self->{pod}->send_string($output_string);
    }
}

############################
# terminal_upload_code_cmd #
############################
sub terminal_upload_code_cmd {
    my $self     = shift @_;

    if (exists $self->{code}->{problems}) {
      #print linear S-Record
      if (defined $self->{pod}) {
	$self->{pod}->send_string($self->{code}->print_lin_srec("HSW12",
								$self->{session}->{preferences}->{srec}->{format},
								$self->{session}->{preferences}->{srec}->{length},
								$self->{session}->{preferences}->{srec}->{s5},
								$self->{session}->{preferences}->{srec}->{fill_bytes}));
      }
    }
}

######################
# terminal_clear_cmd #
######################
sub terminal_clear_cmd {
    my $self     = shift @_;

    $self->{gui}->{terminal}->{text_text}->delete('0.0', 'end');
}

##############################
# terminal_execute_macro_cmd #
##############################
sub terminal_execute_macro_cmd {
    my $self        = shift @_;
    my $macro       = shift @_;
    #format
    my @text_components;
    my $text_component;
    my $text_component_text;
    my $text_component_tag;
    #output string
    my $output_string;
    my $error_occured;
    #macro_flags
    my $macro_flags = ($macro_allow_update    |
                       $macro_allow_upload    |
                       $macro_allow_recompile |
                       $macro_allow_evaluate  |
		       $macro_allow_lookup    |
		       $macro_error_popup);
		       
    ##########################
    # evaluate format string #
    ##########################
    @text_components = @{$self->evaluate_macro($self->{session}->{gui}->{terminal}->{$macro}->{sequence}, $macro_flags)};
    
    ###########################
    # determine output string #
    ###########################
    $output_string = "";
    $error_occured = 0;
    foreach $text_component (@text_components) {
	if ($#$text_component >= 1) {
	    $text_component_text = $text_component->[0];
	    $text_component_tag  = $text_component->[1];
	    
	    if ($text_component_tag eq $macro_tag_error) {
		$error_occured = 1;
	    } else {
		$output_string .= $text_component_text;
	    }
	} else {
	    $error_occured = 1;
	}
    }
    
    if ((defined $self->{pod}) &&
	(!$error_occured)) {
	$self->{pod}->send_string($output_string);
    }
}

#############################
# terminal_define_macro_cmd #
#############################
sub terminal_define_macro_cmd {
    my $macro_widget = shift @_;
    my $self         = shift @_;
    my $macro        = shift @_;
    my $macro_state;
    my $answer;
    #print "terminal_define_macro_cmd\n";

    #####################
    # preset macro name #
    #####################
    $self->{gui}->{terminal}->{macro_dialog_entry_variable} = 
	$self->{session}->{gui}->{terminal}->{$macro}->{name};

    #########################
    # preset macro sequence #
    #########################
    $self->{gui}->{terminal}->{macro_dialog_text}->delete('0.0', 'end');
    $self->{gui}->{terminal}->{macro_dialog_text}->insert('end',
							  $self->{session}->{gui}->{terminal}->{$macro}->{sequence});
    
    $answer = $self->{gui}->{terminal}->{macro_dialog}->Show();
    if ($answer eq "Ok") {
	$self->{session}->{gui}->{terminal}->{$macro}->{name} = 
	    $self->{gui}->{terminal}->{macro_dialog_entry_variable};
	$self->{session}->{gui}->{terminal}->{$macro}->{sequence} = 
	    $self->{gui}->{terminal}->{macro_dialog_text}->get('0.0', 'end - 1 chars');
	if ($self->{session}->{gui}->{terminal}->{$macro}->{sequence} =~ /^\s*$/s) {
	    $macro_state = 'disable';
	} else {
	    $macro_state = 'normal';
	}
	$self->{gui}->{terminal}->{$macro}->{button}->configure(-state => $macro_state);
    }
}   

#############################
# create_source_code_window #
#############################
sub create_source_code_window {
    my $self         = shift @_;
    my $state;

    if ($self->{session}->{gui}->{source_code}->{state} !~ /^closed$/) {
	if (Tk::Exists($self->{gui}->{source_code}->{toplevel})) {
	    #############################
	    # redraw source code window #
	    #############################
	    
	} else {
	    ############################# 
	    # create source code window #
	    #############################
	    #toplevel
	    $self->{gui}->{source_code}->{toplevel} = $self->{gui}->{main}->Toplevel;
	    $self->{gui}->{source_code}->{toplevel}->gridColumnconfigure(0, -weight => 1);
	    $self->{gui}->{source_code}->{toplevel}->gridRowconfigure(   0, -weight => 1);
	    $self->{gui}->{source_code}->{toplevel}->gridRowconfigure(   1, -weight => 0);
	    $self->{gui}->{source_code}->{toplevel}->gridRowconfigure(   2, -weight => 0);
	    
	    #text_frame
	    $self->{gui}->{source_code}->{text_frame} = $self->{gui}->{source_code}->{toplevel}->Frame(-relief => 'ridge', -border => 2);
	    $self->{gui}->{source_code}->{text_frame}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{source_code}->{text_frame}->gridColumnconfigure(0, -weight => 1);
	    $self->{gui}->{source_code}->{text_frame}->gridRowconfigure(   0, -weight => 1);
	    $self->{gui}->{source_code}->{text_text} = 
		$self->{gui}->{source_code}->{text_frame}->Scrolled('ROText', 
								    -scrollbars => 'osoe',
								    -wrap       => 'none');
	    $self->{gui}->{source_code}->{text_text}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{source_code}->{text_text}->bind('<Double-Button-1>', [\&source_edit_cmd, $self]);
	    $self->{gui}->{source_code}->{text_info} = []; 

	    #goto frame
	    $self->{gui}->{source_code}->{goto_frame} = $self->{gui}->{source_code}->{toplevel}->Frame(-relief => 'ridge', -border => 2);
	    $self->{gui}->{source_code}->{goto_frame}->grid(-column => 0, -row => 1, -sticky => 'nsew');
	    $self->{gui}->{source_code}->{goto_frame}->gridColumnconfigure(0, -weight => 0);
	    $self->{gui}->{source_code}->{goto_frame}->gridColumnconfigure(1, -weight => 1);
	    $self->{gui}->{source_code}->{goto_frame}->gridColumnconfigure(2, -weight => 0);
	    $self->{gui}->{source_code}->{goto_frame}->gridRowconfigure(   0, -weight => 0);
	    #follow pc
	    $self->{gui}->{source_code}->{goto_follow_pc_cbutton} = 
		$self->{gui}->{source_code}->{goto_frame}->Checkbutton(-text     => "FOLLOW PC",
								       -command  => [\&source_code_follow_pc_cmd, $self],
								       -width    => 10,														    
								       -onvalue  => 1,
								       -offvalue => 0);
	    $self->{gui}->{source_code}->{goto_follow_pc_cbutton}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    #goto entry
	    $self->{gui}->{source_code}->{goto_entry} = 
		$self->{gui}->{source_code}->{goto_frame}->Entry();
	    $self->{gui}->{source_code}->{goto_entry}->grid(-column => 1, -row => 0, -sticky => 'nsew');
	    #goto button
	    $self->{gui}->{source_code}->{goto_entry}->bind('<Key-Return>', [sub {$self->source_code_goto_cmd()}]);
	    $self->{gui}->{source_code}->{goto_button} = 
		$self->{gui}->{source_code}->{goto_frame}->Button(-text         => "GOTO",
								  -command      => [\&source_code_goto_cmd, $self],
								  -width        => 6);
	    $self->{gui}->{source_code}->{goto_button}->grid(-column => 2, -row => 0, -sticky => 'nsew');
	    
	    #search frame
	    $self->{gui}->{source_code}->{search_frame} = $self->{gui}->{source_code}->{toplevel}->Frame(-relief => 'ridge', -border => 2);
	    $self->{gui}->{source_code}->{search_frame}->grid(-column => 0, -row => 2, -sticky => 'nsew');
	    $self->{gui}->{source_code}->{search_frame}->gridColumnconfigure(0, -weight => 1);
	    $self->{gui}->{source_code}->{search_frame}->gridColumnconfigure(1, -weight => 0);
	    $self->{gui}->{source_code}->{search_frame}->gridRowconfigure(   0, -weight => 0);
	    #search entry
	    $self->{gui}->{source_code}->{search_entry} = 
		$self->{gui}->{source_code}->{search_frame}->Entry();
	    $self->{gui}->{source_code}->{search_entry}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{source_code}->{search_entry}->bind('<Key-Return>', [sub {$self->source_code_search_cmd()}]);
	    #search button
	    $self->{gui}->{source_code}->{search_button} = 
		$self->{gui}->{source_code}->{search_frame}->Button(-text         => "SEARCH",
								    -command      => [\&source_code_search_cmd, $self],
								    -width        => 6);
	    $self->{gui}->{source_code}->{search_button}->grid(-column => 1, -row => 0, -sticky => 'nsew');
	    
	}
	
	################
	# set geometry #
	################
	$self->{gui}->{source_code}->{toplevel}->geometry($self->{session}->{gui}->{source_code}->{geometry});
	if ($self->{session}->{gui}->{source_code}->{state} =~ /^iconic$/) {
	    $self->{gui}->{main}->iconify();
	}

	########################
	# set test widget view #
	########################
	$self->{gui}->{source_code}->{text_text}->xviewMoveto($self->{session}->{gui}->{source_code}->{scrollpos_x});
	$self->{gui}->{source_code}->{text_text}->yviewMoveto($self->{session}->{gui}->{source_code}->{scrollpos_y});

	####################
	# connect callback #
	####################
	$self->{gui}->{source_code}->{toplevel}->bind('<Configure>', 
						      [\&geometry_callback, $self, "source_code"]);
	
	##################
	# close callback #
	##################
	$self->{gui}->{source_code}->{toplevel}->OnDestroy([\&source_code_destroy_callback, $self]);
	
	#############################
	# update source code window #
	#############################
	$self->update_source_code_window();
	
    } elsif (Tk::Exists($self->{gui}->{source_code}->{toplevel})) {
	############################
	# close source code window #
	############################
	$self->{gui}->{source_code}->{toplevel}->destroy();
    }
}

#############################
# update_source_code_window #
#############################
sub update_source_code_window {
    my $self     = shift @_;

    #widget states
    my $code_loaded_state;
    my $code_error_free_state;
    #source file
    my $file_short;

    if ($self->{session}->{gui}->{source_code}->{state} !~ /^closed$/) {

	#############
	# set title #
	#############
	if ($self->{session}->{source_file} =~ /^\s*$/) {
	    $self->{gui}->{source_code}->{toplevel}->title("HSW12 - Source Code");
	} else {
	    $file_short = $self->{session}->{source_file};
	    $file_short =~ s/^.*\///;
	    $self->{gui}->{source_code}->{toplevel}->title(sprintf("HSW12 - Source Code (%s)", $file_short));
	}  
   
	#####################
	# configure widgets #
	#####################
	#code is loaded
	if (exists $self->{code}->{problems}) {
	    $code_loaded_state = 'normal';
	} else {
	    $code_loaded_state = 'disabled';
	}
	#code is error free
	if (exists $self->{code}->{problems}) {
	    if (! $self->{code}->{problems}) {
		$code_error_free_state = 'normal';
	    } else {
		$code_error_free_state = 'disabled';
	    }       
	} else {
	    $code_error_free_state = 'disabled';
	}
	
	#text_frame
	#$self->{gui}->{source_code}->{text_frame}->configure(-background         => $self->{session}->{colors}->{white},
	#						     -highlightbackground => $self->{session}->{colors}->{white})
	
	#follow pc
	$self->{gui}->{source_code}->{goto_follow_pc_cbutton}->configure(-variable    => \$self->{session}->{gui}->{source_code}->{follow_pc},
									 -state       => $code_error_free_state,
									 -selectcolor => $self->{session}->{colors}->{dark_red});
	#goto entry
	$self->{gui}->{source_code}->{goto_entry}->configure(#-background          => $self->{session}->{colors}->{white},
							     #-highlightbackground => $self->{session}->{colors}->{white},
							     -textvariable        => \$self->{session}->{gui}->{source_code}->{goto_string},
							     -state               => $code_loaded_state);
	#goto button
	$self->{gui}->{source_code}->{goto_button}->configure(-state => $code_loaded_state);
	#search entry
	$self->{gui}->{source_code}->{search_entry}->configure(#-background          => $self->{session}->{colors}->{white},
							       #-highlightbackground => $self->{session}->{colors}->{white},
							       -state               => $code_loaded_state,
							       -textvariable        => \$self->{session}->{gui}->{source_code}->{search_string});
	#search button
	$self->{gui}->{source_code}->{search_button}->configure(-state => $code_loaded_state);

	######################
	# update text widget #
	######################
	$self->update_source_code_text();

	#############
	# lock size #
	#############
	#if ($self->{session}->{gui}->{main}->{connect}) {
	#    $self->{gui}->{source_code}->{toplevel}->resizable(0, 0);
	#} else {
	#    $self->{gui}->{source_code}->{toplevel}->resizable(1, 1);
	#}
    }
}

################################
# source_code_destroy_callback #
################################
sub source_code_destroy_callback {
    my $self     = shift @_;
    
    if ($self->{session}->{gui}->{source_code}->{state} !~ /^closed$/) {
	##################
	# store geometry #
	##################
	$self->{session}->{gui}->{source_code}->{geometry} = $self->{gui}->{source_code}->{toplevel}->geometry();
	##########################
	# store test widget view #
	##########################
	$self->{session}->{gui}->{source_code}->{scrollpos_x} = ($self->{gui}->{source_code}->{text_text}->xview())[0];
	$self->{session}->{gui}->{source_code}->{scrollpos_y} = ($self->{gui}->{source_code}->{text_text}->yview())[0];
    }	
    $self->{session}->{gui}->{source_code}->{state} = 'closed';
}

###########################
# update_source_code_text #
###########################
sub update_source_code_text {
    my $self     = shift @_;

    #address space
    my $addr;
    my $addrspace_entry;
    my $addr_tag;
    #code entry
    my $code_entry;
    my $code_line;
    my $code_comments;
    my $code_pc_lin;
    my $code_pc_pag;
    my $code_hex;
    my $code_errors;
    my $code_error;
    my $code_pc_pag_string;
    my @code_hex_bytes;
    my @code_hex_strings;
    my $code_hex_string;
    #comments
    my $cmt_line;
    my $cmt_line_cnt;
    my $cmt_label;
    my $cmt_label_wsp;
    my $cmt_mnemonic;
    my $cmt_mnemonic_wsp;
    my $cmt_args;
    my $cmt_args_wsp;
    my $cmt_comment;
    #colors
    my $color_address           = $self->{session}->{colors}->{purple};
    my $color_address_highlight = $self->{session}->{colors}->{dark_purple};
    my $color_hexcode           = $self->{session}->{colors}->{brown};
    my $color_label             = $self->{session}->{colors}->{dark_green};
    my $color_mnemonic          = $self->{session}->{colors}->{dark_blue};
    my $color_args              = $self->{session}->{colors}->{blue};
    my $color_comment           = $self->{session}->{colors}->{dark_red};
    my $color_error             = $self->{session}->{colors}->{red};
    my $color_highlight         = $self->{session}->{colors}->{yellow};
    #text widget
    my $text = $self->{gui}->{source_code}->{text_text};
    #info array
    my @info = ();

    #####################
    # clear text widget #
    #####################
    $text->delete('0.0', 'end');

    ###################
    # delete all tags #
    ###################
    $text->tagDelete($text->tagNames());

    ###########################
    # configure standard tags #
    ###########################
    $text->tagConfigure($source_tag_address,
			-foreground => $color_address);
    $text->tagConfigure($source_tag_hexcode,
			-foreground => $color_hexcode);
    $text->tagConfigure($source_tag_label,
			-foreground => $color_label);
    $text->tagConfigure($source_tag_mnemonic,
			-foreground => $color_mnemonic);
    $text->tagConfigure($source_tag_args,
			-foreground => $color_args);
    $text->tagConfigure($source_tag_comment,
			-foreground => $color_comment);
    $text->tagConfigure($source_tag_error,
			-foreground => $color_error);
    $text->tagConfigure($source_tag_highlight,
			-background => $color_highlight);

    #############
    # code loop #
    #############
    foreach $code_entry (@{$self->{code}->{code}}) {

	$code_line     = $code_entry->[0];
	$code_file     = $code_entry->[1];
	$code_comments = $code_entry->[2];
	$code_pc_pag   = $code_entry->[7];
	$code_hex      = $code_entry->[8];
	$code_errors   = $code_entry->[10];
        $code_macros   = $code_entry->[11];
	
	###############################
	# convert integers to strings #
	###############################
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
		/$hsw12_asm::cmp_no_hexcode/ && do {
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
		    #if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
		    #								     (shift @code_hex_bytes)));}
		    #if ($#code_hex_bytes >= 0) {$code_hex_string = sprintf("%s %s", ($code_hex_string,
		    #								     (shift @code_hex_bytes)));}
		    #trim string
		    $code_hex_string =~ s/^\s*//;
		    $code_hex_string =~ s/\s*$//;
		    push @code_hex_strings, $code_hex_string;
		}
	    }
	} else {	    
	    @code_hex_strings = ("??");
	}

	####################
	# print code entry #
	####################
	foreach $cmt_line_cnt (0..$#$code_comments) {
	    $cmt_line = $code_comments->[$cmt_line_cnt];
	    #printf "%.6X %s\n", $addr, $cmt_line;
	    
	    #parse comment line 
	    if ($cmt_line =~ /^(\w*:?)(\s*)([^\*\;\s]*)(\s*)([^;]*)(\s*)([;\*]?.*)$/) {
		$cmt_label        = $1;
		$cmt_label_wsp    = $2;
		$cmt_mnemonic     = $3;
		$cmt_mnemonic_wsp = $4;
		$cmt_args         = $5;
		$cmt_args_wsp     = $6;
		$cmt_comment      = $7;
	    } else {
		$cmt_label        = "";
		$cmt_label_wsp    = "";
		$cmt_mnemonic     = "";
		$cmt_mnemonic_wsp = "";
		$cmt_args         = "";
		$cmt_args_wsp     = "";
		$cmt_comment      = $cmt_line;
	    }
	    #printf "label:        \"%s\"\n", $cmt_label;
	    #printf "label_wsp:    \"%s\"\n", $cmt_label_wsp;
	    #printf "mnemonic:     \"%s\"\n", $cmt_mnemonic;
	    #printf "mnemonic_wsp: \"%s\"\n", $cmt_mnemonic_wsp;
	    #printf "args:         \"%s\"\n", $cmt_args;
	    #printf "args_wsp:     \"%s\"\n", $cmt_args_wsp;
	    #printf "comment:      \"%s\"\n", $cmt_comment;

	    #debug
	    #$self->{gui}->{source_code}->{text_text}->insert('end', sprintf("%12s %3d ", $$code_file, $code_line));

	    ########################
	    # address and hex code #
	    ########################
	    if ($cmt_line_cnt < $#$code_comments) {
		#no address or hex code
		#$self->{gui}->{source_code}->{text_text}->insert('end', sprintf("%6s ", ""), $source_tag_address);
		#$self->{gui}->{source_code}->{text_text}->insert('end', sprintf("%-18s ", ""), $source_tag_hexcode);
		$self->{gui}->{source_code}->{text_text}->insert('end', sprintf("%6s ", ""));
		$self->{gui}->{source_code}->{text_text}->insert('end', sprintf("%-18s ", ""));
	    } else {
		####################################
		# compare address to address space #
		####################################
		#$addr_tag = $source_tag_address;
		#if (defined $code_pc_pag) {
		#    if (exists $self->{code}->{pag_addrspace}->{$code_pc_pag}) {
		#	 if ($self->{code}->{pag_addrspace}->{$code_pc_pag}->[1] == $code_entry) {
		#	     #highlighted address
		#	     $addr_tag = sprintf("addr_%.6X", $code_pc_pag);
		#	     $text->tagConfigure($addr_tag,
		#				 -foreground => $color_address_highlight);
		#	 }
		#    }
		#}
		#$self->{gui}->{source_code}->{text_text}->insert('end', sprintf("%6s ", $code_pc_pag_string), $addr_tag);
		$self->{gui}->{source_code}->{text_text}->insert('end', sprintf("%6s", $code_pc_pag_string), $source_tag_address, " ");
		$self->{gui}->{source_code}->{text_text}->insert('end', sprintf("%-18s", shift @code_hex_strings), $source_tag_hexcode, " ");
	    }
	    
	    #label
	    if ($cmt_label =~ /^\s*$/) {
		$self->{gui}->{source_code}->{text_text}->insert('end', $cmt_label);
	    } else {
		$self->{gui}->{source_code}->{text_text}->insert('end', $cmt_label, $source_tag_label);
	    }
	    $self->{gui}->{source_code}->{text_text}->insert('end', $cmt_label_wsp);
	    
	    #mnemonic
	    if ($cmt_mnemonic =~ /^\s*$/) {
		$self->{gui}->{source_code}->{text_text}->insert('end', $cmt_mnemonic);
	    } else {
		$self->{gui}->{source_code}->{text_text}->insert('end', $cmt_mnemonic, $source_tag_mnemonic);
	    }
	    $self->{gui}->{source_code}->{text_text}->insert('end', $cmt_mnemonic_wsp);
	    
	    #args
	    if ($cmt_args =~ /^\s*$/) {
		$self->{gui}->{source_code}->{text_text}->insert('end', sprintf("%s%s", $cmt_args, $cmt_args_wsp));
	    } else {
		$self->{gui}->{source_code}->{text_text}->insert('end', $cmt_args, $source_tag_args);
		$self->{gui}->{source_code}->{text_text}->insert('end', $cmt_args_wsp);
	    }
	    
	    #comment
	    if ($cmt_comment =~ /^\s*$/) {
		$self->{gui}->{source_code}->{text_text}->insert('end', $cmt_comment_wsp);
	    } else {
		$self->{gui}->{source_code}->{text_text}->insert('end', $cmt_comment, $source_tag_comment);
	    }

	    #line break
	    $self->{gui}->{source_code}->{text_text}->insert('end', "\n");
	    #add info entry
	    push @info, $code_entry,
	}

	#print additional hex bytes
	foreach $code_hex_string (@code_hex_strings) {
	    $self->{gui}->{source_code}->{text_text}->insert('end', sprintf("%6s ", ""), $source_tag_address);
	    $self->{gui}->{source_code}->{text_text}->insert('end', sprintf("%-18s\n", $code_hex_string), $source_tag_hexcode);
	    push @info, $code_entry,
	}

	#errors
	foreach $code_error (@$code_errors) {
	    $self->{gui}->{source_code}->{text_text}->insert('end', 
							     sprintf("  ERROR! %s\n", $code_error), 
							     $source_tag_error);
	    push @info, $code_entry,
	}
	if ($#$code_errors >= 0) {
	    $self->{gui}->{source_code}->{text_text}->insert('end', 
							     sprintf("         (%s, line: %d)\n", $$code_file, $code_line), 
							     $source_tag_error);
	    push @info, $code_entry,
	}
    }
    $self->{gui}->{source_code}->{text_info} = \@info;
}

#############################
# source_code_follow_pc_cmd #
#############################
sub source_code_follow_pc_cmd {
    my $self     = shift @_;
    my $pc;
    my $ppage;
    my $address;
    
    #print STDERR "source_code_follow_pc_cmd\n";
    if($self->{session}->{gui}->{source_code}->{follow_pc}) {
	
        #####################
        # read PC and PPAGE #
        #####################
        $pc    = $self->{session}->{gui}->{registers}->{pc_read_string};
	$pc    =~ s/\s//g;
        $ppage = $self->{session}->{gui}->{registers}->{ppage_read_string};
	$ppage =~ s/\s//g;
	#printf STDERR "PPAGE:PC = %s:%s\n", $ppage, $pc;

	if (($pc    =~ /^[0-9a-fA-F]+$/) &&
	    ($ppage =~ /^[0-9a-fA-F]+$/)) {

	    ($ppage, $pc) = $self->format_address(((hex($ppage) & 0xff) << 16) | (hex($pc) & 0xffff));

	    ################
	    # show address #
	    ################
	    #printf STDERR "PPAGE:PC = %X:%X\n", $pc, $ppage;
	    $self->source_code_goto_address($ppage, $pc);
	}
    }
}

########################
# source_code_goto_cmd #
########################
sub source_code_goto_cmd {
    my $self     = shift @_;
    my $address;
    my $pc;
    my $ppage;

    ###############################
    # evaluate address expression #
    ###############################
    $address = $self->evaluate_expression($self->{session}->{gui}->{source_code}->{goto_string},
					  0xffffff,
					  1);

    ($ppage, $pc) = $self->format_address($address);

    ################
    # show address #
    ################
    $self->source_code_goto_address($ppage, $pc);
}

############################
# source_code_goto_address #
############################
sub source_code_goto_address {
    my $self    = shift @_;
    my $ppage   = shift @_;
    my $pc      = shift @_;
    my $address;
    my $current_address_string;
    my $current_address;
    my $current_start;
    my $current_end;
    my $search_done;
    my $best_address;
    my $best_start;
    my $best_end;

    ########################
    # remove highlight tag #
    ########################
    $self->{gui}->{source_code}->{text_text}->tagRemove($source_tag_highlight, '0.0', 'end');

    if (defined $pc) {
	if (defined $ppage) {
	    $address = ((($ppage & 0xff) << 16) | ($pc & 0xffff));
	} else {
	    $address = ($pc & 0xffff);
	}
	$best_address = undef;
	$best_start   = undef;
	$best_end     = undef;
	$search_done  = 0;
	$current_end  = '0.0';
	################
	# address loop #
	################
	while (!$search_done) {
	    ($current_start, $current_end) = $self->{gui}->{source_code}->{text_text}->tagNextrange($source_tag_address, $current_end);
	    if ((defined $current_start) && (defined $current_end)) {
		#######################
		# read address string #
		#######################
		$current_address_string = $self->{gui}->{source_code}->{text_text}->get($current_start, $current_end);
		#printf "current address: (%s) (%s) \"%s\"\n", $current_start, $current_end, $current_address_string;

		if ($current_address_string =~ /^[0-9a-f]+$/i) {
		    ##########################
		    # convert address string #
		    ##########################
		    $current_address = hex($current_address_string); 
		    #printf "  --->: %.6X\n", $current_address;

		    #########################
		    # check current address #
		    #########################
		    if (defined $best_address) {
			if (defined $ppage) {
			    if (abs($address - $current_address) < abs($address - $best_address)) {
				#current address is better
				$best_address = $current_address;
				$best_start   = $current_start;
				$best_end     = $current_end;
				if ($current_address == $address) {$search_done = 1;}
			    }
			} else{
			    if (abs($address - ($current_address & 0xffff)) < abs($address - ($best_address & 0xffff))) {
				#current address is better
				$best_address = $current_address;
				$best_start   = $current_start;
				$best_end     = $current_end;
				if (($current_address & 0xffff) == $address) {$search_done = 1;}
			    }
			}
		    } else {
			if (defined $ppage) {
			    #no best address defined
			    $best_address = $current_address;
			    $best_start   = $current_start;
			    $best_end     = $current_end;
			    if ($current_address == $address) {$search_done = 1;}
			} else {
			    #no best address defined
			    $best_address = $current_address;
			    $best_start   = $current_start;
			    $best_end     = $current_end;
			    if (($current_address & 0xffff) == $address) {$search_done = 1;}
			}
		    }
		}
	    } else {
		$search_done = 1;
	    }
	}

	if ((defined $best_start) && (defined $best_end)) {
	    #####################
	    # highlight address #
	    #####################
	    $self->{gui}->{source_code}->{text_text}->tagAdd($source_tag_highlight,
							     $best_start, 
							     $best_end);
	    $self->{gui}->{source_code}->{text_text}->see("$best_start linestart");
	    $self->{gui}->{source_code}->{text_text}->see($best_start);
	}
    }
}
 
##########################
# source_code_search_cmd #
##########################
sub source_code_search_cmd {
    my $self     = shift @_;
    my $index;
 
    if ($self->{gui}->{source_code}->{text_text}->tagRanges('sel')) {
	 $index =  $self->{gui}->{source_code}->{text_text}->search('-forwards',
								    '-regexp',
								    '-nocase',
								    '--',
								    sprintf("%s", $self->{session}->{gui}->{source_code}->{search_string}),
								    'sel.last');
    } else {
	 $index =  $self->{gui}->{source_code}->{text_text}->search('-forwards',
								    '-regexp',
								    '-nocase',
								    '--',
								    sprintf("%s", $self->{session}->{gui}->{source_code}->{search_string}),
								    '0.0');
    }
  
    #remove selection
    $self->{gui}->{source_code}->{text_text}->tagRemove('sel', '0.0', 'end'); 

    if (defined $index) {
	#select search result
	$self->{gui}->{source_code}->{text_text}->tagAdd('sel', $index, "$index lineend");
	#view search results
	$self->{gui}->{source_code}->{text_text}->see("$index linestart");
	$self->{gui}->{source_code}->{text_text}->see($index);
    } 
}

###################
# source_edit_cmd #
###################
sub source_edit_cmd {
    my $text_widget = shift @_;
    my $self        = shift @_;
    my $index;
    my $info;
    my $code_line;
    my $code_entry;
    my $code_file;
   
    ###########################
    # check if code is loaded #
    ###########################
    if (exists $self->{code}->{problems}) {
	$info       = $self->{gui}->{source_code}->{text_info};

	##################
	# get text index #
	##################
	$index = $text_widget->index(sprintf("@%d,%d", 
					     $Tk::event->x,
					     $Tk::event->y));
	if (defined $index) {
	    $index =~ s/\..*$//g;
	    if ($index =~ /^\d+$/) {
		$index = (int($index) - 1);
		if (($index >= 0) &&
		    ($index <= $#$info)) {
		    $code_entry = $info->[$index];
		    $code_line     = $code_entry->[0];
		    $code_file     = $code_entry->[1];

		    ###############
		    # open editor #
		    ###############
		    #printf STDERR "file: %s line: %s\n", $$code_file, $code_line;		    
		    $self->launch_editor($$code_file, $code_line);
		}
	    }
	}
    }	
}

###########################
# create_variables_window #
###########################
sub create_variables_window {
    my $self     = shift @_;
    my $state;

    if ($self->{session}->{gui}->{variables}->{state} !~ /^closed$/) {
	if (Tk::Exists($self->{gui}->{variables}->{toplevel})) {
	    ###########################
	    # redraw variables window #
	    ###########################
	    
	} else {
	    ########################### 
	    # create variables window #
	    ###########################

	    #toplevel
	    $self->{gui}->{variables}->{toplevel} = $self->{gui}->{main}->Toplevel;
	    $self->{gui}->{variables}->{toplevel}->gridColumnconfigure(0, -weight => 1);
	    $self->{gui}->{variables}->{toplevel}->gridRowconfigure(   0, -weight => 1);
	    $self->{gui}->{variables}->{toplevel}->gridRowconfigure(   1, -weight => 0);
	    #$self->{gui}->{variables}->{toplevel}->gridRowconfigure(   2, -weight => 0);
	    
	    #text_frame
	    $self->{gui}->{variables}->{text_frame} = $self->{gui}->{variables}->{toplevel}->Frame(-relief => 'ridge', -border => 2);
	    $self->{gui}->{variables}->{text_frame}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{variables}->{text_frame}->gridColumnconfigure(0, -weight => 1);
	    $self->{gui}->{variables}->{text_frame}->gridRowconfigure(   0, -weight => 1);
	    $self->{gui}->{variables}->{text_text} = 
		$self->{gui}->{variables}->{text_frame}->Scrolled('ROText', 
								  -scrollbars => 'osoe',
								  -wrap       => 'none');
	    $self->{gui}->{variables}->{text_text}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{variables}->{text_text}->bind('<Double-Button-1>', [\&variables_edit_cmd, $self]);

	    #set_frame
	    $self->{gui}->{variables}->{set_frame} = $self->{gui}->{variables}->{toplevel}->Frame(-relief => 'ridge', -border => 2);
	    $self->{gui}->{variables}->{set_frame}->grid(-column => 0, -row => 1, -sticky => 'nsew');
	    $self->{gui}->{variables}->{set_frame}->gridColumnconfigure(0, -weight => 1);
	    $self->{gui}->{variables}->{set_frame}->gridColumnconfigure(1, -weight => 1);
	    $self->{gui}->{variables}->{set_frame}->gridColumnconfigure(2, -weight => 0);
	    $self->{gui}->{variables}->{set_frame}->gridColumnconfigure(3, -weight => 0);
	    $self->{gui}->{variables}->{set_frame}->gridRowconfigure(   0, -weight => 0);
	    $self->{gui}->{variables}->{set_addr_entry} = $self->{gui}->{variables}->{set_frame}->Entry();
	    $self->{gui}->{variables}->{set_addr_entry}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{variables}->{set_addr_entry}->bind('<Key-Return>', [sub {$self->variables_set_cmd()}]);
	    $self->{gui}->{variables}->{set_data_entry} = $self->{gui}->{variables}->{set_frame}->Entry();
	    $self->{gui}->{variables}->{set_data_entry}->grid(-column => 1, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{variables}->{set_data_entry}->bind('<Key-Return>', [sub {$self->variables_set_cmd()}]);
	    $self->{gui}->{variables}->{set_width_entry} = $self->{gui}->{variables}->{set_frame}->Entry(-width => 3);
	    $self->{gui}->{variables}->{set_width_entry}->grid(-column => 2, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{variables}->{set_width_entry}->bind('<Key-Return>', [sub {$self->variables_set_cmd()}]);
	    $self->{gui}->{variables}->{set_button} = $self->{gui}->{variables}->{set_frame}->Button(-text    => "Set",
                                                                                                     -command => [\&variables_set_cmd, $self]);
	    $self->{gui}->{variables}->{set_button}->grid(-column => 3, -row => 0, -sticky => 'nsew');
	    
	    #edit_frame
	    #$self->{gui}->{variables}->{edit_frame} = $self->{gui}->{variables}->{toplevel}->Frame(-relief => 'ridge', -border => 2);
	    #$self->{gui}->{variables}->{edit_frame}->grid(-column => 0, -row => 2, -sticky => 'nsew');
	    #$self->{gui}->{variables}->{edit_frame}->gridColumnconfigure(0, -weight => 1);
	    #$self->{gui}->{variables}->{edit_frame}->gridRowconfigure(   0, -weight => 0);
	    #$self->{gui}->{variables}->{edit_button} = $self->{gui}->{variables}->{edit_frame}->Button(-text    => "Edit",
            #													     -command => [\&variables_edit_cmd, 0, $self]);
            #$self->{gui}->{variables}->{edit_button}->grid(-column => 0, -row => 0, -sticky => 'nsew');

	    #dialog
	    $self->{gui}->{variables}->{edit_dialog} = 
		$self->{gui}->{variables}->{toplevel}->DialogBox(-title          => "Edit Variables",
						        	 -buttons        => ["Ok", "Cancel"],
								 -default_button => "Ok");	    
	    $self->{gui}->{variables}->{edit_dialog_frame} = 
		 $self->{gui}->{variables}->{edit_dialog}->Frame();
	    $self->{gui}->{variables}->{edit_dialog_frame}->pack(-fill   => 'both',
								 -expand => 1); 
	    $self->{gui}->{variables}->{edit_dialog_frame}->gridColumnconfigure(0, -weight => 1);
	    $self->{gui}->{variables}->{edit_dialog_frame}->gridRowconfigure(   0, -weight => 1);

	    $self->{gui}->{variables}->{edit_dialog_text} = 
		$self->{gui}->{variables}->{edit_dialog_frame}->Scrolled('Text', 
									 #-background          => $self->{session}->{colors}->{white},
									 #-highlightbackground => $self->{session}->{colors}->{white},
									 -scrollbars => 'osoe',
									 -wrap       => 'none');
	    $self->{gui}->{variables}->{edit_dialog_text}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{variables}->{edit_dialog_text}->bind('<Key-Return>' => [sub {$_[0]->break;}]);	    
	}

	################
	# set geometry #
	################
	$self->{gui}->{variables}->{toplevel}->geometry($self->{session}->{gui}->{variables}->{geometry});
	if ($self->{session}->{gui}->{variables}->{state} =~ /^iconic$/) {
	    $self->{gui}->{main}->iconify();
	}
	
	########################
	# set test widget view #
	########################
	$self->{gui}->{variables}->{text_text}->xviewMoveto($self->{session}->{gui}->{variables}->{scrollpos_x});
	$self->{gui}->{variables}->{text_text}->yviewMoveto($self->{session}->{gui}->{variables}->{scrollpos_y});

	####################
	# connect callback #
	####################
	$self->{gui}->{variables}->{toplevel}->bind('<Configure>', 
						    [\&geometry_callback, $self, "variables"]);
	
	##################
	# close callback #
	##################
	$self->{gui}->{variables}->{toplevel}->OnDestroy([\&variables_destroy_callback, $self]);
	

	###########################
	# update variables window #
	###########################
	$self->update_variables_window();
	
    } elsif (Tk::Exists($self->{gui}->{variables}->{toplevel})) {
	#########################
	# close variables window #
	#########################
	$self->{gui}->{variables}->{toplevel}->destroy();
    }
}

###########################
# update_variables_window #
###########################
sub update_variables_window {
    my $self     = shift @_;

    #widget states
    my $code_loaded_state;
    my $code_error_free_state;
    #source file
    my $file_short;

    if ($self->{session}->{gui}->{variables}->{state} !~ /^closed$/) {

	#############
	# set title #
	#############
	if ($self->{session}->{source_file} =~ /^\s*$/) {
	    $self->{gui}->{variables}->{toplevel}->title("HSW12 - Variables");
	} else {
	    $file_short = $self->{session}->{source_file};
	    $file_short =~ s/^.*\///;
	    $self->{gui}->{variables}->{toplevel}->title(sprintf("HSW12 - Variables (%s)", $file_short));
	}  

	#####################
	# configure widgets #
	#####################
	#text frame
	#$self->{gui}->{variables}->{text_text}->configure(-background         => $self->{session}->{colors}->{white},
	#						  -highlightbackground => $self->{session}->{colors}->{white});
	#set_addr_entry
	$self->{gui}->{variables}->{set_addr_entry}->configure(#-background          => $self->{session}->{colors}->{white},
							       #-highlightbackground => $self->{session}->{colors}->{white},
							       -textvariable        => \$self->{session}->{gui}->{variables}->{addr_string});
	#set_data_entry
	$self->{gui}->{variables}->{set_data_entry}->configure(#-background          => $self->{session}->{colors}->{white},
							       #-highlightbackground => $self->{session}->{colors}->{white},
							       -textvariable        => \$self->{session}->{gui}->{variables}->{data_string});
	#set_width_entry
	$self->{gui}->{variables}->{set_width_entry}->configure(#-background          => $self->{session}->{colors}->{white},
								#-highlightbackground => $self->{session}->{colors}->{white},
								-textvariable        => \$self->{session}->{gui}->{variables}->{width_string});

	######################
	# update text widget #
	######################
	$self->update_variables_text(0);	    

	#############
	# lock size #
	#############
	#if ($self->{session}->{gui}->{main}->{connect}) {
	#    $self->{gui}->{variables}->{toplevel}->resizable(0, 0);
	#} else {
	#    $self->{gui}->{variables}->{toplevel}->resizable(1, 1);
	#}
    }
}

##############################
# variables_destroy_callback #
##############################
sub variables_destroy_callback {
    my $self     = shift @_;
    
    if ($self->{session}->{gui}->{variables}->{state} !~ /^closed$/) {
	##################
	# store geometry #
	##################
	$self->{session}->{gui}->{variables}->{geometry} = $self->{gui}->{variables}->{toplevel}->geometry();
	##########################
	# store test widget view #
	##########################
	$self->{session}->{gui}->{variables}->{scrollpos_x} = ($self->{gui}->{variables}->{text_text}->xview())[0];
	$self->{session}->{gui}->{variables}->{scrollpos_y} = ($self->{gui}->{variables}->{text_text}->yview())[0];
    }
    $self->{session}->{gui}->{variables}->{state} = 'closed';
}

#########################
# update_variables_text #
#########################
sub update_variables_text {
    my $self            = shift @_;
    my $allow_pod_reads = shift @_;
    #macro_flags
    my $macro_flags;
    #format
    my @text_components;
    my $text_component;
    my $text_component_text;
    my $text_component_tag;
    #colors
    my $color_text     = $self->{session}->{colors}->{purple};
    my $color_evaluate = $self->{session}->{colors}->{dark_green};
    my $color_lookup   = $self->{session}->{colors}->{dark_blue};
    my $color_error    = $self->{session}->{colors}->{red};
    #text widget
    my $text = $self->{gui}->{variables}->{text_text};
    #scroll values
    my @x_scroll;
    my @y_scroll;
    #temporary
    my $error;
    my $value;
    my $char;
    my $string;
    my $i;

    #########################
    # determine macro flags #
    #########################
    if ($allow_pod_reads) {
	$macro_flags = ($macro_allow_pod_reads |
			$macro_allow_evaluate  |
			$macro_allow_lookup    |
			$macro_error_text);
    } else {
	$macro_flags = ($macro_allow_evaluate |
			$macro_allow_lookup    |
			$macro_error_text);
    }

    #####################
    # clear text widget #
    #####################
    @x_scroll = $text->xview();
    @y_scroll = $text->yview();
    $text->delete('0.0', 'end');

    ###################
    # delete all tags #
    ###################
    $text->tagDelete($text->tagNames());
   
    ###########################
    # configure standard tags #
    ###########################
    $text->tagConfigure($macro_tag_default,
			-foreground => $color_text);
    $text->tagConfigure($macro_tag_evaluate,
			-foreground => $color_evaluate);
    $text->tagConfigure($macro_tag_lookup,
			-foreground => $color_lookup);
    $text->tagConfigure($macro_tag_error,
			-foreground => $color_error);

    ##########################
    # evaluate format string #
    ##########################
    @text_components = @{$self->evaluate_macro($self->{session}->{gui}->{variables}->{format}, $macro_flags)};
    
    ####################
    # fill text widget #
    ####################
    foreach $text_component (@text_components) {	
	if ($#$text_component >= 1) {
	    $text_component_text = $text_component->[0];
	    $text_component_tag  = $text_component->[1];
	    
	    #print text
	    $self->{gui}->{variables}->{text_text}->insert('end', $text_component_text, $text_component_tag);
	}
    }

    ###############
    # adjust view #
    ###############
    $text->xviewMoveto($x_scroll[0]);
    $text->yviewMoveto($y_scroll[0]);
}

######################
# variables_edit_cmd #
######################
sub variables_edit_cmd {
    my $text_widget = shift @_;
    my $self        = shift @_;
    my $answer;
    my $format_string;
    my $var_bytes;
    my $var_type;
    my $var_expr;
    my $value;
    my $error;
    my $i;   
    #printf STDERR "$self\n";
    
    #update format string
    $self->{gui}->{variables}->{edit_dialog_text}->delete('0.0', 'end');
    $self->{gui}->{variables}->{edit_dialog_text}->insert('end', $self->{session}->{gui}->{variables}->{format});
    
    #open dialog
    $answer = $self->{gui}->{variables}->{edit_dialog}->Show();
    
    if ($answer eq "Ok") {
	#save format string
	$format_string = $self->{gui}->{variables}->{edit_dialog_text}->get('0.0', 'end - 1 chars');
	$self->{session}->{gui}->{variables}->{format} = $format_string;
	    
	#update variables text
	$self->update_variables_text();	    
    }
}


#####################
# variables_set_cmd #
#####################
sub variables_set_cmd {
    my $self     = shift @_;
    my $address;
    my $data;
    my $bytes;
    my $mask;
    #temporary
    my $i;

    #printf "address: \"%s\"\n", $self->{session}->{gui}->{variables}->{addr_string};
    #printf "data:    \"%s\"\n", $self->{session}->{gui}->{variables}->{data_string};
    #printf "width:   \"%s\"\n", $self->{session}->{gui}->{variables}->{width_string};
   
    #######################
    # check address entry #
    #######################
    $address = $self->evaluate_expression($self->{session}->{gui}->{variables}->{addr_string},
					  0xffff,
					  1);
    if (defined $address) {
	#######################
	# check address entry #
	#######################
	$data = $self->evaluate_expression($self->{session}->{gui}->{variables}->{data_string},
					   undef,
					   1);
	if (defined $data) {
	    #####################
	    # check width entry #
	    #####################
	    $bytes = $self->evaluate_expression($self->{session}->{gui}->{variables}->{width_string},
						undef,
						1);
	    if (defined $bytes) {
		#############
		# mask data #
		#############
		$mask = ((256 ** $bytes) - 1);
		$data = $data & $mask;

		##############
		# write data #
		##############
		if (defined $self->{pod}) {
		  $self->{pod}->write_mem($address, $bytes, $data);	
		}
	    }
	}
    }
}

#########################
# auto_select_variables #
#########################
sub auto_select_variables {
    my $self      = shift @_;
    my %var_hash; 
    my $var_symb  = 0; 
    my $var_addr  = 0; 
    my $var_width = 0; 
    my $format_string; 

    #quit if a format has already been defined
    if (defined $self->{session}->{gui}->{variables}->{format}) {
	if ($self->{session}->{gui}->{variables}->{format} ne "") {
	    return 1;
	}
    } 
    
    #read compiler symbols
    while (($var_symb, $var_addr) = each %{$self->{code}->{comp_symbols}}) {
	if (! exists $self->{code}->{lin_addrspace}->{$var_addr}) {
	    if (! exists $var_hash{$var_addr}) {
		$var_hash{$var_addr} = $var_symb;
	    }
	}
    }

    #setup format string and variables hash
    $format_string = "Variables:\n==========\n";
    foreach $var_addr (sort {$a <=> $b} keys %var_hash) {
	$var_symb = $var_hash{$var_addr};
	
	#guess with of the variable
	if (exists $var_hash{$var_addr + 1}) {
	    #next byte is a new symbol
	    $var_width = 1;
	    #} elsif ($var_addr & 1) {
	    #    #odd address
	    #    $var_width = 1;
	} else {
	    #even address
	    $var_width = 2;
	}
	
	if ($var_width == 1) {
	    #byte
	    $format_string .= sprintf("%-15s   ([e %-15s 1h])   [l %-15s 1h]\n", ($var_symb,
										  $var_symb,
										  $var_symb));

	} else {
	    #word
	    $format_string .= sprintf("%-15s ([e %-15s 2h]) [l %-15s 2h]\n", ($var_symb,
									       $var_symb,
									       $var_symb));

	}
    }
    #set format string
    $self->{session}->{gui}->{variables}->{format} = $format_string;
    #print $format_string;
    return 1;
}

###########################
# create_registers_window #
###########################
sub create_registers_window {
    my $self     = shift @_;

    if ($self->{session}->{gui}->{registers}->{state} !~ /^closed$/) {
	if (Tk::Exists($self->{gui}->{registers}->{toplevel})) {
	    ###########################
	    # redraw registers window #
	    ###########################
	    
	} else {
	    ########################### 
	    # create registers window #
	    ###########################
	    #toplevel
	    $self->{gui}->{registers}->{toplevel} = $self->{gui}->{main}->Toplevel;
	    $self->{gui}->{registers}->{toplevel}->gridColumnconfigure( 0, -weight => 0);
	    $self->{gui}->{registers}->{toplevel}->gridColumnconfigure( 1, -weight => 1);
	    $self->{gui}->{registers}->{toplevel}->gridColumnconfigure( 2, -weight => 1);
	    $self->{gui}->{registers}->{toplevel}->gridColumnconfigure( 3, -weight => 0);
	    $self->{gui}->{registers}->{toplevel}->gridRowconfigure(    0, -weight => 1);
	    $self->{gui}->{registers}->{toplevel}->gridRowconfigure(    1, -weight => 1);
	    $self->{gui}->{registers}->{toplevel}->gridRowconfigure(    2, -weight => 1);
	    $self->{gui}->{registers}->{toplevel}->gridRowconfigure(    3, -weight => 1);
	    $self->{gui}->{registers}->{toplevel}->gridRowconfigure(    4, -weight => 1);
	    $self->{gui}->{registers}->{toplevel}->gridRowconfigure(    5, -weight => 1);
	    $self->{gui}->{registers}->{toplevel}->gridRowconfigure(    6, -weight => 1);
	    $self->{gui}->{registers}->{toplevel}->gridRowconfigure(    7, -weight => 1);
	    
	    #accu A
	    $self->{gui}->{registers}->{a_label} = $self->{gui}->{registers}->{toplevel}->Label(-text    => "A:",
												-justify => 'right');
	    $self->{gui}->{registers}->{a_read_label} = $self->{gui}->{registers}->{toplevel}->Label(-width    => 8,
												     -relief   => 'ridge',
												     -justify  => 'right');
	    $self->{gui}->{registers}->{a_write_entry} = $self->{gui}->{registers}->{toplevel}->Entry(-width   => 8,
												      -justify => 'right');
	    $self->{gui}->{registers}->{a_set_button} = $self->{gui}->{registers}->{toplevel}->Button(-text    => "Set",
												      -command => [\&registers_set_a_cmd, $self]);
	    $self->{gui}->{registers}->{a_label}->grid(       -column => 0, -row => 0, -sticky => 'nse'); 
	    $self->{gui}->{registers}->{a_read_label}->grid(  -column => 1, -row => 0, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{a_write_entry}->grid( -column => 2, -row => 0, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{a_set_button}->grid(  -column => 3, -row => 0, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{a_write_entry}->bind('<Key-Return>', [sub {$self->registers_set_a_cmd()}]);

	    #accu B
	    $self->{gui}->{registers}->{b_label} = $self->{gui}->{registers}->{toplevel}->Label(-text    => "B:",
												-justify => 'right');
	    $self->{gui}->{registers}->{b_read_label} = $self->{gui}->{registers}->{toplevel}->Label(-width    => 8,
												     -relief   => 'ridge',
												     -justify  => 'right');
	    $self->{gui}->{registers}->{b_write_entry} = $self->{gui}->{registers}->{toplevel}->Entry(-width   => 8,
												      -justify => 'right');
	    $self->{gui}->{registers}->{b_set_button} = $self->{gui}->{registers}->{toplevel}->Button(-text    => "Set",
												      -command => [\&registers_set_b_cmd, $self]);
	    $self->{gui}->{registers}->{b_label}->grid(       -column => 0, -row => 1, -sticky => 'nse'); 
	    $self->{gui}->{registers}->{b_read_label}->grid(  -column => 1, -row => 1, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{b_write_entry}->grid( -column => 2, -row => 1, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{b_set_button}->grid(  -column => 3, -row => 1, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{b_write_entry}->bind('<Key-Return>', [sub {$self->registers_set_b_cmd()}]);
	    
	    #index X
	    $self->{gui}->{registers}->{x_label} = $self->{gui}->{registers}->{toplevel}->Label(-text    => "X:",
												-justify => 'right');
	    $self->{gui}->{registers}->{x_read_label} = $self->{gui}->{registers}->{toplevel}->Label(-width    => 8,
												     -relief   => 'ridge',
												     -justify  => 'right');
	    $self->{gui}->{registers}->{x_write_entry} = $self->{gui}->{registers}->{toplevel}->Entry(-width   => 8,
												      -justify => 'right');
	    $self->{gui}->{registers}->{x_set_button} = $self->{gui}->{registers}->{toplevel}->Button(-text    => "Set",
												      -command => [\&registers_set_x_cmd, $self]);
	    $self->{gui}->{registers}->{x_label}->grid(       -column => 0, -row => 2, -sticky => 'nse'); 
	    $self->{gui}->{registers}->{x_read_label}->grid(  -column => 1, -row => 2, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{x_write_entry}->grid( -column => 2, -row => 2, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{x_set_button}->grid(  -column => 3, -row => 2, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{x_write_entry}->bind('<Key-Return>', [sub {$self->registers_set_x_cmd()}]);
	    
	    #index Y
	    $self->{gui}->{registers}->{y_label} = $self->{gui}->{registers}->{toplevel}->Label(-text    => "Y:",
												-justify => 'right');
	    $self->{gui}->{registers}->{y_read_label} = $self->{gui}->{registers}->{toplevel}->Label(-width    => 8,
												     -relief   => 'ridge',
												     -justify  => 'right');
	    $self->{gui}->{registers}->{y_write_entry} = $self->{gui}->{registers}->{toplevel}->Entry(-width   => 8,
												      -justify => 'right');
	    $self->{gui}->{registers}->{y_set_button} = $self->{gui}->{registers}->{toplevel}->Button(-text    => "Set",
												      -command => [\&registers_set_y_cmd, $self]);
	    $self->{gui}->{registers}->{y_label}->grid(       -column => 0, -row => 3, -sticky => 'nse'); 
	    $self->{gui}->{registers}->{y_read_label}->grid(  -column => 1, -row => 3, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{y_write_entry}->grid( -column => 2, -row => 3, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{y_set_button}->grid(  -column => 3, -row => 3, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{y_write_entry}->bind('<Key-Return>', [sub {$self->registers_set_y_cmd()}]);
	    
	    #stack pointer SP
	    $self->{gui}->{registers}->{sp_label} = $self->{gui}->{registers}->{toplevel}->Label(-text    => "SP:",
												 -justify => 'right');
	    $self->{gui}->{registers}->{sp_read_label} = $self->{gui}->{registers}->{toplevel}->Label(-width    => 8,
												      -relief   => 'ridge',
												      -justify  => 'right');
	    $self->{gui}->{registers}->{sp_write_entry} = $self->{gui}->{registers}->{toplevel}->Entry(-width   => 8,
												       -justify => 'right');
	    $self->{gui}->{registers}->{sp_set_button} = $self->{gui}->{registers}->{toplevel}->Button(-text    => "Set",
												       -command => [\&registers_set_sp_cmd, $self]);
	    $self->{gui}->{registers}->{sp_label}->grid(       -column => 0, -row => 4, -sticky => 'nse'); 
	    $self->{gui}->{registers}->{sp_read_label}->grid(  -column => 1, -row => 4, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{sp_write_entry}->grid( -column => 2, -row => 4, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{sp_set_button}->grid(  -column => 3, -row => 4, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{sp_write_entry}->bind('<Key-Return>', [sub {$self->registers_set_sp_cmd()}]);
	    
	    #program counter PC
	    $self->{gui}->{registers}->{pc_label} = $self->{gui}->{registers}->{toplevel}->Label(-text    => "PC:",
												 -justify => 'right');
	    $self->{gui}->{registers}->{pc_read_label} = $self->{gui}->{registers}->{toplevel}->Label(-width    => 8,
												      -relief   => 'ridge',
												      -justify  => 'right');
	    $self->{gui}->{registers}->{pc_write_entry} = $self->{gui}->{registers}->{toplevel}->Entry(-width   => 8,
												       -justify => 'right');
	    $self->{gui}->{registers}->{pc_set_button} = $self->{gui}->{registers}->{toplevel}->Button(-text    => "Set",
												       -command => [\&registers_set_pc_cmd, $self]);
	    $self->{gui}->{registers}->{pc_label}->grid(       -column => 0, -row => 5, -sticky => 'nse'); 
	    $self->{gui}->{registers}->{pc_read_label}->grid(  -column => 1, -row => 5, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{pc_write_entry}->grid( -column => 2, -row => 5, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{pc_set_button}->grid(  -column => 3, -row => 5, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{pc_write_entry}->bind('<Key-Return>', [sub {$self->registers_set_pc_cmd()}]);
	    
	    #PPAGE register
	    $self->{gui}->{registers}->{ppage_label_frame} = $self->{gui}->{registers}->{toplevel}->Frame();
	    $self->{gui}->{registers}->{ppage_left_label}  = $self->{gui}->{registers}->{ppage_label_frame}->Label(-text    => "PPAGE:",
	    												       -justify => 'right',
	    												       -width   => 7)->pack(-side   => 'right',
	    															    -fill   => 'both',
	    															    -expand => 1);
	    $self->{gui}->{registers}->{ppage_read_label}  = $self->{gui}->{registers}->{toplevel}->Label(-width    => 8,
													  -relief   => 'ridge',
													  -justify  => 'right');
	    
	    $self->{gui}->{registers}->{ppage_write_entry} = $self->{gui}->{registers}->{toplevel}->Entry(-width    => 8,
													  -justify  => 'right');
	    $self->{gui}->{registers}->{ppage_set_button}  = $self->{gui}->{registers}->{toplevel}->Button(-text    => "Set",
													   -command => [\&registers_set_ppage_cmd, $self]);
	    $self->{gui}->{registers}->{ppage_label_frame}->grid( -column => 0, -row => 6, -sticky => 'nse'); 
	    $self->{gui}->{registers}->{ppage_read_label}->grid(  -column => 1, -row => 6, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{ppage_write_entry}->grid( -column => 2, -row => 6, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{ppage_set_button}->grid(  -column => 3, -row => 6, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{ppage_write_entry}->bind('<Key-Return>', [sub {$self->registers_set_ppage_cmd()}]);
	    
	    #condition code register CCR
	    $self->{gui}->{registers}->{ccr_label} = $self->{gui}->{registers}->{toplevel}->Label(-text    => "CCR:",
												  -justify => 'right');
	    $self->{gui}->{registers}->{ccr_read_label} = $self->{gui}->{registers}->{toplevel}->Label(-width        => 8,
												       -relief       => 'ridge',
												       -justify      => 'right');
	    
	    $self->{gui}->{registers}->{ccr_write_frame} =  $self->{gui}->{registers}->{toplevel}->Frame();
	    $self->{gui}->{registers}->{ccr_s_write_cbutton} = $self->{gui}->{registers}->{ccr_write_frame}->Checkbutton(-text        => "S",
															 -onvalue     => 1,
															 -offvalue    => 0,
															 -indicatoron => 0,
															 -selectcolor => $self->{session}->{colors}->{dark_red},
															 -width       => 1)->pack(-side   => 'left',
																		  -fill   => 'both',
																		  -expand => 1);
	    $self->{gui}->{registers}->{ccr_x_write_cbutton} = $self->{gui}->{registers}->{ccr_write_frame}->Checkbutton(-text        => "X",
															 -onvalue     => 1,
															 -offvalue    => 0,
															 -indicatoron => 0,
															 -selectcolor => $self->{session}->{colors}->{dark_red},
															 -width       => 1)->pack(-side   => 'left',
																		  -fill   => 'both',
																		  -expand => 1);
	    $self->{gui}->{registers}->{ccr_h_write_cbutton} = $self->{gui}->{registers}->{ccr_write_frame}->Checkbutton(-text        => "H",
															 -onvalue     => 1,
															 -offvalue    => 0,
															 -indicatoron => 0,
															 -selectcolor => $self->{session}->{colors}->{dark_red},
															 -width       => 1)->pack(-side   => 'left',
																		  -fill   => 'both',
																		  -expand => 1);
	    $self->{gui}->{registers}->{ccr_i_write_cbutton} = $self->{gui}->{registers}->{ccr_write_frame}->Checkbutton(-text        => "I",
															 -onvalue     => 1,
															 -offvalue    => 0,
															 -indicatoron => 0,
															 -selectcolor => $self->{session}->{colors}->{dark_red},
															 -width       => 1)->pack(-side   => 'left',
																		  -fill   => 'both',
																		  -expand => 1);
	    $self->{gui}->{registers}->{ccr_n_write_cbutton} = $self->{gui}->{registers}->{ccr_write_frame}->Checkbutton(-text        => "N",
															 -onvalue     => 1,
															 -offvalue    => 0,
															 -indicatoron => 0,
															 -selectcolor => $self->{session}->{colors}->{dark_red},
															 -width       => 1)->pack(-side   => 'left',
																		  -fill   => 'both',
																		  -expand => 1);
	    $self->{gui}->{registers}->{ccr_z_write_cbutton} = $self->{gui}->{registers}->{ccr_write_frame}->Checkbutton(-text        => "Z",
															 -onvalue     => 1,
															 -offvalue    => 0,
															 -indicatoron => 0,
															 -selectcolor => $self->{session}->{colors}->{dark_red},
															 -width       => 1)->pack(-side   => 'left',
																		  -fill   => 'both',
																		  -expand => 1);
	    $self->{gui}->{registers}->{ccr_v_write_cbutton} = $self->{gui}->{registers}->{ccr_write_frame}->Checkbutton(-text        => "V",
															 -onvalue     => 1,
															 -offvalue    => 0,
															 -indicatoron => 0,
															 -selectcolor => $self->{session}->{colors}->{dark_red},
															 -width       => 1)->pack(-side   => 'left',
																		  -fill   => 'both',
																		  -expand => 1);
	    $self->{gui}->{registers}->{ccr_c_write_cbutton} = $self->{gui}->{registers}->{ccr_write_frame}->Checkbutton(-text        => "C",
															 -onvalue     => 1,
															 -offvalue    => 0,
															 -indicatoron => 0,
															 -selectcolor => $self->{session}->{colors}->{dark_red},
															 -width       => 1)->pack(-side   => 'left',
																		  -fill   => 'both',
																		  -expand => 1);
	    $self->{gui}->{registers}->{ccr_set_button} = $self->{gui}->{registers}->{toplevel}->Button(-text    => "Set",
													-command => [\&registers_set_ccr_cmd, $self]);
	    $self->{gui}->{registers}->{ccr_label}->grid(       -column => 0, -row => 7, -sticky => 'nse'); 
	    $self->{gui}->{registers}->{ccr_read_label}->grid(  -column => 1, -row => 7, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{ccr_write_frame}->grid( -column => 2, -row => 7, -sticky => 'nsew'); 
	    $self->{gui}->{registers}->{ccr_set_button}->grid(  -column => 3, -row => 7, -sticky => 'nsew'); 
	    
	}

	################
	# set geometry #
	################
	$self->{gui}->{registers}->{toplevel}->geometry($self->{session}->{gui}->{registers}->{geometry});
	if ($self->{session}->{gui}->{registers}->{state} =~ /^iconic$/) {
	    $self->{gui}->{main}->iconify();
	}

	####################
	# connect callback #
	####################
	$self->{gui}->{registers}->{toplevel}->bind('<Configure>', 
						    [\&geometry_callback, $self, "registers"]);
	
	##################
	# close callback #
	##################
	$self->{gui}->{registers}->{toplevel}->OnDestroy([\&registers_destroy_callback, $self]);

	###########################
	# update registers window #
	###########################
	$self->update_registers_window();

    } elsif (Tk::Exists($self->{gui}->{registers}->{toplevel})) {
	##########################
	# close registers window #
	##########################
	$self->{gui}->{registers}->{toplevel}->destroy();
    }
}

###########################
# update_registers_window #
###########################
sub update_registers_window {
    my $self     = shift @_;

    #source file
    my $file_short;

    if ($self->{session}->{gui}->{registers}->{state} !~ /^closed$/) {
	
	#############
	# set title #
	#############
	if ($self->{session}->{source_file} =~ /^\s*$/) {
	    $self->{gui}->{registers}->{toplevel}->title("HSW12 - Registers");
	} else {
	    $file_short = $self->{session}->{source_file};
	    $file_short =~ s/^.*\///;
	    $self->{gui}->{registers}->{toplevel}->title(sprintf("HSW12 - Registers (%s)", $file_short));
	}  
	
	#####################
	# configure widgets #
	#####################
	#accu A
	$self->{gui}->{registers}->{a_read_label}->configure(#-background          => $self->{session}->{colors}->{white},
							     #-highlightbackground => $self->{session}->{colors}->{white},
							     -textvariable        => \$self->{session}->{gui}->{registers}->{a_read_string});
	$self->{gui}->{registers}->{a_write_entry}->configure(#-background          => $self->{session}->{colors}->{white},
							      #-highlightbackground => $self->{session}->{colors}->{white},
							      -textvariable        => \$self->{session}->{gui}->{registers}->{a_write_string});
	#accu B
	$self->{gui}->{registers}->{b_read_label}->configure(#-background          => $self->{session}->{colors}->{white},
							     #-highlightbackground => $self->{session}->{colors}->{white},
							     -textvariable        => \$self->{session}->{gui}->{registers}->{b_read_string});
	$self->{gui}->{registers}->{b_write_entry}->configure(#-background          => $self->{session}->{colors}->{white},
							      #-highlightbackground => $self->{session}->{colors}->{white},
							      -textvariable        => \$self->{session}->{gui}->{registers}->{b_write_string});
	#index X
	$self->{gui}->{registers}->{x_read_label}->configure(#-background         => $self->{session}->{colors}->{white},
							     #-highlightbackground => $self->{session}->{colors}->{white},
							     -textvariable       => \$self->{session}->{gui}->{registers}->{x_read_string});
	$self->{gui}->{registers}->{x_write_entry}->configure(#-background          => $self->{session}->{colors}->{white},
							      #-highlightbackground => $self->{session}->{colors}->{white},
							      -textvariable        => \$self->{session}->{gui}->{registers}->{x_write_string});
	#index Y
	$self->{gui}->{registers}->{y_read_label}->configure(#-textvariable       => \$self->{session}->{gui}->{registers}->{x_read_string},
							     #-background         => $self->{session}->{colors}->{white},
							     -textvariable       => \$self->{session}->{gui}->{registers}->{y_read_string});
	$self->{gui}->{registers}->{y_write_entry}->configure(#-textvariable       => \$self->{session}->{gui}->{registers}->{x_read_string},
							      #-background         => $self->{session}->{colors}->{white},
							      -textvariable      => \$self->{session}->{gui}->{registers}->{y_write_string});
        #stack pointer SP
	$self->{gui}->{registers}->{sp_read_label}->configure(#-textvariable       => \$self->{session}->{gui}->{registers}->{x_read_string},
							      #-background         => $self->{session}->{colors}->{white},
							      -textvariable      => \$self->{session}->{gui}->{registers}->{sp_read_string},);
	$self->{gui}->{registers}->{sp_write_entry}->configure(#-textvariable       => \$self->{session}->{gui}->{registers}->{x_read_string},
							       #-background         => $self->{session}->{colors}->{white},
							       -textvariable     => \$self->{session}->{gui}->{registers}->{sp_write_string});
	#program counter PC
	$self->{gui}->{registers}->{pc_read_label}->configure(#-textvariable       => \$self->{session}->{gui}->{registers}->{x_read_string},
							      #-background         => $self->{session}->{colors}->{white},
							      -textvariable      => \$self->{session}->{gui}->{registers}->{pc_read_string});
	$self->{gui}->{registers}->{pc_write_entry}->configure(#-textvariable       => \$self->{session}->{gui}->{registers}->{x_read_string},
							       #-background         => $self->{session}->{colors}->{white},
							       -textvariable     => \$self->{session}->{gui}->{registers}->{pc_write_string});
	#PPAGE register
	$self->{gui}->{registers}->{ppage_read_label}->configure(#-textvariable       => \$self->{session}->{gui}->{registers}->{x_read_string},
								 #-background         => $self->{session}->{colors}->{white},
								 -textvariable   => \$self->{session}->{gui}->{registers}->{ppage_read_string});
	$self->{gui}->{registers}->{ppage_write_entry}->configure(#-textvariable       => \$self->{session}->{gui}->{registers}->{x_read_string},
								  #-background         => $self->{session}->{colors}->{white},
								  -textvariable  => \$self->{session}->{gui}->{registers}->{ppage_write_string});
	#condition code register CCR
	$self->{gui}->{registers}->{ccr_read_label}->configure(-textvariable     => \$self->{session}->{gui}->{registers}->{ccr_read_string});
	$self->{gui}->{registers}->{ccr_s_write_cbutton}->configure(-variable    => \$self->{session}->{gui}->{registers}->{ccr_s_write_value});
	$self->{gui}->{registers}->{ccr_x_write_cbutton}->configure(-variable    => \$self->{session}->{gui}->{registers}->{ccr_x_write_value});
	$self->{gui}->{registers}->{ccr_h_write_cbutton}->configure(-variable    => \$self->{session}->{gui}->{registers}->{ccr_h_write_value});
	$self->{gui}->{registers}->{ccr_i_write_cbutton}->configure(-variable    => \$self->{session}->{gui}->{registers}->{ccr_i_write_value});
	$self->{gui}->{registers}->{ccr_n_write_cbutton}->configure(-variable    => \$self->{session}->{gui}->{registers}->{ccr_n_write_value});
	$self->{gui}->{registers}->{ccr_z_write_cbutton}->configure(-variable    => \$self->{session}->{gui}->{registers}->{ccr_z_write_value});
	$self->{gui}->{registers}->{ccr_v_write_cbutton}->configure(-variable    => \$self->{session}->{gui}->{registers}->{ccr_v_write_value});
	$self->{gui}->{registers}->{ccr_c_write_cbutton}->configure(-variable    => \$self->{session}->{gui}->{registers}->{ccr_c_write_value});
    
	##########################
	# update register values #
	##########################
	$self->update_register_values(0);	    

	#############
	# lock size #
	#############
	#if ($self->{session}->{gui}->{main}->{connect}) {
	#    $self->{gui}->{variables}->{toplevel}->resizable(0, 0);
	#} else {
	#    $self->{gui}->{variables}->{toplevel}->resizable(1, 1);
	#}
      }
}

##############################
# registers_destroy_callback #
##############################
sub registers_destroy_callback {
    my $self     = shift @_;
    
    if ($self->{session}->{gui}->{registers}->{state} !~ /^closed$/) {
	$self->{session}->{gui}->{registers}->{geometry} = $self->{gui}->{registers}->{toplevel}->geometry();
    }
    $self->{session}->{gui}->{registers}->{state} = 'closed';
}

#######################
# registers_set_a_cmd #
#######################
sub registers_set_a_cmd {
    my $self  = shift @_;
    my $value = $self->evaluate_expression($self->{session}->{gui}->{registers}->{a_write_string},
					   0xff,
					   1);
    
    if (defined $self->{pod}) {
      $self->{pod}->write_reg('a', $value);
    }
}

#######################
# registers_set_b_cmd #
#######################
sub registers_set_b_cmd {
    my $self  = shift @_;
    my $value = $self->evaluate_expression($self->{session}->{gui}->{registers}->{b_write_string},
					   0xff,
					   1);
    if (defined $self->{pod}) {
      $self->{pod}->write_reg('b', $value);
    }
}

#######################
# registers_set_x_cmd #
#######################
sub registers_set_x_cmd {
    my $self  = shift @_;
    my $value = $self->evaluate_expression($self->{session}->{gui}->{registers}->{x_write_string},
					   0xffff,
					   1);
    if (defined $self->{pod}) {
      $self->{pod}->write_reg('x', $value);
    }
}

#######################
# registers_set_y_cmd #
#######################
sub registers_set_y_cmd {
    my $self  = shift @_;
    my $value = $self->evaluate_expression($self->{session}->{gui}->{registers}->{y_write_string},
					   0xffff,
					   1);
    if (defined $self->{pod}) {
      $self->{pod}->write_reg('y', $value);
    }
}

########################
# registers_set_sp_cmd #
########################
sub registers_set_sp_cmd {
    my $self  = shift @_;
    my $value = $self->evaluate_expression($self->{session}->{gui}->{registers}->{sp_write_string},
					   0xffff,
					   1);
    if (defined $self->{pod}) {
      $self->{pod}->write_reg('sp', $value);
    }
}

########################
# registers_set_pc_cmd #
########################
sub registers_set_pc_cmd {
    my $self  = shift @_;
    my $value = $self->evaluate_expression($self->{session}->{gui}->{registers}->{pc_write_string},
					   0xffff,
					   1);
    if (defined $self->{pod}) {
      $self->{pod}->write_reg('pc', $value);
    }
}

###########################
# registers_set_ppage_cmd #
###########################
sub registers_set_ppage_cmd {
    my $self     = shift @_;
    my $value = $self->evaluate_expression($self->{session}->{gui}->{registers}->{pc_write_string},
					   0xff,
					   1);
    if (defined $self->{pod}) {
      $self->{pod}->write_reg('pp', $value);
    }
}

#########################
# registers_set_ccr_cmd #
#########################
sub registers_set_ccr_cmd {
     my $self     = shift @_;
     my $value;

     $value = (($self->{session}->{gui}->{registers}->{ccr_s_write_value} << 7) |
	       ($self->{session}->{gui}->{registers}->{ccr_x_write_value} << 6) |
	       ($self->{session}->{gui}->{registers}->{ccr_h_write_value} << 5) |
	       ($self->{session}->{gui}->{registers}->{ccr_i_write_value} << 4) |
	       ($self->{session}->{gui}->{registers}->{ccr_n_write_value} << 3) |
	       ($self->{session}->{gui}->{registers}->{ccr_z_write_value} << 2) |
	       ($self->{session}->{gui}->{registers}->{ccr_v_write_value} << 1) |
	       ($self->{session}->{gui}->{registers}->{ccr_c_write_value}));
     
     #printf "ccr: %s %.1x %.1x %.1x %.1x %.1x %.1x %.1x %.1x\n",
     #	($value,
     #	 $self->{session}->{gui}->{registers}->{ccr_s_write_value},
     #	 $self->{session}->{gui}->{registers}->{ccr_x_write_value},
     #	 $self->{session}->{gui}->{registers}->{ccr_h_write_value},
     #	 $self->{session}->{gui}->{registers}->{ccr_i_write_value},
     #	 $self->{session}->{gui}->{registers}->{ccr_n_write_value},
     #	 $self->{session}->{gui}->{registers}->{ccr_z_write_value},
     #	 $self->{session}->{gui}->{registers}->{ccr_v_write_value},
     #	 $self->{session}->{gui}->{registers}->{ccr_c_write_value});
     
     if (defined $self->{pod}) {
       $self->{pod}->write_reg('ccr', $value);
     }
}

##########################
# update_register_values #
##########################
sub update_register_values {
    my $self            = shift @_;
    my $allow_pod_reads = shift @_;
    my $reg_value;
    my $ccr_string;

    if (defined $self->{pod}) {
      #PPAGE
      $reg_value = $self->{pod}->read_reg('pp', $allow_pod_reads);
      if (defined $reg_value) {
      	 $self->{session}->{gui}->{registers}->{ppage_read_string} = sprintf("%.2X", $reg_value);
      	 ####################################
      	 # point out address in source code #
      	 ####################################
      	 $self->source_code_follow_pc_cmd();
      } else {	
      	 $self->{session}->{gui}->{registers}->{ppage_read_string} = "??";
      }

      #PC
      $reg_value = $self->{pod}->read_reg('pc', $allow_pod_reads);
      if (defined $reg_value) {
	$self->{session}->{gui}->{registers}->{pc_read_string} = sprintf("%.4X", $reg_value);
	####################################
	# point out address in source code #
	####################################
	$self->source_code_follow_pc_cmd();
      } else {	
	$self->{session}->{gui}->{registers}->{pc_read_string} = "????";
      }
      
      #SP
      $reg_value = $self->{pod}->read_reg('sp', $allow_pod_reads);
      if (defined $reg_value) {
	$self->{session}->{gui}->{registers}->{sp_read_string} = sprintf("%.4X", $reg_value);
      } else {	
	$self->{session}->{gui}->{registers}->{sp_read_string} = "????";
      }
      
      #X
      $reg_value = $self->{pod}->read_reg('x', $allow_pod_reads);
      if (defined $reg_value) {
	$self->{session}->{gui}->{registers}->{x_read_string} = sprintf("%.4X", $reg_value);
      } else {	
	$self->{session}->{gui}->{registers}->{x_read_string} = "????";
      }
      
      #Y
      $reg_value = $self->{pod}->read_reg('y', $allow_pod_reads);
      if (defined $reg_value) {
	$self->{session}->{gui}->{registers}->{y_read_string} = sprintf("%.4X", $reg_value);
      } else {	
	$self->{session}->{gui}->{registers}->{y_read_string} = "????";
      }
      
      #A
      $reg_value = $self->{pod}->read_reg('a', $allow_pod_reads);
      if (defined $reg_value) {
	$self->{session}->{gui}->{registers}->{a_read_string} = sprintf("%.2X", $reg_value);
      } else {	
	$self->{session}->{gui}->{registers}->{a_read_string} = "??";
      }
      
      #B
      $reg_value = $self->{pod}->read_reg('b', $allow_pod_reads);
      if (defined $reg_value) {
	$self->{session}->{gui}->{registers}->{b_read_string} = sprintf("%.2X", $reg_value);
      } else {	
	$self->{session}->{gui}->{registers}->{b_read_string} = "??";
      }
      
      #CCR
      $reg_value = $self->{pod}->read_reg('ccr', $allow_pod_reads);
      if (defined $reg_value) {
	$ccr_string = "";
	#S bit
	if ($reg_value & 0x80) {
	  $ccr_string .= "S";
	  $self->{session}->{gui}->{registers}->{ccr_s_write_value} = 1;
	} else {
	  $ccr_string .= ".";
	  $self->{session}->{gui}->{registers}->{ccr_s_write_value} = 0;
	}
	#X bit
	if ($reg_value & 0x40) {
	  $ccr_string .= "X";
	  $self->{session}->{gui}->{registers}->{ccr_x_write_value} = 1;
	} else {
	  $ccr_string .= ".";
	  $self->{session}->{gui}->{registers}->{ccr_x_write_value} = 0;
	}
	#H bit
	if ($reg_value & 0x20) {
	  $ccr_string .= "H";
	  $self->{session}->{gui}->{registers}->{ccr_h_write_value} = 1;
	} else {
	  $ccr_string .= ".";
	  $self->{session}->{gui}->{registers}->{ccr_h_write_value} = 0;
	}
	#I bit
	if ($reg_value & 0x10) {
	  $ccr_string .= "I";
	  $self->{session}->{gui}->{registers}->{ccr_i_write_value} = 1;
	} else {
	  $ccr_string .= ".";
	  $self->{session}->{gui}->{registers}->{ccr_i_write_value} = 0;
	}
	#N bit
	if ($reg_value & 0x08) {
	  $ccr_string .= "N";
	  $self->{session}->{gui}->{registers}->{ccr_n_write_value} = 1;
	} else {
	  $ccr_string .= ".";
	  $self->{session}->{gui}->{registers}->{ccr_n_write_value} = 0;
	}
	#Z bit
	if ($reg_value & 0x04) {
	  $ccr_string .= "Z";
	  $self->{session}->{gui}->{registers}->{ccr_z_write_value} = 1;
	} else {
	  $ccr_string .= ".";
	  $self->{session}->{gui}->{registers}->{ccr_z_write_value} = 0;
	}
	#V bit
	if ($reg_value & 0x02) {
	  $ccr_string .= "V";
	  $self->{session}->{gui}->{registers}->{ccr_v_write_value} = 1;
	} else {
	  $ccr_string .= ".";
	  $self->{session}->{gui}->{registers}->{ccr_v_write_value} = 0;
	}
	#C bit
	if ($reg_value & 0x01) {
	  $ccr_string .= "C";
	  $self->{session}->{gui}->{registers}->{ccr_c_write_value} = 1;
	} else {
	  $ccr_string .= ".";
	  $self->{session}->{gui}->{registers}->{ccr_c_write_value} = 0;
	}
	
	$self->{session}->{gui}->{registers}->{ccr_read_string} = $ccr_string;
	
      } else {	
	$self->{session}->{gui}->{registers}->{ccr_read_string} = "????????";
      }
    }
}

#########################
# create_control_window #
#########################
sub create_control_window {
    my $self     = shift @_;

    if ($self->{session}->{gui}->{control}->{state} !~ /^closed$/) {
	if (Tk::Exists($self->{gui}->{control}->{toplevel})) {
	    #########################
	    # redraw control window #
	    #########################
	    
	} else {
	    ######################### 
	    # create control window #
	    #########################
	    #toplevel
	    $self->{gui}->{control}->{toplevel} = $self->{gui}->{main}->Toplevel;
	    $self->{gui}->{control}->{toplevel}->gridColumnconfigure( 0, -weight => 1);
	    $self->{gui}->{control}->{toplevel}->gridRowconfigure(    0, -weight => 1); 
	    $self->{gui}->{control}->{toplevel}->gridRowconfigure(    1, -weight => 1);
	    $self->{gui}->{control}->{toplevel}->gridRowconfigure(    2, -weight => 1);
	    
	    #breakpoints
	    $self->{gui}->{control}->{breakpoint_frame} = $self->{gui}->{control}->{toplevel}->Frame(-relief => 'ridge', -border => 2);	
	    $self->{gui}->{control}->{breakpoint_frame}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{control}->{breakpoint_frame}->gridColumnconfigure( 0, -weight => 0);
	    $self->{gui}->{control}->{breakpoint_frame}->gridColumnconfigure( 1, -weight => 1);
	    $self->{gui}->{control}->{breakpoint_frame}->gridColumnconfigure( 2, -weight => 0);
	    $self->{gui}->{control}->{breakpoint_frame}->gridRowconfigure(    0, -weight => 1); 
	    $self->{gui}->{control}->{breakpoint_frame}->gridRowconfigure(    1, -weight => 1); 
	    $self->{gui}->{control}->{breakpoint1_label} = $self->{gui}->{control}->{breakpoint_frame}->Label(-text => "BR1:");
	    $self->{gui}->{control}->{breakpoint1_label}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{control}->{breakpoint1_entry} = $self->{gui}->{control}->{breakpoint_frame}->Entry(-justify => 'right');
	    $self->{gui}->{control}->{breakpoint1_entry}->grid(-column => 1, -row => 0, -sticky => 'nsew');
	    $self->{gui}->{control}->{breakpoint2_label} = $self->{gui}->{control}->{breakpoint_frame}->Label(-text => "BR2:");
	    $self->{gui}->{control}->{breakpoint2_label}->grid(-column => 0, -row => 1, -sticky => 'nsew');
	    $self->{gui}->{control}->{breakpoint2_entry} = $self->{gui}->{control}->{breakpoint_frame}->Entry(-justify => 'right');
	    $self->{gui}->{control}->{breakpoint2_entry}->grid(-column => 1, -row => 1, -sticky => 'nsew');
	    $self->{gui}->{control}->{breakpoint_set_button} = $self->{gui}->{control}->{breakpoint_frame}->Button(-text => "Set",
														   -command => [\&control_set_breakpoints_cmd, $self]);
	    $self->{gui}->{control}->{breakpoint_set_button}->grid(-column => 2, -row => 0, -rowspan => 2, -sticky => 'nsew');
	    $self->{gui}->{control}->{breakpoint1_entry}->bind('<Key-Return>', [sub {$self->control_set_breakpoints_cmd()}]);
	    $self->{gui}->{control}->{breakpoint2_entry}->bind('<Key-Return>', [sub {$self->control_set_breakpoints_cmd()}]);

	    #target
	    $self->{gui}->{control}->{target_frame} = $self->{gui}->{control}->{toplevel}->Frame(-relief => 'ridge', -border => 2);	
	    $self->{gui}->{control}->{target_frame}->grid(-column => 0, -row => 1, -sticky => 'nsew');
	    $self->{gui}->{control}->{target_frame}->gridColumnconfigure( 0, -weight => 1);
	    $self->{gui}->{control}->{target_frame}->gridColumnconfigure( 1, -weight => 1);
	    $self->{gui}->{control}->{target_frame}->gridColumnconfigure( 2, -weight => 1);
	    $self->{gui}->{control}->{target_frame}->gridRowconfigure(    0, -weight => 1); 
	    $self->{gui}->{control}->{target_frame}->gridRowconfigure(    1, -weight => 1);
	    $self->{gui}->{control}->{target_frame}->gridRowconfigure(    2, -weight => 1); 
	    $self->{gui}->{control}->{target_frame}->gridRowconfigure(    3, -weight => 1);
	    #reset
	    $self->{gui}->{control}->{target_reset_button} = $self->{gui}->{control}->{target_frame}->Button(-text    => "Reset",
													     -command => [\&control_reset_cmd, $self]);
	    $self->{gui}->{control}->{target_reset_button}->grid(-column => 0, -row => 0, -columnspan => 3, -sticky => 'nsew');
	    #stop
	    $self->{gui}->{control}->{target_stop_button} = $self->{gui}->{control}->{target_frame}->Button(-text    => "Stop",
													    -command => [\&control_stop_cmd, $self]);
	    $self->{gui}->{control}->{target_stop_button}->grid(-column => 0, -row => 1, -columnspan => 3, -sticky => 'nsew');
	    #go
	    $self->{gui}->{control}->{target_go_button} = $self->{gui}->{control}->{target_frame}->Button(-text    => "Go",
													  -command => [\&control_go_cmd, $self],
													  -width   => 8);
	    $self->{gui}->{control}->{target_go_button}->grid(-column => 0, -row => 2, -sticky => 'nsew');	
	    $self->{gui}->{control}->{target_go_addr_button} = $self->{gui}->{control}->{target_frame}->Button(-text    => "Go addr:",
													       -command => [\&control_go_addr_cmd, $self],
													       -width   => 8);
	    $self->{gui}->{control}->{target_go_addr_button}->grid(-column => 1, -row => 2, -sticky => 'nsew');
	    $self->{gui}->{control}->{target_go_addr_entry} = $self->{gui}->{control}->{target_frame}->Entry(-width => 8);
	    $self->{gui}->{control}->{target_go_addr_entry}->grid(-column => 2, -row => 2, -sticky => 'nsew');
	    #trace
	    $self->{gui}->{control}->{target_trace_button} = $self->{gui}->{control}->{target_frame}->Button(-text    => "Trace",
													     -command => [\&control_trace_cmd, $self],
													     -width   => 8);
	    $self->{gui}->{control}->{target_trace_button}->grid(-column => 0, -row => 3, -sticky => 'nsew');	
	    $self->{gui}->{control}->{target_trace_n_button} = $self->{gui}->{control}->{target_frame}->Button(-text    => "Trace n:",
													       -command => [\&control_trace_n_cmd, $self],
													       -width   => 8);
	    $self->{gui}->{control}->{target_trace_n_button}->grid(-column => 1, -row => 3, -sticky => 'nsew');
	    $self->{gui}->{control}->{target_trace_n_entry} = $self->{gui}->{control}->{target_frame}->Entry(-width => 8);
	    $self->{gui}->{control}->{target_trace_n_entry}->grid(-column => 2, -row => 3, -sticky => 'nsew');
	    $self->{gui}->{control}->{target_trace_n_entry}->bind('<Key-Return>', [sub {$self->control_trace_n_cmd()}]);
	    
	    #update
	    $self->{gui}->{control}->{update_frame} = $self->{gui}->{control}->{toplevel}->Frame(-relief => 'ridge', -border => 2);
	    $self->{gui}->{control}->{update_frame}->grid(-column => 0, -row => 2, -sticky => 'nsew');
	    $self->{gui}->{control}->{update_frame}->gridColumnconfigure( 0, -weight => 1);
	    $self->{gui}->{control}->{update_frame}->gridRowconfigure(    0, -weight => 1); 
	    
	    $self->{gui}->{control}->{update_button} = $self->{gui}->{control}->{update_frame}->Button(-text     => "Update",
												       -command  => [\&control_update_cmd, $self]);
	    $self->{gui}->{control}->{update_button}->grid(-column => 0, -row => 0, -sticky => 'nsew');
	    
	}
	    
	################
	# set geometry #
	################
	$self->{gui}->{control}->{toplevel}->geometry($self->{session}->{gui}->{control}->{geometry});
	if ($self->{session}->{gui}->{control}->{state} =~ /^iconic$/) {
	    $self->{gui}->{main}->iconify();
	}
	
	####################
	# connect callback #
	####################
	$self->{gui}->{control}->{toplevel}->bind('<Configure>', 
						  [\&geometry_callback, $self, "control"]);
	
	##################
	# close callback #
	##################
	$self->{gui}->{control}->{toplevel}->OnDestroy([\&control_destroy_callback, $self]);

	#########################
	# update control window #
	#########################
	$self->update_control_window();

    } elsif (Tk::Exists($self->{gui}->{control}->{toplevel})) {
	########################
	# close control window #
	########################
	$self->{gui}->{control}->{toplevel}->destroy();
    }
}

#########################
# update_control_window #
#########################
sub update_control_window {
    my $self     = shift @_;
    
    #source file
    my $file_short;

    if ($self->{session}->{gui}->{control}->{state} !~ /^closed$/) {

	#############
	# set title #
	#############
	if ($self->{session}->{source_file} =~ /^\s*$/) {
	    $self->{gui}->{control}->{toplevel}->title("HSW12 - Control");
	} else {
	    $file_short = $self->{session}->{source_file};
	    $file_short =~ s/^.*\///;
	    $self->{gui}->{control}->{toplevel}->title(sprintf("HSW12 - Control (%s)", $file_short));
	}  

	#####################
	# configure widgets #
	#####################
	#breakpoint1_entry
	$self->{gui}->{control}->{breakpoint1_entry}->configure(#-background          => $self->{session}->{colors}->{white},
								#-highlightbackground => $self->{session}->{colors}->{white},
								-textvariable        => \$self->{session}->{gui}->{control}->{bkp1});
	#breakpoint2_entry
	$self->{gui}->{control}->{breakpoint2_entry}->configure(#-background          => $self->{session}->{colors}->{white},
								#-highlightbackground => $self->{session}->{colors}->{white},
								-textvariable        => \$self->{session}->{gui}->{control}->{bkp2});
	#target_go_addr_entry
	$self->{gui}->{control}->{target_go_addr_entry}->configure(#-background          => $self->{session}->{colors}->{white},
								   #-highlightbackground => $self->{session}->{colors}->{white},
								   -textvariable        => \$self->{session}->{gui}->{control}->{go_addr});
	#target_trace_n_entry
	$self->{gui}->{control}->{target_trace_n_entry}->configure(#-background          => $self->{session}->{colors}->{white},
								   #-highlightbackground => $self->{session}->{colors}->{white},
								   -textvariable        => \$self->{session}->{gui}->{control}->{trace_steps});
	#############
	# lock size #
	#############
	#if ($self->{session}->{gui}->{main}->{connect}) {
	#    $self->{gui}->{control}->{toplevel}->resizable(0, 0);
	#} else {
	#    $self->{gui}->{control}->{toplevel}->resizable(1, 1);
	#}
    }
}

############################
# control_destroy_callback #
############################
sub control_destroy_callback {
    my $self     = shift @_;
    
    if ($self->{session}->{gui}->{control}->{state} !~ /^closed$/) {
	$self->{session}->{gui}->{control}->{geometry} = $self->{gui}->{control}->{toplevel}->geometry();
    }
    $self->{session}->{gui}->{control}->{state} = 'closed';
}

###############################
# control_set_breakpoints_cmd #
###############################
sub control_set_breakpoints_cmd {
     my $self     = shift @_;
     my $bkp1;
     my $bkp2;
     my $ppage1;
     my $ppage2;
     
    if (defined $self->{pod}) {
      $bkp1   = $self->evaluate_expression($self->{session}->{gui}->{control}->{bkp1},
					   0xffffff,
					   1);
      ($ppage1, $bkp1) = $self->format_address($bkp1);

      $bkp2   = $self->evaluate_expression($self->{session}->{gui}->{control}->{bkp2},
					   0xffffff,
					   1);
      ($ppage2, $bkp2) = $self->format_address($bkp2);
      
      $self->{pod}->set_breakpoints($ppage1, $bkp1, $ppage2, $bkp2);
    }
}

#####################
# control_reset_cmd #
#####################
sub control_reset_cmd {
     my $self     = shift @_;

     if (defined $self->{pod}) {
       $self->{pod}->reset();
     }
}

####################
# control_stop_cmd #
####################
sub control_stop_cmd {
     my $self     = shift @_;

     if (defined $self->{pod}) {
       $self->{pod}->stop();
     }
}     

##################
# control_go_cmd #
##################
sub control_go_cmd {
     my $self     = shift @_;

     if (defined $self->{pod}) {
       $self->{pod}->go();
     }
}

#######################
# control_go_addr_cmd #
#######################
sub control_go_addr_cmd {
     my $self     = shift @_;
     my $addr;
     my $ppage;
     
     if (defined $self->{pod}) {
	 $addr = $self->evaluate_expression($self->{session}->{gui}->{control}->{go_addr}, 
					    0xffffff,
					    1);
	 ($ppage, $addr) = $self->format_address($addr);
       $self->{pod}->go_addr($ppage, $addr);
     }
}

#####################
# control_trace_cmd #
#####################
sub control_trace_cmd {
     my $self     = shift @_;

     if (defined $self->{pod}) {
       $self->{pod}->trace(1);
     }
}

#####################
# control_trace_cmd #
#####################
sub control_trace_n_cmd {
     my $self     = shift @_;
     my $steps;
     
     if (defined $self->{pod}) {
       $steps = $self->evaluate_expression($self->{session}->{gui}->{control}->{trace_steps},
					   undef,
					   1);
       #printf "trace: \"%s\" \"%s\"\n", $self->{session}->{gui}->{control}->{trace_steps}, $steps;
       
       $self->{pod}->trace($steps);
     }
}

######################
# control_update_cmd #
######################
sub control_update_cmd {
  my $self     = shift @_;
    
  if (defined $self->{pod}) {
    ###############
    # clear cache #
    ###############
    $self->{pod}->clear_cache();

    ##########################
    # update variable window #
    ##########################
    $self->update_variables_text(1);	    

    ##########################
    # update register window #
    ##########################
    $self->update_register_values(1);	    
  }
}

###############
# new_session #
###############
sub new_session {
    my $self         = shift @_;

    #temporary toplevel
    my $mw;
    #screen
    my $screen_height;
    my $screen_width;
    #window manager
    my $wm_n_border = 23;
    my $wm_s_border =  6;
    my $wm_w_border =  6;
    my $wm_e_border =  6;
    #relative window size
    my $gui_relative_width = 0.9;
    my $gui_relative_height = 0.8;
    #main
    my $main_x;
    my $main_y;
    my $main_width;
    my $main_height;
    my $main_geometry;
    #terminal
    my $terminal_x;
    my $terminal_y;
    my $terminal_width;
    my $terminal_height;
    my $terminal_geometry;
    #source_code
    my $source_code_x;
    my $source_code_y;
    my $source_code_width;
    my $source_code_height;
    my $source_code_geometry;
    #variables
    my $variables_x;
    my $variables_y;
    my $variables_width;
    my $variables_height;
    my $variables_geometry;
    #registers
    my $registers_x;
    my $registers_y;
    my $registers_width;
    my $registers_height;
    my $registers_geometry;
    #control
    my $control_x;
    my $control_y;
    my $control_width;
    my $control_height;
    my $control_geometry;


    ###################
    # forget ASM code #
    ###################
    $self->{code} = {};

    #######################
    # setup POD interface #
    #######################
    if (defined $self->{pod}) {
      $self->{session}->{preferences}->{io}->{device} =
	$self->{pod}->{set_device($self->{session}->{preferences}->{io}->{device})};
      $self->{session}->{preferences}->{io}->{baud_rate} =
	$self->{pod}->{set_baud_rate($self->{session}->{preferences}->{io}->{baud})};
    }

    ##############
    # set colors #
    ##############
    $self->{session}->{colors}->{black}          = "#000000"; #  0   0   0 (black)
    $self->{session}->{colors}->{white}          = "#ffffff"; #255 255 255 (white)
    $self->{session}->{colors}->{gray}           = "#7f7f7f"; #127 127 127 (gray50)
    $self->{session}->{colors}->{red}            = "#ff0000"; #255   0   0 (red)
    $self->{session}->{colors}->{dark_red}       = "#6b3939"; #107  57  57 (indian red)
    $self->{session}->{colors}->{green}          = "#00ff00"; #  0 255   0 (green)
    $self->{session}->{colors}->{dark_green}     = "#00562d"; #  0  86  45 (dark green)
    $self->{session}->{colors}->{blue}           = "#0000ff"; #  0   0 255 (blue)
    $self->{session}->{colors}->{dark_blue}      = "#232375"; # 35  35 117 (navy blue)
    $self->{session}->{colors}->{yellow}         = "#ffff00"; #255 255   0 (yellow)
    $self->{session}->{colors}->{dark_yellow}    = "#fea445"; #244 164  96 (sandybrown)
    $self->{session}->{colors}->{orange}         = "#ff8700"; #255 135   0 (orange)
    $self->{session}->{colors}->{dark_orange}    = "#ff8c00"; #255 140   0 (dark orange)
    $self->{session}->{colors}->{purple}         = "#a020f0"; #160  32 240 (purple)
    $self->{session}->{colors}->{dark_purple}    = "#9400d3"; #148   0 211 (dark violet)
    $self->{session}->{colors}->{brown}          = "#a52a2a"; #165  42  42 (brown)
    $self->{session}->{colors}->{dark_brown}     = "#8b4513"; #139  69  19 (saddlebrown)
    $self->{session}->{colors}->{turquoise}      = "#19cce9"; # 25 204 223 (turquoise)
    $self->{session}->{colors}->{dark_turquoise} = "#00a6a6"; #  0 166 166 (dark turquoise)
    $self->{session}->{colors}->{background}     = "#5470aa"; # 84 112 170 (steel blue)
    
    ###############################
    # determine window geometries #
    ###############################
    if (Tk::Exists($self->{gui}->{main})) {
	$screen_height = $self->{gui}->{main}->screenheight();
	$screen_width  = $self->{gui}->{main}->screenwidth();
    } else {
	$mw = MainWindow->new();
	$screen_height = $mw->screenheight();
	$screen_width  = $mw->screenwidth();
	$mw->destroy();
    }
    #print "$screen_width x $screen_height\n";

    #main window geometry
    $main_width    = int($screen_width * $gui_relative_width) - ($wm_w_border + $wm_e_border);
    $main_height   = 30;
    $main_x        = int(((1 - $gui_relative_width) * $screen_width) / 2);
    $main_y        = int(((1 - $gui_relative_height) * $screen_height) / 8);
    $main_geometry = sprintf("%dx%d+%d+%d", $main_width, $main_height, $main_x, $main_y);
    #print "main: $main_geometry\n";
    
    #terminal geometry
    $terminal_width    = int(($main_width + $wm_w_border + $wm_e_border) / 3) - ($wm_w_border + $wm_e_border);
    $terminal_height   = int($screen_height * $gui_relative_height) - (2* $wm_n_border + 
								       2* $wm_s_border +
								       $main_height);
    $terminal_x        = $main_x;
    $terminal_y        = $main_y + $main_height + $wm_n_border + $wm_s_border;
    $terminal_geometry = sprintf("%dx%d+%d+%d", $terminal_width, $terminal_height, $terminal_x, $terminal_y);
    #print "terminal: $terminal_geometry\n";
    
    #source code geometry
    $source_code_width    = $terminal_width;
    $source_code_height   = $terminal_height;
    $source_code_x        = $terminal_x + $terminal_width + $wm_w_border + $wm_e_border;
    $source_code_y        = $terminal_y;
    $source_code_geometry = sprintf("%dx%d+%d+%d", $source_code_width, $source_code_height, $source_code_x, $source_code_y);
    #print "source_code: $source_code_geometry\n";
    
    #variables geometry
    $variables_width    = $main_width - ($terminal_width + $source_code_width + 2* $wm_w_border + 2* $wm_e_border);
    $variables_height   = int(($source_code_height + $wm_n_border + $wm_s_border) / 3) - ($wm_n_border + $wm_s_border);
    $variables_x        = $source_code_x + $source_code_width + $wm_w_border + $wm_e_border;
    $variables_y        = $source_code_y;
    $variables_geometry = sprintf("%dx%d+%d+%d", $variables_width, $variables_height, $variables_x, $variables_y);
    #print "variables: $variables_geometry\n";
    
    #registers geometry
    $registers_width    = $variables_width;
    $registers_height   = $variables_height;
    $registers_x        = $variables_x;
    $registers_y        = $variables_y + $variables_height + $wm_n_border + $wm_s_border;
    $registers_geometry = sprintf("%dx%d+%d+%d", $registers_width, $registers_height, $registers_x, $registers_y);
    #print "registers: $registers_geometry\n";
    
    #control geometry
    $control_width    = $registers_width;
    $control_height   = $source_code_height - ($variables_height + $registers_height + 2* $wm_n_border + 2* $wm_s_border);
    $control_x        = $variables_x;
    $control_y        = $registers_y + $registers_height + $wm_n_border + $wm_s_border;
    $control_geometry = sprintf("%dx%d+%d+%d", $control_width, $control_height, $control_x, $control_y);
    #print "control: $control_geometry\n";
    
    ##########################
    # reset session settings #
    ##########################
    #file name
    $self->{session}->{file_name} = "";

    #ASM code
    $self->{session}->{source_file} = "";

    #preferences
    $self->{session}->{preferences}->{io}->{device}              = "";
    $self->{session}->{preferences}->{io}->{baud}                = "9600";
    $self->{session}->{preferences}->{srec}->{format}            = "S28";
    $self->{session}->{preferences}->{srec}->{length}            = 64;
    $self->{session}->{preferences}->{srec}->{s5}                = 0;
    $self->{session}->{preferences}->{srec}->{fill_bytes}        = 1;
    $self->{session}->{preferences}->{ppage}                     = 1;

    #main window settings
    $self->{session}->{gui}->{main}->{geometry}     = $main_geometry;
    $self->{session}->{gui}->{main}->{state}        = 'normal';
    $self->{session}->{gui}->{main}->{connect}      = 1;
    #$self->{session}->{gui}->{main}->{connect}      = 0;
    
    #terminal window settings
    $self->{session}->{gui}->{terminal}->{geometry}           = $terminal_geometry;
    $self->{session}->{gui}->{terminal}->{state}              = 'normal';
    #$self->{session}->{gui}->{terminal}->{content}           = "";
    $self->{session}->{gui}->{terminal}->{input_string}       = "";    
    $self->{session}->{gui}->{terminal}->{macro1}->{name}     = "Macro 1";
    $self->{session}->{gui}->{terminal}->{macro2}->{name}     = "Macro 2";
    $self->{session}->{gui}->{terminal}->{macro3}->{name}     = "Macro 3";
    $self->{session}->{gui}->{terminal}->{macro4}->{name}     = "Macro 4";
    $self->{session}->{gui}->{terminal}->{macro5}->{name}     = "Macro 5";
    $self->{session}->{gui}->{terminal}->{macro6}->{name}     = "Macro 6";
    $self->{session}->{gui}->{terminal}->{macro7}->{name}     = "Macro 7";
    $self->{session}->{gui}->{terminal}->{macro8}->{name}     = "Macro 8";
    $self->{session}->{gui}->{terminal}->{macro1}->{sequence} = "";
    $self->{session}->{gui}->{terminal}->{macro2}->{sequence} = "";
    $self->{session}->{gui}->{terminal}->{macro3}->{sequence} = "";
    $self->{session}->{gui}->{terminal}->{macro4}->{sequence} = "";
    $self->{session}->{gui}->{terminal}->{macro5}->{sequence} = "";
    $self->{session}->{gui}->{terminal}->{macro6}->{sequence} = "";
    $self->{session}->{gui}->{terminal}->{macro7}->{sequence} = "";
    $self->{session}->{gui}->{terminal}->{macro8}->{sequence} = "";

    #source code window settings
    $self->{session}->{gui}->{source_code}->{geometry}        = $source_code_geometry;
    $self->{session}->{gui}->{source_code}->{state}           = 'normal';
    $self->{session}->{gui}->{source_code}->{follow_pc}       = 0;
    $self->{session}->{gui}->{source_code}->{goto_string}     = "";
    $self->{session}->{gui}->{source_code}->{search_string}   = "";
    $self->{session}->{gui}->{source_code}->{scrollpos_x}     = 0;
    $self->{session}->{gui}->{source_code}->{scrollpos_y}     = 0;

    #variables window settings
    $self->{session}->{gui}->{variables}->{geometry}      = $variables_geometry;
    $self->{session}->{gui}->{variables}->{state}         = 'normal';
    $self->{session}->{gui}->{variables}->{format}        = "";
    $self->{session}->{gui}->{variables}->{scrollpos_x}   = 0;
    $self->{session}->{gui}->{variables}->{scrollpos_y}   = 0;
    $self->{session}->{gui}->{variables}->{addr_string}   = "";
    $self->{session}->{gui}->{variables}->{data_string}   = "";
    $self->{session}->{gui}->{variables}->{width_string}  = "";
 
    #register window settings
    $self->{session}->{gui}->{registers}->{geometry}           = $registers_geometry;
    $self->{session}->{gui}->{registers}->{state}              = 'normal';
    $self->{session}->{gui}->{registers}->{a_write_string}     = "";
    $self->{session}->{gui}->{registers}->{b_write_string}     = "";
    $self->{session}->{gui}->{registers}->{x_write_string}     = "";
    $self->{session}->{gui}->{registers}->{y_write_string}     = "";
    $self->{session}->{gui}->{registers}->{sp_write_string}    = "";
    $self->{session}->{gui}->{registers}->{pc_write_string}    = "";
    $self->{session}->{gui}->{registers}->{ppage_write_string} = "";
    $self->{session}->{gui}->{registers}->{ccr_s_write_value}  = 0;
    $self->{session}->{gui}->{registers}->{ccr_x_write_value}  = 0;
    $self->{session}->{gui}->{registers}->{ccr_h_write_value}  = 0;
    $self->{session}->{gui}->{registers}->{ccr_i_write_value}  = 0;
    $self->{session}->{gui}->{registers}->{ccr_n_write_value}  = 0;
    $self->{session}->{gui}->{registers}->{ccr_z_write_value}  = 0;
    $self->{session}->{gui}->{registers}->{ccr_v_write_value}  = 0;
    $self->{session}->{gui}->{registers}->{ccr_c_write_value}  = 0;
    $self->{session}->{gui}->{registers}->{a_read_string}      = "";
    $self->{session}->{gui}->{registers}->{b_read_string}      = "";
    $self->{session}->{gui}->{registers}->{x_read_string}      = "";
    $self->{session}->{gui}->{registers}->{y_read_string}      = "";
    $self->{session}->{gui}->{registers}->{sp_read_string}     = "";
    $self->{session}->{gui}->{registers}->{pc_read_string}     = "";
    $self->{session}->{gui}->{registers}->{ppage_read_string}  = "";
    $self->{session}->{gui}->{registers}->{ccr_read_string}    = "";
    
    #control window settings
    $self->{session}->{gui}->{control}->{geometry}    = $control_geometry;
    $self->{session}->{gui}->{control}->{state}       = 'normal';
    $self->{session}->{gui}->{control}->{ppage1}      = "";
    $self->{session}->{gui}->{control}->{bkp1}        = "";
    $self->{session}->{gui}->{control}->{ppage2}      = "";
    $self->{session}->{gui}->{control}->{bkp2}        = "";
    $self->{session}->{gui}->{control}->{go_addr}     = "";
    $self->{session}->{gui}->{control}->{trace_steps} = 4;
}

################
# save_session #
################
sub save_session {
    my $self         = shift @_;
    my $session_file = shift @_;

    #file
    my $file_handle;
    #dump
    my $dump;

    ##########################
    # save window geometries #
    ##########################
    #$self->save_geometries();

    #############
    # open file #
    #############
    if ($file_handle = IO::File->new($session_file, O_CREAT|O_WRONLY)) {
	#######################
	# delete old contents #
	#######################
	truncate $file_handle, 0;

	################
	# setup dumper #
	################
	$dump = Data::Dumper->new([$self->{session}], ['session']);
	$dump->Indent(2);

	################
	# dump session #
	################
	print $file_handle $dump->Dump;

	##############
	# close file #
	##############
	$file_handle->close();

    } else {
	$self->show_error_message(sprintf("cannot open \"%s\"", $session_file));
    }
}

###################
# restore_session #
###################
sub restore_session {
    my $self         = shift @_;
    my $session_file = shift @_;
    
    #file
    my $file_handle;
    #source code
    my $file_name;
    #data
    my $data;
    #session
    my $session;
    #text window
    my $text;

    #############
    # open file #
    #############
    if ($file_handle = IO::File->new($session_file, O_RDONLY)) {

	##################
	# read dump file #
	##################
	$data = join "", <$file_handle>;

	##############
	# close file #
	##############
	$file_handle->close();

	###################
	# restore session #
	###################
	eval $data;
	if (defined $session) {
	    $self->{session} = $session;

	    #######################
	    # compile source code #
	    #######################
	    $file_name = $self->{session}->{source_file};
	    if ($file_name !~ /^\s*$/) {
		if (Exists $self->{gui}->{source_code}->{text_text}) {
		    #use source code window
		    $self->{code} = hsw12_asm->new([$self->{session}->{source_file}], [sprintf("%s/", dirname($file_name)), "./"], {}, "S12", 0);
		} else {
		    #use STDOUT
		    $self->{code} = hsw12_asm->new([$self->{session}->{source_file}], [sprintf("%s/", dirname($file_name)), "./"], {}, "S12", 0);
		}
	    }

	    #######################
	    # setup POD interface #
	    #######################
	    if (defined $self->{pod}) {
	      $self->{session}->{preferences}->{io}->{device} =
		$self->{pod}->set_device($self->{session}->{preferences}->{io}->{device});
	      $self->{session}->{preferences}->{io}->{baud} =
		$self->{pod}->set_baud_rate($self->{session}->{preferences}->{io}->{baud});
	    }

	} else {
	    $self->show_error_message(sprintf("\"%s\" does not contain a valid HSW12 session", $session_file));
	    return 0;
	}
    } else {
	$self->show_error_message(sprintf("cannot open \"%s\"", $session_file));
	return 0;
    }
    #printf STDERR "Session restored!\n";
    return 1;
}

###################
# save_geometries #
###################
sub save_geometries {
    my $self = shift @_;

    ##########################
    # save window geometries #
    ##########################
    #main
    $self->{session}->{gui}->{main}->{state}    = $self->{gui}->{main}->state();
    if (!$self->{session}->{gui}->{main}->{connect}) {
	$self->{session}->{gui}->{main}->{geometry} = $self->{gui}->{main}->geometry();
    }
    #terminal
    if ($self->{session}->{gui}->{terminal}->{state} !~ /^closed$/) {
	$self->{session}->{gui}->{terminal}->{state}    = $self->{gui}->{terminal}->{toplevel}->state();
	if (!$self->{session}->{gui}->{main}->{connect}) {
	    $self->{session}->{gui}->{terminal}->{geometry} = $self->{gui}->{terminal}->{toplevel}->geometry();
	}
    }
    #source code
    if ($self->{session}->{gui}->{source_code}->{state} !~ /^closed$/) {
	$self->{session}->{gui}->{source_code}->{state}    = $self->{gui}->{source_code}->{toplevel}->state();
	if (!$self->{session}->{gui}->{main}->{connect}) {
	    $self->{session}->{gui}->{source_code}->{geometry} = $self->{gui}->{source_code}->{toplevel}->geometry();
	}
	$self->{session}->{gui}->{source_code}->{scrollpos_x} = ($self->{gui}->{source_code}->{text_text}->xview())[0];
	$self->{session}->{gui}->{source_code}->{scrollpos_y} = ($self->{gui}->{source_code}->{text_text}->yview())[0];
    }
    #variables
    if ($self->{session}->{gui}->{variables}->{state} !~ /^closed$/) {
	$self->{session}->{gui}->{variables}->{state}    = $self->{gui}->{variables}->{toplevel}->state();
	if (!$self->{session}->{gui}->{main}->{connect}) {
	    $self->{session}->{gui}->{variables}->{geometry} = $self->{gui}->{variables}->{toplevel}->geometry();
	}
	$self->{session}->{gui}->{variables}->{scrollpos_x} = ($self->{gui}->{variables}->{text_text}->xview())[0];
	$self->{session}->{gui}->{variables}->{scrollpos_y} = ($self->{gui}->{variables}->{text_text}->yview())[0];
    }
    #registers
    if ($self->{session}->{gui}->{registers}->{state} !~ /^closed$/) {
	$self->{session}->{gui}->{registers}->{state}    = $self->{gui}->{registers}->{toplevel}->state();
	if (!$self->{session}->{gui}->{main}->{connect}) {
	    $self->{session}->{gui}->{registers}->{geometry} = $self->{gui}->{registers}->{toplevel}->geometry();
	}
    }
    #control
    if ($self->{session}->{gui}->{control}->{state} !~ /^closed$/) {
	$self->{session}->{gui}->{control}->{state}    = $self->{gui}->{control}->{toplevel}->state();
	if (!$self->{session}->{gui}->{main}->{connect}) {
	    $self->{session}->{gui}->{control}->{geometry} = $self->{gui}->{control}->{toplevel}->geometry();
	}
    }
}

#############
# build_gui #
#############
sub build_gui {
    my $self = shift @_;

    #main window
    $self->create_main_window();

    #terminal window
    $self->create_terminal_window();
    
    #source code window
    $self->create_source_code_window();
    
    #variables window
    $self->create_variables_window();
    
    #register window
    $self->create_registers_window();
 
    #control window
    $self->create_control_window();
}

#################
# read_geometry #
#################
sub read_geometry {
    my $self     = shift @_;
    my $geometry = shift @_;
    #my $screen_height = $self->{gui}->{main}->screenheight();
    #my $screen_width  = $self->{gui}->{main}->screenwidth();
    my $window_height;
    my $window_width;
    my $window_xpos;
    my $window_ypos;
   
    #printf STDERR "read_geometry: %s\n", $geometry; 
   
    if ($geometry =~ /^=?(\d+)x(\d+)\+(-?\d+)\+(-?\d+)$/) {
	$window_width  = $1;
	$window_height = $2;
	$window_xpos   = $3;
	$window_ypos   = $4;

	#printf STDERR "read_geometry: %s %s %s %s\n", $window_width, $window_height, $window_xpos, $window_ypos;

	return ($window_width, $window_height, $window_xpos, $window_ypos); 
    } else {
	#invalid geometry string
	return (undef, undef, undef, undef);
    } 
}

###################
# adjust_position #
###################
sub adjust_position {
    my $self     = shift @_;
    my $geometry = shift @_;
    my $diff_x   = shift @_;;
    my $diff_y   = shift @_;;
    #my $screen_height = $self->{gui}->{main}->screenheight();
    #my $screen_width  = $self->{gui}->{main}->screenwidth();
    my $window_height;
    my $window_width;
    my $window_xpos;
    my $window_ypos;
    my $xpos;
    my $ypos;

    if ($geometry =~ /^=?(\d+)x(\d+)\+(-?\d+)\+(-?\d+)$/) {
	$window_width  = $1;
	$window_hight  = $2;
	$window_xpos   = $3;
	$window_ypos   = $4;
	
	$xpos = $window_xpos + $diff_x;
	$ypos = $window_ypos + $diff_y;
	
	return sprintf("%dx%d+%d+%d", ($window_width,
				       $window_hight,
				       $xpos,
				       $ypos));
	
    } else {
	#invalid geometry string
	return $geometry;
    } 
}

#####################
# geometry_callback #
#####################
sub geometry_callback {
    my $window       = shift @_;
    my $self         = shift @_;
    my $window_name  = shift @_;
    my $new_geometry;
    my $old_geometry;
    my $old_width;
    my $new_width;
    my $old_height;
    my $new_height;
    my $old_x;
    my $new_x;
    my $diff_x;
    my $old_y;
    my $new_y;
    my $diff_y;

    ##########################
    # window must have focus #
    ##########################
    if (Exists $window->focusCurrent()) {
      if ($window == $window->focusCurrent()->toplevel()) {

	##############################
	# geometry must have changed #
	##############################
	$new_geometry = $window->geometry();
	for ($window_name) {
	  /^main$/        && do {$old_geometry = $self->{session}->{gui}->{main}->{geometry};        last;};
	  /^terminal$/    && do {$old_geometry = $self->{session}->{gui}->{terminal}->{geometry};    last;};
	  /^source_code$/ && do {$old_geometry = $self->{session}->{gui}->{source_code}->{geometry}; last;};
	  /^variables$/   && do {$old_geometry = $self->{session}->{gui}->{variables}->{geometry};   last;};
	  /^registers$/   && do {$old_geometry = $self->{session}->{gui}->{registers}->{geometry};   last;};
	  /^control$/     && do {$old_geometry = $self->{session}->{gui}->{control}->{geometry};     last;};
	}
	if ($old_geometry ne $new_geometry) {

	  #####################
	  # save new geometry #
	  #####################
	  for ($window_name) {
	    /^main$/        && do {$self->{session}->{gui}->{main}->{geometry}        = $new_geometry; last;};
	    /^terminal$/    && do {$self->{session}->{gui}->{terminal}->{geometry}    = $new_geometry; last;};
	    /^source_code$/ && do {$self->{session}->{gui}->{source_code}->{geometry} = $new_geometry; last;};
	    /^variables$/   && do {$self->{session}->{gui}->{variables}->{geometry}   = $new_geometry; last;};
	    /^registers$/   && do {$self->{session}->{gui}->{registers}->{geometry}   = $new_geometry; last;};
	    /^control$/     && do {$self->{session}->{gui}->{control}->{geometry}     = $new_geometry; last;};
	  }

	  ##########################
	  # move connected windows #
	  ##########################
	  if ($self->{session}->{gui}->{main}->{connect}) {
	    #########################
	    # determine coordinates #
	    #########################
	    ($old_width, $old_height, $old_x, $old_y) = $self->read_geometry($old_geometry);
	    ($new_width, $new_height, $new_x, $new_y) = $self->read_geometry($new_geometry);
	    if ((defined $old_x) && (defined $new_x) && (defined $old_y) && (defined $new_y)) {
	      $diff_x = $new_x - $old_x;
	      $diff_y = $new_y - $old_y;
	      if (($diff_x != 0) || ($diff_y != 0)) {
		
		###############
		# main window #
		###############
		if ($window_name !~ /^main$/) {
		  $self->{session}->{gui}->{main}->{geometry} = $self->adjust_position($self->{session}->{gui}->{main}->{geometry}, 
										       $diff_x, 
										       $diff_y);
		  $self->{gui}->{main}->geometry($self->{session}->{gui}->{main}->{geometry});
		}

		###################
		# terminal window #
		###################
		if ($window_name !~ /^terminal$/) {
		  $self->{session}->{gui}->{terminal}->{geometry} = $self->adjust_position($self->{session}->{gui}->{terminal}->{geometry}, 
											   $diff_x, 
											   $diff_y);
		  if (Exists $self->{gui}->{terminal}->{toplevel}) {
		    $self->{gui}->{terminal}->{toplevel}->geometry($self->{session}->{gui}->{terminal}->{geometry});
		  }
		}

		######################
		# source_code window #
		######################
		if ($window_name !~ /^source_code$/) {
		  $self->{session}->{gui}->{source_code}->{geometry} = $self->adjust_position($self->{session}->{gui}->{source_code}->{geometry}, 
											      $diff_x, 
											      $diff_y);
		  if (Exists $self->{gui}->{source_code}->{toplevel}) {
		    $self->{gui}->{source_code}->{toplevel}->geometry($self->{session}->{gui}->{source_code}->{geometry});
		  }
		}

		####################
		# variables window #
		####################
		if ($window_name !~ /^variables$/) {
		  $self->{session}->{gui}->{variables}->{geometry} = $self->adjust_position($self->{session}->{gui}->{variables}->{geometry}, 
											    $diff_x,
											    $diff_y);
		  if (Exists $self->{gui}->{variables}->{toplevel}) {
		    $self->{gui}->{variables}->{toplevel}->geometry($self->{session}->{gui}->{variables}->{geometry});
		  }
		}

		####################
		# registers window #
		####################
		if ($window_name !~ /^registers$/) {
		  $self->{session}->{gui}->{registers}->{geometry} = $self->adjust_position($self->{session}->{gui}->{registers}->{geometry}, 
											    $diff_x,
											    $diff_y);
		  if (Exists $self->{gui}->{registers}->{toplevel}) {
		    $self->{gui}->{registers}->{toplevel}->geometry($self->{session}->{gui}->{registers}->{geometry});
		  }
		}

		##################
		# control window #
		##################
		if ($window_name !~ /^control$/) {
		  $self->{session}->{gui}->{control}->{geometry} = $self->adjust_position($self->{session}->{gui}->{control}->{geometry}, 
											  $diff_x,
											  $diff_y);
		  if (Exists $self->{gui}->{control}->{toplevel}) {
		    $self->{gui}->{control}->{toplevel}->geometry($self->{session}->{gui}->{control}->{geometry});
		  }
		}
	      }
	    }
	  }
	}
      }
    }
}

######################
# show_error_message #
######################
sub show_error_message {
    my $self   = shift @_;
    my $string = shift @_;

    if (Exists $self->{gui}->{main}) {
	$self->{gui}->{main}->messageBox(-title   => "Error!",
					 -message => sprintf("Error! %s", $string),
					 -type    => 'OK');
    } else {
	printf STDERR "Error! %s\n", $string;
    }
}

###############
# update_vars #
###############
sub update_vars {
    my $self   = shift @_;

    #print STDERR "update_vars\n";
    ##########################
    # update variable window #
    ##########################
    $self->update_variables_text(0);	    
}

###############
# update_regs #
###############
sub update_regs {
    my $self   = shift @_;

    #print STDERR "update_regs\n";
    ##########################
    # update register window #
    ##########################
    $self->update_register_values(0);	    
}

#######################
# evaluate_expression #
#######################
sub evaluate_expression {
    my $self       = shift @_;
    my $string     = shift @_;
    my $mask       = shift @_;
    my $show_error = shift @_;
    my $error;
    my $value;
    my $asm_object;

    ######################
    # evalate expression #
    ######################
    if (exists $self->{code}->{problems}) {
	($error, $value) = @{$self->{code}->evaluate_expression($string, undef, undef, undef)};
    } else {
	($error, $value) = @{hsw12_asm->evaluate_expression($string, undef, undef, undef)};
	#($error, $value) = @{hsw12_asm->new([], [], {})->evaluate_expression($string, undef, undef, undef)};
    }
    #printf STDERR "string: \"%s\"\n", $string;
    #printf STDERR "error:  \"%s\"\n", $error;
    #printf STDERR "value:  \"%s\"\n", $value;
   
    #flag error
    if (defined $show_error) {
	if ($error && $show_error) {
	    #$self->show_error_message(sprintf("%s \"%s\"", $error, $string));
	    $self->show_error_message(sprintf("%s", $error));
	}
    }

    #mask data
    if ((defined $mask) &&
	(defined $value)) {
	#apply mask
	$value = $value & $mask;
    }

    #printf "expression: \"%s\" \"%s\" \n", $string, $value;
    return  wantarray ? ($error, $value) : $value;
}

##################
# evaluate_macro #
##################
sub evaluate_macro {
    my $self         = shift @_;
    my $input_string = shift @_;
    my $macro_flags  = shift @_;
    my $pre_string;
    my $command_string;
    my $post_string;
    my $expression;
    my $bytes;
    my $type;
    my $mask;
    my $error;
    my $value;
    my $output_string;
 
    if ($input_string =~ $macro_split_command) {
	$pre_string     = $1;
	$command_string = $2;
        $post_string    = $3;

	#printf STDERR "pre_string:     \"%s\"\n", $pre_string;
	#printf STDERR "command_string: \"%s\"\n", $command_string;
	#printf STDERR "post_string:    \"%s\"\n", $post_string;

	############################
	# remove escape characters #
	############################	
	$pre_string     =~ s/\\\[/\[/g;
	$pre_string     =~ s/\\\]/\]/g;
	
	#########################
	# process macro command #
	#########################	
	for ($command_string) {
	    ##########
	    # update #
	    ##########
	    /$macro_command_update/ && do {
		if ($macro_flags & $macro_allow_update) {
                    if (defined $self->{pod}) {$self->{pod}->clear_cache();}
		    $self->update_variables_text(1);	    
		    $self->update_register_values(1);	    
		} 
		#return array reference
		return [[$pre_string, $macro_tag_default],
			@{$self->evaluate_macro($post_string, $macro_flags)}];
		last;};
	    ##########
	    # upload #
	    ##########
	    /$macro_command_upload/ && do {
	        #print STDERR "UPLOAD\n";
		if (($macro_flags & $macro_allow_upload) &&
		    (exists $self->{code}->{problems})) {
		    #print linear S-Record
	            #print STDERR "OK\n";
		    return [[$pre_string, $macro_tag_default],
			    [$self->{code}->print_lin_srec("HSW12",
							   $self->{session}->{preferences}->{srec}->{format},
							   $self->{session}->{preferences}->{srec}->{length},
							   $self->{session}->{preferences}->{srec}->{s5},
							   $self->{session}->{preferences}->{srec}->{fill_bytes}), $macro_tag_default],
			    @{$self->evaluate_macro($post_string, $macro_flags)}];    
		} else {
		    #return array reference
	            #print STDERR "NOT OK\n";
		    return [[$pre_string, $macro_tag_default],
			    @{$self->evaluate_macro($post_string, $macro_flags)}];
		} 
		last;};
	    #################
	    # upload linear #
	    #################
	    /$macro_command_upload_linear/ && do {
		if (($macro_flags & $macro_allow_upload) &&
		    (exists $self->{code}->{problems})) {
		    #print linear S-Record
		    return [[$pre_string, $macro_tag_default],
			    [$self->{code}->print_lin_srec("HSW12",
							   $self->{session}->{preferences}->{srec}->{format},
							   $self->{session}->{preferences}->{srec}->{length},
							   $self->{session}->{preferences}->{srec}->{s5},
							   $self->{session}->{preferences}->{srec}->{fill_bytes}), $macro_tag_default],
			    @{$self->evaluate_macro($post_string, $macro_flags)}];    
		} else {
		    #return array reference
		    return [[$pre_string, $macro_tag_default],
			    @{$self->evaluate_macro($post_string, $macro_flags)}];
		} 
		last;};
	    ################
	    # upload paged #
	    ################
	    /$macro_command_upload_paged/ && do {
		if (($macro_flags & $macro_allow_upload) &&
		    (exists $self->{code}->{problems})) {
		    #print linear S-Record
		    return [[$pre_string, $macro_tag_default],
			    [$self->{code}->print_pag_srec("HSW12",
							   $self->{session}->{preferences}->{srec}->{format},
							   $self->{session}->{preferences}->{srec}->{length},
							   $self->{session}->{preferences}->{srec}->{s5},
							   $self->{session}->{preferences}->{srec}->{fill_bytes}), $macro_tag_default],
			    @{$self->evaluate_macro($post_string, $macro_flags)}];    
		} else {
		    #return array reference
		    return [[$pre_string, $macro_tag_default],
			    @{$self->evaluate_macro($post_string, $macro_flags)}];
		} 
		last;};
	    #############
	    # recompile #
	    #############
	    /$macro_command_recompile/ && do {
		if ($macro_flags & $macro_allow_recompile) {
		    if (exists $self->{code}->{problems}) {
			$self->{gui}->{main}->Busy(-recurse => 1);
			if (Exists $self->{gui}->{source_code}->{text_text}) {
			  #use source code window
			  $self->{code}->reload(0);
			} else {
			  #use STDOUT
			  $self->{code}->reload(0);
			}
			
			$self->save_geometries();
			$self->build_gui();
			$self->{gui}->{main}->Unbusy();
		    }
		} 
		#return array reference
		return [[$pre_string, $macro_tag_default],
			@{$self->evaluate_macro($post_string, $macro_flags)}]; 
		last; };
	    ############
	    # evaluate #
	    ############
	    /$macro_command_evaluate/ && do {
		#read arguments
		$expression    = $1;
		$bytes         = $2;
		$type          = $3;
		if ($macro_flags & $macro_allow_evaluate) {
		
		    #determine mask
		    $mask = ((256 ** $bytes) - 1);
		    #printf "mask:         \"%X\"\n", $mask;

		    #evalate expression
		    ($error, $value) = $self->evaluate_expression($expression, $mask, 0);
		    if ($error) {
			########################
			#  error in expression #
			########################
			if ($macro_flags & $macro_error_popup) {
			    $self->show_error_message(sprintf("%s \"%s\"", $error, $expression));
			    return [];
			}
			if ($macro_flags & $macro_error_text) {
			    return [[$pre_string, $macro_tag_default],
				    [sprintf(" \"Error! %s (%s)\" ", $error, $expression), $macro_tag_error],
				    @{$self->evaluate_macro($post_string, $macro_flags)}]; 		    
			}
		    } elsif (($macro_flags & $macro_error_popup) &&
			     (!defined $value)) {
			$self->show_error_message(sprintf("undefined result \"%s\"", $expression));
			return [];
		    } else {	    		    
			#determine output string
			($error, $output_string) = @{$self->format_integer($value, $type, $bytes)};
			#printf "value:         \"%X\"\n", $value;
			#printf "error:         \"%s\"\n", $error;
			#printf "output_string: \"%s\"\n", $output_string;
			if ($error && 0) {#unused
			    ###################
			    # error in format #
			    ###################
			    if ($macro_flags & $macro_error_popup) {
				$self->show_error_message(sprintf("invalid format \"%s\"", $expression));
				return [];
			    }
			    if ($macro_flags & $macro_error_text) {
				return [[$pre_string, $macro_tag_default],
					[sprintf(" \"Error! invalid format (%s)\" ", $expression), $macro_tag_error],
					@{$self->evaluate_macro($post_string, $macro_flags)}]; 		    
			    }
			} else {
			    #############
			    # no errors #
			    #############
			    return [[$pre_string, $macro_tag_default],
				    [$output_string, $macro_tag_default],
				    @{$self->evaluate_macro($post_string, $macro_flags)}]; 
			} 
		    }
		} else {
		    #return array reference
		    return [[$pre_string, $macro_tag_default],
			    @{$self->evaluate_macro($post_string, $macro_flags)}]; 
		}
		last;};
	    ##########
	    # lookup #
	    ##########
	    /$macro_command_lookup/ && do {
		#read arguments
		$expression    = $1;
		$bytes         = $2;
		$type          = $3;
		
		if ($macro_flags & $macro_allow_lookup) {
		
		    #determine mask
		    $mask = ((256 ** $bytes) - 1);
		    
		    #evalate expression
		    ($error, $value) = $self->evaluate_expression($expression, 0xffff, 0);
		    if ($error) {
			########################
			#  error in expression #
			########################
			if ($macro_flags & $macro_error_popup) {
			    $self->show_error_message(sprintf("%s \"%s\"", $error, $expression));
			    return [];
			}
			if ($macro_flags & $macro_error_text) {
			    return [[$pre_string, $macro_tag_default],
				    [sprintf(" \"Error! %s (%s)\" ", $error, $expression), $macro_tag_error],
				    @{$self->evaluate_macro($post_string, $macro_flags)}]; 		    
			}
		    } elsif (!defined $value) {
			#####################
			# undefined address #
			#####################
			if ($macro_flags & $macro_error_popup) {
			    $self->show_error_message(sprintf("undefined expression \"%s\"", $expression));
			    return [];
			}
			if ($macro_flags & $macro_error_text) {
			    return [[$pre_string, $macro_tag_default],
				    [sprintf(" \"Error! undefined expression (%s)\" ", $expression), $macro_tag_error],
				    @{$self->evaluate_macro($post_string, $macro_flags)}]; 		    
			}
		    } else {
			###############
			# read memory #
			###############
		        if (defined $self->{pod}) {
			  if ($macro_flags & $macro_allow_pod_reads) {
			    $value = $self->{pod}->read_mem($value, $bytes, 1);
			  } else {
			    $value = $self->{pod}->read_mem($value, $bytes, 0);
			  }
			} else {
			  $value = undef;
			}
			####################
			# undefined result #
			####################			
			if (($macro_flags & $macro_error_popup) &&
			    (!defined $value)) {
			    $self->show_error_message(sprintf("undefined result \"%s\"", $expression));
			    return [];
			} else {
			    ###########################
			    # determine output string #
			    ###########################
			    ($error, $output_string) = @{$self->format_integer($value, $type, $bytes)};			
			    if ($error & 0) {#unsued
				###################
				# error in format #
				###################
				if ($macro_flags & $macro_error_popup) {
				    $self->show_error_message(sprintf("invalid format \"%s\"", $expression));
				    return [];
				}
				if ($macro_flags & $macro_error_text) {
				    return [[$pre_string, $macro_tag_default],
					    [sprintf(" \"Error! invalid format (%s)\" ", $expression), $macro_tag_error],
					    @{$self->evaluate_macro($post_string, $macro_flags)}]; 		    
				}
			    } else {
				#############
				# no errors #
				#############
				return [[$pre_string, $macro_tag_default],
					[$output_string, $macro_tag_default],
					@{$self->evaluate_macro($post_string, $macro_flags)}]; 
			    } 
			}
		    }
		} else {
		    #return array reference
		    return [[$pre_string, $macro_tag_default],
			    @{$self->evaluate_macro($post_string, $macro_flags)}]; 
		}
		last;};
	    #########
	    # error #
	    #########
	    #print STDERR sprintf("invalid command \"\[%s\]\"\n", $command_string);
	    if ($macro_flags & $macro_error_popup) {
		$self->show_error_message(sprintf("invalid command \"\[%s\]\"", $command_string));
		return [];
	    }
	    if ($macro_flags & $macro_error_text) {
		return [[$pre_string, $macro_tag_default],
			[sprintf(" \"Error! invalid command \[%s\]\" ", $command_string), $macro_tag_error],
			@{$self->evaluate_macro($post_string, $macro_flags)}]; 		    
	    }
	}
    } else {
	####################
	# no macro command #
	####################
	#printf "no macro: \"%s\"\n", $input_string;
	#return array reference
	return [[$input_string, $macro_tag_default]];
    }
}

##################
# format_integer #
##################
sub format_integer {
    my $self        = shift @_;
    my $value       = shift @_;
    my $type        = shift @_;
    my $bytes       = shift @_;
    my $char;
    my $output_string;
    my $error;
    my $digits;
    my $i;
    
    #initialize error flag
    $error = 0;

    #determine output string
    for ($type) {
	#######
	# bin #
	#######
	/$macro_format_bin/ && do {
	    $output_string = "";
	    if (defined $value) {
		foreach $i (1 .. ($bytes * 8)) {
		    $output_string = sprintf("%1d", ($value & 1)) . $output_string;
		    $value = $value >> 1;
		}
	    } else {
		$error = 1;
		foreach $i (1 .. ($bytes * 8)) {
		    $output_string .= "?"; 
		}
	    }
	last;};
	#######
	# dec #
	#######
	/$macro_format_dec/ && do {
	    $digits = (log ((256 ** $bytes) - 1)) / (log 10);
	    if (int($digits) < $digits) {
		$digits = int($digits) + 1;
	    } else {
		$digits = int($digits);
	    }
	    if (defined $value) {
		$output_string = sprintf(sprintf("%%.%dd", $digits), $value);
	    } else {
		$error = 1;
		$output_string = "";
		foreach $i (1 .. $digits) {
		    $output_string .= "?"; 
		}
	    }			
	last;};
	#######
	# hex #
	#######
	/$macro_format_hex/ && do {
	    $digits = $bytes * 2; 
	    if (defined $value) {
		$output_string = sprintf(sprintf("%%.%dX", $digits), $value);
	    } else {
		$error = 1;
		$output_string = "";
		foreach $i (1 .. $digits) {
		    $output_string .= "?"; 
		}
	    }			
	last;};
	#########
	# ascii #
	#########
	/$macro_format_ascii/ && do {
	    $output_string = "";
	    if (defined $value) {
		foreach $i (1 .. ($bytes)) {
		    if ((($value & 0xff) >= 0x20 ) &&
			(($value & 0xff) <= 0x7f )) {
			$char = chr($value & 0xff);
		    } else {
			$char = chr(0xfc);
			#$char = chr(0xf2);
		    }
		    $value = $value >> 8;
		    $output_string .= $char;
		}
	    } else {
		$error = 1;
		foreach $i (1 .. ($bytes)) {			     
		    $output_string .= "?"; 
		}								
	    }
	last;};
	###################
	# default (error) #
	###################
	$error = 1;
	$output_string = "";
	foreach $i (1 .. $bytes) {
	    $output_string .= "?"; 
	}										    
    }
    
    #return result
    return [$error, $output_string];
}

##################
# format_address #
##################
sub format_address {
    my $self    = shift @_;
    my $address = shift @_;
    my $ppage;
    my $pc;

    if (!defined $address) {
      $ppage = undef;
      $pc    = undef;
    } elsif (!$self->{session}->{preferences}->{ppage}) {
      $ppage = undef;
      $pc    = ($address & 0xffff);
    } elsif ((($address & 0xffff) >= 0x8000) &&
	     (($address & 0xffff) <  0xc000)) {
      $ppage = (($address >> 16) & 0xff);
      $pc    = ($address & 0xffff);
    } else {
      $ppage = undef;
      $pc    = ($address & 0xffff);
    }
    
    #if (defined $ppage) {
    #  printf STDERR "PPAGE: %X\n", $ppage;
    #} else {
    #  printf STDERR "PPAGE: %s\n", "undef";
    #}
    #if (defined $pc) {
    #  printf STDERR "PC:    %X\n", $pc;
    #} else {
    #  printf STDERR "PC:    %s\n", "undef";
    #}
    
    return wantarray ? ($ppage, $pc) : [$ppage, $pc];
}

#################
# launch editor #
#################
sub launch_editor {
    my $self     = shift @_;
    my $file     = shift @_;
    my $line     = shift @_;
    my $child_id;
    my $exec_format = "%s +%d %s";
    my $exec_line;
    my $terminal;

    #############################
    # check if file is readable #
    #############################
    if (-r $file) {

	####################
	# determine editor #
	####################
	if (defined $ENV{HSW12_EDITOR}) {
	    #################
	    # $HSW12_EDITOR #
	    #################
	    $exec_line = $ENV{HSW12_EDITOR};
	    $exec_line =~ s/%f/$file/ig;
	    $exec_line =~ s/%l/$line/ig;
	} elsif (defined $ENV{WINEDITOR}) {
	    ##############
	    # $WINEDITOR #
	    ##############
	    $exec_line = sprintf($exec_format, $ENV{WINEDITOR}, $line, $file);
	} elsif (defined $ENV{EDITOR}) {
	    #################################
	    # $EDITOR (command line editor) #
	    #################################
	    #determine terminal
	    if (defined $ENV{HSW12_TERMINAL}) {
		$terminal = $ENV{HSW12_TERMINAL};
	    } else {
		$terminal = "xterm";
	    }
	    $exec_line = sprintf("%s -e \"%s +%d %s\"", $terminal, $ENV{EDITOR}, $line, $file);	
	} else {
	    #########
	    # emacs #
	    #########
	    $exec_line = sprintf("emacs +%d %s", $line, $file);
	}
	
	################
	# start editor #
	################
	if ($child_id = fork) {
	    #parent process
	} elsif (defined $child_id) {
	    #child process 
	    #detach from parent
	    #setpgrp(0, $$); #does not always work
	    require POSIX;
	    &POSIX::setsid;
	    #execute command line
	    exec $exec_line;
	} else {
	    #error
	    $self->show_error_message(sprintf("Something went wrong while opening \"%s\"", $file));	
	}	    
    } else {
	#file is not readable
	$self->show_error_message(sprintf("Can't open file \"%s\"", $file));	
    }
}

1;



























