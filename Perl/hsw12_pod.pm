#! /usr/bin/env perl
##################################################################################
#                             HC(S)12 POD Interface                              #
##################################################################################
# file:    hsw12_pod.pm                                                          #
# author:  Dirk Heisswolf                                                        #
# purpose: This is the HSW12 POD Interface                                       #
##################################################################################
# Copyright (C) 2003-2009 by Dirk Heisswolf. All rights reserved.                #
# This file is part of "HSW12". HSW12 is free software;                          #
# you can redistribute it and/or modify it under the same terms as Perl itself.  #
##################################################################################
=pod
=head1 NAME

hsw12_pod - D-Bug12 POD Interface

=head1 SYNOPSIS

 require hsw12_pod

 $pod = hsw12_pod->new($device,          #serial interface (string)
                       $baud_rate,       #baud rate        (string)
                       $terminal_window, #text widget      (widget reference)
                       $main_window,     #toplevel widget  (widget reference)
                       $update_vars,     #callback         (array reference)
                       $update_regs);    #callback         (array reference)

 $pod->set_device($device);

 $pod->set_baud_rate($baud_rate);

 $pod->send_string($string);

 $pod->clear_cache();

 $data = $pod->read_mem($address, #address         (integer)
                        $bytes,   #number of bytes (integer)
                        $pod_io); #allow POD I/O   (boolean)

 $data = $pod->read_reg($name,    #register name   (integer)
                        $pod_io); #allow POD I/O   (boolean)

 $pod->write_mem($address, #address         (integer)
		 $bytes,   #number of bytes (integer)
		 $data);   #data            (integer)

 $pod->write_reg($name,    #register name   (integer)
		 $data);   #data            (integer)

 $pod->set_breakpoints($ppage1, #bkp1 page   (integer)
		       $bkp1,   #breakpoint1 (integer)
           	       $ppage1, #bkp2 page   (integer)
		       $bkp2);  #breakpoint2 (integer)

 $pod->trace($steps); #number of trace steps (integer)

 $pod->stop();

 $pod->go();

 $pod->go_addr($ppage,  #page            (integer)
	       $pc);    #address         (integer)

 $pod->reset();

=head1 REQUIRES

perl5.005, hsw12_gui, Tk, IO::File, IO:Select, FindBin

=head1 DESCRIPTION

This module provides an interface to the D-BUG12 POD.

=head1 METHODS

=head2 Creation

=over 4

=item hsw12_pod->new($device, $baud_rate, $terminal_window, $main_window, $update_vars, $update_regs);

 Creates and returns an hsw12_pod object. 
 This method requires six arguments:
     1. $device:          device name of the serial interface (string)
     2. $baud_rate:       baud rate (string)
     3. $terminal_window: text widget for terminal outputs (widget reference)
     4. $main_window:     toplevel widget (widget reference)
     5. $update_vars:     callback to update the variable display (array reference, arg0: subroutine, arg1: hsw12_gui object)
     6. $update_regs:     callback to update the register display (array reference, arg0: subroutine, arg1: hsw12_gui object)

=back

=head2 POD Setup

=over 4

=item $pod->set_device($device);

 Switches to a different serial interface. 
 This method requires one argument:
     1. $device: device name of the serial interface (string)
 
=item $pod->set_baud_rate($baud_rate);

 Changes the baud rate of the serial interface. 
 This method requires one argument:
     1. $baud_rate: baud rate (string)
 
=back

=head2 POD Interaction

=over 4

=item $pod->send_string($string);

 Sends an ASCII string to the POD. 
 This method requires one argument:
     1. $string: ASCII string (string)
 
=item $pod->clear_cache();

 Clears the variable and register cache. 


=item $pod->read_mem($address, $bytes, $pod_io);

 Reads and returns a number of bytes from the target MCU's memory. 
 This method requires three arguments:
     1. $address: start address (interger)
     2. $bytes:   number of bytes (interger)
     3. $pod_io:  1=read from cache or POD, 
                  0=only read from cache (boolean)

=item $pod->read_reg($name, $pod_io);

 Reads and returns a register value from the target MCU. 
 This method requires two arguments:
     1. $name:    register name (string)
     2. $pod_io:  1=read from cache or POD, 
                  0=only read from cache (boolean)

=item $pod->write_mem($address, $bytes, $data);

 Writes a number of bytes into the target MCU's memory. 
 This method requires three arguments:
     1. $address: start address (interger)
     2. $bytes:   number of bytes (interger)
     3. $data:    data to be written (integer)

=item $pod->write_reg($name, $pod_io);

 Sets a register value in the target MCU. 
 This method requires two arguments:
     1. $name: register name (string)
     2. $data: new register value (integer)

=item $pod->set_breakpoints($bkp1, $bkp2);

 Sets breakpoints. 
 This method requires two arguments:
     1. $bkp1: breakpoint1 (integer)
     2. $bkp2: breakpoint2 (integer)

=item $pod->trace($steps);

 Traces a number of program steps. 
 This method requires one argument:
     1. $steps: number of trace steps (integer)

=item $pod->stop();

 Stops program execution. 

=item $pod->go();

 Resumes program execution. 

=item $pod->go($address);

 Resumes program execution at a given address. 
 This method requires one argument:
     1. $address: new address (integer)

=item $pod->reset();

 Resets target MCU. 

=back

=head1 AUTHOR

Dirk Heisswolf

=head1 VERSION HISTORY

=item V00.00 - Feb  9, 2003 

 initial release

=item V00.01 - Feb 18, 2003 

 -modified "parse input string" (bugfix, support backspaces)
 -modified "send_command" (delay after each line)

=item V00.02 - Feb 23, 2003 

 -fixed filter for invalid characters in terminal window

=item V00.03 - Mar 11, 2003 

 -changed terminal settings
 -reduced command delay

=item V00.04 - Mar 14, 2003 

 -changed instruction for setting registers
 -added ppage values to breakpoints

=item V00.05 - Apr 4, 2003 

 -PPAGE register is set and reads as CPU register
 -go command can be run paged and unpaged

=item V00.06 - Apr 23, 2003 

 -"tramsmit" subroutine lo longer writes to undefined handles
 -modified regular expression to detect register values 

=item V00.07 - May  6, 2003 

 -interpreting $07 as "beep" in terminal window

=item V00.08 - May 13, 2003 

 -fixed subroutine "request_mem_byte"

=item V00.09 - Oct 29, 2003 

 -added output formats for S12X

=item V00.10 - Nov 19, 2004 

 -modified regular expressions for parsing CPU registers
 -fixed CCR parser

=item V00.11 - Oct  3, 2004 

 -modified regular expressions for parsing CPU registers

=item V00.12 - Jun 16, 2005 

 -modified regular expressions for parsing CPU registers

=item V00.13 - Oct 13, 2009 

 -modified stty call for Mac OS X (10.5)

=item V00.14 - May 17, 2010 

 -use different stty args depending on OS

=over 4

initial release

=back

=cut

#################
# Perl settings #
#################
#use warnings;
#use strict;
use FindBin qw($RealBin);
use lib $RealBin;
require hsw12_gui;

####################
# create namespace #
####################
package hsw12_pod;

###########
# modules #
###########
use Tk;
use IO::File;
use IO::Select;

####################
# global variables #
####################

#############
# constants #
#############
###########
# version #
###########
*version = \"00.14";#"

######################
# parser expressions #
######################
#display regs (1=PC 2=SP 3=X 4=Y 5=A 6=B 7=CCR)
*parse_display_regs = \qr/\n +PC +SP +X +Y +D += +A:B +CCR += +SXHI NZVC.*\n([A-F\d]{4}) +([A-F\d]{4}) +([A-F\d]{4}) +([A-F\d]{4}) +([A-F\d]{2}):([A-F\d]{2}) +([A-F\d]{4} [A-F\d]{4})/is;
#display regs + ppage (1=PP 2=PC 3=SP 4=X 5=Y 6=A 7=B 8=CCR)
*parse_display_regs_ppage = \qr/\nPP +PC +SP +X +Y +D += +A:B +CCR += +SXHI NZVC.*\n([A-FXx\d]{2}) +([A-F\d]{4}) +([A-F\d]{4}) +([A-F\d]{4}) +([A-F\d]{4}) +([A-F\d]{2}):([A-F\d]{2}) +([01]{4} [01]{4})/is;
*parse_display_regs_ppage_ipl = \qr/\nPP +PC +SP +X +Y +D += +A:B +CCR += +IPL +SXHI NZVC.*\n([A-FXx\d]{2}) +([A-F\d]{4}) +([A-F\d]{4}) +([A-F\d]{4}) +([A-F\d]{4}) +([A-F\d]{2}):([A-F\d]{2}) +\d+ +([01]{4} [01]{4})/is;
#display memory bytes (1=address 2=+0 3=+1 4=+2 5=+3 6=+4 7=+5 8=+6 9=+7 10=+8 11=+9 12=+A 13=+B 14=+C 15=+D 16=+E 17=+F)
*parse_display_mem_bytes = \qr/\n([A-F\d]{4}) +([A-F\d]{2}) +([A-F\d]{2}) +([A-F\d]{2}) +([A-F\d]{2}) +- +([A-F\d]{2}) +([A-F\d]{2}) +([A-F\d]{2}) +([A-F\d]{2}) +- +([A-F\d]{2}) +([A-F\d]{2}) +([A-F\d]{2}) +([A-F\d]{2}) +- +([A-F\d]{2}) +([A-F\d]{2}) +([A-F\d]{2}) +([A-F\d]{2}) */is;
#display memory words (1=address 2=+0 3=+1 4=+2 5=+3 6=+4 7=+5 8=+6 9=+7 10=+8 11=+9 12=+A 13=+B 14=+C 15=+D 16=+E 17=+F)
*parse_display_mem_words = \qr/\n([A-F\d]{4}) +([A-F\d]{2})([A-F\d]{2}) +([A-F\d]{2})([A-F\d]{2}) +- +([A-F\d]{2})([A-F\d]{2}) +([A-F\d]{2})([A-F\d]{2}) +- +([A-F\d]{2})([A-F\d]{2}) +([A-F\d]{2})([A-F\d]{2}) +- +([A-F\d]{2})([A-F\d]{2}) +([A-F\d]{2})([A-F\d]{2}) */is;
#input regs (1=value)
*parse_input_reg_pc   = \qr/\nPC=([A-F\d]{4}) +/is;
*parse_input_reg_sp   = \qr/\nSP=([A-F\d]{4}) +/is;
*parse_input_reg_x    = \qr/\nIX=([A-F\d]{4}) +/is;
*parse_input_reg_y    = \qr/\nIY=([A-F\d]{4}) +/is;
*parse_input_reg_a    = \qr/\nA=([A-F\d]{2}) +/is;
*parse_input_reg_b    = \qr/\nB=([A-F\d]{2}) +/is;
*parse_input_reg_ccr  = \qr/\nCCR=([A-F\d]{2}) +/is;
*parse_input_reg_ccrw = \qr/\nCCRW=..([A-F\d]{2}) +/is;
#input memory bytes (1=address 2=value) 
*parse_input_mem_bytes = \qr/\n([A-F\d]{4}) +([A-F\d]{2}) *\n/is;
#input memory words (1=address 2=hi 3=lo) 
*parse_input_mem_words = \qr/\n([A-F\d]{4}) +([A-F\d]{2})([A-F\d]{2}) *\n/is;

###############
# delays (ms) #
###############
*command_delay = \200;
#*command_delay = \10;

###############
# constructor #
###############
sub new {
    my $proto           = shift @_;
    my $class           = ref($proto) || $proto;
    my $device          = shift @_;
    my $baud_rate       = shift @_;
    my $terminal_window = shift @_;
    my $main_window     = shift @_;
    my $update_vars     = shift @_;
    my $update_regs     = shift @_;
    my $self            = {};

    #initalize global variables
    $self->{device}           = undef;
    $self->{baud_rate}        = undef;
    $self->{terminal_window}  = $terminal_window;
    $self->{main_window}      = $main_window;
    $self->{update_vars}      = $update_vars;
    $self->{update_regs}      = $update_regs;
    $self->{input_handle}     = undef;
    $self->{input_select}     = undef;
    $self->{output_handle}    = undef;
    $self->{mem_cache}        = {};
    $self->{reg_cache}        = {};
    $self->{input_string}     = "";
    $self->{esc_instr}        = 0;
    $self->{output_queue}     = [];
    $self->{transmit}         = 0;
        
    #instantiate object
    bless $self, $class;

    #select device
    $self->set_device($device);
    #$self->set_device("/dev/modem");

    #select baud rate
    $self->set_baud_rate($baud_rate);
    #$self->set_baud_rate(4800);

    return $self;
}

##############
# destructor #
##############
sub DESTROY {
    my $self = shift @_;

}

##############
# set_device #
##############
sub set_device {
  my $self   = shift @_;
  my $device = shift @_;
  my $input_handle;
  my $output_handle;
  my $input_select;
  
  #print STDERR "device: $device\n";

  #close file handles
  if (defined $self->{input_handle}) {close $self->{input_handle};}
  if (defined $self->{output_handle}) {close $self->{output_handle};}

  #open output handle
  if ($output_handle = IO::File->new(">$device")) {
    $output_handle->autoflush(1);
    #$output_handle->autoflush(0);
    #select $output_handle;
    #$| = 1;
    select STDOUT;
    $self->{output_handle}  = $output_handle;
    
    #open input handle
    if ($input_handle = IO::File->new("$device")) {
      $self->{input_handle}  = $input_handle;

      $input_select = IO::Select->new($input_handle);
      $self->{input_select}  = $input_select;

      #set file event
      $self->{main_window}->fileevent($input_handle, 'readable', [\&parse_input_stream, $self]);
            
    } else {
      #can't open input handle
      if (Exists $self->{terminal_window}) {
	$self->{terminal_window}->insert('end', 
					 sprintf("Error! Can't read from device \"%s\" (%s)\n", $device, $!),
					 $hsw12_gui::terminal_tag_error);

	$self->{terminal_window}->see('end linestart');
	$self->{terminal_window}->see('end');
      } else {
	printf STDERR "Error! Can't read from device \"%s\" (%s)\n", $device, $!;
      }
      $self->{device} = undef;
      return 0;
    }
    
  } else {
    #can't open output handle
    if (Exists $self->{terminal_window}) {
      $self->{terminal_window}->insert('end', 
				       sprintf("Error! Can't write to device \"%s\" (%s)\n", $device, $!),
				       $hsw12_gui::terminal_tag_error);	
      $self->{terminal_window}->see('end linestart');
      $self->{terminal_window}->see('end');
    } else {
      printf STDERR "Error! Can't write to device \"%s\" (%s)\n", $device, $!;
    }
    $self->{device} = undef;
    return 0;
  }
  if (Exists $self->{terminal_window}) {
    $self->{terminal_window}->insert('end', 
				     sprintf("Connected to device \"%s\"\n", $device),
				     $hsw12_gui::terminal_tag_info);	
    $self->{terminal_window}->see('end linestart');
    $self->{terminal_window}->see('end');
  }
  $self->{device} = $device;
  return $device;
}

#################
# set_baud_rate #
#################
sub set_baud_rate {
  my $self      = shift @_;
  my $baud_rate = shift @_;
  my $device    = $self->{device};

  #printf STDERR "set_baud_rate: %s\n", $baud_rate;

  if (defined $device) {
    undef $!;
    #set stty args
    if ($^O =~ /darwin/) {
      $stty_call  = sprintf("stty -f %s ", $device);
    } else {
      $stty_call  = sprintf("stty -F %s ", $device);      
    }
    $stty_call .= "-parenb ";
    $stty_call .= "-parodd ";
    $stty_call .= "cs8 ";
    $stty_call .= "-hupcl ";
    $stty_call .= "-cstopb ";
    $stty_call .= "cread ";
    $stty_call .= "clocal ";
    $stty_call .= "-crtscts ";
    $stty_call .= "ignbrk ";
    $stty_call .= "-brkint ";
    $stty_call .= "ignpar ";
    $stty_call .= "-parmrk ";
    $stty_call .= "-inpck ";
    $stty_call .= "-istrip ";
    $stty_call .= "-inlcr ";
    $stty_call .= "-igncr ";
    $stty_call .= "-icrnl ";
    $stty_call .= "ixon ";
    $stty_call .= "ixoff ";
    $stty_call .= "-ixany ";
    $stty_call .= "imaxbel ";
    $stty_call .= "-opost ";
    #$stty_call .= "-olcuc ";
    $stty_call .= "-ocrnl ";
    $stty_call .= "-onlcr ";
    $stty_call .= "-onlret ";
    $stty_call .= "-ofill ";
    $stty_call .= "-ofdel ";
    $stty_call .= "nl0 ";
    $stty_call .= "cr0 ";
    $stty_call .= "tab0 ";
    $stty_call .= "bs0 ";
    $stty_call .= "vt0 ";
    $stty_call .= "ff0 ";
    $stty_call .= "-isig ";
    $stty_call .= "-icanon ";
    $stty_call .= "-iexten ";
    $stty_call .= "-echo ";
    $stty_call .= "-echoe ";
    $stty_call .= "-echok ";
    $stty_call .= "-echonl ";
    $stty_call .= "-noflsh ";
    #$stty_call .= "-xcase ";
    $stty_call .= "-tostop ";
    $stty_call .= "-echoprt ";
    $stty_call .= "-echoctl ";
    $stty_call .= "-echoke ";
    $stty_call .= "-echoke ";
    $stty_call .= "min 1 ";
    $stty_call .= "time 1 ";
    $stty_call .= "rows 0 ";
    $stty_call .= "columns 0 ";
    #$stty_call .= "line 0 ";
    $stty_call .= sprintf("ispeed %d ", $baud_rate);
    $stty_call .= sprintf("ospeed %d", $baud_rate);

    #printf STDERR $stty_call . "\n";
    system($stty_call);

    if ($!) {	
      #can't set baud rate
      if (Exists $self->{terminal_window}) {
	$self->{terminal_window}->insert('end', 
					 sprintf("Error! Can't set baud rate on device \"%s\" (%s)\n", $device, $!),
					 $hsw12_gui::terminal_tag_error);	
	$self->{terminal_window}->see('end linestart');
	$self->{terminal_window}->see('end');
      } else {
	printf STDERR "Error! Can't set baud rate on device \"%s\" (%s)\n", $device, $!;
      }
      $self->{baud_rate} = undef;
      return 0;
    } else {
      if (Exists $self->{terminal_window}) {
	$self->{terminal_window}->insert('end', 
					 sprintf("Device \"%s\" set to %d baud\n", $device, $baud_rate),
					 $hsw12_gui::terminal_tag_info);	
	$self->{terminal_window}->see('end linestart');
	$self->{terminal_window}->see('end');
      }
      $self->{baud_rate} = $baud_rate;
      return $baud_rate;
    }
  } else {
    #not connected
    if (Exists $self->{terminal_window}) {
      $self->{terminal_window}->insert('end', 
				       "Error! Not connected\n",
				       $hsw12_gui::terminal_tag_error);	
      $self->{terminal_window}->see('end linestart');
      $self->{terminal_window}->see('end');
    } else {
      print STDERR "Error! Not connected\n";
    }
    $self->{baud_rate} = undef;
    return 0;
  }
}

######################
# parse_input_stream #
######################
sub parse_input_stream {
    my $self             = shift @_;
    my $input_handle     = $self->{input_handle};
    my $output_handle    = $self->{output_handle};
    my $input_select     = $self->{input_select};
    my $update_regs_call = $self->{update_regs};
    my $update_regs_sub  = $update_regs_call->[0];
    my $update_regs_arg  = $update_regs_call->[1];
    my $update_vars_call = $self->{update_vars};
    my $update_vars_sub  = $update_vars_call->[0];
    my $update_vars_arg  = $update_vars_call->[1];
    my $can_read;
    my $data;
    my $char;
    my $bytes;
    my $instr_queue;
    my $instr;
    my $update_regs;
    my $update_vars;
    
    $can_read = $input_select->can_read(1);
    if ($can_read) {
	$bytes = sysread $input_handle, $data, 4096;
	$data =~ s/\r//g;
	
	#append data to input string
	$self->{input_string} .= $data;
	#print data into terminal window
	if (Exists $self->{terminal_window}) {
	    foreach $char (split //, $data) {
		if ($char =~ /^[\x20-\x7e\s]$/) {
		    #display one character
		    $self->{terminal_window}->insert('end', $char, $hsw12_gui::terminal_tag_default);
		} elsif ($char =~ /^[\x08]$/) {
		    #backspace
		    #print STDERR "backspace\n";
		    $self->{terminal_window}->delete('end - 2 chars', 'end');
		} elsif ($char =~ /^[\x07]$/) {
		    #backspacebeep
		    #print STDERR "beep\n";
		    $self->{terminal_window}->bell;
		} else {
		    #display hex code
		    $self->{terminal_window}->insert('end', sprintf("[%.2X]", ord($char)), $hsw12_gui::terminal_tag_error);
		}	    
	    }	    
	    $self->{terminal_window}->see('end linestart');
	    $self->{terminal_window}->see('end');
	}
	
	if (! defined $bytes) {
	    #read error
	    if (Exists $self->{terminal_window}) {
		$self->{terminal_window}->insert('end', 
						 sprintf("Error! Can't read from device \"%s\" (%s)\n", $self->{device}, $!),
						 $hsw12_gui::terminal_tag_error);
		$self->{terminal_window}->see('end linestart');
		$self->{terminal_window}->see('end');
	    } else {
		printf STDERR "Error! Can't read from device \"%s\" (%s)\n", $self->{device}, $!;
	    }	
	} else {
	    ######################
	    # parse input string #
	    ######################
	    ($instr_queue, $self->{input_string}) = @{$self->parse_string($self->{input_string})};
	    
	    
	    #print STDERR "instr_queue: \"";
	    #foreach $instr (@$instr_queue) {
	    #  printf STDERR "%s=%s ", $instr->[0], $instr->[1];
	    #}
	    #print STDERR "\"\n";

	    #execute instruction queue
	    $update_regs = 0;
	    $update_vars = 0;
	    foreach $instr (@$instr_queue) {
		for ($instr->[0]) {
		    ##########
		    # memory #
		    ##########
		    /^\d+$/ && do {
			if ($instr->[1] =~ /^[A-F\d]{2}$/) {
			    $update_vars = 1;
			    #printf STDERR "%.4X = %.2X\n", int($instr->[0]), hex($instr->[1]);
			    $self->{mem_cache}->{int($instr->[0])} = hex($instr->[1]);
			} 
			last;};
		    ######
		    # PP #
		    ######
		    /^pp$/ && do {
			if ($instr->[1] =~ /^[A-F\d]{2}$/) {
			    $update_regs = 1;
			    $self->{reg_cache}->{'pp'} = hex($instr->[1]);
			} elsif ($instr->[1] =~ /^[Xx]{2}$/) {
			    #$self->{reg_cache}->{'pp'} = undef;
			}
			last;};
		    ######
		    # PC #
		    ######
		    /^pc$/ && do {
			if ($instr->[1] =~ /^[A-F\d]{4}$/) {
			    $update_regs = 1;
			    $self->{reg_cache}->{'pc'} = hex($instr->[1]);
			} 
			last;};
		    ######
		    # SP #
		    ######
		    /^sp$/ && do {
			if ($instr->[1] =~ /^[A-F\d]{4}$/) {
			    $update_regs = 1;
			    $self->{reg_cache}->{'sp'} = hex($instr->[1]);
			} 
			last;};
		    #####
		    # X #
		    #####
		    /^x$/ && do {
			if ($instr->[1] =~ /^[A-F\d]{4}$/) {
			    $update_regs = 1;
			    $self->{reg_cache}->{'x'} = hex($instr->[1]);
			} 
			last;};
		    #####
		    # Y #
		    #####
		    /^y$/ && do {
			if ($instr->[1] =~ /^[A-F\d]{4}$/) {
			    $update_regs = 1;
			    $self->{reg_cache}->{'y'} = hex($instr->[1]);
			} 
			last;};
		    #####
		    # A #
		    #####
		    /^a$/ && do {
			if ($instr->[1] =~ /^[A-F\d]{2}$/) {
			    $update_regs = 1;
			    $self->{reg_cache}->{'a'} = hex($instr->[1]);
			} 
			last;};
		    #####
		    # B #
		    #####
		    /^b$/ && do {
			if ($instr->[1] =~ /^[A-F\d]{2}$/) {
			    $update_regs = 1;
			    $self->{reg_cache}->{'b'} = hex($instr->[1]);
			} 
			last;};
		    #######
		    # CCR #
		    #######
		    /^ccr$/ && do {
			if ($instr->[1] =~ /^[A-F\d]{2}$/) {
			    $update_regs = 1;
			    #printf STDERR "CCR: %X\n", hex($instr->[1]);
			    $self->{reg_cache}->{'ccr'} = hex($instr->[1]);
			} 
			last;};
		    ############
		    # no match #
		    ############
		    #ignore
		}
	    }
	    ###################
	    # update displays #
	    ###################
	    if ($update_regs) {&$update_regs_sub($update_regs_arg);}
	    if ($update_vars) {&$update_vars_sub($update_vars_arg);}
	}
    }
}

################
# parse_string #
################
sub parse_string {
    my $self   = shift @_;
    my $string = shift @_;
    my $pre_instr;
    my $pre_string;
    my $post_instr;
    my $post_string;
    my $prematch;
    my $postmatch;
    my $match01;
    my $match02;
    my $match03;
    my $match04;
    my $match05;
    my $match06;
    my $match07;
    my $match08;
    my $match09;
    my $match10;
    my $match11;
    my $match12;
    my $match13;
    my $match14;
    my $match15;
    my $match16;
    my $match17;
    my $ccr_char;
    my $ccr_value;
    
    #printf STDERR "parse_string: \"%s\"\n", $string;
    for ($string) {
	################
	# display regs #
	################
	/$parse_display_regs/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    $match02   = $2;
	    $match03   = $3;
	    $match04   = $4;
	    $match05   = $5;
	    $match06   = $6;
	    $match07   = $7;
	    #print STDERR "match display_regs\n";

	    #determine CCR value
	    $ccr_value = 0;
	    $match07   =~ s/\s//g;
	    foreach $ccr_char (split //, $match07) {
		$ccr_value = $ccr_value << 1;
		if ($binery_char ne "0") {
		    $binery_value++;
		}
	    }
	
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     ['pc',  $match01],
		     ['sp',  $match02],
		     ['x',   $match03],
		     ['y',   $match04],
		     ['a',   $match05],
		     ['b',   $match06],
		     ['ccr', sprintf("%.2X", $ccr_value)],		     
		     @$post_instr],
		    $post_string];	    
	    last;};
	########################
	# display regs + ppage #
	########################
	/$parse_display_regs_ppage/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    $match02   = $2;
	    $match03   = $3;
	    $match04   = $4;
	    $match05   = $5;
	    $match06   = $6;
	    $match07   = $7;
	    $match08   = $8;
	    #print STDERR "match display_regs_ppage\n";
	    
	    #determine CCR value
	    $ccr_value = 0;
	    $match08   =~ s/\s//g;
	    foreach $ccr_char (split //, $match08) {
		$ccr_value = $ccr_value << 1;
		if ($ccr_char ne "0") {
		    $ccr_value++;
		}
	    }
	
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     ['pp',  $match01],
		     ['pc',  $match02],
		     ['sp',  $match03],
		     ['x',   $match04],
		     ['y',   $match05],
		     ['a',   $match06],
		     ['b',   $match07],
		     ['ccr', sprintf("%.2X", $ccr_value)],		     
		     @$post_instr],
		    $post_string];	    
	    last;};
	##############################
	# display regs + ppage + ipl #
	##############################
	/$parse_display_regs_ppage_ipl/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    $match02   = $2;
	    $match03   = $3;
	    $match04   = $4;
	    $match05   = $5;
	    $match06   = $6;
	    $match07   = $7;
	    $match08   = $8;
	    #print STDERR "match display_regs_ppage_ipl\n";	    
	    #printf STDERR "match08 = \"%s\"\n", $match08;
	    #determine CCR value
	    $ccr_value = 0;
	    $match08   =~ s/\s//g;
	    foreach $ccr_char (split //, $match08) {
		$ccr_value = $ccr_value << 1;
		if ($ccr_char ne "0") {
		    $ccr_value++;
		}
	    }
	    #printf STDERR "ccr_value = \"%s\" (%.2X)\n", $ccr_value, $ccr_value;
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     ['pp',  $match01],
		     ['pc',  $match02],
		     ['sp',  $match03],
		     ['x',   $match04],
		     ['y',   $match05],
		     ['a',   $match06],
		     ['b',   $match07],
		     ['ccr', sprintf("%.2X", $ccr_value)],		     
		     @$post_instr],
		    $post_string];	    
	    last;};
	########################
	# display memory bytes #
	########################
	/$parse_display_mem_bytes/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    $match02   = $2;
	    $match03   = $3;
	    $match04   = $4;
	    $match05   = $5;
	    $match06   = $6;
	    $match07   = $7;
	    $match08   = $8;
	    $match09   = $9;
	    $match10   = $10;
	    $match11   = $11;
	    $match12   = $12;
	    $match13   = $13;
	    $match14   = $14;
	    $match15   = $15;
	    $match16   = $16;
	    $match17   = $17;
	    #print STDERR "match display_mem_bytes\n";
	    
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     [(hex($match01) +  0), $match02],
		     [(hex($match01) +  1), $match03],
		     [(hex($match01) +  2), $match04],
		     [(hex($match01) +  3), $match05],
		     [(hex($match01) +  4), $match06],
		     [(hex($match01) +  5), $match07],
		     [(hex($match01) +  6), $match08],		     
		     [(hex($match01) +  7), $match09],
		     [(hex($match01) +  8), $match10],
		     [(hex($match01) +  9), $match11],
		     [(hex($match01) + 10), $match12],
		     [(hex($match01) + 11), $match13],
		     [(hex($match01) + 12), $match14],
		     [(hex($match01) + 13), $match15],
		     [(hex($match01) + 14), $match16],
		     [(hex($match01) + 15), $match17],
		     @$post_instr],
		    $post_string];	    
	    last;};
	########################
	# display memory words #
	########################
	/$parse_display_mem_words/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    $match02   = $2;
	    $match03   = $3;
	    $match04   = $4;
	    $match05   = $5;
	    $match06   = $6;
	    $match07   = $7;
	    $match08   = $8;
	    $match09   = $9;
	    $match10   = $10;
	    $match11   = $11;
	    $match12   = $12;
	    $match13   = $13;
	    $match14   = $14;
	    $match15   = $15;
	    $match16   = $16;
	    $match17   = $17;
	    #print STDERR "match display_mem_words\n";
	    
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     [(hex($match01) +  0), $match02],
		     [(hex($match01) +  1), $match03],
		     [(hex($match01) +  2), $match04],
		     [(hex($match01) +  3), $match05],
		     [(hex($match01) +  4), $match06],
		     [(hex($match01) +  5), $match07],
		     [(hex($match01) +  6), $match08],		     
		     [(hex($match01) +  7), $match09],
		     [(hex($match01) +  8), $match10],
		     [(hex($match01) +  9), $match11],
		     [(hex($match01) + 10), $match12],
		     [(hex($match01) + 11), $match13],
		     [(hex($match01) + 12), $match14],
		     [(hex($match01) + 13), $match15],
		     [(hex($match01) + 14), $match16],
		     [(hex($match01) + 15), $match17],
		     @$post_instr],
		    $post_string];	    
	    last;};
	###################
	# input regs (PC) #
	###################
	/$parse_input_reg_pc/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    #print STDERR "match input_reg_pc\n";
	    
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     ['pc',  $match01],
		     @$post_instr],
		    $post_string];	    
	    last;};
	###################
	# input regs (SP) #
	###################
	/$parse_input_reg_sp/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    #print STDERR "match input_reg_sp\n";
	    
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     ['sp',  $match01],
		     @$post_instr],
		    $post_string];	    
	    last;};
	##################
	# input regs (X) #
	##################
	/$parse_input_reg_x/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    #print STDERR "match input_reg_x\n";
	    
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     ['x',  $match01],
		     @$post_instr],
		    $post_string];	    
	    last;};
	##################
	# input regs (Y) #
	##################
	/$parse_input_reg_y/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    #print STDERR "match input_reg_y\n";
	    
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     ['y',  $match01],
		     @$post_instr],
		    $post_string];	    
	    last;};
	##################
	# input regs (A) #
	##################
	/$parse_input_reg_a/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    #print STDERR "match input_reg_a\n";
	    
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     ['a',  $match01],
		     @$post_instr],
		    $post_string];	    
	    last;};
	##################
	# input regs (B) #
	##################
	/$parse_input_reg_b/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    #print STDERR "match input_reg_b\n";
	    
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     ['b',  $match01],
		     @$post_instr],
		    $post_string];	    
	    last;};
	####################
	# input regs (CCR) #
	####################
	/$parse_input_reg_ccr/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    #print STDERR "match input_reg_ccr\n";
	    
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     ['ccr',  $match01],
		     @$post_instr],
		    $post_string];	    
	    last;};
	#####################
	# input regs (CCRW) #
	#####################
	/$parse_input_reg_ccrw/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    #print STDERR "match input_reg_ccr\n";
	    
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     ['ccr',  $match01],
		     @$post_instr],
		    $post_string];	    
	    last;};
	######################
	# input memory bytes #
	######################
	/$parse_input_mem_bytes/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    $match02   = $2;
	    #print STDERR "match input_mem_words\n";
	    #workaround for missing newlinw
	    $postmatch = "\n" . $postmatch;
	    
	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     [(hex($match01)), $match02],
		     @$post_instr],
		    $post_string];	    
	    last;};
	######################
	# input memory words #
	######################
	/$parse_input_mem_words/ && do {
	    $prematch  = $`;
	    $postmatch = $';
	    $match01   = $1;
	    $match02   = $2;
	    $match03   = $3;
	    #print STDERR "match input_mem_words\n";
	    #workaround for missing newlinw
	    $postmatch = "\n". $postmatch;

	    ($pre_instr,  $pre_string)  = @{$self->parse_string($prematch)};
	    ($post_instr, $post_string) = @{$self->parse_string($postmatch)};
	    return [[@$pre_instr,
		     [(hex($match01)), $match02],
		     @$post_instr],
		    $post_string];	    
	    last;};
	############
	# no match #
	############
	return [[], $string];
    }
}

###############
# send_string #
###############
sub send_string {
    my $self = shift @_;
    my $data = shift @_;
    my $output_queue = $self->{output_queue};

    #print STDERR $data;
    $data =~ s/\n/\r/g;
    $self->{esc_instr} = 1;

    if($self->{transmit}) {
      push @$output_queue, [$data, O];
    } else {
      push @$output_queue, [$data, 0];
      $self->transmit();
    }
}

################
# send_command #
################
sub send_command {
    my $self         = shift @_;
    my $data         = shift @_;
    my $output_queue = $self->{output_queue};
    my $substring    = "";

    #adjust lineends
    $data =~ s/\n/\r/g;

    #escape previous commands
    if ($self->{raw_output}) {$data .= ".\r";}
    $self->{esc_instr} = 0;

    while ($data =~ /^([^\.\r]*[\.\r])(.+)$/) {
	$substring = $1;
	$data      = $2;
	
	#transmit substring
	if($self->{transmit}) {
	    push @$output_queue, [$substring, $command_delay];
	} else {
	    push @$output_queue, [$substring, $command_delay];
	    $self->transmit();
	}
    }

    #transmit remaining data
    if($self->{transmit}) {
	push @$output_queue, [$data, $command_delay];
    } else {
	push @$output_queue, [$data, $command_delay];
	$self->transmit();
    }
}

############
# transmit #
############
sub transmit {
    my $self         = shift @_;
    my $out_handle   = $self->{output_handle};
    my $output_queue = $self->{output_queue};
    my $output_queue_entry;
    my $data;
    my $delay;

    if ((defined $out_handle) &&
	(defined $output_queue)) {
	if ($#$output_queue >= 0) {
	    $output_queue_entry = shift @$output_queue;
	    $data  = $output_queue_entry->[0];
	    $delay = $output_queue_entry->[1];
	    
	    #printf STDERR "transmit: %s :%s\n", $data, $delay;
	    $out_handle->print($data);
	    #$out_handle->flush();
	    
	    if ($delay > 0) {
		$self->{transmit} =
		    $self->{main_window}->after($delay, [\&transmit, $self]);
	    } else {
		$self->transmit();
	    }
	} else {
	    #transmit queue is empty
	    $self->{transmit} = 0;
	}
    }
}

###############
# clear_cache #
###############
sub clear_cache {
    my $self      = shift @_;    

    #print STDERR "clear_cache\n";
    #clear cache
    #printf STDERR "before= %s\n", join(", ", sort keys %{$self->{mem_cache}});
    $self->{mem_cache} = {};
    $self->{reg_cache} = {};
    #printf STDERR "after= %s\n", join(", ", sort keys %{$self->{mem_cache}});
}

############
# read_mem #
############
sub read_mem {
    my $self           = shift @_;    
    my $address        = shift @_;
    my $bytes          = shift @_;
    my $allow_requests = shift @_;
    my $data;
    my $data_available;
    my $i;
    #printf STDERR "read_mem: %.4X %.1X %.1X\n", $address, $bytes, $allow_requests;

    #############
    # byte loop #
    #############
    $data_available = 1;
    $data           = 0;
    for ($i = int($address); 
	 #(($i <= int($address + $bytes)) && $data_available);
	 ($i < int($address + $bytes));
	 $i++) {
	#printf STDERR "read_mem loop : %X\n", $i;

	######################
	# check memory cache #
	######################
	if (exists $self->{mem_cache}->{$i}) {
	    if (defined $self->{mem_cache}->{$i}) {
		#byte available
		$data = $data << 8;
		$data = $data + $self->{mem_cache}->{$i};
	    } else {
		$data_available = 0;
	    }
	} else {
	    #request data byte
	    if ($allow_requests) {$self->request_mem_byte($i)}
	    $data_available = 0;
	}
    }

    if ($data_available) {
	#data available
	#printf STDERR "read_mem -> %X\n", $data;
	return $data;
    } else {
	#data not available
	#printf STDERR "read_mem -> data not available\n";
	return undef;
    }
}

####################
# request_mem_byte #
####################
sub request_mem_byte {
    my $self    = shift @_;    
    my $address = shift @_;    
    my $lower_range;
    my $upper_range;
    my $i;
    my $request_necessary;

    #determine address range
    $lower_range = (int($address) & 0xfff0);
    $upper_range = ($lower_range + 0x0F);
    #printf STDERR "request_mem_byte: %.4X %.4X %.4X\n", $address, $lower_range, $upper_range;
   
    #flag requested addresses
    $request_necessary = 0;
    foreach $i ($lower_range ... $upper_range) {
	if (!exists $self->{mem_cache}->{$i}) {
	    $self->{mem_cache}->{$i} = undef;
	    #printf STDERR "undef: %X\n", $i;
	    $request_necessary = 1;
	} 
    }

    #send request
    if ($request_necessary) {
	$self->send_command(sprintf("mdw %.4x\n", $lower_range));
    }
}

############
# read_reg #
############
sub read_reg {
    my $self           = shift @_;    
    my $name           = shift @_;
    my $allow_requests = shift @_;
    #printf "read_reg: %s %.1X\n", $name, $allow_requests;
    
    if (exists $self->{reg_cache}->{lc($name)}) {
	if (defined $self->{reg_cache}->{lc($name)}) {
	    #printf "%s: \"%X\"\n", $name, $self->{reg_cache}->{lc($name)};
	    return $self->{reg_cache}->{lc($name)};
	} else {
            #printf "%s: undefined\n", $name;
	    return undef;
	}
    } else {
	if ($allow_requests) {$self->request_regs();}
        #printf "%s: unknown\n", $name;
	return undef;
    }
}

###############
# request_reg #
###############
sub request_regs {
    my $self = shift @_;    
    my $reg;
    my $request_necessary;

    #flag requested addresses
    $request_necessary = 0;
    foreach $reg ('pc', 'sp', 'x', 'y', 'a', 'b', 'pp', 'ccr') {
	if (!exists $self->{reg_cache}->{$reg}) {
	    $request_necessary = 1;
	    $self->{reg_cache}->{$reg} = undef;
	} elsif (!defined $self->{reg_cache}->{$reg}) {
	    $request_necessary = 1;
	}
    }

    #send request
    if ($request_necessary) {
	$self->send_command("rd\n");
    }
}
    
#############
# write_mem #
#############
sub write_mem {
    my $self      = shift @_;    
    my $address   = shift @_;
    my $bytes     = shift @_;
    my $data      = shift @_;
    my $i;
    #printf "write_mem: %.4X %d %.4X\n", $address, $bytes, $data;

    if ((defined $address) &&
	(defined $bytes) &&
	(defined $data)) {
	
	#address loop
	$i = $bytes - 1;
	while ($i >= 0) {
	    if ($i > 0) {
		if ((($address + $i) & 1) == 1) {
		    ##############
		    # write word #
		    ##############
		    $self->send_command(sprintf("mmw %.4x %.4x\n", (($address + $i - 1), 
								    ($data & 0xffff))));
		    #check memory
		    $self->send_command(sprintf("mdw %.4x\n", ($address + $i - 1)));

		    $data = $data >> 16;
		    $i = $i - 2;
		} else {
		    ##############
		    # write byte #
		    ##############
		    $self->send_command(sprintf("mm %.4x %.2x\n", (($address + $i), 
								   ($data & 0xff))),
					$delay_mm);
		    #check memory
		    $self->send_command(sprintf("md %.4x\n", ($address + $i)));
		    $data = $data >> 8;
		    $i--;;
		}
	    } else {
		##############
		# write byte #
		##############
		$self->send_command(sprintf("mm %.4x %.2x\n", (($address + $i), 
							       ($data & 0xff))),
				    $delay_mm);
		#check memory
		$self->send_command(sprintf("md %.4x\n", ($address + $i)));
		$data = $data >> 8;
		$i--;;
	    }
	}
    }
}

#############
# write_reg #
#############
sub write_reg {
    my $self      = shift @_;    
    my $name      = shift @_;
    my $data      = shift @_;
    my $string;
    my $done;

    if (defined $data) {
         for ($name) {
	   /^pc$/   && do {$string = sprintf("pc %.4x\n",  ($data & 0xffff)); last;};
	   /^sp$/   && do {$string = sprintf("sp %.4x\n",  ($data & 0xffff)); last;};
	   /^x$/    && do {$string = sprintf("x %.4x\n",   ($data & 0xffff)); last;};
	   /^y$/    && do {$string = sprintf("x %.4x\n",   ($data & 0xffff)); last;};
	   /^a$/    && do {$string = sprintf("a %.2x\n",   ($data & 0xff));   last;};
	   /^b$/    && do {$string = sprintf("b %.2x\n",   ($data & 0xff));   last;};
	   /^pp$/   && do {$string = sprintf("pp %.2x\n",   ($data & 0xff));   last;};
	   /^ccr$/  && do {$string = sprintf("ccr %.2x\n", ($data & 0xff));   last;};
	 }

    	 #send command
    	 $self->send_command($string);
    	 #$self->send_command("rd\n");
    }
}

###################
# set_breakpoints #
###################
sub set_breakpoints {
    my $self   = shift @_;
    my $ppage1 = shift @_;
    my $bkp1   = shift @_;
    my $ppage2 = shift @_;
    my $bkp2   = shift @_;
    my $string;
    my $set_br;

    #initialize string;
    $string = "nobr\n";
    $set_br = 0;

    if (defined $bkp1) {
      if (defined $ppage1) {
	$string .= sprintf("br %.2x:%.4x", ($ppage1 & 0xff), ($bkp1 & 0xffff));
      } else {
	$string .= sprintf("br %.4x", ($bkp1 & 0xffff));
      }
      $set_br = 1;
    }
    if (defined $bkp2) {
      if (!$set_br) {
	$string .= "br";
      }
      if (defined $ppage2) {
	$string .= sprintf(" %.2x:%.4x", ($ppage2 & 0xff), ($bkp2 & 0xffff));
      } else {
	$string .= sprintf(" %.4x", ($bkp2 & 0xffff));
      }
      $set_br = 1;
    }
    if ($set_br) {
      $string .= "\n";
    }

    #send command
    $self->send_command($string);
}    
 
#########
# trace #
#########
sub trace {
    my $self  = shift @_;    
    my $steps = shift @_;    
    my $string;

    if (defined $steps) {
	if ($steps > 1) {
	    $string = sprintf("t %d\n", $steps);
	} else {
	    $string = "t\n";
	}
	#send command
	$self->send_command($string);
    }
}    

########
# stop #
########
sub stop {
    my $self  = shift @_;    

    #send command
    $self->send_command("stop\n");
}

######
# go #
######
sub go {
    my $self  = shift @_;    

    #send command
    $self->send_command("g\n");
}

###########
# go_addr #
###########
sub go_addr {
    my $self    = shift @_;    
    my $ppage   = shift @_;    
    my $pc      = shift @_;    
    my $string;

    if ((defined $ppage) && (defined $pc)) {
	$string = sprintf("g %.2x:%.4x\n", (($ppage & 0xff),
					    ($pc    & 0xffff)));
	#send command
	$self->send_command($string);
    } elsif (defined $pc) {
	$string = sprintf("g %.4x\n", ($pc    & 0xffff));
	#send command
	$self->send_command($string);
    } 
}    

#########
# reset #
#########
sub reset {
    my $self  = shift @_;    

    #send command
    $self->send_command("reset\n");
}

1;
