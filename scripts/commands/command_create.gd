class_name CommandCreate extends Command


var marker_pscn := preload("res://scenes/star_marker.tscn")

var marker_container : Node
var marker_instance : StarMarker
var target_position : Vector3


func set_data(args : Array = []) -> Dictionary:
	if args.size() != 2: return {"status": false}
	marker_container = args[0]
	target_position = args[1] + (args[1].normalized() * 2.)
	return {"status": true}


func action(_args : Array = []) -> Dictionary:
	if marker_instance: return {"status": false}
	if !target_position: return {"status": false}
	# Create the marker and put it on the scene tree
	marker_instance = marker_pscn.instantiate()
	marker_container.add_child(marker_instance)
	marker_instance.global_position = target_position
	return {"status": true}


func undo(_args : Array = []) -> Dictionary:
	if !marker_instance: return {"status": false} # Check if marker_instance exists
	marker_instance.queue_free() # Delete the marker_instance
	marker_instance = null
	return {"status": true}
