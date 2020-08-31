function Get-GeminiTrades {
	[CmdletBinding()]
	Param(
		[ValidateSet('btcusd','ethbtc','ethusd','zecusd','zecbtc','zeceth',
			'zecbch','zecltc','bchusd','bchbtc','bcheth','ltcusd','ltcbtc',
			'ltceth','ltcbch','batusd','daiusd','linkusd','oxtusd','batbtc',
			'daibtc','linkbtc','oxtbtc','bateth','daieth','linketh','oxteth')]
		[string]$Symbol = 'btcusd',

		[ValidateRange(1,500)]
		[int]$Limit,

		[System.DateTime]$Since
	)

	$Payload = @{
		symbol = $Symbol
	}

	if($Limit){
		$Payload['limit_trades'] = $Limit
	}

	if($Since){
		$Payload['timestamp'] = [long]($Since - $UnixEpoch).TotalMilliseconds
	}

	$IrmParams = Get-PrivateApiRequestCallParameters -Request '/v1/mytrades' -Payload $Payload

	# https://windowsserver.uservoice.com/forums/301869-powershell/suggestions/11201622-invoke-restmethod-returns-an-unrolled-array
	(Invoke-RestMethod @IrmParams) | ForEach-Object {
		Write-Verbose "Processing trade"
		if ($_.timestampms){
			Write-Verbose "timestampms is present..."
			$_ | Add-Member -MemberType NoteProperty -Name 'timestamp' -Value $UnixEpoch.AddMilliseconds($_.timestampms) -Force
		}

		$_ # pass it on
	}
}