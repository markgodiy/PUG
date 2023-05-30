function Get_weather {
    "Weather Forecast From Weather.gov`r`n"
    (New-Object -com "Wscript.Shell").SendKeys("{SCROLLLOCK}{SCROLLLOCK}")
    try {        
        $weathergov_api = invoke-restmethod "https://api.weather.gov/points/38.9,-77.1"
        $4cast = invoke-restmethod $weathergov_api.properties.forecast
        $4cast.properties.periods | ForEach-Object { 
            $currentDate = get-date
            $weatherDate_start = Get-Date $_.startTime
            $weatherDate_end = Get-Date $_.endTime
            If ($weatherDate_start.Day -like $currentDate.day) {
                Write-Host "$($_.name) ($($weatherDate_start.Hour):00 until $($weatherDate_end.Hour):00) -- $($_.detailedForecast)"
                "`r`n"
            }
        }
    }
    catch {
        "`r`n"
        "Unable to get Weather API resource."
        "`r`n"
    }
}