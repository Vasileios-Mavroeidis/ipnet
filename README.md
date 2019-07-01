# ipnet
IPv4 Validator - Calculator - Decimal to Binary - Wildcard


### Description

ipnet.R contains three functions:

1. ipnet()
   - Takes as input an IP address and its associated routing prefix (CIDR) or an IP address and its associated Subnet mask
   - The input can be given as user input by running ipnet() or given directly as part of the function. For example ipnet("192.168.1.1/24")
   - Validates that the CIDR or the IP address and Subnet mask are given in the appropriate format
   - The outputs of the function are the following variables:
      - ip: the given IP
      - netmask: the associated netmask of the IP
      - prefix: the associated prefix
      - total_addresses: total addresses (usable hosts + network address + broadcast address)
      - usable_hosts: the number of usable hosts (total addresses - 2)
      - wildacard: the wildcard (used with routing protocols or access control lists)
      - binary_ip: The given IP in binary format
      - binary_subnet: The given subnet mask in binary format
   
2. dec_to_binary()
   - transforms IPs and Subnet masks from decimal to binary
   
3. print.ipnet()
   - Prints the variables generated from the ipnet() function. Used after running ipnet()
