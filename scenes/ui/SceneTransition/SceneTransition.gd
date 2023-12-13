extends ColorRect


func fade_in(time: float = 0.5):
	modulate.a8 = 255
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color8(255, 255, 255, 0), time)
	await tween.finished

func fade_out(time: float = 0.5):
	modulate.a8 = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color8(255, 255, 255, 255), time)
	await tween.finished

func change_scene(scene: String, params = null):
	await fade_out()
	SceneSwitcher.change_scene_to_file(scene, params)
