BeforeAll {
    . $PWD\lib\windows\functions.ps1
}

Describe "Get-Module" -Tag 'Unit' {

    $global:install_module = "posh-git"

    it "throws error if module is not found" {
        $module_name = 'randomnamenotamodule'
        { Get-Module -ModuleName $module_name } | Should -ExpectedMessage "No match was found for the specified search criteria and module name '$module_name'. Try Get-PSRepository to see all available registered module repositories."
    }
    
    It "installs module if found" {
        Get-Module -ModuleName $install_module
        $counter = Get-InstalledModule | Where-Object { $_.Name -eq $install_module } | measure

        $counter.Count | Should -BeExactly 1
    }

    AfterAll {
        Uninstall-Module $global:install_module -Force
        Remove-Variable -Name install_module -Scope Global
    }
}