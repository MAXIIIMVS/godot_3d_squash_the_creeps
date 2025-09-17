extends Node

@export var mob_scene: PackedScene


func _on_mob_timer_timeout():
	var mob := mob_scene.instantiate()
	$SpawnPath/SpawnLocation.progress_ratio = randf()

	mob.initialize($SpawnPath/SpawnLocation.position, $Player.position)
	add_child(mob)
