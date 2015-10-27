package net::arp::nh_arp;
use Net::ARP;
require Exporter;

@ISA = qw(Exporter);
@EXPORT = qw(
                nh_arp_spoof 
             );

sub nh_arp_send_reply {
    my $if = shift(@_);

    Net::ARP::send_packet($if,                 # Device
        '127.0.0.1',          # Source IP
        '127.0.0.1',          # Destination IP
        'aa:bb:cc:aa:bb:cc',  # Source MAC
        'aa:bb:cc:aa:bb:cc',  # Destinaton MAC
        'reply');             # ARP operation
}            

sub nh_arp_spoof {
    my $it = shift(@_);

    print("PPP\n");
    &nh_arp_send_reply(@_); 
}

1;
