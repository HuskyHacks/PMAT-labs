# Challenge 2: SikoMode

Analyst,

This specimen came from a poor decision and a link that should not have been clicked on. No surprises there. We need to figure out the extent of what this thing can do. It looks a little advanced.

Perform a full analysis and send us the report when done. We need to go in depth on this one to determine what it is doing, so break out your decompiler and debugger and get to work!

IR Team

---

## Objective
Perform static and dynamic analysis on this malware sample and extract facts about the malware's behavior. Use all tools and skills in your arsenal! Be sure to include a limited amount of debugging and decompiling and employ advanced methodology to the extent that you are comfortable. 

Answer the challenge quesitons below. If you get stuck, the `answers/` directory has the answers to the challenge.


## Tools
Basic Analysis
- File hashes
- VirusTotal
- FLOSS
- PEStudio
- PEView
- Wireshark
- Inetsim
- Netcat
- TCPView
- Procmon

Advanced Analysis
- Cutter
- Debugger

## Challenge Questions:

- What language is the binary written in?
- What is the architecture of this binary?
- Under what conditions can you get the binary to delete itself?
- Does the binary persist? If so, how?
- What is the first callback domain?
- Under what conditions can you get the binary to exfiltrate data?
- What is the exfiltration domain?
- How does exfiltration take place?
- What URI is used to exfiltrate data?
- What type of data is exfiltrated (the file is cosmo.jpeg, but how exactly is the file's data transmitted?)
- What kind of encryption algorithm is in use?
- What key is used to encrypt the data?
- What is the significance of `houdini`?
