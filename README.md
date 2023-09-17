# PowerShell User Group

## Monad Manifesto

Back in Aug 8, 2002, Jeffrey Snover published the ["Monad Manifesto"](https://www.jsnover.com/Docs/MonadManifesto.pdf), which articulated the long term vision and started the development effort which became PowerShell. 

- "Monad Manifesto: Revisited", 2014, Video (1:12:10) https://youtu.be/j0EX5R2nnRI


## about_Powershell

PowerShell is an object-based distributed automation engine, scripting language, and command line shell.

*What is PowerShell?* https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-5.1#next-steps

## 3 cmdlets beginners should know

**1. Get-Command**  
**2. Get-Member**  
**3. Get-Help**

```powershell
# Use Get-Help to view the online guide and documentation for Get-Command and Get-Member

Get-Help Get-Command -online

Get-Help Get-Member -online
```

## Quick Guide: Checking Running Services in PowerShell

**:warning: Running code found on the internet can pose significant security risks, including malware, data loss, and system instability. Exercise extreme caution, verify the source, and prioritize your system's security and privacy:exclamation:**

**Example 1: Simple Copy and Paste**

1. **Open PowerShell**: Click the Start button, type "PowerShell," and press Enter.

2. **Copy and Paste**: Copy the following command and paste it into the PowerShell window:

   ```powershell
   Get-Service | Where-Object { $_.Status -eq 'Running' }
   ```

3. **Press Enter**: Hit Enter to execute the command.

   - You'll see a list of all running services on your computer, neatly filtered to show only the ones that are currently active.

**Example 2: Creating a Function**

1. **Open PowerShell**: Launch PowerShell if it's not already open.

2. **Create a Function**: Copy and paste the same code snippet from Example1 and encapsulate it as a function within a pair of curly braces. Give the function a descriptive verb-noun name, e.g., Get-RunningServices:

   ```powershell
   function Get-RunningServices {
       Get-Service | Where-Object { $_.Status -eq 'Running' }
   }
   ```

3. **Press Enter**: Hit Enter to create the function. Nothing will happen, but that's okay. The function is loaded in session. We just need to call it to run the code.

4. **Run the Function**: Now you can run your custom function anytime. Type `Get-RunningServices` at the prompt and press Enter.

   - The function will display a list of only the currently running services, making it easy to see what's active.

5. :information_source:Keep in mind that custom functions are only loaded in the current PowerShell session. Once you close the terminal, the function will be discarded. You'll need to reload it if you want to use it again. 

**Example 3: Saving and Running a Script**

1. **Create a PowerShell Script**:

   - Open Notepad or any text editor.
   - Copy and paste the following code into the editor:

   ```powershell
   # Save this as Get-RunningServices.ps1
   Get-Service | Where-Object { $_.Status -eq 'Running' }
   ```

2. **Save the File**: Go to "File" > "Save As."
   - Choose a location and name the file as `Get-RunningServices.ps1`.
   - Save it.

3. **Adjust Execution Policy**:

   - Open PowerShell as an Administrator (Right-click PowerShell and select "Run as Administrator").
   - Run the following command to allow the execution of PowerShell scripts:

   ```powershell
   Set-ExecutionPolicy RemoteSigned
   ```

   - Confirm with "Y" (Yes) when prompted.

4. **Execute the Script**:

   - Navigate to the directory where you saved `Get-RunningServices.ps1`.
   - Run the script by typing `.\Get-RunningServices.ps1` and pressing Enter.

   - You'll see a list of running services, just like in Example 1, but with the added filter to show only the active ones.

Now, you can explore running services in a more engaging way by filtering and customizing your PowerShell commands and scripts. Happy scripting!


