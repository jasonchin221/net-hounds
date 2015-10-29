#!/usr/bin/perl

use strict;
use warnings;
use lib 'modules';
use nh_common;
use net::dev::nh_dev;
use net::dns::nh_dns;
use Getopt::Std;

use vars qw($opt_i $opt_d $opt_g $opt_V $opt_H);
&getopts('i:d:g:HV');

my $net_hounds_name = "Net_Hounds";

sub usage {
    print ("usage: $0 -i [interface of network]\n");
    print ("\t\t\t\t-d [dest ip address]\n");
    print ("\t\t\t\t-g [gateway ip address]\n");
    print ("\t\t\t\t-V (version)\n");
    print ("\t\t\t\t-H (help)\n");
}

sub co_print_version {
    print ("$net_hounds_name v0.0.1\n");
}

if ($opt_H) {
    &usage;
    exit(1);
}

if ($opt_V) {
    &co_print_version;
    exit(0);
}

my $interface = $opt_i;
if (!$interface) {
    print("Please input interface name with -i\n");
    exit(1);
}

my @devs = &nh_netdev_list();
if (! &nh_array_exist($interface, \@devs)) {
    print("NetDev $interface not exist!\n");
    exit(1);
}

my $dest = $opt_d;
if (!$dest) {
    print("Please input dest ip with -d\n");
    exit(1);
}

my $gw = $opt_g;
if (!$gw) {
    print("Please input gateway ip with -g\n");
    exit(1);
}

my $ret = &nh_dns_spoof($interface, $dest, $gw);
exit($ret);
