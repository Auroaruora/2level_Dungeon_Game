extends Node

# Optional: limit inventory size
const MAX_SLOTS = 5

var items: Array = []

func add_item(item_data: Dictionary):
	items.append(item_data)
	print("Added to inventory:", item_data)

func remove_item(item_name: String):
	for i in range(items.size()):
		if items[i]["name"] == item_name:
			items.remove_at(i)
			return


func has_item(item_name: String) -> bool:
	for item in items:
		if item.has("name") and item["name"] == item_name:
			return true
	return false
