function Speak-RobotVoice {
    
    <#
    .DESCRIPTION
    Author: Mark Go,
    Purpose: Text-to-speech applications. 
    
    #>
    param(
        [Parameter(Mandatory = $true)]$Text,
        $Gender
    )

    # Load Assembly for Spech Synthesizer
    Add-Type -AssemblyName System.Speech

    # Create an instance of SpeechSynthesizer
    $synthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer

    # Define variable based on Gender input, or set to Default
    Switch ($Gender) {
        Male { $voiceGender = [System.Speech.Synthesis.VoiceGender]::Male }
        Female { $voiceGender = [System.Speech.Synthesis.VoiceGender]::Female }
        Default { $voiceGender = [System.Speech.Synthesis.VoiceGender]::Male }
    }

    # Get installed voices
    $voices = $synthesizer.GetInstalledVoices()

    # Find the voice with the desired gender
    $voice = $voices | Where-Object { $_.VoiceInfo.Gender -eq $voiceGender }

    # Set the voice of the synthesizer
    $synthesizer.SelectVoice($voice.VoiceInfo.Name)

    # Speak the text with the specified voice
    $synthesizer.Speak($text)

}

# Write-Output " Function: 'Speak-RobotVoice' has been loaded."