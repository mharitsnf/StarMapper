extends Node3D


@export var spring_arm : SpringArm3D
@export var rotation_speed : float
@export var y_rotation_limit : Vector2
@export var invert_x : bool
@export var invert_y : bool


func _unhandled_input(event):
    if event is InputEventMouseMotion and Input.is_action_pressed("grab_camera"): 
        var rel : Vector2 = event.relative
        var inv_x := float(invert_x) * 2. - 1.
        var inv_y := float(invert_y) * 2. - 1.
        rotate_y(rel.x * .001 * rotation_speed * inv_x)
        spring_arm.rotate_x(rel.y * .001 * rotation_speed * inv_y)
        spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, y_rotation_limit.x, y_rotation_limit.y)
