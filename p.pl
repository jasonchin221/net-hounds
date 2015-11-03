#!/usr/bin/perl

use strict;
use warnings;
use lib 'modules';
use net::mac::nh_mac;
use Getopt::Std;

my $if = "vmnet1";
my $dmac = "ffffffffffff";
my $smac = "003018cc8970";
my $proto = "0806";
my $data = "0001080006040001003018cc8970c0a8016400000000c0a80101";

&nh_mac_packet_send($if, $dmac, $smac, $proto, $data);
