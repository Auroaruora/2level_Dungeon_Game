extends Control

func _process(_delta):
	update_inventory()

func update_inventory():
	var slot_nodes = $HBoxContainer.get_children()
	for i in range(slot_nodes.size()):
		var panel = slot_nodes[i]
		var icon_node = panel.get_node_or_null("Icon")
		if icon_node:
			if i < Inventory.items.size():
				icon_node.texture = Inventory.items[i]["icon"]
			else:
				icon_node.texture = null
