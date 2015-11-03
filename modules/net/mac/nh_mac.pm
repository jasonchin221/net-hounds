package net::mac::nh_mac;
use net::packet::nh_packet;
require Exporter;

@ISA = qw(Exporter);
@EXPORT = qw(
                nh_mac_packet_send
             );

sub nh_mac_packet_send {
    my $if = shift(@_);
    my $dmac = shift(@_);
    my $smac = shift(@_);
    my $proto = shift(@_);
    my $data = shift(@_);
    my $pkt;

    $pkt = $dmac.$smac.$proto.$data;
    $pkt = pack("H*",$pkt);
    &nh_packet_send($if, $pkt); 
}             

1;
