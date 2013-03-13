#!/bin/bash 

if [ ! -d hosts ]; then
	mkdir hosts
fi

if [ ! -d nmap ]; then
	mkdir nmap
fi

if [ ! -d logs ]; then
	mkdir logs
fi

if [ ! -d resource_scripts ]; then
	echo "What the F*3k did you do!?" >&2 
	exit DYING
fi


msfconsole -r resource_scripts/meter_resource_nmap_os.rc
grep -e "Windows\",\"7" hosts/targets.csv | cut -d',' -f1 | tr -d '"' > hosts/win_workstations.txt 
grep -e "Windows\",\"XP" hosts/targets.csv | cut -d',' -f1 | tr -d '"' >> hosts/win_workstations.txt 
grep -e "Windows\",\"Vista" hosts/targets.csv | cut -d',' -f1 | tr -d '"' >> hosts/win_workstations.txt 

grep -e "Windows\",\"20" hosts/targets.csv | cut -d',' -f1 | tr -d '"' > hosts/win_servers.txt
grep -e "Windows\",\"Server" hosts/targets.csv | cut -d',' -f1 | tr -d '"' >> hosts/win_servers.txt

grep -e "\"Linux\",\"" hosts/targets.csv | cut -d',' -f1 | tr -d '"' > hosts/linux.txt
grep -e "\"FreeBSD\",\"" hosts/targets.csv | cut -d',' -f1 | tr -d '"' >> hosts/linux.txt
grep -e "\"Sun OpenSolaris\",\"" hosts/targets.csv | cut -d',' -f1 | tr -d '"' >> hosts/linux.txt

cat hosts/win_*.txt > hosts/windows.txt

msfconsole -r resource.rc
mv *.log logs
grep "[+]" logs/*.log >> results.log
