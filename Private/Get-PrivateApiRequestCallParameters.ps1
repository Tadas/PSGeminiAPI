function Get-PrivateApiRequestCallParameters {
	[CmdletBinding(DefaultParameterSetName = 'Hashtable')]
	Param(
		# This needs to be an ordered dictionary to allow testing - base64 results would be different because hashtable key order would be random
		[Parameter(ValueFromPipeline = $true, ParameterSetName = 'Ordered')]
		[System.Collections.Specialized.OrderedDictionary]$OrderedPayload = @{},

		[Parameter(ValueFromPipeline = $true, ParameterSetName = 'Hashtable')]
		[hashtable]$Payload = @{},

		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$Request,

		[ValidateNotNullOrEmpty()]
		[String]$API_Url = $script:API_Url,

		[ValidateNotNullOrEmpty()]
		[pscredential]$Credentials = $script:API_Credentials
	)

	PROCESS {
		if(-not $Credentials){
			throw "No credentials provided! Use Initialize-GeminiApi to provide credentials"
		}
		# Two parameter sets are used to support providing an ordered dictionary for testing
		# as well as simple hashtable for normal usage
		if ($PSCmdlet.ParameterSetName -eq 'Ordered'){
			$PayloadBody = $OrderedPayload
		} else {
			$PayloadBody = $Payload
		}

		$PayloadBody['nonce'] = (Get-Date).ToFileTime()
		$PayloadBody['request'] = $Request

		Write-Verbose "Payload body: $($PayloadBody | ConvertTo-Json -Compress)"

		$RestMethodParams = [ordered]@{
			Uri = $API_Url.TrimEnd('/') + '/' + $Request.TrimStart('/')
			Method = 'POST'
			Headers = [ordered]@{
				'Cache-Control'      = 'no-cache'
				'Content-Type'       = 'text/plain'
				'X-GEMINI-APIKEY'    = $Credentials.UserName
				'X-GEMINI-PAYLOAD'   = [Convert]::ToBase64String( [System.Text.Encoding]::UTF8.GetBytes( ($PayloadBody | ConvertTo-Json -Compress) ) )
				'X-GEMINI-SIGNATURE' = ''
			}
		}

		$RestMethodParams.Headers['X-GEMINI-SIGNATURE'] = [System.BitConverter]::ToString(
			[System.Security.Cryptography.HMACSHA384]::new(
				# [Text.Encoding]::ASCII.GetBytes( (ConvertFrom-SecureString $Credentials.Password -AsPlainText) ) # Since v7
				[Text.Encoding]::ASCII.GetBytes( $Credentials.GetNetworkCredential().Password )
			).ComputeHash(
				[Text.Encoding]::ASCII.GetBytes( $RestMethodParams.Headers['X-GEMINI-PAYLOAD'] )
			)
		).Replace('-', '').ToLower()

		return $RestMethodParams
	}
}