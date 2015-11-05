package net::ipv4::nh_ip;
require Exporter;
require 'sys/ioctl.ph';
use Socket;

@ISA = qw(Exporter);
@EXPORT = qw(
                nh_ip_get 
                $nh_ipv4_id 
             );

$nh_ipv4_id = "0800";

sub nh_get_ip_address($) {
    my $pack = pack("a*", shift);
    my $socket;

    socket($socket, AF_INET, SOCK_DGRAM, 0);
    ioctl($socket, SIOCGIFADDR(), $pack);

    return inet_ntoa(substr($pack,20,4));
};

sub nh_ip_get {
    my $if = shift(@_);

    return &nh_get_ip_address($if);
}            


1;
