class_name Command extends Node


func set_data(_args : Array = []) -> Dictionary:
    return {"status": true}

func action(_args : Array = []) -> Dictionary:
    return {"status": true}

func undo(_args : Array = []) -> Dictionary:
    return {"status": true}

func destroy() -> Dictionary:
    return {"status": true}