#!/usr/bin/perl -w

use strict;
use IO::Select;
use IO::Socket;

my ($data, $fh);

my $ipc_select = IO::Select->new();

my $IPC_SOCKET = new IO::Socket::INET(Listen    => 5,
									LocalAddr => 'localhost',
									LocalPort => 9000,
									Proto   => "tcp" );

print "SOCKET = $IPC_SOCKET\n";

$ipc_select->add($IPC_SOCKET);
print "Listening...\n";
while (1) {
	if (my @ready = $ipc_select->can_read(.01)) {
        foreach $fh (@ready) {
			if($fh == $IPC_SOCKET) {
                #add incoming socket to select
				my $new = $IPC_SOCKET->accept;
				$ipc_select->add($new);
				print "incoming connection...\n";
			} else {
                # Process socket
				if (recv $fh,$data,1024,0) {
					print $fh $data;
					print "$data";
				} else {
	                $ipc_select->remove($fh);
					$fh->close;
				}
            }
		}
	}
}