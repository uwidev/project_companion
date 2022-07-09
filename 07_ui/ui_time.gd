extends ProgressBar

func _ready():
	WorldState.connect("time_advanced", self, "sync_resource")

func sync_resource():
	value = WorldState.time
