extends Area2D


func _ready():
	pass


func _on_coil_body_entered(body): 
	$sprite.play("action")
	$coil_audio.play()
	body.jump(1500, false)
