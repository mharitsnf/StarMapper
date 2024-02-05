class_name CommandCreate extends Command


var marker_pscn := preload("res://scenes/star_marker.tscn")

var marker_container : Node
var marker_instance : StarMarker
var target_position : Vector3


func set_data(args : Array = []) -> bool:
	if args.size() != 2: return false
	marker_container = args[0]
	target_position = args[1] + (args[1].normalized() * 2.)
	# var offset := (target_position.normalized() * target_position.length()) + Vector3.ONE
	return true


func get_marker():
	return marker_instance


func action(_args : Array = []) -> bool:
	if marker_instance: return false
	if !target_position: return false
	# Create the marker and put it on the scene tree
	marker_instance = marker_pscn.instantiate()
	marker_container.add_child(marker_instance)
	marker_instance.global_position = target_position
	return true


func undo(_args : Array = []) -> bool:
	if !marker_instance: return false # Check if marker_instance exists
	marker_instance.queue_free() # Delete the marker_instance
	marker_instance = null
	return true
