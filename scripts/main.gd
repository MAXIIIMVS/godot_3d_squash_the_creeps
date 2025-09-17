extends Node

@export var mob_scene: PackedScene


func _on_mob_timer_timeout():
	var mob := mob_scene.instantiate()
	$SpawnPath/SpawnLocation.progress_ratio = randf()

	mob.initialize($SpawnPath/SpawnLocation.position, $Player.position)
	add_child(mob)

	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())


func _on_player_hit() -> void:
	$MobTimer.stop()
