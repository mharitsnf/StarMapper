class_name StarMarker extends Marker3D


@export var mesh : MeshInstance3D
var time_controller : TimeController

var is_pulsating := false
var _previous_pulsating_speed := -1.
var pulsating_speed := -1.
var alpha_range = Vector2(-1, 1)

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
        var new_a = remap_values(
            sin(time_controller.get_time_elapsed() * pulsating_speed),
            -1., 1.,
            alpha_range.x, alpha_range.y
        )
        active_material.albedo_color.a = new_a


func set_selected_material(value : bool):
    next_pass.albedo_color.a = int(value)


func get_color():
    return active_material.albedo_color


func set_color(new_color : Color):
    active_material.albedo_color = new_color


func get_is_pulsating():
    return is_pulsating


func set_is_pulsating(value : bool):
    is_pulsating = value
    
    if value:
        pulsating_speed = _previous_pulsating_speed
    else:
        pulsating_speed = -1.
        active_material.albedo_color.a = 1


func get_alpha_range() -> Vector2:
    return alpha_range


func set_alpha_range(new_range : Vector2):
    alpha_range = new_range


func get_pulsating_speed():
    return pulsating_speed


func set_pulsating_speed(value : float):
    pulsating_speed = value
    _previous_pulsating_speed = value


func remap_values(old_value, old_min, old_max, new_min, new_max) -> float:
    return (((old_value - old_min) * (new_max - new_min)) / (old_max - old_min)) + new_min


func load(data : Dictionary):
    global_position = Vector3(
        data.tp_x, data.tp_y, data.tp_z,
    )
    set_is_pulsating(data.is_pulsating)
    set_pulsating_speed(data.pulsating_speed)
    set_alpha_range(Vector2(data.alpha_min, data.alpha_max))
    set_color(Color(data.color_r, data.color_g, data.color_b, 1))


func save() -> Dictionary:
    return {
        "np_x": global_position.normalized().x,
        "np_y": global_position.normalized().y,
        "np_z": global_position.normalized().z,
        "tp_x": global_position.x,
        "tp_y": global_position.y,
        "tp_z": global_position.z,
        "is_pulsating": is_pulsating,
        "pulsating_speed": pulsating_speed,
        "alpha_min": alpha_range.x,
        "alpha_max": alpha_range.y,
        "color_r": active_material.albedo_color.r,
        "color_g": active_material.albedo_color.g,
        "color_b": active_material.albedo_color.b,
    }