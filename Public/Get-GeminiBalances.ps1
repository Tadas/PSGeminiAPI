function Get-GeminiBalances {
	$IrmParams = Get-PrivateApiRequestCallParameters -Request '/v1/balances'

	Invoke-RestMethod @IrmParams
}