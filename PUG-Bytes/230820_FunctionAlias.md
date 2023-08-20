Define aliases for a function within the function script itself using the `CmdletBinding` attribute and the `Alias` parameter. Here's how you can do it:

```powershell
function Get-SecretItem {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [Alias("gsi")]
    param (
        [string]$Name
    )
    
    # Function code here
}
```

In the above example, the `Alias` parameter within the `CmdletBinding` attribute assigns the alias "gsi" to the `Get-SecretItem` function. Now you can use both the full function name (`Get-SecretItem`) and the alias (`gsi`) to call the function:

```powershell
Get-SecretItem -Name "MySecret"
# or
gsi -Name "MySecret"
```

----

In PowerShell, you can assign aliases to functions using the `Set-Alias` cmdlet. To create an alias for your function, follow these steps:

1. Define your function with the desired name (e.g., `Get-SecretItem`).
   
   ```powershell
   function Get-SecretItem {
       param (
           [string]$Name
       )
       # Function code here
   }
   ```

2. Create an alias using the `Set-Alias` cmdlet. Specify the alias name (e.g., `gsi`) and the target function name (`Get-SecretItem`).

   ```powershell
   Set-Alias -Name "gsi" -Value "Get-SecretItem"
   ```

Now, you can use the alias `gsi` to call the `Get-SecretItem` function. For example:

```powershell
gsi -Name "MySecret"
```

---------

Remember that defining aliases within the function script itself can be helpful for providing convenience, but it's important to document these aliases properly to ensure that other users understand the available options for invoking the function.