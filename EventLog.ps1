#Expanded Event ID Mapping
$eventMap = @{
    #Account Logon
    4624 = "Logon Success"
    4625 = "Logon Failure"
    4776 = "Credential Validation"
    4777 = "Kerberos Pre-Auth Failure"
    4778 = "Session Reconnected"
    4779 = "Session Disconnected"
    
    #Account Management
    4720 = "User Account Created"
    4722 = "User Account Enabled"
    4723 = "Password Change Attempt"
    4724 = "Password Reset"
    4725 = "User Account Disabled"
    4726 = "User Account Deleted"
    4738 = "User Account Changed"
    4740 = "Account Locked Out"

    #Detailed Tracking
    4688 = "Process Creation"
    4689 = "Process Termination"
    4697 = "Service Installed"
    4698 = "Scheduled Task Created"
    4699 = "Scheduled Task Deleted"
    4700 = "Scheduled Task Enabled"
    4701 = "Scheduled Task Disabled"

    #DS Access
    4622 = "Directory Service Access"

    #Logon/Logoff
    4634 = "Logoff"
    4647 = "User Initiated Logoff"
    4648 = "Logon Attempt with Explicit Credentials"

    #Object Access
    4660 = "Object Deleted"
    4663 = "Object Access"
    4656 = "Handle Request"
    4658 = "Handle Closed"

    #Policy Change
    4719 = "System Audit Policy Changed"
    4739 = "Domain Policy Changed"
    4902 = "Per-User Audit Policy Changed"

    #Privilege Use
    4672 = "Special Privileges Assigned"
    4673 = "Privilege Service Called"
    4674 = "Privilege Operation Attempted"

    #Global Object Access Auditing
    4657 = "Registry Value Changed"
    4659 = "Handle Duplicated" 
    }

#Collect Events
$events = Get-WinEvent-LogName Security -MaxEvents 1000 | Where-Object { $eventMap.ContainsKey($_.Id)}  | Foreach-Object {
    $pathVal = $null
    if ($_.Id -in 4688, 4689 -and $_.Properties.Count -gt 5) {
        $pathVal = $_.Properties[5].Value
    }
    [PSCustomObject]@{
        Source = "EventLog"
        Name = $_.Id
        Path = $pathVal
        State = $eventMap[$_.Id]
        Detail = $_.TimeCreated.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss")
    }
}

$allData = $events

#Display unified audit view
$allData | Out-GridView -Title "Event Log QuickView" -PassThru