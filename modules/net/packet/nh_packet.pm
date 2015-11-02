package net::packet::nh_packet;
use Net::Pcap;
require Exporter;

@ISA = qw(Exporter);
@EXPORT = qw(
                nh_packet_send
             );

sub nh_packet_send {
    my $if = shift(@_);
    my $data = shift(@_);
    my $err;

    my $pcap = Net::Pcap::open_live($if, 1000, 1, 1, \$err);
    Net::Pcap::sendpacket($pcap, $data);
}

1;
