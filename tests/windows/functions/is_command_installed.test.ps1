BeforeAll {
    . $PWD\lib\windows\functions.ps1
}

Describe "isCommandInstalled" -Tag 'Unit' {

    it "should return false for non-existing command" {
        isCommandInstalled  -commandName "somerandomname" | Should -BeExactly $false
    }

    it "should return true for the installed module" {
        isCommandInstalled  -commandName "ls" | Should -BeExactly $true
    }    
}