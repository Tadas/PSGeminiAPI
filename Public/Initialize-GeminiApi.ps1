function Initialize-GeminiApi {
	Param(
		[pscredential]$Credentials,

		[switch]$Sandbox
	)

	if($Sandbox){
		$script:API_Url = 'https://api.sandbox.gemini.com'
	} else {
		$script:API_Url = 'https://api.gemini.com'
	}

	if ($Credentials){
		$script:API_Credentials = $Credentials
	} else {
		$script:API_Credentials = $null
	}
}