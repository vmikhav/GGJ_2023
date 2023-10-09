extends Node

var _params = null

func change_scene_to_file(next_scene: String, params = null):
	_params = params
	get_tree().call_deferred("change_scene_to_file", next_scene)

func change_scene_to_packed(next_scene: PackedScene, params = null):
	_params = params
	get_tree().change_scene_to_packed(next_scene)

# In the newly opened scene, you can get the parameters by name
func get_param(param_name = null):
	if param_name == null:
		return _params
	if _params != null and _params.has(param_name):
		return _params[param_name]
	return null
