function Speak-RobotVoice {
    param(
    $phrase
    )
    Add-Type -AssemblyName System.Speech
    $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $Phrase = Read-Host "What do you want the robot to say?"
    $SpeechSynth.Speak($phrase)
            
    }
    
    Speak-RobotVoice