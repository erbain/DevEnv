#!/usr/bin/env perl
# vim:ts=4:sw=4:expandtab
# © 2012 Michael Stapelberg, Public Domain

# This script is a simple wrapper which prefixes each i3status line with custom
# information. To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/i3status/contrib/wrapper.pl
# In the 'bar' section.

use strict;
use warnings;
# You can install the JSON module with 'cpan JSON' or by using your
# distribution’s package management system, for example apt-get install
# libjson-perl on Debian/Ubuntu.
use JSON;

# Don’t buffer any output.
$| = 1;

# Skip the first line which contains the version header.
print scalar <STDIN>;

# The second line contains the start of the infinite array.
print scalar <STDIN>;

my $vpn_status_cmd = q/nmcli con status | grep -oP '^(([^\s]+\s){1,}[\s]{2,}){4}yes.+$' | grep -oP '^.*?(?=\s{2,})'/;

# Read lines forever, ignore a comma at the beginning if it exists.
while (my ($statusline) = (<STDIN> =~ /^,?(.*)/)) {
    # Decode the JSON-encoded line.
    my @blocks = @{decode_json($statusline)};

    my $vpn_status = `$vpn_status_cmd`;
    chomp($vpn_status);
    @blocks = ({
        full_text => 'VPN: ' . $vpn_status,
        name => 'vpn',
        color => "#00FF00",
    }, @blocks) if $vpn_status;

    # Output the line as JSON.
    print encode_json(\@blocks) . ",\n";
}
