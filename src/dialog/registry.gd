extends Node2D

var registry = {
	"DATE": OS.get_datetime(),
	"SYSTEM": OS.get_name()
}

func lookup(name : String):
	return registry[name] if registry.has(name) else ""
