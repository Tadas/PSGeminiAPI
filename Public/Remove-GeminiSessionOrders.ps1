function Remove-GeminiSessionOrders {
	$IrmParams = Get-PrivateApiRequestCallParameters -Request '/v1/order/cancel/session'

	Invoke-RestMethod @IrmParams
}