# Set up event filter and query
$filter = [xml]@"
<QueryList>
  <Query Id="0" Path="Microsoft-Windows-TaskScheduler/Operational">
    <Select Path="Microsoft-Windows-TaskScheduler/Operational">
      *[System[Provider[@Name='Microsoft-Windows-TaskScheduler'] and EventID=140]] 
    </Select>
  </Query>
</QueryList>
"@
$query = New-Object System.Diagnostics.Eventing.Reader.EventLogQuery("Microsoft-Windows-TaskScheduler/Operational", [System.Diagnostics.Eventing.Reader.PathType]::LogName, $filter)
$watcher = New-Object System.Diagnostics.Eventing.Reader.EventLogWatcher($query)

# Start monitoring for events
$watcher.Start()

# Loop to wait for events and show alerts
while ($true) {
    $event = $watcher.ReadEvent()
    if ($event.Id -eq 140) {
        $message = "New scheduled task was created: $($event.Properties[0].Value)"
        Write-Host $message
        # Send alert through email, text message, or other means
        # Example: Send email alert using Send-MailMessage cmdlet
        Send-MailMessage -To "admin@example.com" -From "alerts@example.com" -Subject "New Scheduled Task Created" -Body $message -SmtpServer "smtp.example.com"
    }
}
