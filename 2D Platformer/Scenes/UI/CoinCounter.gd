extends HBoxContainer

func _ready():
	var main = get_tree().get_nodes_in_group("Level")
	
	if main.size() > 0: # for safe
		main[0].connect("coin_total_changed", self, "_update_coin_total")

		update_display(main[0].total_coins, main[0].collected_coins) # for level complete ui scene to display no of coins when instanced

func _update_coin_total(total_coins, collected_coins):
	update_display(total_coins, collected_coins)

func update_display(total_coins, collected_coins):
	$CoinLabel.text = str(collected_coins, "/",  total_coins)
	
