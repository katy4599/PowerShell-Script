<# 
    Author: Katy Millard 
    ID: 011055280

    .SYNOPSIS
    Demonstrates competencies
    .DESCRIPTION
    This script demostrates the required competencies of D411 PRFA-AUN 1  
    .INPUTS    
    None
    .OUTPUTS
    Output selections to screen, local folder, and grid view.
    .EXAMPLE
    PS. .\prompts.ps1
#>

#Region Function

function Show-Menu {
    <#
    .SYNOPSIS
    Function to display menu and collect user input
    .DESCRIPTION
    This function displays a menu for the user to select an option
    The options are supplied as a string array parameter
    The user is prompted and the select input is returned
    Input is validated with a RegEx and will re-prompt on invalid selection
    .PARAMETER Title
    The title string to display
    .PARAMETER Options
    The array of string that represent the options to show the user
    #>
param (
    [string]$Title = "Main Menu",
    [string[]]$Options
)

Write-Host $Title
Write-Host "========================="

# Create a loop the size of the array of options that was provided
for ($i = 0; $i -lt $Options.Length; $i++)
{
    # Iterate over the array and write the number and the text of selection
    Write-Host "$($i+1). $($Options[$i])"
}

# Prompt the user for input
$selection = Read-Host "Please select an option"

# Validate the input with RegEx
if ($selection -match '^\d+$' -and $selection -le $Options.Length)
{
    # Return the selection
    return $selection
}
else {
    # If the input is invalid, inform the user and re-prompt
    Write-Host -ForegroundColor DarkYellow "`n*Invalid Selection, please try again*`n"
    Show-Menu -Title $Title -Options $Options
}
}
#End Region

# Main Script Logic

# This sets the variable containing the list of choices for the menu
$menuOptions = @("Create file for list of log files", "List files A-Z in table form and create file.", "Show current CPU and memory usage.", "List running process by size.", "Exit the Script")

# This initializes the the UserInput variable
$UserInput = 1

# This try statement will run the code while the catch statement watches for exceptions
Try
{
    # The while loop will run as long as the UserInput is not equal to 5
    while ($UserInput -ne 5) 
    {
     $UserInput =  Show-Menu  -Title "Demo - Please select an item" -Options $menuOptions
    
     # The switch statement tells the script what to execute for each UserInput
     switch ($UserInput)
     {
        # User Selects Option 1
        1
        {
            # Create a variable to store fileanme and path for output
            $outputFile = "$PSScriptRoot\DailyLog.txt"

            # Add timestamp to file
            "TIMESTAMP: " + (Get-Date) | Out-File -FilePath $outputFile -Append
        
            # Get all items with type .log in the root directory and outputs to file
            Get-ChildItem -Path $PSScriptRoot -Filter "*.log" | Out-File $outputFile -Append
        }
        2
        {
            # Create a variable to store fileanme and path for output
            $anotherOutputFile = "$PSScriptRoot\C916contents.txt"

            # Get all items in root directory in table format and sorted and outputs to file
            Get-ChildItem -Path $PSScriptRoot | Sort-Object | Format-Table | Out-File $anotherOutputFile
        }
        3 
        {
            # Lists CPU and memory useage
            Get-Counter -Counter "\Processor(_Total)\% Processor Time"
            Get-Counter "\Memory\% Committed Bytes In Use"  
        }
        4
        {
            # Displays in grid format all running processes sorted by size
            Get-Process | Sort-Object -Property WS, PS | Out-GridView
        }
        5
        {
            # Exits the loop and script
            Write-Host -ForegroundColor Cyan "Thanks for evaluating my script!"
        }
    }
    
}
}
# Catches Out of memory exceptions
Catch [System.OutOfMemoryException]
{  
    $_
}
# Catches all other exceptions
Catch 
{
    $_
}
Finally 
{  
# Close any open resource
}