extends Area2D


func _ready():
	get_tree().call_group("game" , "add_stage_coins")
	pass


func _on_coins_body_entered(body):
	$coin_bronzer.play()
	$sprite.visible = false
	collision_mask = 0
	$queue_timer.start()
	$particles.emitting = true
	get_tree().call_group("coin_counter" , "coin_counter")
	
	


func _on_queue_timer_timeout():
	queue_free()
