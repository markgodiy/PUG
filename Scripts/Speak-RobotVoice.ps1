function Speak-RobotVoice {
    param(
        $Text,
        $Gender
    )

Switch ($Gender) {
    Male {$voiceGender = [System.Speech.Synthesis.VoiceGender]::Male}
    Female {$voiceGender = [System.Speech.Synthesis.VoiceGender]::Female}
    Default {$voiceGender = [System.Speech.Synthesis.VoiceGender]::Male}
}

Add-Type -AssemblyName System.Speech

# Create an instance of SpeechSynthesizer
$synthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer

# Get the installed voices
$voices = $synthesizer.GetInstalledVoices()

# Find the voice with the desired gender

$voice = $voices | Where-Object { $_.VoiceInfo.Gender -eq $desiredGender }

# Set the voice of the synthesizer
$synthesizer.SelectVoice($voice.VoiceInfo.Name)

# Speak the text with the specified voice
$text = "Hello, I am a female voice."
$synthesizer.Speak($text)

}
    
Speak-RobotVoice