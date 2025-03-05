class_name ExtraLifeUpgrade
extends BaseUpgrade


func perform_effect(game, upgrade_node: Node):
	game.increase_life()
	upgrade_node.queue_free()
