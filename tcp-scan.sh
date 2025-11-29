#!/usr/bin/bash
# A script I made because rustscan just filters all of the ports because it's too fast. So I just wanted to make this script so that I can actually freaking enumerate

target=$1

if [[ -z "$target" ]]; then
    echo "Usage: $0 <target>"
    exit 1
fi

mkdir -p nmap

cmd1="nmap -p- --min-rate=500 -vv -Pn $target -oN nmap/initial"
echo "[+] Running initial scan: $cmd1"
bash -c "$cmd1"

initial_file="nmap/initial"

# Separate ports
ports=$(awk '/open/ {split($1,a,"/"); print a[1]}' "$initial_file" | paste -sd, -)

if [[ -z "$ports" ]]; then
    echo "[!] No open ports found. Exiting."
    exit 1
fi

echo "[+] Open ports: "$ports""

cmd2="nmap -p $ports -sC -sV -Pn $target -oN nmap/full-tcp"
echo "[+] Running enumeration scripts: $cmd2"
bash -c "$cmd2"
