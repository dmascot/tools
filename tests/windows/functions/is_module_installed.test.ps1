BeforeAll {
    . $PWD\scripts\windows\functions.ps1
}

Describe "isModuleInstalled" -Tag 'Unit' {

    it "should return false for non exisiting or not installed module" {
        isModuleInstalled  -ModuleName "somerandomname" | Should -BeExactly $false
    }

    it "should return true for the installed module" {
        isModuleInstalled  -ModuleName "pester" | Should -BeExactly $true
    }    
}