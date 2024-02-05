class_name CommandDelete extends Command


var marker_pscn := preload("res://scenes/star_marker.tscn")

var target_position : Vector3
var marker_instance : StarMarker
var marker_container : Node


func set_data(args : Array = []) -> Dictionary:
    if args.size() != 2: return {"status": false}
    marker_container = args[0]
    marker_instance = args[1]
    target_position = marker_instance.global_position
    return {"status": true}


func action(_args : Array = []) -> Dictionary:
    if !marker_instance: return {"status": false}
    marker_container.remove_child(marker_instance)
    return {"status": true}


func undo(_args : Array = []) -> Dictionary:
    if !marker_instance: return {"status": false}
    marker_container.add_child(marker_instance)
    return {"status": true}