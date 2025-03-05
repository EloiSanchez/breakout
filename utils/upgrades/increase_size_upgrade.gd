class_name IncreaseSizeUpgrade
extends BaseUpgrade


func perform_effect(game, upgrade_node: Node):
	game.board.increase_size()
	upgrade_node.queue_free()
