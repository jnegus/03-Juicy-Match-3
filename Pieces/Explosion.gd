extends Node2D


func play():
	$AnimatedSprite.playing = true

func _on_AnimatedSprite_animation_finished():
	queue_free()
