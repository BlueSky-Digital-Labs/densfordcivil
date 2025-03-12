![BlueSky Logo](/!README/BlueSkyEmailSignature.png)
# uPhoria
### Tools Directory

---
The tools directory contains any useful scripts (.sh, .cmd, .scpt) that are useful.

Examples of scripts we could include:
- Build Testing
- Vulnerability Analysis
- Image Optimisaion

---

## Developer Notes
For any scripts that you add to the folder, please ensure the scripts contain a header that explains what the script
is used for. An example header is below

```sh
#!/bin/sh
# example.sh ###########################################################################################################
# Author: BlueSky Developer
# This is an example script that showcases an example script header
########################################################################################################################
echo "Hello World!"

 ```

----

## Troubleshooting
For any scripts that are in this folder, you may need to add execution permissions before you can run them.

### Linux
```sh
chmod +x [name of script].sh
```

### MacOS

Shell scripts (.sh)
```sh
chmod +x [name of script].sh
```

For Automator Scripts (.scpt)
1. Navigate to the tools directory using Finder
2. Right-Click the script
3. Click on "Open"
4. On the warning dialog, click on "Open"

### Windows
1. Navigate to the tools directory using Windows Explorer (Win+E)
2. Right-Click the script
3. Click on "Properties"
4. On the bottom of the properties window, Click on "Unblock"
5. Try running the script again
