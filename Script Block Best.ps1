function Get-Weather {

#The $userLoc variable will prompt the user for a City and State, and then store the user's input. example: Tacoma WA
$userLoc = read-host -prompt 'Please enter a city and state'
$userDays = read-host -prompt 'Please enter number of days for forecast'
$userUnit = read-host -prompt 'Please enter unit: C or F'

#Declarations of input
$int = [int] $userDays
$temp = [char] $userunit

#The $formatLoc variable takes the users input, replaces any spaces with '+', and stores that value. example: Tacoma+WA
$formatLoc = $userLoc -replace(' ', '+') 


#Adds the location into the url for the API
$googleGeoJSON = "https://maps.googleapis.com/maps/api/geocode/json?address=" + $formatloc + "&key=AIzaSyDGT-1IEg0NHsXiLAtntLxAFctMttHwTao"


#Invoke geolocation URL
$resultsLocJSON = Invoke-RestMethod $googleGeoJSON


#Sets the two variables to equal the latitude/longitude properties
$varLat = $resultsLocJSON.results.geometry.location.lat #This will be your Latitude
$varLng = $resultsLocJSON.results.geometry.location.lng #This will be your Longitude

#convert number of days requested into proper format
$daysrequested = $int * 86400 #This takes users request of days and converts into unix
$daysforcasted = [int][double]::Parse((Get-Date (get-date).touniversaltime() -UFormat %s)) #This converts todays date into Unix
$newtime = $daysforcasted + $daysrequested #Adds user request and todays date

#Function to convert UNIX back into date
Function get-epochDate ($epochDate) { [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($epochDate)) } #converts unix back into datetime

#Adds $varLat, $varLng and converted time into Weather API
$Darkskydata = "https://api.darksky.net/forecast/93dcf96ac1507b0bc9c572e244f7b633/" + $varLat + "," + $varLng + "," + $newtime +"?" + ",[us]"

#Invoke weather URL
$resultsDayJSON = Invoke-RestMethod $Darkskydata -Method Get 

#Function to convert F to C
function get-f2c([double] $farentemp)
{
    $celtemp = $fahrentemp - 32
    $celtemp = $celtemp / 1.8
    $celtemp
}

#Display for prototype/Troubleshooting purposes
while ($Countdown = $daysforcasted + 86400 -le $newtime){
    
    $Countdown = ($daysforcasted += 86400) 
    $newResults = "https://api.darksky.net/forecast/93dcf96ac1507b0bc9c572e244f7b633/" + $varLat + "," + $varLng + "," + $Countdown
    $Final = Invoke-RestMethod $newResults -Method Get
    $confirmtime = [int] $final.currently.time

#Broken attempt within the while loop to do a conditional for F or C
if ($temp = "F"){
    get-epochDate $confirmtime
    echo  "your punk ass time zone is: "$final.timezone
    write-host "Summary:" $final.hourly.summary
    echo "Average Temperature:" $final.currently.temperature
    echo "Precipitation Probability:" $final.currently.precipProbability
    echo "Wind Speed:" $final.currently.windSpeed
    echo "Humidity:" $final.currently.humidity
    echo `n    }

else { 
    get-epochDate $confirmtime
    echo  "your punk ass time zone is: "$final.timezone
    write-host "Summary:" $final.hourly.summary
    $farentemp = [double] $final.currently.temperature
    get-f2c $farentemp
    echo "Precipitation Probability:" $final.currently.precipProbability
    echo "Wind Speed:" $final.currently.windSpeed
    echo "Humidity:" $final.currently.humidity
    echo `n

     }
                                                       } 
}
