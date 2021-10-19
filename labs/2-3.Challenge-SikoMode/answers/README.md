# Challenge Answers

Q: What language is the binary written in?

A: The binary is written in Nim. You can tell from pulling the strings from the binary and identifying the string references to Nim libraries. This is also indicated by the existence of the NimMain, NimMainInner, and NimMainModule methods present in the binary.

---

Q: What is the architecture of this binary?

A: This is a x64 (64-bit CPU) binary, which can be determined by loading the binary into PE-Studio. More specifically, the binary contains assembly instructions and memory registers specific to x64 assembly. It's worth noting that this concept has not been introduced in the course at this point, so determining the architecture by inspecting the assembly is considered a bonus.

---

Q: Under what conditions can you get the binary to delete itself?

A: `unknown.exe` deletes itself in the following contexts:
- If the executable is run and cannot make a successful connection to the initial callback URL (hxxp://update.ec12-4-109-278-3-ubuntu20-04.local)
- If the executable is interrupted in the middle of its exfiltration routine (i.e. if INetSim is shut off while the binary is exfiltrating data)
- If the executable finishes its exfiltration routine


---

Q: Does the binary persist? If so, how?

A: There is no persistence mechanism used by this malware.

---

Q: What is the first callback domain?

A: The first callback domain is `hxxp://update.ec12-4-109-278-3-ubuntu20-04.local`, which is not present in the strings of the sample. This is because this URL is assembled in a loop at runtime and therefore doesn't show up in the strings/FLOSS output. The sample attempts to contact this domain at execution.

---

Q: Under what conditions can you get the binary to exfiltrate data?

A: If the binary contacts the initial callback domain successfully, exfiltration occurs. After a successful check in with this domain, the sample unpacks the `passwrd.txt` file into `C:\Users\Public\`,  opens a handle to `cosmo.jpeg`, base64 encodes the contents of the file, and begins the data encryption routine. 

---

Q: What is the exfiltration domain?

A: Exfiltration is achieved with the `hxxp://cdn.altimiter.local` domain.

---

Q: What URI is used to exfiltrate data?

A: The URI used is `http://cdn.altimiter.local/feed?post=[data]`, where `[data]` is the encrypted and base64 encoded data pulled from the `cosmo.jpeg` file sent in chunks.

---

Q: What type of data is exfiltrated (the file is cosmo.jpeg, but how exactly is the file's data transmitted?)

A: The file data from `cosmo.jpeg` is read in by the malware, then encrypted using the contents of `passwrd.txt` as the key. 

---

Q: What kind of encryption algorithm is in use?

A: The algorithm is RC4. This can be determined by either inspecting the imported libraries (easy) or following the `sym.stealstuff()` routine in the decompiled code (much, much harder). The `sym.stealstuff()` routine calls the `toRC4` method after opening the handle to  `cosmo.jpeg` and converting the contents to base64.

---

Q: What key is used to encrypt the data?

A: The key is the contents of `passwrd.txt`, which is the text `SikoMode`.

---
Q: What is the significance of `houdini`?

A: `houdini` refers to the method call that makes the binary delete itself from disk. This method call is invoked in a few different instances, which are covered in the third question in this challenge. This method call can be observed in the strings of the binary and in the decompiled output in Cutter.
