# Boss Fight - WannaCry
A challenger approaches! This is everything you've been training for, Analyst. Get in there and do your job!

## WannaCry
In the early summer of 2017, WannaCry was unleashed on the world. Widely considered to be one of the most devastating malware infections to date, WannaCry left a trail of destruction in its wake. WannaCry is a classic ransomware sample; more specifically, it is a ransomware cryptoworm, which means that it can encrypt individual hosts and had the capability to propagate through a network on its own.

## Objective
Perform a full analysis of WannaCry and answer the questions below.

## Challenge Questions
- Record any observed symptoms of infection from initial detonation. What are the main symptoms of a WannaCry infection?
- Use FLOSS and extract the strings from the main WannaCry binary. Are there any strings of interest?
- Inspect the import address table for the main WannaCry binary. Are there any notable API imports?
- What conditions are necessary to get this sample to detonate?
- **Network Indicators**: Identify the network indicators of this malware
- **Host-based Indicators**: Identify the host-based indicators of this malware. 
- Use Cutter to locate the killswitch mechanism in the decompiled code and explain how it functions.