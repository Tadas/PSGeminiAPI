function Get-GeminiOrders {
	$IrmParams = Get-PrivateApiRequestCallParameters -Request '/v1/orders'

	Invoke-RestMethod @IrmParams
}