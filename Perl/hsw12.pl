#! /usr/bin/env perl
##################################################################################
#                                    HSW12                                       #
##################################################################################
# file:    hsw12.pl                                                              #
# author:  Dirk Heisswolf                                                        #
# purpose: HSW12 IDE                                                             #
##################################################################################
# Copyright (C) 2003-2009 by Dirk Heisswolf. All rights reserved.                #
# This file is part of "HSW12". HSW12 is free software;                          #
# you can redistribute it and/or modify it under the same terms as Perl itself.  #
##################################################################################
=pod
=head1 NAME

hsw12.pl - HSW12 IDE

=head1 SYNOPSIS

 hsw12.pl
 hsw12.pl asm_source.s 
 hsw12.pl hsw12_session.hsw12

=head1 REQUIRES

perl5.005, hsw12_gui, Tk, FindBin

=head1 DESCRIPTION

This script invokes the HSW12 GUI.

=head1 METHODS

=over 4

=item hsw12.pl <file name>

 Starts the HSW12 IDE. 
 This script reads one optional argument:
     1. file name: assembler source code (*.s) or 
                   HSW12 session file (*.hsw12)

=back

=head1 AUTHOR

Dirk Heisswolf

=head1 VERSION HISTORY

=item V00.00 - Feb 9, 2003

=over 4

initial release

=back

=cut

#################
# Perl settings #
#################
use 5.005;
#use warnings;
use Tk;
use FindBin qw($RealBin);
use lib $RealBin;
require hsw12_gui;

$gui = hsw12_gui->new(shift @ARGV);

#print "MainLoop\n";
MainLoop;
