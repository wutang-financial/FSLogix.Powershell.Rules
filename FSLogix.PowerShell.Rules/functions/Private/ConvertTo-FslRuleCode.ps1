function ConvertTo-FslRuleCode {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$FolderOrKey,

        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$FileOrValue,

        <#
        [Parameter(
            Position = 2,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$ContainsUserVar,
        #>

        [Parameter(
            Position = 3,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$CopyObject,

        <#
        [Parameter(
            Position = 4,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Persistent,
        #>

        [Parameter(
            Position = 5,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Redirect,

        [Parameter(
            Position = 6,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Hiding,

        [Parameter(
            Position = 7,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Printer,

        [Parameter(
            Position = 8,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$SpecificData,

        [Parameter(
            Position = 9,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Java,

        [Parameter(
            Position = 10,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$VolumeAutoMount,

        [Parameter(
            Position = 11,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$HideFont

        <#
        [Parameter(
            Position = 12,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Mask
        #>
    )

    BEGIN {
        Set-StrictMode -Version Latest
        $FRX_RULE_SRC_IS_A_DIR_OR_KEY = 0x00000001
        $FRX_RULE_SRC_IS_A_FILE_OR_VALUE = 0x00000002
        #$FRX_RULE_CONTAINS_USER_VARS = 0x00000008
        $FRX_RULE_SHOULD_COPY_FILE = 0x00000010
        $FRX_RULE_IS_PERSISTANT = 0x00000020
        $FRX_RULE_TYPE_REDIRECT = 0x00000100
        $FRX_RULE_TYPE_HIDING = 0x00000200
        $FRX_RULE_TYPE_HIDE_PRINTER = 0x00000400
        $FRX_RULE_TYPE_SPECIFIC_DATA = 0x00000800
        $FRX_RULE_TYPE_JAVA = 0x00001000
        $FRX_RULE_TYPE_VOLUME_AUTOMOUNT = 0x00002000
        $FRX_RULE_TYPE_HIDE_FONT = 0x00004000
    } # Begin
    PROCESS {
        $codeToOutput = 0
        #Persistent is always true except if Java is present so no need to pass in a parameter
        if ($java) {
            $persistent = $false
        }
        else {
            $persistent = $true
        }

        switch ($true) {
            $FolderOrKey { $codeToOutput = $codeToOutput -bor $FRX_RULE_SRC_IS_A_DIR_OR_KEY }
            $FileOrValue { $codeToOutput = $codeToOutput -bor $FRX_RULE_SRC_IS_A_FILE_OR_VALUE }
            $CopyObject { $codeToOutput = $codeToOutput -bor $FRX_RULE_SHOULD_COPY_FILE }
            $Persistent { $codeToOutput = $codeToOutput -bor $FRX_RULE_IS_PERSISTANT }
            $Redirect { $codeToOutput = $codeToOutput -bor $FRX_RULE_TYPE_REDIRECT }
            $Hiding { $codeToOutput = $codeToOutput -bor $FRX_RULE_TYPE_HIDING }
            $Printer { $codeToOutput = $codeToOutput -bor $FRX_RULE_TYPE_HIDE_PRINTER }
            $SpecificData { $codeToOutput = $codeToOutput -bor $FRX_RULE_TYPE_SPECIFIC_DATA }
            $Java { $codeToOutput = $codeToOutput -bor $FRX_RULE_TYPE_JAVA }
            $VolumeAutomount { $codeToOutput = $codeToOutput -bor $FRX_RULE_TYPE_VOLUME_AUTOMOUNT }
            $HideFont { $codeToOutput = $codeToOutput -bor $FRX_RULE_TYPE_HIDE_FONT }
        }

        #convert code to hex string so it doesn't get outputted as an integer
        $formattedCode = "0x{0:X8}" -f $codeToOutput

        Write-Output $formattedCode
    } #Process
    END {} #End
}  #function ConvertTo-FslRuleCode