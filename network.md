# marc.cx Network
10.0.0.0/8

# Site 1 (Home)
10.1.0.0/16

## VLANs
110 Management 10.1.10.1/24 (IMPI, iDrac, Hypervisors)
150 LAN 10.1.50.1/24 (Workstations, Desktop VM's) [Can access 151, 160]
151 Internal Wifi 10.1.51.1/24 (Laptops, trusted phones/devices) [Can access 150, 160]
160 IoT Devices 10.1.60.1/24 (Lights, Thermostat) [Limited WAN access]
170 Guest Wifi 10.1.70.1/24 (Guests) [WAN only]
180 Plex (10.1.80.1/24) (Plex servers) [Limited access]
190 VPN (10.1.90.1/24)

