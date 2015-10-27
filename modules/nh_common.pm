package nh_common;
require Exporter;
use Tie::File;
use Cwd;

@ISA = qw(Exporter);
@EXPORT = qw(
                nh_array_exist nh_remove_space_front_back 
                $nh_arp_spoof_name 
             );

$nh_arp_spoof_name = "arp_spoof";

sub nh_array_exist {
    my $key = shift(@_);
    my $array = shift(@_);
    my @output;

    @output = grep(/^$key$/, @$array);
    foreach my $a (@output) {
        if ($a eq $key) {
            return 1;
        }
    }

    return 0;
}

#去掉前后空格 
sub nh_remove_space_front_back {
    my ($str) = @_;

    $str =~ s/^(\s+)|(\s+)$//g;

    return $str;
}


1;
