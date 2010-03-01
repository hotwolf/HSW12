#! /bin/env perl
##################################################################################
#                                    HSW12                                       #
##################################################################################
# file:    wav2asm.pl                                                            #
# author:  Dirk Heisswolf                                                        #
# purpose: Sound file converter (11.025kHz 8-bit Mono .WAV type)                 #
##################################################################################
# Copyright (C) 2003-2009 by Dirk Heisswolf. All rights reserved.                #
# This file is part of "HSW12". HSW12 is free software;                          #
# you can redistribute it and/or modify it under the same terms as Perl itself.  #
##################################################################################
=pod
=head1 NAME

wav2asm.pl - Sound File Converter (11.025kHz 8-bit Mono .WAV type)

=head1 SYNOPSIS

 hsw12asm.pl <src files>

=head1 REQUIRES

perl5.005, IO::File

=head1 DESCRIPTION

This script is converts 11.025kHz 8-bit Mono .WAV files into ASCII assembler include files.

=head1 METHODS

=over 4

=item wav2asm.pl [-o offset] <src files>

 Starts the .WAV file converter 
 This script reads the following arguments:
     offset:         byte offset
     src files:      sound files(*.wav)

=back

=head1 AUTHOR

Dirk Heisswolf

=head1 VERSION HISTORY

=item V00.00 - Jan 19, 2004

 initial release

=cut

#################
# Perl settings #
#################
use 5.005;
use warnings;
use IO::File;

#############
# constants #
#############
*mid_val       = \0x80;
*threshold     = \0x08;
*padding       = \3;
*page_size     = \(16*1024);

###############
# global vars #
###############
$arg               = "";
$arg_type          = "";
$offset            = 0;
@src_files         = ();
$src_file          = "";
$src_handle        = 0;
$riff_check        = "";
$mono_check        = "";
$rate_check        = "";
$sample_check      = "";
$file_size         = "";
@data_buffer       = ();
@pad_buffer        = ();
$out_total         = 0;
$out_count         = 0;
$byte_count        = 0;
$out_basename      = "";
$out_file          = "";
$out_handle        = 0;

#general purpose
$i                 = 0;
$j                 = 0;
$byte              = "";
$string            = "";
$hival             = 0;
$loval             = 0;


##########################
# read command line args #
##########################
$arg_type = "src";
foreach $arg (@ARGV) {
    if ($arg =~ /^\s*\-o\s*$/i) {
	$arg_type = "offset";
    } elsif ($arg =~ /^\s*\-/) {
	#ignore
    } elsif ($arg_type eq "offset") {
	if ($offset =~ \D) {
	    printf STDOUT ("    WARNING! Invalid offset \"%s\" ignored\n", $arg);
	} else {
	    $offset = $arg;
	}
	$arg_type = "src";
    } elsif ($arg_type eq "src") {
	#sourcs file
	push @src_files, $arg;
    }
}
#printf STDERR "offset:    \"%X\"\n", $offset;

###################
# print help text #
###################
if ($#src_files < 0) {
    printf "usage: %s <src files>\n", $0;
    print  "\n";
    exit;
}

##################
# .WAV file loop #
##################
foreach $src_file (@src_files) {
    ##################
    # open .WAV file #
    ##################
    #check if file exists
    if (! -e $src_file) {
	 printf STDOUT ("    ERROR! File \"%s\" does not exist\n", $src_file);
	 next;
    } 
    #check if file is readable
    if (! -r $src_file) {
	 printf STDOUT "    ERROR! File \"%s\" is not readable\n", $src_file;
	 next;
    }
    #check if file can be opened
    if ($src_handle = IO::File->new($src_file, O_RDONLY)) {
    } else {
	 printf STDOUT "    ERROR! Unable to open file \"%s\" (%s)\n", $src_file, $!;
	 next;
    }

    $src_handle->seek(0, SEEK_SET);      #reset file handle pointer
    $src_handle->read($riff_check, 4);   #check RIFF header
    $src_handle->seek(18, SEEK_CUR);     #skip 18 bytes
    $src_handle->read($mono_check, 2);   #check mono flag
    $src_handle->seek(4, SEEK_CUR);      #skip 4 bytes
    $src_handle->read($rate_check, 4);   #check sampling rate
    $src_handle->read($sample_check, 2); #check sampling data width
    $src_handle->seek(6, SEEK_CUR);      #skip 6 bytes
    $src_handle->read($file_size, 4);    #check file size

    #unpack data
    $sample_check = unpack "v", $sample_check;
    $mono_check   = unpack "v", $mono_check;
    $rate_check   = unpack "V", $rate_check;
    $file_size    = unpack "V", $file_size;

    #printf STDERR "riff_check:   \"%s\"\n", $riff_check;
    #printf STDERR "sample_check: \"%X\"\n", $sample_check;
    #printf STDERR "mono_check:   \"%X\"\n", $mono_check; 
    #printf STDERR "rate_check:   \"%X\"\n", $rate_check;
    #printf STDERR "file_size:    \"%X\ (%dk)\n", $file_size, ($file_size/1024);

    #check if RIFF header was found
    if ($riff_check ne "RIFF") {
	 printf STDOUT "    ERROR! File \"%s\" is not a .WAV file\n", $src_file;
	 $src_handle->close();   #close file handle
	 next;
    }
    #check is data witdth is 8 bit
    if ($sample_check != 0x01) {
	 printf STDOUT "    ERROR! File \"%s\" is not an 8-bit sound sample\n", $src_file;
	 $src_handle->close();   #close file handle
	 next;
    }
    #check if sound sample is mono
    if ($mono_check != 0x0001) {
	 printf STDOUT "    ERROR! File \"%s\" is not a mono sound sample\n", $src_file;
	 $src_handle->close();   #close file handle
	 next;
    }
    #check if sample rate is 11.025kHz
    if ($rate_check != 0x2B11) {
	 printf STDOUT "    ERROR! Sample rate of file \"%s\" is not 11.025 kHz\n", $src_file;
	 $src_handle->close();   #close file handle
	 next;
    }
    #check if file size is larger than 240kB
    if ($file_size >= (240*1024)) {
	 printf STDOUT "    ERROR! File \"%s\" is larger than 240kB\n", $src_file;
	 $src_handle->close();   #close file handle
	 next;
    }

    $src_handle->seek(1, SEEK_CUR);                 #skip 1 byte

    @data_buffer       = ();                        #read data
    foreach $i (0..($file_size-2)) {
	 if ($src_handle->read($byte, 1)) {
	     $byte = unpack "C", $byte;
             #printf STDERR "byte %.3d:    \"%X\"\n", $i, $byte;
	     push @data_buffer, $byte;
	 } else {
	     printf STDOUT "    WARNING! File \"%s\" could not be read completely\n", $src_file;
	     last;
	 }
    }
    #printf STDERR "file_size:    %d (%dk)\n", $file_size, ($file_size/1024);
    $src_handle->close();                           #close file handle

    #######################
    # filter sound sample #
    #######################
    #truncate silence at the beginning
    @pad_buffer = (); 
    while ($#data_buffer > 0) {
	 $byte = shift @data_buffer;
	 push @pad_buffer, $byte;
	 if ($#pad_buffer > $padding) {
	     shift @pad_buffer;
	 }
         #printf STDERR "byte:    \"%X\" \"%X\" %s\n", $byte, $#pad_buffer, join(", ", @pad_buffer);
	 if (($byte <= ($mid_val-$threshold)) || 
	     ($byte >= ($mid_val+$threshold))) {
             #printf STDERR "sound byte:    \"%X\"\n", $byte;
	     last;
	 }
    }
    @data_buffer = (@pad_buffer, @data_buffer);

    #$file_size  = $#data_buffer;
    #printf STDERR "file_size:    %d (%dk)\n", $file_size, ($file_size/1024);
    #exit;

    #truncate silence at the ent
    @data_buffer = reverse @data_buffer;
    @pad_buffer = ();
    while ($#data_buffer > 0) {
	 $byte = shift @data_buffer;
	 push @pad_buffer, $byte;
	 if ($#pad_buffer > $padding) {
	     shift @pad_buffer;
	 }
         #printf STDERR "byte:    \"%X\" \"%X\" %s\n", $byte, $#pad_buffer, join(", ", @pad_buffer);
	 if (($byte <= ($mid_val-$threshold)) || 
	     ($byte >= ($mid_val+$threshold))) {
             #printf STDERR "sound byte:    \"%X\"\n", $byte;
	     last;
	 }
    }
    @data_buffer = (@pad_buffer, @data_buffer);
    @data_buffer = reverse @data_buffer;
    $file_size  = ($#data_buffer+1);

    #printf STDERR "last data byte: %X\n", pop(@data_buffer);
    #printf STDERR "file_size:    %d (%dk)\n", $file_size, ($file_size/1024);
    #exit;

    #$data_old = shift @data_buffer;
    #$sign_old = undef;
    #$sign_sum = 0;
    #$sign_cnt = 0;
    #$sign_cyc = 0;
    #$data_sum = 0;
    #$data_cnt = 0;
    #$diff_max = 0;
    #foreach $data_cur (@data_buffer) {
    #	  $data_sum += abs($data_cur - $data_old);
    #	  if ($diff_max < abs($data_cur - $data_old)) {$diff_max = abs($data_cur - $data_old);}
    #	  if (defined $sign_old) {
    #	      if (($data_cur >= $data_old) && !$sign_old) {
    #		  $sign_sum += $sign_cyc;
    #		  $sign_cnt++;
    #		  $sign_cyc = 0;
    #	      } elsif (($data_cur < $data_old) && $sign_old) {
    #		  $sign_sum += $sign_cyc;
    #		  $sign_cnt++;
    #		  $sign_cyc = 0;
    #	      }
    #	  }
    #	  $sign_cyc++;
    #	  if ($data_cur >= $data_old) {
    #	      $sign_old = 1;
    #	  } else {
    #	      $sign_old = 0;
    #	  }
    #	  $data_cnt++;
    #	  $data_old = $data_cur;
    #}
    #printf STDERR "average signal change: %s\n", ($data_sum/$data_cnt);
    #printf STDERR "maximum signal change: %s\n", $diff_max;
    #printf STDERR "average samples per sign change: %s\n", ($sign_sum/$sign_cnt);
    #exit;

    #####################
    # prepare data dump #
    #####################
    $offset       = $offset % $page_size;
    #printf STDERR "offset:    \"%X\"\n", $offset;
    $out_count    = 0;
    $out_total    = ($offset + $file_size) / $page_size;
    if ((($offset + $file_size) % $page_size) > 0) {
	$out_total++;
    }
    if ($src_file =~ /^([\w-]+)\.wav$/i) {
	$out_basename = $1;
    } else {
	$out_basename = $src_file;
    }

    #################
    # dump out data #
    #################
    while ($#data_buffer >= 0) {
        #create file name 	
	if ($out_total == 1) {
	    $out_file = sprintf("%s.s", $out_basename);
	} else {
	    $out_file = sprintf("%s_%d.s", $out_basename, $out_count);
	}
	printf STDOUT "    -> %s\n", $out_file;

	#check if file can be opened
	if ($out_handle = IO::File->new($out_file,  O_CREAT|O_WRONLY)) {
	    $out_handle->truncate(0);
	} else {
	    printf STDOUT "    ERROR! Unable to open file \"%s\" (%s)\n", $out_file, $!;
	    last;
	}

	#print header
	printf $out_handle ";#######################################################################\n";
	printf $out_handle ";# Sound Sample: %-45s %3d/%-3d #\n", $src_file, ($out_count+1), $out_total;
        printf $out_handle ";#######################################################################\n";
	printf $out_handle "\n";
	if ($out_count == 0) {
	    printf $out_handle "%-24s EQU  \%d ;(%d kb)\n", sprintf("%s_SIZE", uc($out_basename)), $file_size, ($file_size/1024);
	    printf $out_handle "%-24s EQU  *\n",    sprintf("%s_START", uc($out_basename));
	}

	$byte_count = $offset;
	while (1) {
	    if ($byte_count >= $page_size) {
		#page is full
		$offset = 0;
		last;
	    } elsif ($#data_buffer < 0) {
		#data buffer is empty
		$offset = $byte_count;
		last;
	    } else {
		#data to be dumped
		$string            = "";
		$hival             = 0x00;
		$loval             = 0xff;		
		for ($i=1; (($i<=16)             && 
			    ($#data_buffer >= 0) &&
			    ($byte_count < $page_size)); $i++) {
		    $byte = shift @data_buffer;		    
		    #if ($#data_buffer < 10) {printf STDERR "byte:    \"%X\" \"%X\"\n", $byte, $#data_buffer;}
		    if ($byte > $hival) {$hival = $byte;}
		    if ($byte < $loval) {$loval = $byte;}
		    $string .= sprintf("\$%.2X ", ($byte & 0xff));
		    $byte_count++;
                    #printf STDERR "byte %.3d:    \"%X\" \"%X\"\n", $byte_count, $byte, $#data_buffer;
		}
		#print data
		printf $out_handle "%-24s DB   %-64s ;|", "", $string;
		#print graph
		$string  = "";
		$hival = $hival >> 4;
		$loval = $loval >> 4;
		for ($j=0; $j<$loval;           $j++) {$string .= " ";}
		for ($j=0; $j<=($hival-$loval); $j++) {$string .= "*";}
		for ($j=0; $j<(15-$hival);      $j++) {$string .= " ";}
		$string .= "|\n";
		printf $out_handle $string;
                #printf STDERR "bytes left \"%X\" \"%X\" \"%X\"\n", $#data_buffer, $hival, $loval;
	    }
	}
	#printf STDOUT "    completed  %s\n", $out_file;
	#print end of file
	if ($#data_buffer < 0) {
	    printf $out_handle "%-24s EQU  *\n", sprintf("%s_END", uc($out_basename));
	}
	#close file
	$out_handle->close();
	$out_count++;
    }
}
