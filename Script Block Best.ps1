function Get-Weather {

#The $userLoc variable will prompt the user for a City and State, and then store the user's input. example: Tacoma WA
$userLoc = read-host -prompt 'Please enter a city and state'
$userDays = read-host -prompt 'Please enter number of days for forecast'
$userUnit = read-host -prompt 'Please enter unit: C or F'
$int = [int] $userDays

#The $formatLoc variable takes the users input, replaces any spaces with '+', and stores that value. example: Tacoma+WA
$formatLoc = $userLoc -replace(' ', '+') 
$forecastSeconds = $int * 86400

#Adds the location into the url for the API
$googleGeoJSON = "https://maps.googleapis.com/maps/api/geocode/json?address=" + $formatloc + "&key=AIzaSyDGT-1IEg0NHsXiLAtntLxAFctMttHwTao"
$Darkskydata = "https://api.darksky.net/forecast/93dcf96ac1507b0bc9c572e244f7b633/" + $varLat + "," + $varLng + "," + $forecastSeconds + ",[us]"
#Invoke URL
$resultsLocJSON = Invoke-RestMethod $googleGeoJSON
$resultsDayJSON = Invoke-RestMethod $Darkskydata -Method Get 

#Sets the two variables to equal the latitude/longitude properties
$varLat = $resultsLocJSON.results.geometry.location.lat #This will be your Latitude
$varLng = $resultsLocJSON.results.geometry.location.lng #This will be your Longitude


while ($Countdown = $forecastSeconds - 86400 -ge 0){
    
    $Countdown = ($forecastSeconds -= 86400) 
    $newResults = "https://api.darksky.net/forecast/93dcf96ac1507b0bc9c572e244f7b633/" + $varLat + "," + $varLng + "," + $Countdown
    $Final = Invoke-RestMethod $newResults -Method Get
    echo (get-Date).AddSeconds($countdown) | Get-Date -Format "dd-MMM-yyyy"
    write-host "Summary:" $final.currently.summary
    echo "Average Temperature:" $final.currently.temperature
    echo "Precipitation Probability:" $final.currently.precipProbability
    echo "Wind Speed:" $final.currently.windSpeed
    echo "Humidity:" $final.currently.humidity
    echo `n
    
    }

}