extends Area2D

var level = 1
var hp = 999
var damage = 5
var speed = 300
var knockback_amount = 100
var fire_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 1
			speed = 300
			damage = 5 
			knockback_amount = 100
			fire_size =  1.0 * (1.0 + player.attack_size)
		2:
			hp = 2
			speed = 300
			damage = 8
			knockback_amount = 100
			fire_size = 1.0 * (1.0 + player.attack_size)
		3:
			hp = 2
			speed = 300
			damage = 8
			knockback_amount = 100
			fire_size = 1.0 * (1.0 + player.attack_size)
	
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1)*fire_size,1).set_trans(Tween.TRANS_QUINT).set_ease(tween.EASE_OUT)
	tween.play()

func _physics_process(delta):
	position += angle * speed * delta
	
func enemy_hit(_charge):
	pass


func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
