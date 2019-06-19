#The $userLoc variable will prompt the user for a City and State, and then store the user's input. example: Tacoma WA
$userLoc = read-host -prompt 'Please enter a city and state'

$resultsDayJSON = Invoke-RestMethod $Darkskydata -Method Get 

#Sets the two variables to equal the latitude/longitude properties
$varLat = $resultsLocJSON.results.geometry.location.lat #This will be your Latitude
$varLng = $resultsLocJSON.results.geometry.location.lng #This will be your Longitude

#Echos the Lat/Lon just for demonstration.
echo $varLat
echo $varLng
echo $resultsDayJSON
