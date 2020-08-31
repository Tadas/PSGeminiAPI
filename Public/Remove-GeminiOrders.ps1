function Remove-GeminiOrders {
	$IrmParams = Get-PrivateApiRequestCallParameters -Request '/v1/order/cancel/all'

	Invoke-RestMethod @IrmParams
}