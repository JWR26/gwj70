class_name NarrativeEvent
## Base class of a Narrative Event for the game. A Narrative event consists of text and the acompanying audio file.

extends Resource

## Text of the narrative events
@export_multiline var text: String
## Audio file containing the voiceover for the text.
@export var audio: AudioStreamMP3
