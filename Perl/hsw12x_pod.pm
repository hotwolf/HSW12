#! /bin/env perl
##################################################################################
#                             HC(S)12 POD Interface                              #
##################################################################################
# file:    hsw12_pod.pm                                                          #
# author:  Dirk Heisswolf                                                        #
# purpose: This is the HSW12X POD Interface                                       #
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

 #Constructor
 $pod = hsw12_pod->new($tk_top);
  
 #I/O Parameters
 $error = $pod->set_io_pars($device, $baud_rate);

 #Sync POD
 $pod->sync_pod($good_ref, $bad_ref);

 #Reset POD
 $pod->reset_pod($good_ref, $bad_ref);

 #Set Target Speed
 $pod->set_tgt_speed($speed, $good_ref, $bad_ref);

 #Get Target Speed
 $pod->get_tgt_speed($good_ref, $bad_ref);

 #Sync Target
 $pod->sync_tgt($good_ref, $bad_ref);

 #Reset Target
 $pod->reset_tgt($smode, $good_ref, $bad_ref);
 
 #Read Memory 
 $pod->read_mem($addr, $bytes, $good_ref, $bad_ref);
 
 #Read BDM Registers
 $pod->read_bdm($addr, $bytes, $good_ref, $bad_ref);

 #Read Registers 
 $pod->read_regs($regs_ref, $good_ref, $bad_ref);
 
 #Write Memory
 $pod->write_mem($addr, $data_ref, $good_ref, $bad_ref);

 #Write BDM Registers
 $pod->write_bdm($addr, $data_ref, $good_ref, $bad_ref);

 #Write Registers
 $pod->write_regs($regs_ref, $data_ref, $good_ref, $bad_ref);

 #Go
 $pod->go($good_ref, $bad_ref);

 #Trace
 $pod->trace($good_ref, $bad_ref);
 
=head1 REQUIRES

perl5.005, hsw12_gui, Tk, IO::File, IO:Select, FindBin

=head1 DESCRIPTION

This module provides an interface to the D-BUG12 POD.

=head1 METHODS

=head2 Creation

=over 4

=item hsw12_pod->new();

 Creates and returns an hsw12_pod object. 

=back

=head2 POD Setup

=over 4

=item $objject_ref = hsw12_pod::new($tk_ref);

 Creates a hsw12_pod object. 
 This method requires following argument:
     1. $tk_ref:    Tk widget (reference)
 The return value is a reference to the new object.

=item $error = $pod->set_io_pars($device, $baud_rate);

 Changes the baud rate of the serial interface. 
 This method requires following arguments:
     1. $device:    terminal device (string)
     2. $baud_rate: baud rate       (integer)
 The return value is "0" if no errors occured.
 
=item $pod->sync_pod($good_ref, $bad_ref);

 Resynchronizes the POD communication.
 This method requires following arguments:
     1. $good_ref: Callback        (sub ref)
     2. $bad_ref:  Error callback  (sub ref)
                   _@: Error string (string ref)

=item $pod->reset_pod($good_ref, $bad_ref);

 Resets the POD.
 This method requires following arguments:
     1. $good_ref: Callback        (sub ref)
     2. $bad_ref:  Error callback  (sub ref)
                   _@: Error string (string ref)

=item $pod->set_tgt_speed($speed, $good_ref, $bad_ref);

 Sets the target speed for BDM communication. 
 This method requires following arguments:
     1. $speed:    period of target BDM clock in ns (real)
     2. $good_ref: Callback        (sub ref)
     3. $bad_ref:  Error callback  (sub ref)
                   _@: Error string (string ref)
 
=item $pod->get_tgt_speed($good_ref, $bad_ref);

 Sets the target speed for BDM communication. 
 This method requires following arguments:
     1. $good_ref: Callback        (sub ref)
                   _@: Target speed (integer)
     2. $bad_ref:  Error callback  (sub ref)
                   _@: Error string (string ref)

=back

=head2 Target Interaction

=over 4

=item $pod->sync_tgt($good_ref, $bad_ref);

 Synchronizes POD and Target. 
 This method requires following arguments:
     1. $good_ref: Callback        (sub ref)
     2. $bad_ref:  Error callback  (sub ref)
                   _@: Error string (string ref)

=item $pod->reset_tgt($smode, $good_ref, $bad_ref);

 Resets the Target. 
 This method requires following arguments:
     1. $smode:    Select special mode (boolean)
     2. $good_ref: Callback        (sub ref)
     3. $bad_ref:  Error callback  (sub ref)
                   _@: Error string (string ref)

=item $pod->read_mem($addr, $bytes, $good_ref, $bad_ref);

 Reads a number of bytes from the standard memory map. 
 This method requires following arguments:
     1. $addr:     Start address, format: page:address (integer)
     2. $bytes:    Number of bytes to read             (integer)
     3. $good_ref: Callback                            (sub ref)
                   _@: Data         (array ref)
     4. $bad_ref:  Error callback                      (sub ref)
                   _@: Error string (string ref)

=item $pod->read_bdm($addr, $bytes, $good_ref, $bad_ref);

 Reads a number of bytes from the bdm memory map. 
 This method requires following arguments:
     1. $addr:     Start address, format: page:address (integer)
     2. $bytes:    Number of bytes to read             (integer)
     3. $good_ref: Callback                            (sub ref)
                   _@: Data         (array ref)
     4. $bad_ref:  Error callback                      (sub ref)
                   _@: Error string (string ref)
 
=item $pod->read_regs($regs_ref, $good_ref, $bad_ref);

 Reads a set of register values. 
 This method requires following arguments:
     1. $regs_ref: List of register symbols            (array reference)
     2. $good_ref: Callback                            (sub ref)
                   _@: Data         (array ref)
     3. $bad_ref:  Error callback                      (sub ref)
                   _@: Error string (string ref)
 
=item $pod->write_mem($addr, $data_ref, $good_ref, $bad_ref);

 Writes to a number of bytes in the standard memory map. 
 This method requires following arguments:
     1. $addr:     Start address, format: page:address (integer)
     2. $data_ref: Write data                          (array reference)
     3. $good_ref: Callback                            (sub ref)
     4. $bad_ref:  Error callback                      (sub ref)
                   _@: Error string (string ref)
 
=item $pod->read_bdm($addr, $bytes, $data_ref, $good_ref, $bad_ref);

 Writes to a number of bytes in the bdm memory map. 
 This method requires following arguments:
     1. $addr:     Start address, format: page:address (integer)
     2. $data_ref: Write data                          (array reference)
     3. $good_ref: Callback                            (sub ref)
     4. $bad_ref:  Error callback                      (sub ref)
                   _@: Error string (string ref)
 
=item $pod->read_regs($regs_ref, $data_ref, $good_ref, $bad_ref);

 Writes to a set of register value. 
 This method requires following arguments:
     1. $regs_ref: list of register symbols            (array reference)
     2. $data_ref: write data                          (array reference)
     3. $good_ref: Callback                            (sub ref)
     4. $bad_ref:  Error callback                      (sub ref)
                   _@: Error string (string ref)
 
=item $pod->go($good_ref, $bad_ref);

 Resumes program execution of the target. 
 This method requires following arguments:
     1. $good_ref: Callback        (sub ref)
     2. $bad_ref:  Error callback  (sub ref)
                   _@: Error string (string ref)
 
=item $error = $pod->trace($good_ref, $bad_ref);

 Performs a single step on the target. 
 This method requires following arguments:
     1. $good_ref: Callback        (sub ref)
     2. $bad_ref:  Error callback  (sub ref)
                   _@: Error string (string ref)
 
=back

=head1 AUTHOR

Dirk Heisswolf

=head1 VERSION HISTORY

=item V00.00 - Feb  9, 2003 

 initial release


=over 4

=back

=cut

#################
# Perl settings #
#################
#use warnings;
#use strict;
use FindBin qw($RealBin);
use lib $RealBin;
use Fctl ':flock';

####################
# create namespace #
####################
package hsw12_pod;

###########
# modules #
###########
use IO::File;
use IO::Select;
use POSIX::Termios;

####################
# global variables #
####################

#############
# constants #
#############
*frame_counter_mask = \0xe0;
*frame_counter_inc  = \0x20;

 
*sys_cmd_reset      = \0x00;

*pod_sync           = \0x01;

###########
# version #
###########
*version = \"00.00";#"


###############
# constructor #
###############
sub new {
    my $self            = {};
    my $tk_ref          = shift @_;

    #initalize global variables
    $self->{tk}               = $tk_ref;
    $self->{device}           = undef;
    $self->{baud}             = undef;
    $self->{io_handle}        = undef;
    $self->{io_select}        = undef;
    $self->{frame_counter}    = 0;
    $self->{pod_ready}        = 0;

    #debug variables
    $self->{pod_ready}        = 0;        
    #instantiate object
    bless $self, $class;

    #set I/O parameters
    if (!$self->set_io_pars("/dev/ttyS0", 9660)) 

	#synchronize POD communication
	if (!$self->sync_pod())

	    #reset POD
	    if ($self->reset())

		#POD is ready
		$self->{pod_ready} = 1;
	
    return $self;
}

##############
# destructor #
##############
sub DESTROY {
    my $self = shift @_;
}

###############
# set_io_pars #
###############
sub set_io_pars {
  my $self   = shift @_;
  my $device = shift @_;
  my $baud   = shift @_;
  my $error;
  my $termios;
 
  #close old I/O handle
  if (defined $self->{io_handle}) {
      #unlock file
      flock($self->{io_handle}, LOCK_UN);
      #close file
      close $self->{io_handle};
      $self->{io_handle} = undef;
      $self->{io_select} = undef;
  }

  #check baud rate
  if (($baud ==   1200) ||
      ($baud ==   2400) ||
      ($baud ==   4800) ||
      ($baud ==   9600) ||
      ($baud ==  19200) ||
      ($baud ==  36800)) {
      #open I/O handle
      if ($self->{io_handle} = IO::File->new($device)) {	  
	  #lock I/O handle
	  if (!flock($self->{io_handle}, LOCK_EX|LOCK_NB)) {
	      #set I/O parameters
	      if ($termios = POSIX:Termios->new()) {
		  $termios->getattr($self->{io_handle});
		  $termios->setiflag(BRKINT);
		  $termios->setoflag(0);
		  $termios->setcflag(CLOCAL|CREAD|CS8);
		  $termios->setlflag(0);
		  $termios->setlflag(0);
		  for (baud) {
		      /1200/   && do {$termios->setispeed(B1200);
				      $termios->setospeed(B1200);
				      last;};
		      /2400/   && do {$termios->setispeed(B2400);
				      $termios->setospeed(B2400);
				      last;};
		      /4800/   && do {$termios->setispeed(B4800);
				      $termios->setospeed(B4800);
				      last;};
		      /9600/   && do {$termios->setispeed(B9600);
				      $termios->setospeed(B9600);
				      last;};
		      /19200/  && do {$termios->setispeed(B19200);
				      $termios->setospeed(B19200);
				      last;};
		      /38400/  && do {$termios->setispeed(B38400);
				      $termios->setospeed(B38400);
				      last;};
		  }		  
		  if ($termios->setattr($self->{io_handle}, TCSAFLUSH)) {
		      #Create a select object
		      $self->{io_select} = IO:Select->new($self->{io_handle});
		  } else {
		      #invalid baud rate
		      close $self->{io_handle};
		      $self->{io_handle} = undef;
		      error = sprintf("Could not set terminal attributes (%s)", $device);
		      $self->debug("set_io_pars:", error);
		      return error;
		  }
	      } else {
		  #invalid baud rate
		  close $self->{io_handle};
		  $self->{io_handle} = undef;
		  error = sprintf("Device may not be a terminal (%s)", $device);
		  $self->debug("set_io_pars:", error);
		  return error;
	      }
	  } else {
	      #invalid baud rate
	      close $self->{io_handle};
	      $self->{io_handle} = undef;
	      error = sprintf("Unable to lock device (%s)", $device);
	      $self->debug("set_io_pars:", error);
	      return error;
	  }
      } else {
	  #invalid baud rate
	  error = sprintf("Unable to open device (%s)", $device);
	  $self->debug("set_io_pars:", error);
	  return error;
      }
  } else {
      #invalid baud rate
      error = sprintf("Invalid baud rate (%d)", $baud);
      $self->debug("set_io_pars:", error);
      return error;
  }
}

############
# sync pod #
############
sub sync_pod {
  my $self     = shift @_;
  my $i;
  my $byte;
  my $;

  if (defined $self->{io_handle}) {
  
      #Send initial sync request
      foreach i (1..24) {
	  $self->tx_byte($pod_sync);
      }

      #Receive sync reply
      i = 0;
      while (i < 8) {
	  $self->tx_byte($pod_sync);
	  if ($self->rx_byte() == $pod_sync) {
	      i++;
	  } else {
	      i = 0;
	  }
      }
  } else {
	  


      $self->{io_select}->

      $byte = 


#############
# reset_pod #
#############
sub reset_pod {
  my $self     = shift @_;
  my $checksum;

  #Start system command
  $checksum = $self->{frame_counter} & frame_counter_mask;
  printf($self->{io_handle}, "%.1c", $checksum);

  #Send subcommand
  $checksum += $sys_cmd_reset;
  printf($self->{io_handle}, "%.1c", $sys_cmd_reset);

  #Send checksum
  $checksum = $checksum + ($checksum>>8);
  $checksum = $checksum & 0xff;
  $checksum = ~$checksum;
  printf($self->{io_handle}, "%.1c", $checksum);
  
  #Receive reply

  




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
    $stty_call  = sprintf("stty -F %s ", $device);
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
    $stty_call .= "-olcuc ";
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
    $stty_call .= "-xcase ";
    $stty_call .= "-tostop ";
    $stty_call .= "-echoprt ";
    $stty_call .= "-echoctl ";
    $stty_call .= "-echoke ";
    $stty_call .= "-echoke ";
    $stty_call .= "min 1 ";
    $stty_call .= "time 1 ";
    $stty_call .= "rows 0 ";
    $stty_call .= "columns 0 ";
    $stty_call .= "line 0 ";
    $stty_call .= sprintf("ispeed %d ", $baud_rate);
    $stty_call .= sprintf("ospeed %d", $baud_rate);

    #system(sprintf("stty -F %s cs8 -parenb -cstopb ispeed %d ospeed %d", $device, $baud_rate, $baud_rate));
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
	    
	    #print STDERR "transmit: $data $delay\n";;
	    print $out_handle $data;
	    
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
