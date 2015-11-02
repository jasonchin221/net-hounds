#!/usr/bin/perl

use strict;
use warnings;
use lib 'modules';
use net::packet::nh_packet;
use Getopt::Std;

my $arp_request="ff ff ff ff ff ff 00 30 18 cc 89 70 08 06 00 01 08 00 06 04 00 01 00 30 18 cc 89 70 c0 a8 01 64 00 00 00 00 c0 a8 01 01";
$arp_request = unpack("a*",$arp_request);
$arp_request = pack("H*",$arp_request);
nh_packet_send("lo", $arp_request); 
