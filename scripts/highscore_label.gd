extends RichTextLabel
class_name HighscoreLabel

func _init() -> void:
	_refresh()

func _refresh():
	var highscores = ScoreManager.load_highscores()
	
	# Check if empty
	if highscores.is_empty():
		text = ":("
		return
	
	# Build the list
	var display_text = "TOP HIGHSCORES\n\n"
	var count = min(highscores.size(), 5)  # Max 5 entries
	
	for i in range(count):
		var entry = highscores[i]
		display_text += "%d. %s - %d\n" % [i + 1, entry.TeamName, int(entry.score)]
	
	text = display_text
