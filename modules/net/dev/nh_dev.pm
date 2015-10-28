package net::dev::nh_dev;
require Exporter;
use Tie::File;
use nh_common;

@ISA = qw(Exporter);
@EXPORT = qw(
                nh_netdev_list 
             );

my $nh_proc_dev = "/proc/net/dev";

sub nh_netdev_list {
    my @devs;
    my @file_array;
    my @sp;

    tie(@file_array,'Tie::File', $nh_proc_dev) or die("Open $nh_proc_dev failed!\n");
    foreach my $l (@file_array) {
        if ($l =~ /:/) {
            @sp = split(/:/, $l);
            push(@devs, nh_remove_space_front_back($sp[0]));
        }
    }
    untie(@file_array);

    return @devs;
}            


1;
