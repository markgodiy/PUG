
# Learn how to display a pop-up window by using Windows PowerShell.
From the PowerShell Scripting Blog series, 
https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-display-pop-up-window/

Hey, Scripting Guy! 

Question: How can I use Windows PowerShell to display a pop-up window to a user when a script or function has completed?

Answer: There are several ways to display a pop-up window, but the following command doesn’t require loading assemblies prior to creating the window:


Example: 
```
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Operation Completed",0,"Done",0x1)
```

![image](https://github.com/markgodiy/PUG/assets/101022486/3bbe3f17-361e-4f7f-8912-f35464c17a94)
