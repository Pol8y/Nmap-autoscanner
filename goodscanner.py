import socket
import subprocess

def is_valid_ip(ip_address):
    try:
        socket.inet_aton(ip_address)
        return True
    except OSError:
        return False

# Prompt the user for the IP address to scan
attempts = 0
while True:
    ip_address = input("Enter the IP address to scan (e.g. 192.168.1.1): ")
    if is_valid_ip(ip_address):
        break
    else:
        attempts += 1
        if attempts >= 3:
            print("\nAn IP address is a numerical label assigned to each device connected to a computer network that uses the Internet Protocol for communication. "
                  "IP addresses are written and displayed in human-readable notation, such as 192.168.1.1, instead of the binary format used by computers. "
                  "The range of valid IP addresses is 0.0.0.0 to 255.255.255.255. Please try again.\n")
        else:
            print("Invalid IP address. Please try again. (e.g. 192.168.1.1)")

# The port range to scan
port_range = range(1, 65535)

# Create an empty string to store the open ports
open_ports = ""

# Iterate over the ports and try to connect to each one
for port in port_range:
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(0.5)
        result = s.connect_ex((ip_address, port))
        if result == 0:
            # Append the open port to the open_ports string
            open_ports += str(port) + ","
        s.close()
    except Exception:
        pass

# Remove the trailing comma from the open_ports string
open_ports = open_ports[:-1]

# Run nmap on the IP address and open ports, using the -A and -vv options
subprocess.run(["nmap", "-p", open_ports, "-A", "-vv", ip_address])
