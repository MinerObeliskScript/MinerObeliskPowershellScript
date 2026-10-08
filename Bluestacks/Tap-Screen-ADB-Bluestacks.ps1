# Get the current script's directory
$currentScriptDir = $PSScriptRoot

# Build the relative path to the target script
$ADBCommands = Join-Path -Path $currentScriptDir -ChildPath "..\ADB-Commands-Bluestacks.ps1"

# Import the script using the relative path
. $ADBCommands


if ([string]::IsNullOrEmpty((Get-Process adb -ErrorAction SilentlyContinue))){
	Write-Host "ADB server is not running. Launching ADB server"
	adb start-server
	Start-Sleep 2
}

ADB-SelectDefaultDevice
# Get screen size and touch resolution dynamically
$screenSize = Get-ScreenSize
$touchResolution = Get-TouchResolution

if ($screenSize -and $touchResolution) {
    $screenWidth = $screenSize.Width
    $screenHeight = $screenSize.Height
    $touchMaxX = $touchResolution.MaxX
    $touchMaxY = $touchResolution.MaxY

    # Calculate scaling factors
    $xScale = $touchMaxX / $screenWidth
    $yScale = $touchMaxY / $screenHeight

   # Write-Host "Scaling factors: X=$xScale, Y=$yScale"


# Invoke-Screen-Tap -X 915 -Y 1800 -SleepMilliseconds 1000 # Example usage. Sleep timer is optional and defaults to 1000 (1 second) 
  
 Write-Host "If the taps aren't working change the default device with - ADB-SelectDefaultDevice"
 
 $FoundersDrops = $true
 $Lootbugs = $true
 $LootBugPremium = $false
 $Stargazing = $false
 $Gifts = $true
 $MoveEnabled = $false
 $Prestige = $false
 $BombFiring = $true
 $PrestigeWaitTimeout = 300
 $EndTimeout = 15
 $Pickaxe = $True
 $LevelIndex = 0
 $CycleLevels = $false
  $Levels = @(
    @{Y=780; Name="Level 90"}, 
	@{Y=950; Name="Level 96"}, 
    @{Y=1110; Name="Level 102"}
	)
 $Levels2 = @(
    @{Y=780; Name="Level 90"}, 
	@{Y=780; Name="Level 90"},
	@{Y=780; Name="Level 90"},
    @{Y=950; Name="Level 96"}, 
    @{Y=950; Name="Level 96"}, 
    @{Y=1110; Name="Level 102"}
	)

 adb shell settings put system show_touches 1
 if ($MoveEnabled -and $Gifts){
 Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 750 -FriendlyName "Close Open Windows" 
 Invoke-Screen-Tap -X 915 -Y 1800  -FriendlyName "Store"
 Simulate-Swipe -startX 500 -startY 150 -endX 500 -endY 1700 -steps 100 -FriendlyName "Top of Store" #Scroll to the top to make sure the following step knows it is definitely at the top of the store page
 Simulate-Swipe -startX 650 -startY 1700 -endX 650 -endY 600 -steps 10 -FriendlyName "Line up Freebie Pack"
 }
Invoke-Screen-Tap -X 650 -Y 1800  -FriendlyName "Close Open Windows"
do {
	if ($Gifts){
	Invoke-Screen-Tap -X 650 -Y 1800 -FriendlyName "Close Open Windows"
    Invoke-Screen-Tap -X 915 -Y 1800 -FriendlyName "Store" 
    Invoke-Screen-Tap -X 900 -Y 1620 -FriendlyName "Claim Gift"
	Invoke-Screen-Tap -X 900 -Y 1700 -FriendlyName "Claim Gift - Fallback for PC"
    Invoke-Screen-Tap -X 650 -Y 1800 -FriendlyName "Close Open Windows"
	}
	# Stargazing 
	if ($Stargazing){
	Invoke-Screen-Tap -X 535 -Y 1810 -FriendlyName "Open Menu"
	Invoke-Screen-Tap -X 800 -Y 650  -FriendlyName "Select Stargazing"
	Invoke-Screen-Tap -X 250 -Y 1700 -FriendlyName "Select Stars Sub Menu"
	Invoke-Screen-Tap -X 800 -Y 900 	-FriendlyName "Purchase Top Star Upgrade (if possible)"
	Invoke-Screen-Tap -X 165 -Y 700  -FriendlyName "Jump to Top star"
	# Invoke-Screen-Tap -X 800 -Y 1330 -FriendlyName "Purchase Bottom Star Upgrade (if possible)"
	#  Invoke-Screen-Tap -X 165 -Y 1130 -FriendlyName "Jump to Bottom star"
	Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 1000			-FriendlyName "Close Open Windows" -Silent:$true
	$StarSwapper++
	}
	#LootBugs
	function ClickLootbugs{
	$LootBugNum = 1 # Smart Variable to increment count automatically 
	if ($LootBugPremium){
		$LootBugSleep = 250
		$X2 = 750
		$Y2 = 1050
		$FName = "Purchase"
	}Else{
		$LootBugSleep = 250
		$X2 = 540
		$Y2 = 1225
		$FName = "Close"
	}
	Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 1000 					-FriendlyName "Close Open Windows" -Silent:$true
	
	Invoke-Screen-Tap -X 425 -Y 1000 -SleepMilliseconds $LootBugSleep 		-FriendlyName "Lootbug $([int]$LootBugNum++)"
	Invoke-Screen-Tap -X $X2 -Y $Y2  -SleepMilliseconds 1000		 		-FriendlyName "$FName $($LootBugNum-1)" #Close/purchase
	Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 0 				-FriendlyName "Close Open Windows" -Silent:$true
	
	Invoke-Screen-Tap -X 580 -Y 1000 -SleepMilliseconds $LootBugSleep 		-FriendlyName "Lootbug $([int]$LootBugNum++)"
	Invoke-Screen-Tap -X $X2 -Y $Y2  -SleepMilliseconds 1000		 		-FriendlyName "$FName $($LootBugNum-1)" #Close/purchase
	Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 0				-FriendlyName "Close Open Windows" -Silent:$true
	
	Invoke-Screen-Tap -X 740 -Y 1000 -SleepMilliseconds $LootBugSleep 		-FriendlyName "Lootbug $([int]$LootBugNum++)"
	Invoke-Screen-Tap -X $X2 -Y $Y2  -SleepMilliseconds 1000		 		-FriendlyName "$FName $($LootBugNum-1)" #Close/purchase
	Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 0				-FriendlyName "Close Open Windows" -Silent:$true
	}
	
	# Actually click the lootbugs
	if ($Lootbugs){
	ClickLootbugs
	ClickLootbugs
	ClickLootbugs
	ClickLootbugs
	}
	

	
	# Founders Supply drops
	if ($FoundersDrops){
	Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 750 -FriendlyName "Close Open Windows" -Silent:$true
	$FounderPackNum = 1 # Smart Variable to increment count automatically 
	Invoke-Screen-Tap -X 480 -Y 915  -SleepMilliseconds 0	-FriendlyName "Founders Supply drop #$([int]$FounderPackNum++)"
	Invoke-Screen-Tap -X 550 -Y 750  -SleepMilliseconds 0	-FriendlyName "Founders Supply drop #$([int]$FounderPackNum++)"
	Invoke-Screen-Tap -X 750 -Y 725  -SleepMilliseconds 0	-FriendlyName "Founders Supply drop #$([int]$FounderPackNum++)"
	Invoke-Screen-Tap -X 250 -Y 1000 -SleepMilliseconds 0	-FriendlyName "Founders Supply drop #$([int]$FounderPackNum++)"
	Invoke-Screen-Tap -X 275 -Y 730  -SleepMilliseconds 0	-FriendlyName "Founders Supply drop #$([int]$FounderPackNum++)"
	}
	Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 750 -FriendlyName "Close Open Windows" -Silent:$true
	
	if ($BombFiring){
	#Auto bomb firing -  Item pouch pressed twice to make sure we get the bomb pouch first time on the next tap
	Invoke-Screen-Tap -X 970 -Y 1700 -SleepMilliseconds 0 -FriendlyName "Items pouch"
	Invoke-Screen-Tap -X 970 -Y 1700 -SleepMilliseconds 0 -FriendlyName "Items pouch" 
	Invoke-Screen-Tap -X 970 -Y 1560 -SleepMilliseconds 0 -FriendlyName "Bomb pouch"
	
	# Invokes the Fire-All Bomb function. Assumes the pouch is open and the fire all button is the current button 
	# Loops cos I want it to 
	$LoopAmount = 1
	for ($i = 1; $i -le $LoopAmount; $i++) {
		Fire-All-Bomb -BombX 170 -BombY 1380 -BombName "Gem Bomb (Put first to consume cherries)"
		
		Fire-All-Bomb -BombX 600 -BombY 1380 -BombName "Founders Bomb"
		Fire-All-Bomb -BombX 385 -BombY 1380 -BombName "Battery Bomb"
		Fire-All-Bomb -BombX 500 -BombY 1380 -BombName "D20 Bomb"
		Fire-All-Bomb -BombX 280 -BombY 1380 -BombName "Cherry Bomb"
		
		Fire-All-Bomb -BombX 170 -BombY 1380 -BombName "Gem Bomb"
		
		Fire-All-Bomb -BombX 600 -BombY 1380 -BombName "Founders Bomb(After bomb recharges/cherry)"
		Fire-All-Bomb -BombX 385 -BombY 1380 -BombName "Battery Bomb(After bomb recharges/cherry)"
		Fire-All-Bomb -BombX 500 -BombY 1380 -BombName "D20 Bomb(After bomb recharges/cherry)"
		Fire-All-Bomb -BombX 280 -BombY 1380 -BombName "Cherry Bomb (After bomb recharges/cherry)"
	
	
		Fire-All-Bomb -BombX 385 -BombY 1380 -BombName "Battery Bomb (After bomb recharges/cherry)"
		Fire-All-Bomb -BombX 500 -BombY 1380 -BombName "D20 Bomb(After bomb recharges/cherry)"
		Fire-All-Bomb -BombX 600 -BombY 1380 -BombName "Founders Bomb"
		Fire-All-Bomb -BombX 280 -BombY 1500 -BombName "Chain Bomb"
				
		# Fire-All-Bomb -BombX 700 -BombY 1500 -BombName "Infinity Bomb"
		# Fire-All-Bomb -BombX 385 -BombY 1500 -BombName "Bomb of plenty"
		# Fire-All-Bomb -BombX 500 -BombY 1500 -BombName "XP Bomb"
		# Fire-All-Bomb -BombX 600 -BombY 1500 -BombName "MEGABOMB"
		# Fire-All-Bomb -BombX 170 -BombY 1500 -BombName "Basic Bomb"
		# Fire-All-Bomb -BombX 800 -BombY 1500 -BombName "Transmuter"
		
		# Fire-All-Bomb -BombX 700 -BombY 1380 -BombName "Veinmorpher"
		

	}

	Invoke-Screen-Tap -X 970 -Y 1560 -SleepMilliseconds 0 -FriendlyName "Close Bomb pouch"
	}

if ($Prestige){
	Function Buy-AllUpgrades{
	Invoke-Screen-Tap -X 535 -Y 1810 -FriendlyName "Open Menu"
	Invoke-Screen-Tap -X 200 -Y 1100 -FriendlyName "Bars"
	Invoke-Screen-Tap -X 750 -Y 1720 -FriendlyName "Craft all"
	Invoke-Screen-Tap -X 750 -Y 1720 -FriendlyName "Craft all - confirm"
	Invoke-Screen-Tap -X 535 -Y 1810 -FriendlyName "Open Menu"
	Invoke-Screen-Tap -X 400 -Y 1100 -FriendlyName "Upgrades Menu"
	
	$LoopCountBuyAllUpgrades = 2
	for ($i = 1; $i -le $LoopCountBuyAllUpgrades; $i++) {
	Invoke-Screen-Tap -X 900 -Y 1715 -SleepMilliseconds 0 -FriendlyName "Buy All Upgrades"
	Invoke-Screen-Tap -X 900 -Y 1715 -SleepMilliseconds 0 -FriendlyName "Buy All Upgrades"
	Start-Sleep 2
	}
	Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 750 -FriendlyName "Close Open Windows"
	}
	
	
	Function Prestige-WaitForThings{
	Write-host "pickaxe: $pickaxe "
	if ($Pickaxe){Buy-AllUpgrades}
	if ($Lootbugs){
	# Worked out by the average time to run
	if ($LootBugPremium){
		$LootBugDivideAmount = 25
	} else{
		$LootBugDivideAmount = 35
	}
	$LootBugLoopAmount = [math]::floor($PrestigeWaitTimeout / $LootBugDivideAmount)
	$TimeoutWaitTimeout = $PrestigeWaitTimeout % $LootBugDivideAmount
	$TimeoutBetweenBugs = ($TimeoutWaitTimeout / $LootBugLoopAmount)*1000
	for ($i = 1; $i -le $LootBugLoopAmount; $i++) {
	Write-Host "Loop $i out of $LootBugLoopAmount"
	ClickLootbugs
	Write-Host "Waiting for $([math]::Round(($TimeoutWaitTimeout / $LootBugLoopAmount)*1000)) Milliseconds" -ForegroundColor Green
	Start-Sleep -Milliseconds $TimeoutBetweenBugs
	if ($Pickaxe){Buy-AllUpgrades}
	}}
	else {
	timeout -t $PrestigeWaitTimeout 
		}
	
	}
	
	#pause
	
	Invoke-Screen-Tap -X 535 -Y 1810 -FriendlyName "Open Menu"
	Invoke-Screen-Tap -X 200 -Y 300 -SleepMilliseconds 0 -FriendlyName "Prestige Menu"
	Invoke-Screen-Tap -X 550 -Y 700 -SleepMilliseconds 0 -FriendlyName "Prestige Button"
	Invoke-Screen-Tap -X 550 -Y 700 -SleepMilliseconds 0 -FriendlyName "Prestige Button"
	Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 750 -FriendlyName "Close Open Windows"
	
	
	timeout -t 150
	
	Invoke-Screen-Tap -X 535 -Y 1810 -FriendlyName "Open Menu"
	Invoke-Screen-Tap -X 200 -Y 1100 -FriendlyName "Bars"
	Invoke-Screen-Tap -X 750 -Y 1720 -FriendlyName "Craft all"
	Invoke-Screen-Tap -X 750 -Y 1720 -FriendlyName "Craft all - confirm"
	Invoke-Screen-Tap -X 535 -Y 1810 -FriendlyName "Open Menu"
	Invoke-Screen-Tap -X 800 -Y 1100 -FriendlyName "Contracts Menu"

	timeout -t 150


	Invoke-Screen-Tap -X 900 -Y 850 -FriendlyName "Pickaxe upgrade"
	Invoke-Screen-Tap -X 900 -Y 1000 -FriendlyName "Triple Craft upgrade"
	Invoke-Screen-Tap -X 900 -Y 1200 -FriendlyName "Pickaxe Super Crit upgrade"
	Invoke-Screen-Tap -X 900 -Y 1400 -FriendlyName "Bomb Recharge upgrade"
	$LoopAmountContracts = 15
	for ($i = 1; $i -le $LoopAmountContracts; $i++) {
	Invoke-Screen-Tap -X 900 -Y 1600 -SleepMilliseconds 0 -FriendlyName "XP Gain upgrade"
	}
	$LoopAmountBombRecharge = 15
	for ($i = 1; $i -le $LoopAmountBombRecharge; $i++) {
	Invoke-Screen-Tap -X 900 -Y 1400 -SleepMilliseconds 0 -FriendlyName "Bomb Recharge upgrade"
	}
	Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 2000		-FriendlyName "Close Open Windows" -Silent:$true
	
	
		Prestige-WaitForThings
		if ($Pickaxe){Buy-AllUpgrades}
}
	# LootBugs 2
	if ($Lootbugs -and $Prestige){
	ClickLootbugs
	}
	
	if($CycleLevels){
		Invoke-Screen-Tap -X 650 -Y 1800 -SleepMilliseconds 2000 -FriendlyName "Close Open Windows"
        Invoke-Screen-Tap -X 1000 -Y 790 -FriendlyName "Open Level Select"
        # Grab the current level
        $currentLevel = $Levels[$LevelIndex]

        # Tap it
        Invoke-Screen-Tap -X 815 -Y $currentLevel.Y -FriendlyName "Select $($currentLevel.Name)"
		
		 # Increment index and wrap around
        $LevelIndex = ($LevelIndex + 1) % $Levels.Count
		ClickLootbugs
		ClickLootbugs
		}
	if (!(Check-ADB-Devices))
	{"No ADB Devices found"
	  Get-Date 	} # If no ADB devices - Don't run the commands
	else {
		Write-Host "All taps simulated successfully."
		Get-Date
		timeout -t $EndTimeout
		
}} while (Check-ADB-Devices)
    Write-Host "No ADB Devices found. Ending script"
	Invoke-RestMethod -Method POST -Uri "http://192.168.0.17:8123/api/webhook/Miner_Obelisk_Crash"
}
else {
	Write-Host "Error: Unable to get screen size or touch resolution." -ForegroundColor Red

	# Define choices
	$choices = @(
		[System.Management.Automation.Host.ChoiceDescription]::new("&Yes", "Kill the ADB server.")
		[System.Management.Automation.Host.ChoiceDescription]::new("&No", "Do not kill the ADB server.")
	)

	# Prompt user for choice
	$decision = $host.UI.PromptForChoice("ADB Server Issue", "Would you like to kill the ADB server to try fixing the issue?", $choices, 0)

	# If the user selects "Yes", kill the ADB server
	if ($decision -eq 0) {
		adb kill-server
		Write-Host "ADB server killed. This might fix the issue."
	} else {
		Write-Host "ADB server was not killed."
	}

}