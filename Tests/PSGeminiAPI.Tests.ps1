$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1', '.psm1'
Import-Module "$here\..\$sut" -Force

Describe "PSGeminiAPI" {

	InModuleScope PSGeminiAPI {

		Context "Get-PrivateApiRequestCallParameters" {
			BeforeEach {
				$API_Params = @{
					Credentials = [System.Management.Automation.PSCredential]::new(
						'blah',
						(ConvertTo-SecureString 'Jefe' -AsPlainText -Force)
					)
				}
			}

			It "fails with no credentials" {
				Initialize-GeminiApi # Make sure that there are no credentials
				{ [ordered]@{ something = 'what do ya want for nothing?' } | Get-PrivateApiRequestCallParameters -Request 'blah' } | Should -Throw "No credentials provided! Use Initialize-GeminiApi to provide credentials"
			}

			It "produces expected HTTP headers" {
				# order is important as the function will add properties in a certain sequence
				$ExpectedPayload = [ordered]@{
					something = 'what do ya want for nothing?'
					nonce     = [long]132399262899086044
					request   = '/v1/mytrades'
				}
				$ExpectedPayload_b64 = [Convert]::ToBase64String(
					[System.Text.Encoding]::UTF8.GetBytes( ($ExpectedPayload | ConvertTo-Json -Compress) )
				)

				Mock Get-Date { return [datetime]::FromFileTime($ExpectedPayload.nonce) }

				$ApiCallParams = [ordered]@{ something = 'what do ya want for nothing?' } | Get-PrivateApiRequestCallParameters -Request $ExpectedPayload.request @API_Params

				$ApiCallParams.Headers['Cache-Control']      | Should -Be 'no-cache'
				$ApiCallParams.Headers['Content-Type']       | Should -Be 'text/plain'
				$ApiCallParams.Headers['X-GEMINI-APIKEY']    | Should -Be $API_Params.Credentials.UserName
				$ApiCallParams.Headers['X-GEMINI-PAYLOAD']   | Should -Be $ExpectedPayload_b64
				$ApiCallParams.Headers['X-GEMINI-SIGNATURE'] | Should -Be '15aeab8c2e023d35c1620ce82dc2ed9f495191c297c5ee8ee35ad10c405a2228cf613b000c65c1188c614045f0c97de4'
			}

			It "Request <Request> produces url <Expected>" -TestCases @(
				@{ TestUrl = 'https://api.example.com';  Request = 'v1/mytrades';  Expected = 'https://api.example.com/v1/mytrades'},
				@{ TestUrl = 'https://api.example.com';  Request = '/v1/mytrades'; Expected = 'https://api.example.com/v1/mytrades'},
				@{ TestUrl = 'https://api.example.com/'; Request = 'v1/mytrades';  Expected = 'https://api.example.com/v1/mytrades'},
				@{ TestUrl = 'https://api.example.com/'; Request = '/v1/mytrades'; Expected = 'https://api.example.com/v1/mytrades'}
			) {
				Param( $TestUrl, $Request, $Expected )
				$ApiCallParams = [ordered]@{ a = 'irrelevant for this' } | Get-PrivateApiRequestCallParameters -Request $Request -API_Url $TestUrl @API_Params
				$ApiCallParams.Uri | Should -Be $Expected
			}
		}
	}

}
