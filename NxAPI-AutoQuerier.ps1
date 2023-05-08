# Set variables
$apiUrls = @("https://192.168.2.3:1671",
             "https://10.10.0.10:1671",
             "https://10.10.0.11:1671",
             "https://10.10.0.12:1671",
             "https://10.10.0.10:1671")
$encodedCredentials = "<encoded API credentials here>"
$decodedCredentials = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encodedCredentials))
$nxqlQuery = "select (name) (from device (where device (eq name `"NXT-DV10`")))"
$outputPath = "C:\Users\$env:USERNAME\Documents\QueryName-$(Get-Date -Format yyyy-MM-dd).csv"

# Loop through each API URL and execute query
$results = foreach ($apiUrl in $apiUrls) {
    # Construct API endpoint URL
    $apiEndpoint = "$apiUrl/2/query?platform=windows&query=$nxqlQuery"
    
    # Execute API call with decoded credentials
    $result = Invoke-RestMethod -Uri $apiEndpoint -Headers @{Authorization = "Basic $decodedCredentials"}
    
    # Return results
    $result
}

# Combine results and save to file
$results | Out-File $outputPath -Encoding utf8
