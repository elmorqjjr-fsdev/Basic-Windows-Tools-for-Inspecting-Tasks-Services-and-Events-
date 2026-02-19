#Scheduled Tasks 
$tasks = Get-ScheduledTask | ForEach-Object {
    forEach ($action in $_.Actions) {
        [PSCustomObject]@{
            Source = "ScheduledTask"
            Name = $_.TaskName
            Path = $_.TaskPath
            State = $_.State
            Detail = $_.action.Execute
        }
    }
}

#Services
$services = Get-CimInstance Win32_Service | ForEach-Object {
    [PSCustomObject]@{
        Source = "Service"
        Name = $_.Name
        Path = $_.PathName
        State = $_.State
        Detail = $_.DisplayName
    }
}

#Combine All
$allData = $tasks + $services

#Display unified audit view
$allData | Out-GridView -Title "Task & Services QuickView" -PassThru
