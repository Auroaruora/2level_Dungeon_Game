extends Node

# Optional: limit inventory size
const MAX_SLOTS = 5

var items: Array = []

func add_item(item_data: Dictionary):
	items.append(item_data)
	print("Added to inventory:", item_data)

func remove_item(item_name: String):
	items.erase(item_name)

func has_item(item_name: String) -> bool:
	return item_name in items
