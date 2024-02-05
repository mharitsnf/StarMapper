class_name TimeController extends Node


var time := 0.


func _enter_tree():
    add_to_group("time_controller")


func _process(delta):
    time += delta


func get_time_elapsed():
    return time