BeforeAll {
    . $PWD\scripts\windows\functions.ps1
}

Describe "Get-Usernane" -Tag 'Unit' {
    IT "must be same as environment username" {
        Get-Username | Should -BeExactly $env:USERNAME
    }
}
