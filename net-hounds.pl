#!/usr/bin/perl

use strict;
use warnings;
use lib 'modules';
use nh_common;
use net::dev::nh_dev;
use Getopt::Std;

use vars qw($opt_D $opt_L $opt_V $opt_H);
&getopts('DHVL');

my $net_hounds_name = "Net_Hounds";

my %nh_action_proc = (
    $nh_arp_spoof_name => \&nh_arp_spoof,
);


sub usage {
    print ("usage: $0 -D (list all net device of localhost)\n");
    print ("\t\t\t\t-L (list all actions)\n");
    print ("\t\t\t\t-V (version)\n");
    print ("\t\t\t\t-H (help)\n");
}

sub co_print_version {
    print ("$net_hounds_name v0.0.1\n");
}

if ($opt_H) {
    &usage;
    exit(0);
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

if ($opt_D) {
    my @devs;

    @devs = &nh_netdev_list();
    foreach my $dev (@devs) {
        print("$dev\n");
    }
    exit(0);
}

