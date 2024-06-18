class_name StoryBook

extends PanelContainer


var story: PackedStringArray = ["A story is only born from the retelling of ages, coveted by humans within dusty mouths and books. But some stories shift before our very eyes, controlled by the threads of a higher power. This folklore tale is not one, but of many, and you will see that fate can be played if you are the writer...",
	"Now enough of that high fantasy blather, this is a tale of greed’s consequence. And it concerns a man called Osric, hailing from the well-known Riverbeard family.",
	"The Riverbeards were named after great great great great great great great great grandpa Cuthbert’s beard had grown so long he used it to fish in the local river, but that’s another tale.",
	"Osric’s tale begins as the young man is returning home after stealing a mystical dragon’s egg. Bad idea you say? You don’t need to tell me.",
	]
var current_page: int = -1:
	set(value):
		current_page = clamp(value, -1, story.size() - 1)
		
	get:
		return current_page


@onready var left_text: Label = $HSplitContainer/LeftPage/Text
@onready var left_number: Label = $HSplitContainer/LeftPage/Number
@onready var right_text: Label = $HSplitContainer/RightPage/Text
@onready var right_number: Label = $HSplitContainer/RightPage/Number


func _ready() -> void:
	fill_pages()


func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("move_left"):
		current_page -= 2
		fill_pages()
	if event.is_action_pressed("move_right"):
		current_page += 2
		fill_pages()


func add_page(str: String) -> void:
	story.append(str)

func fill_pages() -> void:
	left_text.set_text(get_page_text(current_page))
	right_text.set_text(get_page_text(current_page + 1))
	left_number.set_text(get_page_number(current_page))
	right_number.set_text(get_page_number(current_page + 1))

func get_page_text(page: int) -> String:
	print("getting text for page: ", page)
	if page < 0 or page >= story.size():
		return " "
	
	return story[page]

func get_page_number(page: int) -> String:
	if page < 0 or page >= story.size():
		return " "
	
	return str(page)

func show_latest_page() -> void:
	current_page = story.size()
	fill_pages()
