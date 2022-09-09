# Challenge Answers

Q: Record any observed symptoms of infection from initial detonation. What are the main symptoms of a WannaCry infection?

A: Symptoms include:

- Changed wallpaper on the infected host.
-	A program window indicating the host has been infected that has a countdown timer and pay buttons.
-	Encryption of files on the host's file system. Files are encrypted and appended with a `.WNCRY` extension.
-	The appearance of a @WanaDecryptor@ executable and a @Please_Read_Me@ text file on the desktop.

---

Q: Use FLOSS and extract the strings from the main WannaCry binary. Are there any strings of interest?

A: The most interesting strings are URLs. FLOSS identifies one that is built on the stack at runtime (a **stackstring**) that contains a long, unpronounceable website name.
```
http://www.iuqerfsodp9ifjaposdfjhgosurijfaewrwergwea.com
```

 Other strings of interest include UNC paths that call to different remote shares (`\\192.168.56.20\IPC$`, `\\192.168.56.20\IPC$`), a bunch of language pack files in a `msg` directory  (`msg/m_korean.wnry`, etc), and the following:

 ```
%s -m security
C:\%s\qeriuwjhrf
tasksche.exe
icacls . /grant Everyone:F /T /C /Q
WNcry@2ol7
 ```

---

Q: Inspect the import address table for the main WannaCry binary. Are there any notable API imports?

A: Interesting API calls include:
- CryptGetRandom
- CryptAcquireContextA
- InternetOpenA
- InternetOpenUrl
- CreateServiceA
- ChangeServiceConfig2A


---

Q: What conditions are necessary to get this sample to detonate?

A: The binary attempts to initiate a connection with the weird URL
```
http://www.iuqerfsodp9ifjaposdfjhgosurijfaewrwergwea.com
```
If a connection is not established, the rest of the ransomware payload is executed.

If a connection is established, the program exits without executing the rest of the ransomware payload.

In a lab setting, this means that INetSim must be turned off in order to detonate the sample.

---

Q: **Network Indicators**: Identify the network indicators of this malware

A: Network indicators of this sample include:

- Attempted access of the weird URL.
- A flood of numerous SMB connection requests to non-private remote addresses.
- A secondary process, taskhsvc.exe, opens port 9050 to a LISTENING state and attempts to connect to non-private remote addresses over HTTPS.

---

Q: **Host-based Indicators**: Identify the host-based indicators of this malware.

A: Host-based indicators for this sample include:

- A new directory with a random character name is created in C:\ProgramData.
- The directory is set to hidden.
- This new directory contains many unpacked artifacts from WannaCry's initial detonation.
The artifacts include the taskhsvc.exe executable and a "Tor" directory that unpacks a "tor" program.
- A new service is created to start tasksche.exe as a persistent executable.

---

Q: Use Cutter to locate the killswitch mechanism in the decompiled code and explain how it functions.

A: The killswitch operates like this:

- In the main function of WannaCry, the string of the killswitch URL is moved into ECX.
- The arguments for InternetOpenA are pushed onto the stack. The boolean result of InternetOpenA is moved into EAX.
- The arguments for InternetOpenUrlA are pushed onto the stack, including the killswitch URL.
The result of InternetOpenUrlA is moved into EAX. Then, this result is also moved into EDI.
- The handle is closed and the program compares the value of EDI to 0 (comparing a boolean true or false).
- If the value is 0, WannaCry makes a call to the first function in the payload.
- Else, WannaCry exits without triggering the payload.



