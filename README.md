
PowerShell module for [Gemini exchange REST API](https://docs.gemini.com/rest-api/)

 - [Get-GeminiBalances](https://docs.gemini.com/rest-api/#get-available-balances)
 - [Get-GeminiOrders](https://docs.gemini.com/rest-api/#get-active-orders)
 - [Get-GeminiTrades](https://docs.gemini.com/rest-api/#get-past-trades)
 - [New-GeminiOrder](https://docs.gemini.com/rest-api/#new-order)
 - [Remove-GeminiOrders](https://docs.gemini.com/rest-api/#cancel-all-active-orders)
 - [Remove-GeminiSessionOrders](https://docs.gemini.com/rest-api/#cancel-all-session-orders)

# Usage example
```powershell
	$creds = Get-Credential -Message 'Provide Gemini API credentials'
	Import-Module PSGeminiAPI

	# Provide credentials before doing anything else...
	Initialize-GeminiApi -Credentials $creds # add -Sandbox to target Gemini's sandbox environment

	# and do anything else...
	Get-GeminiBalances
```

[Gemini Sandbox](https://docs.gemini.com/rest-api/#sandbox)
