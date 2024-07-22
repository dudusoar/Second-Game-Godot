extends Node

const MAX_RANGE = 150
@export var sword_ability: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	# get_node("Timer")
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	# 获取玩家
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return 
	
	# 选取在玩家攻击范围内的敌人	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE,2)
	)
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_dist = a.global_position.distance_squared_to(player.global_position)
		var b_dist = b.global_position.distance_squared_to(player.global_position)
		if a_dist < b_dist:
			return true
		return false
	)
	
	# 实例化剑
	var sword_instance = sword_ability.instantiate() as Node2D
	# 在player下添加该节点为子节点
	player.get_parent().add_child(sword_instance)
	# 默认情况下当你往场景中添加一个2d节点时，默认位置是00
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = (enemies[0].global_position - sword_instance.global_position).normalized()
	sword_instance.rotation = enemy_direction.angle()
	
	
	
	
	
