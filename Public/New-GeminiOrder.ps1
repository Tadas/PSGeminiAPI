function New-GeminiOrder {
	[CmdletBinding()]
	Param(
		[ValidateSet('btcusd','ethbtc','ethusd','zecusd','zecbtc','zeceth',
			'zecbch','zecltc','bchusd','bchbtc','bcheth','ltcusd','ltcbtc',
			'ltceth','ltcbch','batusd','daiusd','linkusd','oxtusd','batbtc',
			'daibtc','linkbtc','oxtbtc','bateth','daieth','linketh','oxteth')]
		[string]$Symbol = 'btcusd',

		[Parameter(Mandatory = $true)]
		[decimal]$Amount,

		[decimal]$MinAmount,

		[Parameter(Mandatory = $true)]
		[decimal]$Price,

		[Parameter(Mandatory = $true)]
		[ValidateSet('buy', 'sell')]
		[string]$Side,

		[string]$ClientOrderId,

		[ValidateSet('maker-or-cancel', 'immediate-or-cancel', 'fill-or-kill', 'auction-only', 'indication-of-interest')]
		[string]$Options,

		[decimal]$StopPrice
	)
	$Payload = @{
		symbol = $Symbol
		amount = [string]$Amount
		price  = [string]$Price
		side   = $Side
		type   = $Type
	}

	if ($MinAmount){
		$Payload['min_amount'] = $ClientOrderId
	}

	if ($ClientOrderId){
		$Payload['client_order_id'] = $ClientOrderId
	}

	if($Options){
		$Payload['options'] = @($Options)
	}

	if ($StopPrice){
		$Payload['type'] = 'exchange stop limit'
		$Payload['stop_price'] = [string]$StopPrice
	} else {
		$Payload['type'] = 'exchange limit'
	}

	$IrmParams = Get-PrivateApiRequestCallParameters -Request '/v1/order/new' -Payload $Payload

	Invoke-RestMethod @IrmParams
}