# Networking

[← Back to FAQ index](faq.md)

---

## FLARE-VM / REMnux / INetSim troubleshooting

Common issues and fixes for the lab network.

First steps: Reboot both guest VMs and ensure Windows Defender and Windows Firewall are off on FLARE-VM.

---

### FLARE-VM and REMnux cannot ping each other

Check:
- Both interfaces are Host-Only and on the same subnet.
- Both VMs have an IP address.
- NIC settings on both VMs.

---

### FLARE-VM can ping REMnux, but REMnux cannot ping FLARE-VM

Cause: FLARE-VM’s firewall is blocking ICMP (often not disabled by the installer).

Fix: Disable the Windows Firewall on the FLARE-VM host.

---

### REMnux has no IP on `ens[#]` (interface is DOWN)

On REMnux, run:

```bash
sudo dhclient
```

---

### Both have IPs and ping works, but INetSim doesn’t resolve IPs

- Check the INetSim config and confirm it’s bound to the correct IP.
- Don’t run INetSim with sudo—it can break things.

---

### INetSim works for IPs but not for DNS requests

🔺 This is the most common networking issues in this course. 🔺

Checklist:
- INetSim config:  - DNS service is uncommented.
  - DNS bind address is correct.
  - DNS default IP is set to REMnux’s IP.
- systemd-resolved is disabled (it and INetSim can’t both use port 53).
- FLARE-VM has REMnux set as both default gateway and DNS server.
- Proxy: Disable “Automatically detect settings” in Proxy settings.
- Chrome: Settings → Advanced → System → Open proxy settings — disable proxy there if needed.
- NPcap Loopback Adapter: Try disabling it; it can interfere with the network stack.

---

### Everything looks correct and DNS works for normal URLs, but malware DNS doesn’t show up

- Double-check your tool and filter settings.
- Clear the Windows DNS cache on FLARE-VM:

  ```cmd
  ipconfig /flushdns
  ```

---

### Does it matter which IP REMnux and FLARE-VM use?

No, as long as they’re on the same subnet and you configure FLARE-VM so that REMnux is its DNS server and default gateway.
