extends Label

var index: int = 0

var story_text: PackedStringArray = [
	"Gather round children, its time I told you the story Jonathan and the dragon...",
	"And he died... so moving on to Sian's confrontation with the dragon...",
	"And she died too... It was down to Joe",
	]

func _ready() -> void:
	set_text(story_text[index])


func update_story(dragon_killed: bool = false) -> void:
	if dragon_killed:
		set_text("The dragon was killed YAY!")
		return
	
	index += 1
	
	if index < story_text.size():
		set_text(story_text[index])
	else:
		set_text("story over")
