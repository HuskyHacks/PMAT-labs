# simpleAntiAnalysis-cpp.exe
A simple anti-analysis POC sample written in C++. Invokes the IsDebuggerPresent() API call to check for a debugger at runtime.

**Note**: This sample is a proof of concept and does not perform any malicious activity when detonated. The payload for this sample is a Windows Message Box that says "BOOM!". The sample is not zipped and password protected because it is completely benign.