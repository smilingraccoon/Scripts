#!/bin/bash
 
#input hosts using a file
hosts=file:./hosts.txt
#scan a range of hosts
#hosts=192.168.1.1/24
threads=25
 
#run smb_version across the network and write it to a file
echo "[*] Running smb_version"
msfcli auxiliary/scanner/smb/smb_version \
RHOSTS=$hosts \
THREADS=$threads E \
> smb_version.txt
echo "[*] Done running smb_version see smb_version.txt"
 
#use msf to fine anonymous ftp servers
echo "[*] Looking for anonymous ftp"
msfcli auxiliary/scanner/ftp/anonymous \
RHOSTS=$hosts \
THREADS=$threads E \
> anonymous_ftp.txt
echo "[*] Done looking for anoymous ftp see anonymoust_ftp.txt"
 
#look for vulerable jboss servers
echo "[*] Looking for vulnerable jboss servers"
msfcli auxiliary/scanner/http/jboss_vulnscan \
RHOSTS=$hosts \
THREADS=$threads E \
> jboss_vuln.txt
echo "[*] Done looking for vulnerable jboss servers see jboss_vuln.txt"
 
#look for open x11 servers
echo "[*] Looking for anonymous x11 servers"
msfcli auxiliary/scanner/x11/open_x11 \
RHOSTS=$hosts \
THREADS=$threads E \
> anonymous_x11.txt
echo "[*] Done looking for anonymous x11 servers see anonymous_x11.txt"
 
#look for anonymous vnc servers
echo "[*] Looking for anonymous VNC servers"
msfcli auxiliary/scanner/vnc/vnc_none_auth \
RHOSTS=$hosts \
THREADS=$threads E \
> anonymous_vnc.txt
echo "[*] Done looking for anonymous VNC servers see anonymous_vnc.txt"
 
#look for cisco ios auth bypass servers
echo "[*] Looking for Cisco auth bypass"
msfcli auxiliary/scanner/http/cisco_ios_auth_bypass \
RHOSTS=$hosts \
THREADS=$threads E \
> cisco_auth_bypass.txt
echo "[*] Done looking for Cisco auth bypass see cisco_auth_bypass.txt"
 
#look for nfs mounts
echo "[*] Looking for anonymous NFS"
msfcli auxiliary/scanner/nfs/nfsmount \
RHOSTS=$hosts \
THREADS=$threads E \
> nfs_mounts.txt
echo "[*] Done looking for anonymous NFS see nfs_mounts.txt"

#look for default apache tomcat
echo "[*] Looking for anonymous NFS"
msfcli auxiliary/admin/http/tomcat_administration \
RHOSTS=$hosts \
THREADS=$threads E \
> tomcat.txt
echo "[*] Done looking for anonymous NFS see nfs_mounts.txt"