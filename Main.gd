extends Node

export(PackedScene) var Mob
var score: int
var highscore := 0

const STORAGE := "user://dodge.json"


func _ready() -> void:
	_load_highscore()
	var width = $Player.width
	var height = $Player.height
	$StartPosition.position = Vector2(width / 2, height / 2)
	$Background.rect_min_size = Vector2(width, height)
	var curve = $MobPath.curve
	curve.clear_points()
	curve.add_point(Vector2(0, 0))
	curve.add_point(Vector2(width, 0))
	curve.add_point(Vector2(width, height))
	curve.add_point(Vector2(0, height))
	curve.add_point(Vector2(0, 0))
	randomize()


func _load_highscore() -> void:
	var file := File.new()
	if not file.file_exists(STORAGE):
		return
	file.open(STORAGE, File.READ)
	var data = parse_json(file.get_line())
	highscore = data.highscore or 0
	file.close()


func _save_highscore() -> void:
	var file := File.new()
	var data = {highscore = highscore}
	file.open(STORAGE, File.WRITE)
	file.store_line(to_json(data))
	file.close()


func _on_StartTimer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout() -> void:
	score += 1
	if score > highscore:
		highscore = score
		$HUD.update_highscore(highscore)
	$HUD.update_score(score)


func _on_MobTimer_timeout() -> void:
	$MobPath/MobSpawnLocation.offset = randi()
	var mob: Mob = Mob.instance()
	add_child(mob)
	mob.start($MobPath/MobSpawnLocation)


func game_over() -> void:
	$IntroTheme.stop()
	$GameOverAudio.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	_save_highscore()


func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$IntroTheme.play()

