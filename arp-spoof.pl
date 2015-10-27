#!/usr/bin/perl

use strict;
use warnings;
use lib 'modules';
use nh_common;
use net::dev::nh_dev;
use net::arp::nh_arp;
use Getopt::Std;

use vars qw($opt_t $opt_i $opt_d $opt_r $opt_L $opt_V $opt_H);
&getopts('t:s:i:d:r:HVL');

my $net_hounds_name = "Net_Hounds";

my %nh_action_proc = (
    $nh_arp_spoof_name => \&,
);


sub usage {
    print ("usage: $0 -t [interval of send ARP packet]\n");
    print ("\t\t\t\t-i [interface of network]\n");
    print ("\t\t\t\t-d [dest ip address1]\n");
    print ("\t\t\t\t-r [dest ip address2]\n");
    print ("\t\t\t\t-L (list all actions)\n");
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

if ($opt_L) {
    foreach my $action (keys %nh_action_proc) {
        print("$action\n");
    }
    exit(0);
}

my $interval = $opt_t;
if (! $interval || $interval <= 0) {
    $interval = 1;
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

my $dest1 = $opt_d;
if (!$dest1) {
    print("Please input dest1 ip with -d\n");
    exit(1);
}

my $dest2 = $opt_r;
if (!$dest2) {
    print("Please input dest2 ip with -r\n");
    exit(1);
}

my $ret = &nh_arp_spoof($interval, $interface, $dest1, $dest2);
exit($ret);
