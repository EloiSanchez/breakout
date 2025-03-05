class_name ExtraBallUpgrade
extends BaseUpgrade


func perform_effect(game, upgrade_node: Node):
	game.spawn_ball(upgrade_node.position, true)
	upgrade_node.queue_free()
