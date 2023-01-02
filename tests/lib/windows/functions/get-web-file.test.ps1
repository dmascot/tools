BeforeAll {
    . $PWD\lib\windows\functions.ps1
}

Describe "Get-Web-File" -Tag 'Unit' {

    Context "with Exceptions" {
         it "should throw an exception if url is an empty string" { 
             { Get-Web-File } |  Should -Throw -ExpectedMessage 'Error: $URL can not be an emptry string'
         }

         it "should throw an exception if download path is invalid" { 
            $DownloadPath = 'C:\this\user\path\is\error'
            { Get-Web-File -URL 'https://this.is.ok/for/now.exe' -DownloadPath $DownloadPath } |  Should -Throw -ExpectedMessage "Error: $DownloadPath does not exist"
        }

        it "should throw an exception if URL is not reachable" { 
            { Get-Web-File -URL 'https://this.is.not.ok/now.exe' } |  Should -Throw -ErrorId 'WebException'
        }
    }

    Context "mock with defaults" {
        BeforeAll {
            #webclient does nothing here, we don't want it to download in nutshell
            Mock _webCleint { }
        }

        It "should reuturn default path of the downloaded file" {

            $file_name =  'dummy.exe'
            $expected_path = [IO.Path]::Combine($env:HOME,'Downloads',$file_name)

            $URL =  "https://this.is.ok/$file_name"

            Get-Web-File -URL $URL | Should -BeExactly $expected_path
        } 

    }

    Context "mock with parameters" {
        BeforeAll {
            $global:custom_download_dir = Join-Path $env:HOME 'MyDownloads'

            #Invoke-WebRequest does nothing here, we don't want it to download in nutshell
            Mock _webCleint { }

            #Create download directory
            New-Item $custom_download_dir -Type Directory
        }

        It "should return downloaded file path with custom download location" {
            $file_name =  'dummy.exe'

            $expected_path =  Join-Path $custom_download_dir $file_name

            $URL =  "https://this.is.ok/$file_name"

            Get-Web-File -URL $URL -DownloadPath $custom_download_dir | Should -BeExactly $expected_path
        }


        It "should return downloaded file path with custom download location and file name" {
            $file_name =  'dummy.exe'
            $another_name = "another_name.exe"

            $expected_path =  Join-Path $custom_download_dir $another_name

            $URL =  "https://this.is.ok/$file_name"

            Get-Web-File -URL $URL -DownloadPath $custom_download_dir -SaveAs $another_name | Should -BeExactly $expected_path
        }


        AfterAll{
            Remove-Item -Path $custom_download_dir -Force -Recurse
            Remove-Variable -Name custom_download_dir -Scope Global
        }
    }
}


