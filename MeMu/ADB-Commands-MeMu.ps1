$SpaceRequired = 30 # Amount of space needed to keep text in line with each other 

Function Set-Debug-Options{
	[CmdletBinding()]
	param(
	  [int]$pointer,
	  [int]$touches
		)
	adb shell settings put system pointer_location $pointer
	adb shell settings put system show_touches $touches
}

Function Check-ADB-Devices{
	# Run adb devices command and capture the output
$adbOutput = adb devices

# Check if the output contains a line with a device attached
if ($adbOutput -match "device$") {
    return $True
} else {
    return $false
}
}

#Function to get screen size using adb
function Get-ScreenSize {
    $screenSizeOutput = adb shell wm size
    if ($screenSizeOutput -match "Physical size: (\d+)x(\d+)") {
        $screenWidth = [int]$matches[1]
        $screenHeight = [int]$matches[2]
        Write-Host "Screen Size: Width=$screenWidth, Height=$screenHeight"
        return @{Width = $screenWidth; Height = $screenHeight}
    } else {
        Write-Host "Failed to retrieve screen size."
        return $null
    }
}

# Function to simulate a swipe
function Simulate-Swipe {
    param (
        [int]$startX,          # Starting X position
        [int]$startY,          # Starting Y position
        [int]$endX,            # Ending X position
        [int]$endY,            # Ending Y position
		[string]$FriendlyName, # Optional Friendly name instead of screen co-ords
        [int]$steps  = 10      # Amount of steps to swipe down - Default is 10 - This basically determines the time spent scrolling 
    )

		# If no ADB devices - Don't run the commands
			if (!(Check-ADB-Devices)){#Write-Host "No ADB Devices Found"
									  return }
		else {	
    # Get the screen size to ensure valid coordinates (optional)
    $screenSize = Get-ScreenSize
    if ($screenSize -eq $null) {
        Write-Host "Could not retrieve screen size."
        return
    }
	
			if ([string]::IsNullOrEmpty($FriendlyName)){
					Write-Host "Swiping screen from X: $startX - Y: $startY -> X: $endX - Y: $endY in $steps amount of steps "
			}else {
				# Trims the friendly name if it is longer than $SpaceRequired
				$FriendlyName = $(if ($FriendlyName.length -gt $($SpaceRequired-1)) {$FriendlyName.substring(0, $($SpaceRequired-1)) } else { $FriendlyName })
				$spaces = $SpaceRequired - $FriendlyName.Length
				Write-Host "Swiping:    $FriendlyName" -NoNewline -ForegroundColor Cyan
				Write-Host (" " * $spaces) -NoNewline
				Write-Host "Steps      = $($steps)." -ForegroundColor Magenta
		}
		
    # Simulate the touch down event at startX, startY
    adb shell sendevent /dev/input/event6 3 53 $startX  # ABS_MT_POSITION_X
    adb shell sendevent /dev/input/event6 3 54 $startY  # ABS_MT_POSITION_Y
    adb shell sendevent /dev/input/event6 0 0 0         # SYN_REPORT (End of event)
    adb shell sendevent /dev/input/event6 1 330 1       # BTN_TOUCH (Touch Down)
    adb shell sendevent /dev/input/event6 0 0 0         # SYN_REPORT

    # Simulate the touch move events (optional, for smoother swipe)
    for ($i = 1; $i -le $steps; $i++) {
        $moveX = $startX + (($endX - $startX) * $i) / $steps
        $moveY = $startY + (($endY - $startY) * $i) / $steps

        adb shell sendevent /dev/input/event6 3 53 $moveX  # ABS_MT_POSITION_X
        adb shell sendevent /dev/input/event6 3 54 $moveY  # ABS_MT_POSITION_Y
        adb shell sendevent /dev/input/event6 0 0 0        # SYN_REPORT
    }

    # Simulate the touch up event at endX, endY
    adb shell sendevent /dev/input/event6 3 53 $endX    # ABS_MT_POSITION_X
    adb shell sendevent /dev/input/event6 3 54 $endY    # ABS_MT_POSITION_Y
    adb shell sendevent /dev/input/event6 1 330 0       # BTN_TOUCH (Touch Up)
    adb shell sendevent /dev/input/event6 0 0 0         # SYN_REPORT
	
	adb shell sendevent /dev/input/event6 0 0 0  # I think this code releases touch of the screen 
	adb shell sendevent /dev/input/event6 0 2 0
	adb shell sendevent /dev/input/event6 0 0 0
	
	
}}





# Function to get the touch event range using adb
function Get-TouchResolution {
    $getEventOutput = adb shell getevent -lp /dev/input/event6
	#Bluestacks
	# $getEventOutput = adb shell getevent -lp /dev/input/event6
    $touchMaxX = $null
    $touchMaxY = $null

    foreach ($line in $getEventOutput) {
        $xMatch = [regex]::Match($line, "ABS_MT_POSITION_X\s+: value 0, min 0, max (\d+)")
        if ($xMatch.Success) {
            $touchMaxX = [int]$xMatch.Groups[1].Value
        }

        $yMatch = [regex]::Match($line, "ABS_MT_POSITION_Y\s+: value 0, min 0, max (\d+)")
        if ($yMatch.Success) {
            $touchMaxY = [int]$yMatch.Groups[1].Value
        }
    }

    if ($touchMaxX -ne $null -and $touchMaxY -ne $null) {
        #Write-Host "Touch Resolution: Max X=$touchMaxX, Max Y=$touchMaxY"
        return @{MaxX = $touchMaxX; MaxY = $touchMaxY}
    } else {
        Write-Host "Failed to retrieve touch resolution."
        return $null
    }
}


# Function to simulate a single tap with optional sleep delay
function Invoke-Screen-Tap {
	param (
		[int]$X,
		[int]$Y,
		[int]$SleepMilliseconds = 500, # Default sleep to 0 if not specified
		[string]$FriendlyName, # Optional Friendly name instead of screen co-ords
		[boolean]$Silent = $False, # Suppress output
		[boolean]$Bypass = $False # Bypass Clear Notifications checker? - Should only be used inside the Check-SignalAndClearNotifications function 
	)
	# If no ADB devices - Don't run the commands
	if (!(Check-ADB-Devices)){#Write-Host "No ADB Devices Found"
	return } 
	else{
	if (-not $Bypass -or ($FriendlyName -match "Close")){
		Check-SignalAndClearNotifications
	}
	# Convert to raw touch coordinates
	$xRaw = [math]::Round($X * $xScale)
	$yRaw = [math]::Round($Y * $yScale)
	
	if ($Silent){
		
	}else {
	if ($($SleepMilliseconds/1000) -eq 1){$SecondsPluralCheck = "second."} else {$SecondsPluralCheck = "seconds."}
	if ([string]::IsNullOrEmpty($FriendlyName)){
		# Print the raw coordinates (for debugging)
	Write-Host "Sending tap at Screen: X=$X, Y=$Y - Sleep time = $($SleepMilliseconds/1000) $SecondsPluralCheck"
	# -> Raw: X=$xRaw, Y=$yRaw"
	}else {
			# Trims the friendly name if it is longer than $SpaceRequired
			$FriendlyName = $(if ($FriendlyName.length -gt $($SpaceRequired-1)) {$FriendlyName.substring(0, $($SpaceRequired-1)) } else { $FriendlyName })
			$spaces = $SpaceRequired - $FriendlyName.Length
			Write-Host "Tapping on: $FriendlyName" -NoNewline -ForegroundColor Cyan
			Write-Host (" " * $spaces) -NoNewline
			Write-Host "Sleep time = $($SleepMilliseconds/1000) $SecondsPluralCheck" -ForegroundColor Magenta
	}
	}
	
	# Simulate the tap
	# Touch down
	$tapCmd = @(
		"sendevent /dev/input/event6 3 57 0"                # ABS_MT_TRACKING_ID
		"sendevent /dev/input/event6 3 53 $xRaw"              # ABS_MT_POSITION_X
		"sendevent /dev/input/event6 3 54 $yRaw"              # ABS_MT_POSITION_Y
		"sendevent /dev/input/event6 3 58 50"                 # ABS_MT_PRESSURE
		"sendevent /dev/input/event6 0 0 0"                   # SYN_REPORT
		"sendevent /dev/input/event6 3 57 -1"                 # ABS_MT_TRACKING_ID (end contact)
		"sendevent /dev/input/event6 0 0 0"                   # SYN_REPORT
	) -join "; "
	adb shell $tapCmd


	# Sleep for the specified time (if any)
	if ($SleepMilliseconds -gt 0) {
		Start-Sleep -Milliseconds $SleepMilliseconds
	}
}}


# Helper function to tidy up code a little. Takes the bomb X and Y and fires the bombs. Assumes the menu is already open 
Function Fire-All-Bomb{
	param (
		[int]$BombX,
		[int]$BombY,
		[String]$BombName
	)


Write-Host "Firing All: $BombName" -ForegroundColor Cyan #-NoNewline

# Trims the friendly name if it is longer than $SpaceRequired

#$BombName = $(if ($BombName.length -gt $($SpaceRequired-1)) {$BombName.substring(0, $($SpaceRequired-1)) } else { $BombName })
#$spaces = $SpaceRequired - $BombName.Length
#Write-Host (" " * $spaces) -NoNewline
#Write-Host "Some useful text here" -ForegroundColor Magenta


# Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 0 -FriendlyName "Close Open Windows" -Silent:$true
Invoke-Screen-Tap -X $BombX -Y $BombY -SleepMilliseconds 250 -Silent:$True
Invoke-Screen-Tap -X 785 -Y 1700 -SleepMilliseconds 0 -Silent:$True
#Invoke-Screen-Tap -X 785 -Y 1700 -SleepMilliseconds 0 -Silent:$True
}

# Function to check for the signal file
function Check-SignalAndClearNotifications {
    if (Test-Path $SIGNAL_FILE_PATH) {
        # The signal file exists, clear notifications
        Write-Host "Signal detected. Clearing notifications..."

        # Run the tapping commands to clear notifications
		
       Invoke-Screen-Tap -X 200 -Y 1350 -SleepMilliseconds 0 -FriendlyName "Notification Clear 1" -Bypass:$True
       Invoke-Screen-Tap -X 200 -Y 1175 -SleepMilliseconds 0 -FriendlyName "Notification Clear 2" -Bypass:$True
       Invoke-Screen-Tap -X 200 -Y 1000 -SleepMilliseconds 0 -FriendlyName "Notification Clear 3" -Bypass:$True
        
        # Remove the signal file after clearing notifications
        Remove-Item $SIGNAL_FILE_PATH

        Write-Host "Notifications cleared and signal reset."
    }
    else {
        # Write-Host "No signal found. Continuing."
    }
}

Function ADB-SelectDefaultDevice {
	Write-Host "Previous ADB default $env:ANDROID_SERIAL" -ForegroundColor Green
	$env:ANDROID_SERIAL = $null
	# Get list of ADB devices
	$devices = adb devices | Select-String "device$" | ForEach-Object { ($_ -split "\s+")[0] }

# Check how many devices are connected
if ($devices.Count -eq 0) {
    Write-Host "No ADB devices found."
} elseif ($devices.Count -eq 1) {
    # If only one device, set it automatically
    $env:ANDROID_SERIAL = $devices
    Write-Host "ADB primary device set to: $env:ANDROID_SERIAL"
} else {
    # If multiple devices, prompt user to choose
    Write-Host "Multiple ADB devices found:"
    for ($i=0; $i -lt $devices.Count; $i++) {
        Write-Host "[$i] $($devices[$i])"
    }
    
    $choice = Read-Host "Enter the number of the device to set as primary"
    
    if ($choice -match "^\d+$" -and [int]$choice -ge 0 -and [int]$choice -lt $devices.Count) {
        $env:ANDROID_SERIAL = $devices[$choice]
        Write-Host "ADB primary device set to: $env:ANDROID_SERIAL"
    } else {
        Write-Host "Invalid choice. No changes made."
    }
}


}