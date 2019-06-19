#The $userLoc variable will prompt the user for a City and State, and then store the user's input. example: Tacoma WA
$userLoc = read-host -prompt 'Please enter a city and state'
$userDays = read-host -prompt 'please enter number of days for forecast'

#The $formatLoc variable takes the users input, replaces any spaces with '+', and stores that value. example: Tacoma+WA
$formatLoc = $userLoc -replace(' ', '+') 
$forecastSeconds = $userDays

#Adds the location into the url for the API
$googleGeoJSON = "https://maps.googleapis.com/maps/api/geocode/json?address=" + $formatloc + "&key=AIzaSyDGT-1IEg0NHsXiLAtntLxAFctMttHwTao"
$Darkskydata = "https://api.darksky.net/forecast/93dcf96ac1507b0bc9c572e244f7b633/" + $varLat + "," + $varLng + "," + $forecastSeconds
#Invoke URL
$resultsLocJSON = Invoke-RestMethod $googleGeoJSON
$resultsDayJSON = Invoke-RestMethod $Darkskydata -Method Get 

#Sets the two variables to equal the latitude/longitude properties
$varLat = $resultsLocJSON.results.geometry.location.lat #This will be your Latitude
$varLng = $resultsLocJSON.results.geometry.location.lng #This will be your Longitude

#Echos the Lat/Lon just for demonstration.
echo $varLat
echo $varLng
echo $resultsDayJSON