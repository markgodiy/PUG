# Monad Manifesto: Summary

The Monad Manifesto, published in 2002 by Jeffrey Snover, outlines the key concepts and principles behind the Monad scripting language, which later evolved into Windows PowerShell. Here is a summary of the Monad Manifesto with bullet points for each key concept:

------------------

- **Focus on Administrators**: The Monad Manifesto emphasizes the primary target audience of administrators and system operators, aiming to provide them with a powerful and flexible toolset for managing and controlling systems effectively.

-------------------

- **Command-Driven Automation**: The Monad Manifesto emphasizes the need for a powerful command-driven automation system that enables administrators to efficiently manage and control their systems through simple and consistent commands.

- **Consistent Naming Conventions**: Monad promotes consistent naming conventions for commands and their parameters to ensure discoverability and ease of use. The Manifesto highlights the importance of intuitive and self-descriptive command names.

- **Discoverable Metadata**: Monad emphasizes the inclusion of metadata and documentation with commands to make them easily discoverable and provide users with comprehensive information about their usage, input, and output.


```
# Verb-Noun Naming Convention/Pattern
Get-Command

# Start a process (application/file)
# Default applications
Start-Process -Path "C:\Temp\Example.txt"

# Get a list of running processes
Get-Process

# Stop a specific process
Stop-Process -Name "MyProcess"


# Start and stop services
Start-Service -Name "MyService"
Stop-Service -Name "MyService"

# Create a new directory
New-Item -Path "C:\NewFolder" -ItemType Directory

# Remove a file
Remove-Item -Path "C:\OldFile.txt"
```

```
Get-Command -ParameterName ComputerName
```

---------------------
- **Object-Based Pipelining**: Monad introduces the concept of object-based pipelining, where the output of one command can be directly passed as input to another command. This enables seamless integration and composition of commands to perform complex operations.

```
# Get all cmdlets and filter based on the pipeline input
$cmdlets = Get-Command -CommandType Cmdlet |
           Where-Object { $_.Parameters.Values.IsPipelineValue }
# Display the filtered cmdlets
$cmdlets
```

- **Command Composition**: Monad supports command composition, allowing users to create new commands by combining existing commands. This enables the creation of powerful and reusable command sequences to automate complex tasks.

- **Scriptability**: The Manifesto highlights the significance of scriptability, enabling administrators to write scripts to automate repetitive tasks and orchestrate complex operations. Monad provides a rich scripting language that is concise, expressive, and capable of handling diverse automation scenarios.


--------------------------------

- **Consistent Data Access**: Monad promotes consistent access to different types of data, including file systems, registries, and other structured data sources. It provides a unified approach to data access through a set of intuitive and consistent commands.

```
Get-PsDrive

Set-Location (alias: cd)
```

- **Integration with Existing Tools**: The Manifesto acknowledges the importance of integrating with existing tools and systems. Monad provides mechanisms for interoperability with COM, .NET, WMI, and other technologies, allowing administrators to leverage their existing investments.


```
Find-Module
```

# Summary of Summary
These key concepts laid out in the Monad Manifesto formed the foundation for the development of Windows PowerShell, which has become a widely adopted automation and scripting platform in the Windows ecosystem.
