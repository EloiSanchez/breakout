class_name ExtraLifeUpgrade
extends BaseUpgrade


func perform_effect(game, upgrade_node: Node):
	print("Performing effect of Extra life")
	game.increase_life()
	upgrade_node.queue_free()
