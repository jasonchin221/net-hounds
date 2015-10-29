package net::nh_middle_attack;
use Net::Pcap::Easy;

@ISA = qw(Exporter);
@EXPORT = qw(
                nh_ma_proc
             );

my $src_mac_key = "src_mac";            
my $dst_mac_key = "dest_mac";            
my $src_ip_key = "src_ip";            
my $dst_ip_key = "dest_ip";            
my $src_port_key = "src_port";            
my $dst_port_key = "dest_port";            

sub nh_ma_udp_callback {
        my ($npe, $ether, $ip, $udp, $header ) = @_;
 
        print "UDP $ip->{src_ip}:$udp->{src_port}"
         . " -> $ip->{dest_ip}:$udp->{dest_port}\n";
 
        print "\t$ether->{src_mac} -> $ether->{dest_mac}\n";
}

sub nh_ma_default_callback {
}

sub nh_ma_proc {
    my $if = shift(@_);
    my $target = shift(@_);

    my $npe = Net::Pcap::Easy->new(
        dev              => $if,
        filter           => "host $target",
        packets_per_loop => 10,
        bytes_to_capture => 1024,
        promiscuous      => 0,

        udp_callback => \&nh_ma_udp_callback,
        default_callback => \&nh_ma_default_callback,
    );

    1 while $npe->loop;
}
