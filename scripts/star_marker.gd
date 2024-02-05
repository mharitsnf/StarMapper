class_name StarMarker extends Marker3D


@export var mesh : MeshInstance3D
var time_controller : TimeController

var is_pulsating := false
var _previous_pulsating_speed := -1.
var pulsating_speed := -1.

var selected_mat : StandardMaterial3D = preload("res://materials/selected_material.tres")
var active_material : StandardMaterial3D
var next_pass : StandardMaterial3D


func _ready():
    active_material = mesh.get_active_material(0)
    assert(active_material)
    next_pass = active_material.next_pass
    assert(next_pass)
    time_controller = get_tree().get_first_node_in_group("time_controller")
    assert(time_controller)


func _process(_delta):
    if is_pulsating:
        active_material.albedo_color.a = sin(time_controller.get_time_elapsed() * pulsating_speed)


func set_selected_material(value : bool):
    next_pass.albedo_color.a = int(value)


func set_is_pulsating(value : bool):
    is_pulsating = value
    pulsating_speed = _previous_pulsating_speed if value else -1.
    
    # Reset albedo
    if !value: active_material.albedo_color.a = 1


func set_pulsating_speed(value : float):
    pulsating_speed = value
    _previous_pulsating_speed = value


func save() -> Dictionary:
    return {
        "np_x": global_position.normalized().x,
        "np_y": global_position.normalized().y,
        "np_z": global_position.normalized().z,
        "tp_x": global_position.x,
        "tp_y": global_position.y,
        "tp_z": global_position.z,
    }