extends Node2D

class TimingGauge extends Control:
	var value := 0.0

	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color("#b6a99a"))
		draw_rect(Rect2(Vector2(size.x * 0.70, 0), Vector2(size.x * 0.15, size.y)), Color("#91a88a"))
		var marker_x := size.x * value / 100.0
		draw_rect(Rect2(Vector2(marker_x - 4, -3), Vector2(8, size.y + 6)), Color("#a75e48"))

const INK := Color("#382d37")
const CREAM := Color("#fff4df")

var player_mood := 35
var relationship_chef := 50
var relationship_advertiser := 50
var relationship_dancer := 50
var relationship_philosopher := 50
var relationship_chef_dancer := 50
var week_one_room_conflict_outcome := ""
var dancer_peanut_memory := false
var dancer_peanut_dish_served := false
var dancer_showcase_route_active := false
var dancer_showcase_intro_done := false
var dancer_showcase_choice := ""
var dancer_showcase_callback_done := false
var week_two_review_result := ""
var week_two_review_hint := ""
var philosopher_ai_route_active := false
var philosopher_ai_decision_done := false
var philosopher_sunday_followup_done := false
var philosopher_ai_opening_stance := ""
var philosopher_sunday_response := ""
var spatial_harmony := 50
var player_extroversion := 50
var work_reputation := 50
var work_task := ""
var work_task_active := false
var work_task_done := false
var work_choice := ""
var work_task_name_label: Label
var work_task_deadline_label: Label
var joined_dinner_plan := false
var declined_dinner_plan := false
var sunday_completed := false
var sunday_shared_plan := false
var monday_completed := false
var monday_evening_completed := false
var monday_forgot_chore := false
var makeup_task_active := false
var dance_rehearsal_active := false
var dancer_rehearsal_invited := false
var dancer_rehearsal_resolved := false
var weekly_cycle_active := false
var weekly_story_week := false
var weekly_household_intro_active := false
var weekly_intro_tallied := false
var weekly_story_stage := ""
var weekly_meeting_open := false
var weekly_week := 1
var weekly_day := 0
var weekly_harmony_start := 50
var weekly_pending_harmony := 0
var weekly_tasks_total := 0
var weekly_tasks_done := 0
var weekly_efficiency_choices := 0
var weekly_care_choices := 0
var consecutive_low_weeks := 0
var weekly_challenge_active := false
var weekly_last_task_completed := false
var weekly_chore_done := false
var weekly_chore_resolved := false
var weekly_previous_chore_done := false
var weekly_tuesday_memory_tag := ""
var weekly_tuesday_roommate := ""
var weekly_cycle_stage := ""
var weekly_dinner_decided := false
var weekly_log_start_index := 0
var weekly_meeting_dialogue := ""
var weekly_meeting_hint := ""
var monday_plan := ""
var current_task := ""
var current_task_active := false
var visited_activities: Array[String] = []
var weekend_memories: Array[String] = []
var day_log: Array[String] = []
var mindset_shift := ""
var place := "厨房"
var time_text := "周二   20:08"
var choice_buttons: Array[Button] = []
var time_label: Label
var dialogue_label: Label
var speaker_label: Label
var status_label: Label
var task_panel: PanelContainer
var task_name_label: Label
var task_deadline_label: Label
var hint_label: Label
var choice_row: HBoxContainer
var dialogue_panel: PanelContainer
var dialogue_scroll: ScrollContainer
var cooking_row: HBoxContainer
var cooking_meter: TimingGauge
var cooking_minigame_active := false
var cooking_phase := 0.0
var cooking_direction := 1.0
var cooking_hits := 0
var cooking_attempts := 0

func _ready() -> void:
	_draw_interface()
	_show_start_menu()

func _draw_interface() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	time_label = Label.new()
	time_label.text = "MIDNIGHTLOFT     ·     " + time_text
	time_label.position = Vector2(28, 20)
	time_label.add_theme_font_size_override("font_size", 17)
	time_label.add_theme_color_override("font_color", CREAM)
	layer.add_child(time_label)
	status_label = Label.new()
	status_label.position = Vector2(28, 48)
	status_label.add_theme_font_size_override("font_size", 14)
	status_label.add_theme_color_override("font_color", Color("#e9c6b5"))
	layer.add_child(status_label)
	_update_status()
	task_panel = PanelContainer.new()
	task_panel.position = Vector2(710, 20)
	task_panel.size = Vector2(230, 145)
	task_panel.visible = false
	var task_style := StyleBoxFlat.new()
	task_style.bg_color = Color("#fff6e9")
	task_style.border_color = Color("#d9ad86")
	task_style.set_border_width_all(2)
	task_style.set_corner_radius_all(12)
	task_style.content_margin_left = 12
	task_style.content_margin_right = 12
	task_style.content_margin_top = 8
	task_style.content_margin_bottom = 8
	task_panel.add_theme_stylebox_override("panel", task_style)
	layer.add_child(task_panel)
	var task_box := VBoxContainer.new()
	task_box.add_theme_constant_override("separation", 4)
	task_panel.add_child(task_box)
	var task_title := Label.new()
	task_title.text = "今日待办"
	task_title.add_theme_font_size_override("font_size", 14)
	task_title.add_theme_color_override("font_color", Color("#a75e48"))
	task_box.add_child(task_title)
	task_name_label = Label.new()
	task_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	task_name_label.add_theme_font_size_override("font_size", 14)
	task_name_label.add_theme_color_override("font_color", INK)
	task_box.add_child(task_name_label)
	task_deadline_label = Label.new()
	task_deadline_label.add_theme_font_size_override("font_size", 12)
	task_deadline_label.add_theme_color_override("font_color", Color("#8e7770"))
	task_box.add_child(task_deadline_label)
	var work_title := Label.new()
	work_title.text = "工作待办"
	work_title.add_theme_font_size_override("font_size", 13)
	work_title.add_theme_color_override("font_color", Color("#a75e48"))
	task_box.add_child(work_title)
	work_task_name_label = Label.new()
	work_task_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	work_task_name_label.add_theme_font_size_override("font_size", 13)
	work_task_name_label.add_theme_color_override("font_color", INK)
	task_box.add_child(work_task_name_label)
	work_task_deadline_label = Label.new()
	work_task_deadline_label.add_theme_font_size_override("font_size", 11)
	work_task_deadline_label.add_theme_color_override("font_color", Color("#8e7770"))
	task_box.add_child(work_task_deadline_label)

	dialogue_panel = PanelContainer.new()
	dialogue_panel.position = Vector2(36, 365)
	dialogue_panel.size = Vector2(888, 148)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#fff6e9")
	style.border_color = Color("#d9ad86")
	style.set_border_width_all(2)
	style.set_corner_radius_all(16)
	style.content_margin_left = 22
	style.content_margin_right = 22
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	dialogue_panel.add_theme_stylebox_override("panel", style)
	layer.add_child(dialogue_panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 7)
	dialogue_panel.add_child(box)
	speaker_label = Label.new()
	speaker_label.add_theme_font_size_override("font_size", 17)
	speaker_label.add_theme_color_override("font_color", Color("#a75e48"))
	box.add_child(speaker_label)
	dialogue_scroll = ScrollContainer.new()
	dialogue_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dialogue_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dialogue_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(dialogue_scroll)
	dialogue_label = Label.new()
	dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_label.custom_minimum_size = Vector2(820, 42)
	dialogue_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dialogue_label.add_theme_font_size_override("font_size", 19)
	dialogue_label.add_theme_color_override("font_color", INK)
	dialogue_scroll.add_child(dialogue_label)
	cooking_row = HBoxContainer.new()
	cooking_row.visible = false
	cooking_row.add_theme_constant_override("separation", 12)
	box.add_child(cooking_row)
	cooking_meter = TimingGauge.new()
	cooking_meter.custom_minimum_size = Vector2(820, 18)
	cooking_row.add_child(cooking_meter)
	choice_row = HBoxContainer.new()
	choice_row.add_theme_constant_override("separation", 12)
	box.add_child(choice_row)
	hint_label = Label.new()
	hint_label.add_theme_font_size_override("font_size", 13)
	hint_label.add_theme_color_override("font_color", Color("#8e7770"))
	box.add_child(hint_label)

func _process(delta: float) -> void:
	if not cooking_minigame_active:
		return
	cooking_phase += delta * 95.0 * cooking_direction
	if cooking_phase >= 100.0:
		cooking_phase = 100.0
		cooking_direction = -1.0
	elif cooking_phase <= 0.0:
		cooking_phase = 0.0
		cooking_direction = 1.0
	cooking_meter.value = cooking_phase
	cooking_meter.queue_redraw()

func _update_status() -> void:
	var bond_text := "刚认识"
	if relationship_chef >= 55:
		bond_text = "熟悉了一点"
	if relationship_chef >= 70:
		bond_text = "亲近起来"
	status_label.text = "心情 %d / 100     ·     空间和睦值 %d / 100     ·     玩家外向值 %d / 100     ·     工作声望 %d / 100     ·     和大厨：%s" % [player_mood, spatial_harmony, player_extroversion, work_reputation, bond_text]
	if weekly_cycle_active and not weekly_meeting_open:
		var weekly_harmony_change := spatial_harmony - weekly_harmony_start + weekly_pending_harmony
		status_label.text += "     ·     本周变化 %s" % [_format_signed(weekly_harmony_change)]

func _format_signed(value: int) -> String:
	if value > 0:
		return "+" + str(value)
	return str(value)

func _set_scene(new_place: String, new_time: String) -> void:
	place = new_place
	time_text = new_time
	time_label.text = "MIDNIGHTLOFT     ·     " + time_text
	if dialogue_scroll != null:
		dialogue_scroll.scroll_vertical = 0
	queue_redraw()

func _set_current_task(task: String, deadline: String = "周二之前") -> void:
	current_task = task
	current_task_active = true
	task_name_label.text = "□ " + current_task
	task_deadline_label.text = "完成期限：%s" % deadline
	task_panel.visible = true

func _complete_current_task(completion_time: String = "周一晚上") -> void:
	current_task_active = false
	task_name_label.text = "✓ " + current_task
	task_deadline_label.text = "已完成 · " + completion_time

func _expire_current_task() -> void:
	current_task_active = false
	task_name_label.text = "× " + current_task
	task_deadline_label.text = "已错过期限"

func _set_work_task(task: String, deadline: String) -> void:
	work_task = task
	work_task_active = true
	work_task_name_label.text = "□ " + task
	work_task_deadline_label.text = "完成期限：%s" % deadline
	task_panel.visible = true

func _clear_work_task() -> void:
	work_task_active = false
	work_task_name_label.text = "— 暂无工作待办"
	work_task_deadline_label.text = ""

func _note_task_makeup() -> void:
	_set_current_task("补做：" + current_task, "周三之前")
	makeup_task_active = true
	if weekly_household_intro_active:
		weekly_tasks_total += 1

func _show_opening() -> void:
	_set_scene("厨房", "周二   20:08")
	speaker_label.text = "大厨"
	dialogue_label.text = "哟，回来啦。正好我在煮茶，要不要喝一点？"
	hint_label.text = "你刚结束一场潜在合作伙伴面谈，第一次回到 Loft。"
	_clear_choices()
	_add_choice("好啊，今天脑子有点转不动了。", _accept_tea)
	_add_choice("谢谢，我想先安静坐一会儿。", _rest_first)

func _show_start_menu() -> void:
	_set_scene("厨房", "Week 1 · 开始")
	dialogue_panel.position = Vector2(36, 365)
	dialogue_panel.size = Vector2(888, 148)
	dialogue_label.custom_minimum_size = Vector2(820, 42)
	dialogue_label.add_theme_font_size_override("font_size", 19)
	speaker_label.text = "MIDNIGHTLOFT"
	dialogue_label.text = "从 Week 1 周一开始，和室友一起经历完整的一周。"
	hint_label.text = "按周一到周日推进，或选择日期直接进入当天，方便体验和测试。"
	_clear_choices()
	_add_choice("开始 Week 1 · 周一", _start_weekly_loop, 350.0)
	_add_choice("选择日期", _show_date_menu, 350.0)

func _show_date_menu() -> void:
	_set_scene("厨房", "Week 1 · 选择日期")
	dialogue_panel.position = Vector2(36, 340)
	dialogue_panel.size = Vector2(888, 173)
	speaker_label.text = "选择进入日期"
	dialogue_label.text = "选择后会从当天开始体验，不会自动补演之前的事件。"
	hint_label.text = "日期入口使用独立的初始状态；想体验连续影响，请从周一开始。"
	_clear_choices()
	var day_labels: Array[String] = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
	for day_index in range(day_labels.size()):
		_add_choice(day_labels[day_index], _start_week_one_day.bind(day_index), 90.0)
	_add_choice("返回", _show_start_menu, 90.0)

func _start_week_one_day(day_index: int) -> void:
	_reset_run()
	weekly_cycle_active = true
	weekly_week = 1
	weekly_day = day_index
	weekly_harmony_start = spatial_harmony
	weekly_log_start_index = day_log.size()
	weekly_cycle_stage = "daily"
	if day_index == 0:
		_start_monday()
		return
	weekly_chore_done = false
	weekly_chore_resolved = false
	weekly_tasks_total = 1
	_set_current_task("打扫公共区域", "周日之前")
	if day_index >= 1 and day_index <= 4:
		joined_dinner_plan = true
		weekly_dinner_decided = true
	if day_index == 4:
		# 周五入口提供一条可直接体验的协商后回响。
		week_one_room_conflict_outcome = "negotiate"
		relationship_chef_dancer = 56
	if day_index >= 5:
		joined_dinner_plan = true
		weekly_dinner_decided = true
		dancer_peanut_memory = true
	_start_weekly_day()

func _start_weekly_loop() -> void:
	_reset_run()
	weekly_cycle_active = true
	weekly_story_week = false
	weekly_week = 1
	weekly_harmony_start = spatial_harmony
	weekly_day = 0
	_start_monday()

func _start_weekly_day() -> void:
	if weekly_cycle_active:
		if weekly_week >= 2 and weekly_day > 2:
			if weekly_week == 2 and weekly_day == 3 and dancer_showcase_route_active and not dancer_showcase_callback_done:
				_start_week_two_dancer_showcase_callback()
				return
			weekly_cycle_stage = "week_two_finished"
			_set_scene("客厅", "第%d周 · 暂未开放" % weekly_week)
			speaker_label.text = "第二周 · 暂告一段落"
			dialogue_label.text = "第二周目前只开放周一至周三剧情；如果第一周听过舞者准备演出的事，还能在周四看到她的回响。"
			hint_label.text = "可以回到开始界面，重新体验第一周的不同选择。"
			_clear_choices()
			_add_choice("结束这次试玩，回到开始界面", _restart_evening, 405.0)
			return
		match weekly_day:
			0:
				_start_monday()
			1:
				if weekly_week == 2:
					_start_week_two_tuesday()
				else:
					_start_week_one_work_choice()
			2:
				if weekly_week == 2:
					_start_week_two_wednesday()
				else:
					if work_task_active:
						_resolve_week_one_work_task()
					else:
						_cycle_daily_event()
			3, 4:
				_cycle_daily_event()
			5:
				if weekly_week == 1 and not dancer_showcase_intro_done:
					_start_dancer_showcase_intro()
					return
				if declined_dinner_plan:
					_show_weekend_dinner()
				else:
					_start_weekend_activities()
			6:
				_start_sunday()
		return
	if weekly_day >= 5:
		if weekly_story_week:
			if declined_dinner_plan:
				_show_weekend_dinner()
			else:
				_start_weekend_activities()
		else:
			_start_weekly_meeting()
		return
	if weekly_story_week:
		weekly_story_stage = "weekday"
	if not current_task_active and not work_task_active:
		task_panel.visible = false
	var day_names: Array[String] = ["周一", "周二", "周三", "周四", "周五"]
	var day_places: Array[String] = ["客厅", "厨房", "露台", "客厅", "厨房"]
	var day_prompts: Array[String] = [
		"新的一周开始了。大家在冰箱边看本周安排，广告人问你想先把流程定清楚，还是先听听大家各自的时间。",
		"大厨发现共享食材快用完了。哲学家想先列出缺少的东西，舞者则问大家最近有没有顾不上吃饭。",
		"舞者提到客厅最近总被临时占用。有人想马上排好时段，也有人觉得应该先问问彼此的需要。",
		"广告人发现这周有两项事情撞在一起。你们可以压缩讨论尽快定下来，也可以多留一点时间协调。",
		"周五下班前，哲学家问大家要不要先看完成了多少，再决定周末例会要讨论什么。"
	]
	dialogue_panel.position = Vector2(36, 275)
	dialogue_panel.size = Vector2(888, 245)
	dialogue_label.custom_minimum_size = Vector2(820, 95)
	dialogue_label.add_theme_font_size_override("font_size", 19)
	_set_scene(day_places[weekly_day], "%s   09:00" % day_names[weekly_day])
	_update_status()
	speaker_label.text = "%s · Loft日常" % day_names[weekly_day]
	dialogue_label.text = day_prompts[weekly_day]
	if weekly_day == 0 and weekly_challenge_active:
		dialogue_label.text += " 上周连续两次落在低和睦区间，大家还希望你今天额外确认本周分工。"
	hint_label.text = "今天的处理方式会影响团队气氛，并决定你今天记下的待办。"
	_clear_choices()
	_add_choice("先把进度和安排定下来", _weekly_choose_efficiency, 350.0)
	_add_choice("先听听大家的情况，再一起决定", _weekly_choose_care, 405.0)

func _weekly_choose_efficiency() -> void:
	_weekly_choose(false)

func _weekly_choose_care() -> void:
	_weekly_choose(true)

func _weekly_choose(care_first: bool) -> void:
	var day_names: Array[String] = ["周一", "周二", "周三", "周四", "周五"]
	var efficient_tasks: Array[String] = ["整理本周公共区轮值", "清点共享食材", "确认客厅使用时段", "整理本周共同开销", "汇总本周进度"]
	var care_tasks: Array[String] = ["确认大家本周的时间安排", "问问大家最近有没有按时吃饭", "和舞者商量客厅排练时间", "确认大家对共同开销是否有顾虑", "听听大家这周过得怎么样"]
	weekly_tasks_total += 1
	if care_first:
		weekly_care_choices += 1
		weekly_pending_harmony += 2
		current_task = care_tasks[weekly_day]
		dialogue_label.text = "你们多聊了一会儿，才把各自的顾虑拼到一起。今天要记得：%s。" % current_task
		hint_label.text = "大家感觉被听见了；安排花的时间也比预想更长。"
	else:
		weekly_efficiency_choices += 1
		weekly_pending_harmony -= 2
		current_task = efficient_tasks[weekly_day]
		dialogue_label.text = "你把讨论收拢成了明确的下一步。今天要记得：%s。" % current_task
		hint_label.text = "事情很快有了着落，但有人的想法还没来得及展开。"
	if weekly_day == 0 and weekly_challenge_active:
		current_task = "修复信任：" + current_task
		weekly_challenge_active = false
	current_task_active = true
	task_name_label.text = "□ " + current_task
	task_deadline_label.text = "完成期限：今天结束前"
	task_panel.visible = true
	day_log.append("第%d周 %s：选择%s，记下待办“%s”。" % [weekly_week, day_names[weekly_day], "先听大家再决定" if care_first else "优先定下进度", current_task])
	_clear_choices()
	_add_choice("记得去完成今天的待办", _weekly_complete_task, 350.0)
	_add_choice("太累了，今天先休息", _weekly_miss_task, 350.0)
	_update_status()

func _weekly_complete_task() -> void:
	var day_names: Array[String] = ["周一", "周二", "周三", "周四", "周五"]
	weekly_tasks_done += 1
	weekly_pending_harmony += 2
	weekly_last_task_completed = true
	_complete_current_task("今天")
	day_log.append("第%d周%s：完成“%s”，当天待办结清。" % [weekly_week, day_names[weekly_day], current_task])
	_weekly_show_day_result(true)

func _weekly_miss_task() -> void:
	var day_names: Array[String] = ["周一", "周二", "周三", "周四", "周五"]
	weekly_pending_harmony -= 4
	weekly_last_task_completed = false
	_expire_current_task()
	day_log.append("第%d周%s：没有完成“%s”，待办记为未完成。" % [weekly_week, day_names[weekly_day], current_task])
	_weekly_show_day_result(false)

func _weekly_show_day_result(completed: bool) -> void:
	if weekly_story_week:
		weekly_story_stage = "weekday_result"
	var day_names: Array[String] = ["周一", "周二", "周三", "周四", "周五"]
	speaker_label.text = "%s · 当天结算" % day_names[weekly_day]
	if completed:
		dialogue_label.text = "今天结束了。“%s”已经完成。团队氛围的变化会在周末例会上和整周表现一起结算。" % current_task
		hint_label.text = "本周待办：%d / %d 完成。" % [weekly_tasks_done, weekly_tasks_total]
	else:
		dialogue_label.text = "今天结束时，“%s”还没有完成。室友先把事情接了过去，这笔影响会留到周末例会。" % current_task
		hint_label.text = "本周待办：%d / %d 完成；漏掉的事情也已经记进日志。" % [weekly_tasks_done, weekly_tasks_total]
	_update_status()
	dialogue_panel.position = Vector2(36, 285)
	dialogue_panel.size = Vector2(888, 230)
	dialogue_label.custom_minimum_size = Vector2(820, 75)
	dialogue_label.add_theme_font_size_override("font_size", 19)
	_clear_choices()
	_add_choice("结束今天，进入下一天", _advance_weekly_day, 350.0)

func _advance_weekly_day() -> void:
	weekly_day += 1
	_start_weekly_day()

func _cycle_monday_evening() -> void:
	weekly_cycle_stage = "monday_evening"
	_set_scene("厨房", "周一   20:08")
	speaker_label.text = "大厨"
	dialogue_label.text = "周一晚上，你回到家。大厨正在泡茶，问你要不要坐下来喝一杯。客厅里，广告人也在聊周六的饭局。"
	hint_label.text = "这周唯一的待办还在右上角；今晚可以先处理，也可以留到周日之前。"
	_clear_choices()
	_add_choice("接过茶，和大厨聊一会儿", _cycle_accept_tea, 260.0)
	_add_choice("今天有点累，先自己待一会儿", _cycle_decline_tea, 260.0)
	if not weekly_chore_done:
		_add_choice("今晚先打扫公共区域", _cycle_clean_chore, 260.0)

func _cycle_accept_tea() -> void:
	player_mood = clampi(player_mood + 6, 0, 100)
	relationship_chef = clampi(relationship_chef + 4, 0, 100)
	weekly_care_choices += 1
	day_log.append("第%d周周一晚：和大厨喝茶，心情 +6、大厨关系 +4。" % weekly_week)
	_update_status()
	_cycle_monday_invitation()

func _cycle_decline_tea() -> void:
	player_mood = clampi(player_mood + 2, 0, 100)
	weekly_efficiency_choices += 1
	day_log.append("第%d周周一晚：没有喝茶，回房休息了一会儿，心情 +2。" % weekly_week)
	_update_status()
	_cycle_monday_invitation()

func _cycle_monday_invitation() -> void:
	weekly_cycle_stage = "monday_invitation"
	_set_scene("客厅", "周一   20:25")
	if weekly_dinner_decided:
		_cycle_monday_after_invitation()
		return
	speaker_label.text = "广告人 · 舞者"
	dialogue_label.text = "广告人提起周六晚饭，问你这周要不要一起参加。大厨说可以给你留个位置，舞者已经在想饭后放什么歌。"
	hint_label.text = "周六是否参加会改变大家迎接你的方式。"
	_clear_choices()
	_add_choice("好啊，周六我一起参加", _cycle_join_dinner, 260.0)
	_add_choice("我先听大家商量", _cycle_listen_dinner, 260.0)
	_add_choice("周六有事，可能去不了", _cycle_decline_dinner, 260.0)

func _cycle_monday_after_invitation() -> void:
	weekly_cycle_stage = "monday_invitation"
	speaker_label.text = "周一 · 晚饭后"
	if declined_dinner_plan:
		dialogue_label.text = "你说明周六可能有事。广告人说没关系，大厨会留些汤；大家各自回房，周一就这样结束了。"
	else:
		dialogue_label.text = "周六饭局的安排已经说定。舞者开始想歌单，大家各自回房，周一就这样结束了。"
	hint_label.text = "公共卫生待办仍可在周日之前完成。"
	_clear_choices()
	if not weekly_chore_done:
		_add_choice("今晚顺手打扫公共区域", _cycle_clean_chore, 350.0)
	_add_choice("结束周一，进入周二", _cycle_advance_day, 350.0)

func _cycle_join_dinner() -> void:
	weekly_dinner_decided = true
	joined_dinner_plan = true
	declined_dinner_plan = false
	spatial_harmony = clampi(spatial_harmony + 4, 0, 100)
	relationship_advertiser = clampi(relationship_advertiser + 3, 0, 100)
	weekly_care_choices += 1
	day_log.append("第%d周周一：答应参加周六饭局，空间和睦 +4、广告人关系 +3。" % weekly_week)
	_update_status()
	_cycle_monday_invitation()

func _cycle_listen_dinner() -> void:
	weekly_dinner_decided = true
	joined_dinner_plan = true
	declined_dinner_plan = false
	spatial_harmony = clampi(spatial_harmony + 2, 0, 100)
	relationship_philosopher = clampi(relationship_philosopher + 2, 0, 100)
	weekly_care_choices += 1
	day_log.append("第%d周周一：先听室友商量饭局安排，空间和睦 +2、哲学家关系 +2。" % weekly_week)
	_update_status()
	_cycle_monday_invitation()

func _cycle_decline_dinner() -> void:
	weekly_dinner_decided = true
	joined_dinner_plan = false
	declined_dinner_plan = true
	day_log.append("第%d周周一：说明周六可能有事，室友答应为你留些晚饭。" % weekly_week)
	_cycle_monday_invitation()

func _cycle_clean_chore() -> void:
	if weekly_chore_done or weekly_chore_resolved:
		return
	weekly_chore_done = true
	weekly_chore_resolved = true
	weekly_tasks_done = 1
	weekly_last_task_completed = true
	_complete_current_task("期限内")
	spatial_harmony = clampi(spatial_harmony + 8, 0, 100)
	relationship_chef = clampi(relationship_chef + 4, 0, 100)
	player_mood = clampi(player_mood - 1, 0, 100)
	day_log.append("第%d周：完成公共区域打扫，空间和睦 +8、大厨关系 +4、心情 -1。" % weekly_week)
	speaker_label.text = "本周待办 · 已完成"
	dialogue_label.text = "你把客厅和餐桌收拾干净。大厨看了一圈，笑着说：“这样周末大家回来就能直接坐下了。”"
	hint_label.text = "这周的打扫已经完成；接下来几天不会再出现新待办。"
	_update_status()
	_clear_choices()
	if weekly_day == 0:
		_add_choice("继续周一晚上的聊天", _cycle_monday_invitation, 350.0)
	elif weekly_day >= 6:
		_add_choice("回到周日早晨", _start_sunday, 350.0)
	else:
		_add_choice("结束今天，进入下一天", _cycle_advance_day, 350.0)

func _cycle_daily_event() -> void:
	var speaker := ""
	var prompt := ""
	var option_a := ""
	var option_b := ""
	match weekly_day:
		1:
			speaker = "周二 · 下班后"
			prompt = "工作一天回到 Loft，广告人正和舞者聊周末的歌单。你在门口听了一会儿。"
			option_a = "留下来和她们聊聊周末计划"
			option_b = "回房间自己听会儿歌"
		2:
			speaker = "周三 · 客厅"
			prompt = "你今天在外面工作得很累。回家时，舞者刚练完一段动作，正和广告人聊起排练后的晚饭。"
			option_a = "听舞者说说她今天的排练"
			option_b = "戴上耳机，一个人听歌放松"
		3:
			if weekly_week == 1:
				_start_week_one_room_conflict()
				return
			speaker = "周四 · 晚饭后"
			prompt = "晚饭后大家还没散开。有人聊起最近的工作，有人只想坐着听别人说。"
			option_a = "加入大家的聊天"
			option_b = "安静听大家聊一会儿"
		4:
			speaker = "周五 · 回家路上"
			prompt = "一周快结束了。广告人发来消息问你今晚想不想一起在客厅待一会儿。"
			if weekly_week == 1 and not week_one_room_conflict_outcome.is_empty():
				prompt = "一周快结束了。你回到客厅时，大厨和舞者都在，周四的分歧还留在空气里。"
			option_a = "回家后和大家聊聊这一周"
			option_b = "先独自听歌，把工作放下"
	weekly_cycle_stage = "daily"
	_set_scene("客厅", "第%d周 周%d   19:30" % [weekly_week, weekly_day + 1])
	speaker_label.text = speaker
	dialogue_label.text = prompt
	hint_label.text = "今天没有新增待办；本周公共卫生任务仍可在周日之前完成。"
	_clear_choices()
	_add_choice(option_a, _cycle_daily_choice_a, 405.0)
	_add_choice(option_b, _cycle_daily_choice_b, 405.0)

func _start_week_one_work_choice() -> void:
	weekly_cycle_stage = "week_one_work_choice"
	_set_scene("厨房", "第1周 周二   19:10")
	speaker_label.text = "工作消息"
	dialogue_label.text = "下班前，合作方发来消息：明天上午要看一版更新后的提案。你知道多花几个小时能把它做得更完整，但今天已经很累，家里也还有约定的公共卫生待办。"
	hint_label.text = "工作声望代表你在职业上的可靠度；高声望会打开不同的人生选择。"
	_clear_choices()
	_add_choice("今晚留下来，完成整份提案", _work_choice_full, 280.0)
	_add_choice("和对方协商，只交关键部分", _work_choice_scope, 280.0)
	_add_choice("说明明早再交，今晚下班休息", _work_choice_boundary, 280.0)

func _work_choice_full() -> void:
	work_choice = "full"
	work_reputation = clampi(work_reputation + 12, 0, 100)
	player_mood = clampi(player_mood - 4, 0, 100)
	_set_work_task("补完并提交整份提案", "周三上午")
	day_log.append("第1周周二：选择加班完成整份提案；工作声望 +12、心情 -4，新增工作待办。")
	_finish_work_choice("你留下来把提案逐页修完。发出去时已经很晚，合作方回复说会在明早仔细看。")

func _work_choice_scope() -> void:
	work_choice = "scope"
	work_reputation = clampi(work_reputation + 8, 0, 100)
	player_mood = clampi(player_mood - 1, 0, 100)
	_set_work_task("完成提案的关键页面", "周三上午")
	day_log.append("第1周周二：与合作方协商交付范围；工作声望 +8、心情 -1，新增精简版工作待办。")
	_finish_work_choice("你回复合作方，今晚先整理关键页面，明早补充其余内容。对方确认了新的交付范围。")

func _work_choice_boundary() -> void:
	work_choice = "boundary"
	work_reputation = clampi(work_reputation + 2, 0, 100)
	player_mood = clampi(player_mood + 3, 0, 100)
	day_log.append("第1周周二：说明今晚需要休息，并约定明早交付；工作声望 +2、心情 +3，没有新增工作待办。")
	_finish_work_choice("你说明今晚已经无法保证质量，提出明早按约定时间提交。对方接受了时间安排；你按时下班，也没有因此损失信誉。")

func _finish_work_choice(result_text: String) -> void:
	_update_status()
	speaker_label.text = "工作与生活"
	dialogue_label.text = result_text
	hint_label.text = "工作声望 %d / 100。右上角工作待办与生活待办分别记录。" % work_reputation
	_clear_choices()
	_add_choice("回到 Loft，继续今晚的生活", _cycle_daily_event, 405.0)

func _resolve_week_one_work_task() -> void:
	weekly_cycle_stage = "week_one_work_task"
	_set_scene("工作桌", "第1周 周三   08:30")
	speaker_label.text = "周三 · 工作待办"
	dialogue_label.text = "早上，你还有时间处理昨天答应的提案。你可以现在完成交付，也可以把时间留给休息和今天的生活。"
	hint_label.text = "工作待办显示在右上角；生活中的打扫待办仍然保留。"
	_clear_choices()
	_add_choice("完成并提交工作内容", _complete_work_task, 350.0)
	_add_choice("先休息，错过这次交付", _miss_work_task, 350.0)

func _complete_work_task() -> void:
	work_task_active = false
	work_task_done = true
	work_reputation = clampi(work_reputation + 8, 0, 100)
	work_task_name_label.text = "✓ " + work_task
	work_task_deadline_label.text = "已完成 · 周三上午"
	player_mood = clampi(player_mood + 1, 0, 100)
	day_log.append("第1周周三：按约提交工作待办，工作声望 +8、心情 +1。")
	_finish_work_task("你按约把提案发给合作方。对方确认收到，也认可你清楚交代了交付内容。", "工作声望 +8；按时完成工作待办。")

func _miss_work_task() -> void:
	work_task_active = false
	work_task_name_label.text = "× " + work_task
	work_task_deadline_label.text = "已错过期限"
	work_reputation = clampi(work_reputation - 6, 0, 100)
	player_mood = clampi(player_mood + 2, 0, 100)
	spatial_harmony = clampi(spatial_harmony - 1, 0, 100)
	day_log.append("第1周周三：没有按时提交工作待办，工作声望 -6、空间和睦 -1；你获得了休息时间。")
	_finish_work_task("你先放下了提案，补了一会儿觉。合作方发来消息确认延期，工作声望有所下降；今晚你能更有精神地回到 Loft。", "工作声望 -6、空间和睦 -1；休息时间 +2 心情。")

func _finish_work_task(result_text: String, result_hint: String) -> void:
	_update_status()
	speaker_label.text = "工作待办结算"
	dialogue_label.text = result_text
	hint_label.text = result_hint
	_clear_choices()
	_add_choice("继续周三晚上的生活", _cycle_daily_event, 405.0)

func _start_week_one_room_conflict() -> void:
	weekly_cycle_stage = "daily"
	_set_scene("客厅", "第1周 周四   19:30")
	speaker_label.text = "大厨 · 舞者"
	dialogue_label.text = "舞者刚把客厅的椅子挪开，准备练一段新编舞。大厨端着刚泡好的茶进来，担心茶几和餐具会被碰乱：“客厅是大家共用的，能不能先把东西放回去？”舞者停下动作：“我只是想找个地方练习，不想每次都先解释。”"
	hint_label.text = "这是一次关于共享空间的分歧；今天不会产生新待办。你可以表明立场，也可以帮他们商量时间。"
	_clear_choices()
	_add_choice("支持大厨：先把客厅收好", _room_conflict_support_chef, 260.0)
	_add_choice("支持舞者：她也需要排练空间", _room_conflict_support_dancer, 260.0)
	_add_choice("建议划定排练时段，之后恢复摆设", _room_conflict_negotiate, 300.0)

func _room_conflict_support_chef() -> void:
	week_one_room_conflict_outcome = "chef"
	relationship_chef = clampi(relationship_chef + 2, 0, 100)
	relationship_dancer = clampi(relationship_dancer - 1, 0, 100)
	relationship_chef_dancer = clampi(relationship_chef_dancer - 4, 0, 100)
	spatial_harmony = clampi(spatial_harmony - 2, 0, 100)
	_remember("周四支持大厨先收好客厅")
	day_log.append("第1周周四：支持大厨先收好客厅；大厨关系 +2、舞者关系 -1、两人关系 -4、空间和睦 -2。")
	_finish_week_one_room_conflict("你帮大厨把茶几和餐具挪回原位。大厨松了口气，舞者把音乐关小，轻声说她晚点再练。两个人没有继续争论，但都显得有些不自在。", "大厨觉得被理解了；舞者暂时让步。大厨和舞者关系 -4，空间和睦 -2。")

func _room_conflict_support_dancer() -> void:
	week_one_room_conflict_outcome = "dancer"
	relationship_dancer = clampi(relationship_dancer + 2, 0, 100)
	relationship_chef = clampi(relationship_chef - 1, 0, 100)
	relationship_chef_dancer = clampi(relationship_chef_dancer - 4, 0, 100)
	spatial_harmony = clampi(spatial_harmony - 2, 0, 100)
	_remember("周四支持舞者使用客厅排练")
	day_log.append("第1周周四：支持舞者使用客厅排练；舞者关系 +2、大厨关系 -1、两人关系 -4、空间和睦 -2。")
	_finish_week_one_room_conflict("你告诉大厨，客厅也可以容纳舞者的排练。舞者重新打开音乐，大厨把茶具拿回厨房：“我只是不想每次都得重新收拾。”两个人各自做回手边的事，话题暂时停住了。", "舞者觉得自己的需要被看见；大厨仍担心公共空间难以维持。大厨和舞者关系 -4，空间和睦 -2。")

func _room_conflict_negotiate() -> void:
	week_one_room_conflict_outcome = "negotiate"
	relationship_chef = clampi(relationship_chef + 2, 0, 100)
	relationship_dancer = clampi(relationship_dancer + 2, 0, 100)
	relationship_chef_dancer = clampi(relationship_chef_dancer + 6, 0, 100)
	spatial_harmony = clampi(spatial_harmony + 4, 0, 100)
	_remember("周四和大厨、舞者商量客厅使用时间")
	day_log.append("第1周周四：和大厨、舞者商量客厅排练时段；两人关系 +6，与玩家各 +2、空间和睦 +4。")
	_finish_week_one_room_conflict("你提议舞者先用客厅练半小时，结束后大家一起把椅子和茶几放回去。大厨想了想：“知道什么时候会用，我就能把茶具先收好。”舞者也点头，重新挑起音乐。", "两人谈妥了暂时的使用时间：彼此关系 +6，你与两人关系各 +2，空间和睦 +4。")

func _finish_week_one_room_conflict(result_text: String, result_hint: String) -> void:
	_update_status()
	speaker_label.text = "周四 · 当日回响"
	dialogue_label.text = result_text
	hint_label.text = result_hint + " 周五会看到这次分歧留下的变化。"
	_cycle_show_daily_result()

func _cycle_daily_choice_a() -> void:
	match weekly_day:
		1:
			relationship_advertiser = clampi(relationship_advertiser + 3, 0, 100)
			relationship_dancer = clampi(relationship_dancer + 2, 0, 100)
			spatial_harmony = clampi(spatial_harmony + 2, 0, 100)
			day_log.append("第1周周二：和广告人、舞者聊周末计划，关系有所升温。")
		2:
			relationship_dancer = clampi(relationship_dancer + 3, 0, 100)
			player_mood = clampi(player_mood + 2, 0, 100)
			if weekly_week == 1:
				dancer_peanut_memory = true
				_remember("记住舞者不喜欢吃花生")
				day_log.append("第1周周三：听舞者聊排练和忌口，记住她不喜欢吃花生；舞者关系 +3、心情 +2。")
			else:
				day_log.append("第%d周周三：听舞者聊排练，舞者关系 +3、心情 +2。" % weekly_week)
		3:
			relationship_advertiser = clampi(relationship_advertiser + 2, 0, 100)
			spatial_harmony = clampi(spatial_harmony + 2, 0, 100)
			day_log.append("第%d周周四：加入晚饭后的聊天，空间和睦 +2。" % weekly_week)
		4:
			relationship_advertiser = clampi(relationship_advertiser + 2, 0, 100)
			player_extroversion = clampi(player_extroversion + 2, 0, 100)
			day_log.append("第%d周周五：和大家聊了这一周，广告人关系 +2、外向 +2。" % weekly_week)
	speaker_label.text = "当日回响"
	if weekly_day == 4 and weekly_week == 1 and not week_one_room_conflict_outcome.is_empty():
		speaker_label.text = "周五 · 关系回响"
		dialogue_label.text = _friday_room_conflict_response(true)
		hint_label.text = "周四的处理方式仍在影响两位室友今天如何相处。"
		day_log.append("第1周周五：在客厅听见大厨和舞者对周四的分歧作出回应。")
	elif weekly_day == 2 and weekly_week == 1:
		dialogue_label.text = "舞者聊起排练后的晚饭：“我其实不太喜欢吃花生，花生味太重了。”你把这个小偏好记了下来。"
		hint_label.text = "记忆标签：舞者不喜欢吃花生。周六晚饭时，这个细节可能会再次出现。"
	else:
		dialogue_label.text = "你留下来和室友多聊了一会儿，话题从手边的事慢慢转到每个人这周的生活。"
		hint_label.text = "这次交流带来的关系和状态变化已记入本周日志。"
	_cycle_show_daily_result()

func _cycle_daily_choice_b() -> void:
	match weekly_day:
		1:
			player_mood = clampi(player_mood + 3, 0, 100)
			day_log.append("第1周周二：回房听歌休息，心情 +3。")
		2:
			player_mood = clampi(player_mood + 4, 0, 100)
			relationship_advertiser = clampi(relationship_advertiser + 1, 0, 100)
			day_log.append("第1周周三：一个人听歌放松，心情 +4。")
		3:
			player_mood = clampi(player_mood + 2, 0, 100)
			day_log.append("第%d周周四：安静听大家聊天，心情 +2。" % weekly_week)
		4:
			player_mood = clampi(player_mood + 3, 0, 100)
			day_log.append("第%d周周五：独自听歌放松，心情 +3。" % weekly_week)
	speaker_label.text = "当日回响"
	if weekly_day == 4 and weekly_week == 1 and not week_one_room_conflict_outcome.is_empty():
		speaker_label.text = "周五 · 关系回响"
		dialogue_label.text = _friday_room_conflict_response(false)
		hint_label.text = "即使你没有加入谈话，周四的处理方式也留下了影响。"
		day_log.append("第1周周五：独处片刻时仍注意到大厨和舞者对周四分歧的不同反应。")
	else:
		dialogue_label.text = "你选择用自己的节奏度过这段时间。屋里安静下来，工作带来的疲惫也慢慢松开。"
		hint_label.text = "这次选择带来的心情或关系变化已记入本周日志。"
	_cycle_show_daily_result()

func _friday_room_conflict_response(stayed_to_chat: bool) -> String:
	match week_one_room_conflict_outcome:
		"chef":
			if stayed_to_chat:
				return "大厨说周四只是想把客厅收好。舞者听完后告诉他，自己今天会把练习鞋收在门边；两人没有完全说开，但语气比那天缓和了。"
			return "你戴上耳机时，听见舞者把练习鞋收进袋子。大厨把茶具放回原处，两个人各自安静下来，客厅暂时恢复整齐。"
		"dancer":
			if stayed_to_chat:
				return "舞者说周四能继续练习让她安心了一点。大厨也说他担心的是每次结束后没人复原客厅；两个人开始谈起怎么收拾，不再只争谁该让步。"
			return "你回房听歌前，看见大厨把茶具端回厨房，舞者则把练习空间留着。两个人没有再争，但客厅还没恢复平常的摆设。"
		_:
			if stayed_to_chat:
				return "大厨和舞者照约定一起把茶几推回原位。舞者说半小时刚好够练习，大厨也说提前知道安排后就容易配合了。"
			return "你独自听歌时，客厅传来挪动椅子的声音。大厨和舞者按约定一起恢复了摆设，随后又聊起了晚饭。"

func _cycle_show_daily_result() -> void:
	weekly_cycle_stage = "daily_result"
	_update_status()
	dialogue_panel.position = Vector2(36, 285)
	dialogue_panel.size = Vector2(888, 230)
	dialogue_label.custom_minimum_size = Vector2(820, 75)
	_clear_choices()
	if not weekly_chore_done:
		_add_choice("现在去完成本周打扫", _cycle_clean_chore, 350.0)
	_add_choice("结束今天，进入下一天", _cycle_advance_day, 350.0)

func _cycle_advance_day() -> void:
	weekly_day += 1
	_start_weekly_day()

func _start_weekly_meeting() -> void:
	if weekly_story_week:
		weekly_story_stage = "weekly_meeting"
	if weekly_cycle_active:
		weekly_cycle_stage = "weekly_log"
	if weekly_meeting_open:
		_set_scene("客厅", "第%d周 周日   10:30" % weekly_week if weekly_story_week or weekly_cycle_active else "第%d周 周六   10:00" % weekly_week)
		dialogue_panel.position = Vector2(36, 145)
		dialogue_panel.size = Vector2(888, 375)
		dialogue_label.custom_minimum_size = Vector2(820, 240)
		dialogue_label.add_theme_font_size_override("font_size", 14 if weekly_cycle_active else 16)
		speaker_label.text = "第%d周 · 本周日志" % weekly_week if weekly_cycle_active else "第%d周 · 周末例会" % weekly_week
		dialogue_label.text = weekly_meeting_dialogue
		hint_label.text = weekly_meeting_hint
		_clear_choices()
		_add_choice("查看本周生活记录", _show_weekend_log, 260.0)
		_add_choice("开启新的一周", _begin_next_cycle_week, 260.0)
		_add_choice("回到开始界面", _restart_evening, 260.0)
		return
	weekly_meeting_open = true
	var harmony_before := weekly_harmony_start
	var harmony_after := clampi(spatial_harmony + weekly_pending_harmony, 0, 100)
	var harmony_delta := harmony_after - weekly_harmony_start
	spatial_harmony = harmony_after
	if spatial_harmony < 40:
		consecutive_low_weeks += 1
	else:
		consecutive_low_weeks = 0
	var meeting_lines := PackedStringArray()
	if harmony_after >= 80:
		meeting_lines.append("例会的气氛很轻松。大家聊着这一周的配合，最后有人提议一起做顿饭庆祝。")
		player_mood = clampi(player_mood + 5, 0, 100)
	elif harmony_after < 40:
		meeting_lines.append("大家坐下后安静了好一会儿。有人提到最近总在替别人收尾，桌上的气氛逐渐绷紧。")
		player_mood = clampi(player_mood - 5, 0, 100)
	else:
		meeting_lines.append("例会照常开始。大家逐项回顾这一周，偶尔有些不同意见，但还能一起商量。")
	if harmony_delta >= 10:
		meeting_lines.append("和上周相比，和睦值明显回升；之前没说开的误会也终于有人主动提起。")
	elif harmony_delta <= -10:
		meeting_lines.append("这周和睦值下滑得很明显。例会结束后，客厅里留下了一段不太舒服的沉默。")
	if weekly_tasks_total > 0 and weekly_tasks_done == weekly_tasks_total:
		meeting_lines.append("本周待办全部完成，大家有了难得的集体成就感。")
	elif weekly_tasks_total > 0 and weekly_tasks_done * 2 <= weekly_tasks_total:
		meeting_lines.append("本周完成的待办不到一半，有人担心这些事情总会落到同几个人身上。")
	if weekly_week == 1 and not week_one_room_conflict_outcome.is_empty():
		meeting_lines.append(_chef_dancer_weekly_recap())
	if weekly_efficiency_choices > weekly_care_choices:
		meeting_lines.append("你们这周更常选择尽快推进。进度不错，但几个人都显得有些疲惫。")
	elif weekly_care_choices > weekly_efficiency_choices:
		meeting_lines.append("你们这周常常先听彼此说完。进度慢了一些，关系却比周初更近。")
	if consecutive_low_weeks >= 2:
		meeting_lines.append("这已经是连续第二周处在低和睦区间。有人开始认真考虑，自己还能不能继续这样住下去。")
		weekly_challenge_active = true
	else:
		weekly_challenge_active = false
	if weekly_cycle_active:
		meeting_lines.append("周一的公共卫生约定、周中日常、周六活动与本周数值变化，都已写入生活日志。")
	day_log.append("第%d周例会：和睦值 %d → %d（%s）；待办完成 %d / %d；效率型选择 %d 次，关怀型选择 %d 次。" % [weekly_week, harmony_before, harmony_after, _format_signed(harmony_delta), weekly_tasks_done, weekly_tasks_total, weekly_efficiency_choices, weekly_care_choices])
	_set_scene("客厅", "第%d周 周日   10:30" % weekly_week if weekly_story_week or weekly_cycle_active else "第%d周 周六   10:00" % weekly_week)
	dialogue_panel.position = Vector2(36, 145)
	dialogue_panel.size = Vector2(888, 375)
	dialogue_label.custom_minimum_size = Vector2(820, 240)
	dialogue_label.add_theme_font_size_override("font_size", 14 if weekly_cycle_active else 16)
	speaker_label.text = "第%d周 · 本周日志" % weekly_week if weekly_cycle_active else "第%d周 · 周末例会" % weekly_week
	dialogue_label.text = "\n\n".join(meeting_lines)
	hint_label.text = "本周和睦值变化：%s · 待办完成：%d / %d" % [_format_signed(harmony_delta), weekly_tasks_done, weekly_tasks_total]
	weekly_meeting_dialogue = dialogue_label.text
	weekly_meeting_hint = hint_label.text
	_update_status()
	_clear_choices()
	_add_choice("查看本周生活记录", _show_weekend_log, 260.0)
	_add_choice("开启第%d周" % (weekly_week + 1), _begin_next_cycle_week, 260.0)
	_add_choice("回到开始界面", _restart_evening, 260.0)

func _chef_dancer_weekly_recap() -> String:
	if relationship_chef_dancer >= 55:
		return "大厨和舞者这周找到了共享客厅的办法。例会开始前，他们一起把椅子摆回原位。"
	if relationship_chef_dancer <= 46:
		return "大厨和舞者还没找到舒服的相处方式。例会开始前，两人都避开了客厅使用的话题。"
	return "大厨和舞者仍在适应彼此的节奏。关于客厅的安排没有再起争执，但也还没完全说开。"

func _begin_next_cycle_week() -> void:
	weekly_previous_chore_done = weekly_chore_done
	weekly_week += 1
	weekly_day = 0
	weekly_harmony_start = spatial_harmony
	weekly_pending_harmony = 0
	weekly_tasks_total = 0
	weekly_tasks_done = 0
	weekly_efficiency_choices = 0
	weekly_care_choices = 0
	weekly_meeting_open = false
	weekly_last_task_completed = false
	weekly_meeting_dialogue = ""
	weekly_meeting_hint = ""
	weekly_chore_done = false
	weekly_chore_resolved = false
	weekly_dinner_decided = false
	weekly_cycle_stage = "monday_meeting"
	weekly_log_start_index = day_log.size()
	weekly_household_intro_active = false
	weekly_story_week = false
	weekly_intro_tallied = false
	weekly_tasks_total = 0
	weekly_tasks_done = 0
	weekly_efficiency_choices = 0
	weekly_care_choices = 0
	joined_dinner_plan = false
	declined_dinner_plan = false
	sunday_completed = false
	sunday_shared_plan = false
	monday_completed = false
	monday_evening_completed = false
	monday_forgot_chore = false
	makeup_task_active = false
	dance_rehearsal_active = false
	dancer_rehearsal_invited = false
	dancer_rehearsal_resolved = false
	visited_activities.clear()
	current_task = ""
	current_task_active = false
	task_name_label.text = ""
	task_deadline_label.text = ""
	task_panel.visible = false
	_start_monday()

func _continue_after_monday_cycle() -> void:
	if makeup_task_active or dance_rehearsal_active:
		return
	weekly_household_intro_active = false
	weekly_day = 3 if dancer_rehearsal_resolved else 2
	_start_weekly_day()

func _accept_tea() -> void:
	player_mood = 52
	relationship_chef = clampi(relationship_chef + 5, 0, 100)
	player_extroversion = clampi(player_extroversion + 5, 0, 100)
	day_log.append("周二：喝茶倾诉，心情 +17，与大厨关系 +5。")
	_update_status()
	speaker_label.text = "大厨"
	dialogue_label.text = "面谈不太顺利？先坐吧，茶还要泡一会儿。你慢慢说。"
	hint_label.text = "你接过茶杯，大厨安静听你说了一会儿。"
	_clear_choices()
	_add_choice("端着茶去客厅看看其他人。", _show_living_room)

func _rest_first() -> void:
	player_mood = 42
	relationship_chef = clampi(relationship_chef + 3, 0, 100)
	day_log.append("周二：安静休息，心情 +7，与大厨关系 +3。")
	_update_status()
	speaker_label.text = "大厨"
	dialogue_label.text = "当然。沙发上有毯子，我把茶放这儿，想聊的时候叫我。"
	hint_label.text = "你先安静坐了一会儿，大厨没有催你开口。"
	_clear_choices()
	_add_choice("缓过来后，去客厅看看其他人。", _show_living_room)

func _show_living_room() -> void:
	_set_scene("客厅", "周二   20:46")
	speaker_label.text = "广告人"
	dialogue_label.text = "你就是新搬来的室友吧？我们正商量周末一起吃什么。舞者想准备歌单，哲学家在讨论怎么照顾每个人的口味。你要不要也加入？"
	hint_label.text = "大厨、舞者和哲学家也在客厅里，几个人正一起计划周末饭局。"
	_clear_choices()
	_add_choice("加入讨论，提议每人带一道菜。", _join_dinner, 260.0)
	_add_choice("先听听大家各自的想法。", _listen_first, 260.0)
	_add_choice("周六有事，说明这次去不了。", _decline_dinner, 260.0)

func _join_dinner() -> void:
	joined_dinner_plan = true
	if weekly_cycle_active:
		weekly_care_choices += 1
	spatial_harmony = clampi(spatial_harmony + 15, 0, 100)
	player_extroversion = clampi(player_extroversion + 10, 0, 100)
	relationship_advertiser = clampi(relationship_advertiser + 4, 0, 100)
	relationship_dancer = clampi(relationship_dancer + 2, 0, 100)
	relationship_philosopher = clampi(relationship_philosopher + 2, 0, 100)
	day_log.append("周二：加入饭局计划，空间和睦 +15、外向 +10；广告人关系 +4，舞者和哲学家各 +2。")
	speaker_label.text = "舞者 · 哲学家"
	dialogue_label.text = "舞者笑着说她来准备歌单。哲学家点点头：“每个人带一道喜欢的菜，谁都能参与决定。”广告人已经开始期待周末了。"
	hint_label.text = "你加入了大家的计划，原本各自的想法开始拼成一顿饭。"
	_update_status()
	_clear_choices()
	_add_choice("和大家聊了一会儿，去露台透透气。", _show_balcony)

func _listen_first() -> void:
	joined_dinner_plan = false
	if weekly_cycle_active:
		weekly_care_choices += 1
	spatial_harmony = clampi(spatial_harmony + 5, 0, 100)
	relationship_advertiser = clampi(relationship_advertiser + 2, 0, 100)
	relationship_dancer = clampi(relationship_dancer + 2, 0, 100)
	relationship_philosopher = clampi(relationship_philosopher + 2, 0, 100)
	day_log.append("周二：先听室友交流，空间和睦 +5，三位室友关系各 +2。")
	speaker_label.text = "哲学家"
	dialogue_label.text = "“一起生活，不必每件事都马上达成一致。”舞者说她可以先放一张歌单，广告人则继续收集大家喜欢的菜。你听着他们慢慢聊开。"
	hint_label.text = "你先听大家聊，室友们也在彼此了解各自的习惯。"
	_update_status()
	_clear_choices()
	_add_choice("和大家聊了一会儿，去露台透透气。", _show_balcony)

func _decline_dinner() -> void:
	joined_dinner_plan = false
	declined_dinner_plan = true
	day_log.append("周二：说明周六已有安排；室友尊重了你的决定。")
	speaker_label.text = "你"
	dialogue_label.text = "不好意思，我周六已经有安排了，这次可能去不了。"
	hint_label.text = "广告人说等你回来再讲饭局的趣事，舞者也说下次有空再一起吃。"
	_clear_choices()
	_add_choice("和大家聊了一会儿，去露台透透气。", _show_balcony)

func _show_balcony() -> void:
	_set_scene("露台", "周二   21:32")
	speaker_label.text = "大厨"
	if declined_dinner_plan:
		dialogue_label.text = "听说你周六有安排了。没关系，等你回来我给你留些汤。"
		hint_label.text = "晚风里还飘着客厅的说笑声，你已经知道自己下次也能加入。"
	elif joined_dinner_plan:
		dialogue_label.text = "广告人说你提了每个人带一道菜的主意。听起来会是个热闹的晚上。"
		hint_label.text = "室内还有人在聊周末的饭局，夜风吹散了些疲惫。"
	else:
		dialogue_label.text = "客厅里挺热闹的吧？刚搬进来先慢慢适应，不用一下子融进所有事。"
		hint_label.text = "大厨陪你在露台站了一会儿，没有追问你要不要参加。"
	_clear_choices()
	_add_choice("谢谢你，今晚感觉没那么像个陌生人了。", _finish_evening)

func _finish_evening() -> void:
	_set_scene("露台", "周二   21:40")
	speaker_label.text = "周二 · 夜深了"
	if declined_dinner_plan:
		dialogue_label.text = "回房前，你和室友们说周六已有安排。广告人说回来后再给你讲饭局的趣事，大厨也答应给你留一碗汤。"
		hint_label.text = "今晚：认识了室友们，也约好等你周六回来再聊。"
	elif joined_dinner_plan:
		dialogue_label.text = "回房前，你听见客厅里还在讨论周末的菜。新生活没有立刻变轻松，但你已经在这间 Loft 里留下一点自己的位置。"
		hint_label.text = "今晚：认识了广告人，和大厨熟悉了一点，也加入了周末饭局。"
	else:
		dialogue_label.text = "回房前，大厨把茶杯收好，告诉你厨房的灯总会为晚归的人留着。你还在适应这里，但已经有人记住你今晚回来了。"
		hint_label.text = "今晚：认识了广告人，也和大厨建立了最初的信任。"
	_clear_choices()
	if weekly_story_week:
		_add_choice("继续到周三，进入第一周的日常", _start_weekly_day, 405.0)
	elif declined_dinner_plan:
		_add_choice("看看周六回家后的情景", _show_weekend_dinner)
	else:
		_add_choice("继续到周末饭局", _show_weekend_dinner)
	_add_choice("回到开始界面", _restart_evening)

func _show_weekend_dinner() -> void:
	if weekly_story_week:
		weekly_story_stage = "dinner"
	if declined_dinner_plan:
		_set_scene("客厅", "周六   22:15")
		_remember("大厨记得你周六有安排，特意留了汤")
		spatial_harmony = clampi(spatial_harmony + 5, 0, 100)
		day_log.append("周六：室友饭局后给你留了汤，空间和睦 +5。")
		_update_status()
		speaker_label.text = "大厨"
		dialogue_label.text = "回来了？饭局刚结束，我给你留了一碗汤。广告人正讲着今晚的趣事，舞者和哲学家也还在客厅。"
		hint_label.text = "你因周六有事没有参加饭局；室友们尊重你的安排，也记得给你留了晚饭。"
		_clear_choices()
		_add_choice("坐下来听大家聊聊今晚。", _close_declined_evening)
		return
	_start_weekend_activities()

func _start_weekend_activities() -> void:
	if weekly_story_week:
		weekly_story_stage = "weekend"
	visited_activities.clear()
	_set_scene("Loft地图", "周六   15:00")
	speaker_label.text = "周六 · 下午"
	dialogue_label.text = "晚饭还早，你有时间在 Loft 里走走。点击地图，选择想去的地方。"
	hint_label.text = "从厨房、客厅和露台中选两处；已经去过的房间会变暗。"
	_clear_choices()

func _activity_chef() -> void:
	visited_activities.append("chef")
	_set_scene("厨房", _activity_time())
	speaker_label.text = "大厨"
	dialogue_label.text = "大厨把洗好的食材递给你：“我来顾着锅，你帮我把切好的菜递过来。咱们配合三次，试试看能不能赶上节奏。”"
	hint_label.text = "先熟悉节奏，再按下“递食材”；指针进入 70–85 的目标区就算配合成功。"
	_clear_choices()
	_add_choice("开始备菜", _start_cooking_game)

func _start_cooking_game() -> void:
	cooking_minigame_active = true
	cooking_phase = 0.0
	cooking_direction = 1.0
	cooking_hits = 0
	cooking_attempts = 0
	cooking_meter.value = 0
	cooking_meter.queue_redraw()
	cooking_row.visible = true
	dialogue_panel.position = Vector2(36, 300)
	dialogue_panel.size = Vector2(888, 220)
	dialogue_label.custom_minimum_size = Vector2(820, 58)
	speaker_label.text = "大厨 · 备菜配合"
	dialogue_label.text = "看着食材递来的节奏，落在目标区时按下按钮。三次之后看看我们的默契。"
	hint_label.text = "成功 %d / 3 · 目标区 70–85" % cooking_hits
	_clear_choices()
	_add_choice("递食材", _cooking_attempt, 180.0)

func _cooking_attempt() -> void:
	if not cooking_minigame_active:
		return
	cooking_attempts += 1
	if cooking_phase >= 70.0 and cooking_phase <= 85.0:
		cooking_hits += 1
		hint_label.text = "接得正好！成功 %d / 3 · 还剩 %d 次" % [cooking_hits, 3 - cooking_attempts]
	else:
		hint_label.text = "这次没接上节奏。成功 %d / 3 · 还剩 %d 次" % [cooking_hits, 3 - cooking_attempts]
	if cooking_attempts >= 3:
		_resolve_cooking_game()

func _resolve_cooking_game() -> void:
	cooking_minigame_active = false
	cooking_row.visible = false
	dialogue_panel.position = Vector2(36, 365)
	dialogue_panel.size = Vector2(888, 148)
	dialogue_label.custom_minimum_size = Vector2(820, 42)
	if cooking_hits >= 2:
		_remember("和大厨默契备菜")
		player_mood = clampi(player_mood + 8, 0, 100)
		relationship_chef = clampi(relationship_chef + 8, 0, 100)
		spatial_harmony = clampi(spatial_harmony + 3, 0, 100)
		day_log.append("周六：和大厨默契备菜（%d / 3 次接准），心情 +8，与大厨关系 +8。" % cooking_hits)
		dialogue_label.text = "你接连把食材递得恰到好处。大厨笑着说：“这节奏不错，下次可以直接把厨房交给咱俩了。”"
		hint_label.text = "配合成功：心情 +8，与大厨关系 +8，空间和睦 +3。"
	else:
		_remember("和大厨备菜时手忙脚乱")
		player_mood = clampi(player_mood + 3, 0, 100)
		relationship_chef = clampi(relationship_chef + 3, 0, 100)
		spatial_harmony = clampi(spatial_harmony + 1, 0, 100)
		day_log.append("周六：和大厨备菜时有些手忙脚乱（%d / 3 次接准），心情 +3，与大厨关系 +3。" % cooking_hits)
		dialogue_label.text = "你们没能每次都赶上节奏，菜差点掉到台面上。大厨笑起来：“没事，厨房里手忙脚乱也算一起做饭。”"
		hint_label.text = "还是一起完成了备菜：心情 +3，与大厨关系 +3，空间和睦 +1。"
	_update_status()
	_clear_choices()
	_add_choice("再安排一件下午的活动", _continue_after_activity)

func _activity_living_room() -> void:
	visited_activities.append("living_room")
	_set_scene("客厅", _activity_time())
	speaker_label.text = "广告人 · 舞者"
	dialogue_label.text = "广告人把手机递给你：“晚饭前的歌单交给你选个方向？”舞者已经站起来试着踩拍子。"
	hint_label.text = "你选的音乐会改变客厅气氛，也会影响你和她们的相处。"
	_clear_choices()
	_add_choice("热闹一点：放首节奏强的歌", _choose_music_vibe.bind("dance"), 260.0)
	_add_choice("轻松一点：选首柔和的歌", _choose_music_vibe.bind("soft"), 260.0)
	_add_choice("折中一下：大家轮流选歌", _choose_music_vibe.bind("shared"), 260.0)

func _choose_music_vibe(vibe: String) -> void:
	speaker_label.text = "广告人 · 舞者"
	if weekly_cycle_active:
		weekly_care_choices += 1
	match vibe:
		"dance":
			_remember("和广告人、舞者选了热闹歌单")
			player_extroversion = clampi(player_extroversion + 10, 0, 100)
			player_mood = clampi(player_mood + 4, 0, 100)
			relationship_advertiser = clampi(relationship_advertiser + 5, 0, 100)
			relationship_dancer = clampi(relationship_dancer + 7, 0, 100)
			spatial_harmony = clampi(spatial_harmony + 4, 0, 100)
			dialogue_label.text = "鼓点一响，舞者跟着节奏转了半圈。广告人也拉你起来：“这首可以！晚饭前客厅先变成舞池。”"
			day_log.append("周六：选了热闹歌单，外向 +10、心情 +4；广告人关系 +5、舞者 +7，空间和睦 +4。")
			hint_label.text = "客厅一下子热闹起来，你也跟着节奏动了几下。"
		"soft":
			_remember("和广告人、舞者选了柔和歌单")
			player_mood = clampi(player_mood + 8, 0, 100)
			player_extroversion = clampi(player_extroversion + 2, 0, 100)
			relationship_advertiser = clampi(relationship_advertiser + 3, 0, 100)
			relationship_dancer = clampi(relationship_dancer + 5, 0, 100)
			spatial_harmony = clampi(spatial_harmony + 2, 0, 100)
			dialogue_label.text = "你挑了首舒缓的歌。舞者在窗边慢慢舒展身体，广告人挨着沙发坐下：“这样听着，感觉今天可以不用赶时间。”"
			day_log.append("周六：选了柔和歌单，心情 +8、外向 +2；广告人关系 +3、舞者 +5，空间和睦 +2。")
			hint_label.text = "没有人急着说话，几个人安静地听完了这首歌。"
		"shared":
			_remember("和广告人、舞者轮流选歌")
			player_extroversion = clampi(player_extroversion + 5, 0, 100)
			relationship_advertiser = clampi(relationship_advertiser + 6, 0, 100)
			relationship_dancer = clampi(relationship_dancer + 4, 0, 100)
			spatial_harmony = clampi(spatial_harmony + 8, 0, 100)
			dialogue_label.text = "你们约好一人选一首。广告人的广告配乐、舞者练习时听的歌，还有你挑的那首依次响起，客厅里每个人都有了位置。"
			day_log.append("周六：和广告人、舞者轮流选歌，外向 +5；广告人关系 +6、舞者 +4，空间和睦 +8。")
			hint_label.text = "三种风格拼成了大家都愿意听的歌单。"
	_update_status()
	_clear_choices()
	_add_choice("再安排一件下午的活动", _continue_after_activity)

func _activity_philosopher() -> void:
	visited_activities.append("philosopher")
	_set_scene("露台", _activity_time())
	speaker_label.text = "哲学家"
	if player_mood < 45:
		dialogue_label.text = "哲学家给你倒了杯茶，等你缓过来才问：“你刚才说，合伙人希望尽快看到 AI 产品的增长计划。如果先把产品推给更多人，却可能让一部分用户被错误分类，你会怎么决定？”"
		hint_label.text = "他看出你今天有些疲惫，仍把关于产品和责任的问题交给你自己回答。"
	else:
		dialogue_label.text = "露台的风吹动桌上的融资计划。哲学家问：“如果先把产品推给更多人，却可能让一部分用户被 AI 错误分类，你会怎么决定？”"
		hint_label.text = "这次谈话触及你的创业选择，也触及谁该为 AI 的误判负责。"
	_clear_choices()
	_add_choice("先扩大用户，再根据反馈修正", _philosopher_growth_first, 260.0)
	_add_choice("先设申诉和人工复核，再考虑扩大", _philosopher_safeguards_first, 300.0)
	_add_choice("我还不确定，想听听你的经历", _philosopher_ask_experience, 260.0)

func _philosopher_growth_first() -> void:
	philosopher_ai_route_active = true
	philosopher_ai_opening_stance = "growth"
	_remember("和哲学家讨论AI增长与责任")
	relationship_philosopher = clampi(relationship_philosopher + 3, 0, 100)
	player_extroversion = clampi(player_extroversion + 2, 0, 100)
	mindset_shift = "增长可以让产品帮助更多人，但不能把误判的代价留给用户自己承担。"
	day_log.append("周六：和哲学家讨论先扩大 AI 产品再修正的想法；哲学家关系 +3、外向 +2。")
	day_log.append("心态转变：增长不能成为把误判代价留给用户的理由。")
	dialogue_label.text = "哲学家听完没有马上反驳：“产品得先活下来，这话我以前也说过。”他提起自己参与教育平台评估模型时，也曾把上线后的修正当成足够的承诺。“后来有件事让我发现，写在计划里的修正，未必来得及帮到被误判的人。”他没有把这段往事讲完，只说愿意继续听你谈增长，也开始认真看待你对风险的判断。"
	hint_label.text = "你们并未得出简单答案；哲学家因为你的坦诚，愿意继续和你讨论。"
	_finish_philosopher_talk()

func _philosopher_safeguards_first() -> void:
	philosopher_ai_route_active = true
	philosopher_ai_opening_stance = "safeguards"
	_remember("和哲学家讨论AI误判的保障")
	relationship_philosopher = clampi(relationship_philosopher + 8, 0, 100)
	spatial_harmony = clampi(spatial_harmony + 2, 0, 100)
	mindset_shift = "做出重要判断的系统，必须让受影响的人知道理由，也能提出异议。"
	day_log.append("周六：主张先为 AI 误判建立申诉与人工复核；哲学家关系 +8、空间和睦 +2。")
	day_log.append("心态转变：受 AI 判断影响的人应该知道理由，并有机会提出异议。")
	dialogue_label.text = "哲学家听到“申诉和人工复核”，安静了一会儿：“我以前参与过教育平台的评估模型。那套系统没有给被误判的人留下好用的申诉办法。”他看着旧讲义说，自己当时以为按计划完成风险清单就算尽责。“你先想到用户能不能提出异议，这一步我当年漏掉了。”他第一次主动问起你的设计细节，也答应周日把那段经历讲完整。"
	hint_label.text = "你提出的保障让哲学家想起自己曾经忽略的责任；哲学家关系 +8。"
	_finish_philosopher_talk()

func _philosopher_ask_experience() -> void:
	philosopher_ai_route_active = true
	philosopher_ai_opening_stance = "curious"
	_remember("听哲学家讲教育AI评估经历")
	player_mood = clampi(player_mood + 3, 0, 100)
	player_extroversion = clampi(player_extroversion + 3, 0, 100)
	relationship_philosopher = clampi(relationship_philosopher + 6, 0, 100)
	mindset_shift = "一个模型没有看见的生活，也可能正是它判断一个人的关键背景。"
	day_log.append("周六：请哲学家讲过去参与教育 AI 评估的经历；心情 +3、外向 +3、哲学家关系 +6。")
	day_log.append("心态转变：模型没看见的生活，可能正是理解一个人的关键背景。")
	dialogue_label.text = "哲学家看了看露台外：“我以前参与过教育平台的学习评估模型。那段经历让我离开平台去教书，但我很久都没把它完整讲给别人听。”他答应周日整理课程讲义时，再说说当时究竟发生了什么。“统计结果不一定是假的，但它总有没看见的部分。”他把话停在这里，像是在确认你愿不愿意继续听。"
	hint_label.text = "哲学家分享了过去的失误；你们的关系更近了一些，心情也稍微松下来。"
	_finish_philosopher_talk()

func _finish_philosopher_talk() -> void:
	_update_status()
	_clear_choices()
	_add_choice("再安排一件下午的活动", _continue_after_activity)

func _activity_time() -> String:
	return "周六   15:30" if visited_activities.size() == 1 else "周六   17:00"

func _start_dancer_showcase_intro() -> void:
	dancer_showcase_intro_done = true
	dancer_showcase_route_active = true
	weekly_cycle_stage = "dancer_showcase_intro"
	_set_scene("客厅", "第1周 周六   13:30")
	speaker_label.text = "舞者 · 周末计划"
	if relationship_chef_dancer >= 55:
		dialogue_label.text = "舞者把一张手写流程单放在茶几上：“下周我想在社区办一场小型舞蹈分享。大厨答应帮我安排客厅的练习时间了，可我还是有点担心到场的人会不会觉得无聊。”她抬头问你，这件事要不要多准备一些。"
	elif relationship_chef_dancer <= 46:
		dialogue_label.text = "舞者把一张手写流程单放在茶几上：“下周我想在社区办一场小型舞蹈分享。周四之后，我有点担心再提排练空间会让大厨为难；可如果准备得太匆忙，来的人也许会不自在。”她停了一下，问你怎么看。"
	else:
		dialogue_label.text = "舞者把一张手写流程单放在茶几上：“下周我想在社区办一场小型舞蹈分享。内容差不多定了，可我还在想怎么让第一次来的邻居也觉得自在。”她问你愿不愿意听听她的安排。"
	hint_label.text = "舞者没有提出待办，只是在分享一件她很在意的事。你可以帮忙、倾听，或坦白自己现在帮不上。"
	_clear_choices()
	_add_choice("帮她一起整理演出流程", _dancer_showcase_offer_help, 260.0)
	_add_choice("先听她说说最担心什么", _dancer_showcase_listen, 260.0)
	_add_choice("坦白这周帮不上，但鼓励她按自己的节奏准备", _dancer_showcase_set_boundary, 310.0)

func _dancer_showcase_offer_help() -> void:
	dancer_showcase_choice = "help"
	relationship_dancer = clampi(relationship_dancer + 3, 0, 100)
	player_extroversion = clampi(player_extroversion + 2, 0, 100)
	_remember("答应帮舞者整理社区演出流程")
	day_log.append("第1周周六：答应帮舞者整理社区演出流程；舞者关系 +3、外向 +2。")
	_finish_dancer_showcase_intro("你和舞者把流程拆成几个轻松的小段落，还商量让邻居可以中途加入。她把那张纸折好：“这样听起来就没那么像一场必须表现完美的演出了。”", "你用实际帮忙回应了她的信任；下周会听到演出准备的结果。")

func _dancer_showcase_listen() -> void:
	dancer_showcase_choice = "listen"
	relationship_dancer = clampi(relationship_dancer + 2, 0, 100)
	player_mood = clampi(player_mood + 2, 0, 100)
	_remember("听舞者谈社区演出的顾虑")
	day_log.append("第1周周六：听舞者谈社区演出的顾虑；舞者关系 +2、心情 +2。")
	_finish_dancer_showcase_intro("你没有急着替她想办法，只问她最怕哪一刻冷场。舞者想了想，说自己担心的不是动作出错，而是没人敢一起跳。说完，她把流程单上“表演”两个字划掉，改成了“大家一起试试”。", "她把真正担心的事说了出来；下周会告诉你她怎么调整了活动。")

func _dancer_showcase_set_boundary() -> void:
	dancer_showcase_choice = "boundary"
	player_mood = clampi(player_mood + 1, 0, 100)
	_remember("坦白暂时帮不上舞者准备演出")
	day_log.append("第1周周六：坦白暂时帮不上舞者准备演出；没有承诺，关系没有下降。")
	_finish_dancer_showcase_intro("你说这周实在抽不出精力帮忙，但希望她别把活动办成给自己打分的考试。舞者笑了：“那我就把它做成一次开放练习，不需要谁负责把场子撑起来。”她把流程单收进包里。", "坦白边界没有伤害关系；下周会看到她如何独自调整计划。")

func _finish_dancer_showcase_intro(result_text: String, result_hint: String) -> void:
	_update_status()
	speaker_label.text = "周六 · 舞者的计划"
	dialogue_label.text = result_text
	hint_label.text = result_hint
	weekly_cycle_stage = "weekend"
	_clear_choices()
	_add_choice("继续周六安排", _continue_after_dancer_showcase, 350.0)

func _continue_after_dancer_showcase() -> void:
	if declined_dinner_plan:
		_show_weekend_dinner()
	else:
		_start_weekend_activities()

func _continue_after_activity() -> void:
	if visited_activities.size() >= 2:
		_set_scene("客厅", "周六   17:30")
		speaker_label.text = "周六 · 傍晚"
		dialogue_label.text = "下午的两件事都做完了。厨房传来大厨的声音，大家准备开饭了。"
		hint_label.text = "你带着下午留下的心情和故事走向饭桌。"
		_clear_choices()
		_add_choice("去饭厅和大家一起吃饭", _start_weekend_dinner)
	else:
		_choose_another_activity()

func _choose_another_activity() -> void:
	_set_scene("Loft地图", "周六   16:30")
	speaker_label.text = "周六 · 下午"
	dialogue_label.text = "下午还没结束。点击地图上另一个房间，看看那里有什么日常。"
	hint_label.text = "再选一处，然后就去饭厅。已经去过的房间不能重复选择。"
	_clear_choices()

func _start_weekend_dinner() -> void:
	_set_scene("饭厅", "周六   18:30")
	var closest := _closest_roommate()
	if closest["score"] >= 58:
		match closest["name"]:
			"大厨":
				speaker_label.text = "大厨"
				dialogue_label.text = "你刚坐下，大厨就把汤碗推到你面前：“下午备菜时说的事，我还想听你讲完。”"
			"广告人":
				speaker_label.text = "广告人"
				dialogue_label.text = "广告人朝你招手：“我把你下午提的歌也加进歌单了，等会儿一起听听效果。”"
			"舞者":
				speaker_label.text = "舞者"
				dialogue_label.text = "舞者给你留了靠近音箱的位置：“这首是我们下午挑的，吃饭时听刚好。”"
			"哲学家":
				speaker_label.text = "哲学家"
				dialogue_label.text = "哲学家替你拉开椅子：“下午那句话我还在想。吃完饭，我们可以接着聊。”"
		hint_label.text = "关系回响：%s主动延续了你们下午的相处。" % closest["name"]
	elif joined_dinner_plan:
		speaker_label.text = "大厨"
		dialogue_label.text = "周末到了。大厨正在盛汤，舞者的歌单从客厅传来，哲学家和广告人已经摆好了餐具。大家给你留了准备的位置。"
		hint_label.text = "你之前参与了饭局计划，室友们自然把你算进今晚的安排。"
	else:
		speaker_label.text = "广告人"
		dialogue_label.text = "周末饭局还是办起来了。大厨煮了汤，舞者放着歌单，哲学家带来一道自己喜欢的菜。听说你也在家，大家给你留了位置。"
		hint_label.text = "你之前先听大家讨论；今晚仍然可以慢慢加入。"
	var pair_reaction := _chef_dancer_dinner_reaction()
	if not pair_reaction.is_empty():
		dialogue_label.text += "\n\n" + pair_reaction
		hint_label.text += " 大厨与舞者的相处值：%d / 100。" % relationship_chef_dancer
	_clear_choices()
	_add_choice("帮大厨一起把菜端上桌。", _help_with_dinner)
	_add_choice("坐下来，听大家聊聊带来的菜。", _share_food_stories)

func _chef_dancer_dinner_reaction() -> String:
	if weekly_week != 1 or week_one_room_conflict_outcome.is_empty():
		return ""
	if relationship_chef_dancer >= 55:
		return "大厨把最后一盘菜递给舞者，舞者顺手把客厅音量调低。两人像是已经找到了一点共同使用空间的节奏。"
	if relationship_chef_dancer <= 46:
		return "大厨和舞者都在照顾自己的那一边桌子。话题碰到客厅安排时短暂停住，广告人很快把大家带去聊别的。"
	return "大厨和舞者各自忙着摆菜，偶尔搭话，但还在试着适应彼此的习惯。"

func _help_with_dinner() -> void:
	_remember("帮大厨把晚饭端上桌")
	spatial_harmony = clampi(spatial_harmony + 8, 0, 100)
	player_extroversion = clampi(player_extroversion + 5, 0, 100)
	relationship_chef = clampi(relationship_chef + 4, 0, 100)
	day_log.append("周六：帮大厨端菜，空间和睦 +8，外向 +5，与大厨关系 +4。")
	_update_status()
	speaker_label.text = "大厨"
	dialogue_label.text = "谢谢你搭把手。菜一盘盘摆上桌，广告人忙着给每道菜起名字，舞者跟着歌单轻轻打拍子。"
	hint_label.text = "一起准备晚饭，让这张桌子更像大家共同的地方。"
	_clear_choices()
	_add_choice("给舞者挑一道菜", _choose_dancer_dish)

func _share_food_stories() -> void:
	_remember("和室友分享菜和生活故事")
	spatial_harmony = clampi(spatial_harmony + 5, 0, 100)
	player_extroversion = clampi(player_extroversion + 4, 0, 100)
	relationship_philosopher = clampi(relationship_philosopher + 3, 0, 100)
	relationship_dancer = clampi(relationship_dancer + 3, 0, 100)
	relationship_advertiser = clampi(relationship_advertiser + 2, 0, 100)
	day_log.append("周六：分享菜和故事，空间和睦 +5、外向 +4；广告人 +2，舞者和哲学家各 +3。")
	_update_status()
	speaker_label.text = "哲学家"
	dialogue_label.text = "每道菜背后都有一个人。大家从家乡口味聊到最近的生活，舞者把歌单调得轻了一些，方便继续聊天。"
	hint_label.text = "你从分享食物和故事开始，慢慢加入了这桌谈话。"
	_clear_choices()
	_add_choice("给舞者挑一道菜", _choose_dancer_dish)

func _choose_dancer_dish() -> void:
	speaker_label.text = "周六 · 饭桌"
	dialogue_label.text = "菜都摆上桌了。你注意到舞者还没动筷，决定先给她推一道菜过去。"
	hint_label.text = "选一道递给舞者：花生汤、奶油焗蘑菇或南瓜栗子蛋糕。"
	_clear_choices()
	_add_choice("花生汤", func(): _serve_dancer_dish("花生汤"), 260.0)
	_add_choice("奶油焗蘑菇", func(): _serve_dancer_dish("奶油焗蘑菇"), 260.0)
	_add_choice("南瓜栗子蛋糕", func(): _serve_dancer_dish("南瓜栗子蛋糕"), 260.0)

func _serve_dancer_dish(dish: String) -> void:
	speaker_label.text = "舞者"
	if dish == "花生汤":
		dancer_peanut_dish_served = true
		if dancer_peanut_memory:
			dialogue_label.text = "你把花生汤推过去。舞者笑着说：“谢谢你还记得我不太吃花生——不过这碗我就不勉强啦。”你们把汤留给了想喝的人。"
		else:
			dialogue_label.text = "你把花生汤推给舞者。她笑着提醒你：“我不太吃花生，不过没关系，这碗留给大家分着喝吧。”"
		hint_label.text = "舞者没有介意这次小小的记错，关系值不变。"
		day_log.append("周六：把花生汤推给舞者；她温和地提醒自己不太吃花生，关系没有下降。")
	else:
		if dancer_peanut_memory:
			relationship_dancer = clampi(relationship_dancer + 2, 0, 100)
			dialogue_label.text = "你把%s推到舞者面前。她愣了一下，笑着说：“你还记得我不喜欢花生呀。这个我可以吃，谢谢你。”" % dish
			hint_label.text = "延迟反馈：舞者惊讶你记得她的忌口；舞者关系 +2。"
			day_log.append("周六：记得舞者不喜欢花生，递给她%s；她很惊讶，舞者关系 +2。" % dish)
		else:
			dialogue_label.text = "你把%s推到舞者面前。她道了谢，大家继续聊起各自喜欢的口味。" % dish
			hint_label.text = "舞者收下了你挑的菜。"
			day_log.append("周六：给舞者递了%s，大家聊起各自喜欢的口味。" % dish)
	_update_status()
	_clear_choices()
	_add_choice("和大家一起开饭", _end_weekend_dinner)

func _end_weekend_dinner() -> void:
	if weekly_story_week:
		weekly_story_stage = "sunday"
	_set_scene("饭厅", "周六   20:16")
	day_log.append("周六：和室友共进晚餐，留下了一段共同回忆。")
	var closest := _closest_roommate()
	speaker_label.text = "周六 · 晚饭后"
	if spatial_harmony >= 70:
		dialogue_label.text = "饭桌上的话题从菜聊到各自的生活。有人添汤，有人接着讲故事。你发现这间 Loft 正慢慢变成一个大家都能参与的地方。"
		hint_label.text = "这顿饭让室友们更愿意一起分享空间和时间。"
	else:
		dialogue_label.text = "这顿饭没有让大家一下子变得无话不谈，但你记住了每个人的声音和习惯。下次再坐到这张桌边，或许会更自在一些。"
		hint_label.text = "你还在适应这间 Loft，不过已经有了下一次一起吃饭的理由。"
	if closest["score"] >= 55:
		hint_label.text += " 你和%s比初见时更自在了。" % closest["name"]
	_clear_choices()
	_add_choice("继续到周日早晨", _start_sunday, 260.0)
	_add_choice("查看周末生活日志", _show_weekend_log)
	_add_choice("回到开始界面", _restart_evening, 260.0)

func _close_declined_evening() -> void:
	if weekly_story_week:
		weekly_story_stage = "sunday"
	_set_scene("客厅", "周六   22:30")
	speaker_label.text = "周六 · 晚饭后"
	dialogue_label.text = "你坐下来听室友们讲今晚的饭菜和笑话。虽然错过了这顿饭，你仍然被留在他们的日常里。"
	hint_label.text = "这次没有参加饭局，但你和室友们的共同生活还在继续。"
	day_log.append("周六：饭后和室友聊了几句，缺席没有中断共同生活。")
	_clear_choices()
	_add_choice("继续到周日早晨", _start_sunday, 260.0)
	_add_choice("查看周末生活日志", _show_weekend_log)
	_add_choice("回到开始界面", _restart_evening, 260.0)

func _show_weekend_log() -> void:
	var log_time := "周六   20:20"
	if weekly_cycle_active and weekly_cycle_stage == "week_two_review_finished":
		log_time = "第2周 周日"
	elif weekly_cycle_active and weekly_meeting_open:
		log_time = "第%d周 周日" % weekly_week if weekly_story_week else "第%d周 周六" % weekly_week
	elif weekly_cycle_active:
		log_time = "第%d周 周%d" % [weekly_week, weekly_day + 1]
	elif dancer_rehearsal_resolved:
		log_time = "周三   20:15"
	elif dancer_rehearsal_invited:
		log_time = "周二   08:05"
	elif monday_completed:
		log_time = "周一   09:15"
		if monday_forgot_chore:
			log_time = "周二   07:20"
		elif monday_evening_completed:
			log_time = "周一   20:20"
	elif sunday_completed:
		log_time = "周日   10:05"
	elif declined_dinner_plan:
		log_time = "周六   22:35"
	_set_scene("客厅", log_time)
	if weekly_cycle_active or sunday_completed or monday_completed:
		dialogue_panel.position = Vector2(36, 155)
		dialogue_panel.size = Vector2(888, 365)
		dialogue_label.custom_minimum_size = Vector2(820, 0)
	else:
		dialogue_panel.position = Vector2(36, 260)
		dialogue_panel.size = Vector2(888, 270)
		dialogue_label.custom_minimum_size = Vector2(820, 0)
	dialogue_label.add_theme_font_size_override("font_size", 14 if weekly_cycle_active else 16)
	speaker_label.text = "生活日志"
	var entries := PackedStringArray()
	var log_start := 0
	if weekly_cycle_active:
		log_start = weekly_log_start_index
	for i in range(log_start, day_log.size()):
		entries.append("· " + day_log[i])
	if not weekend_memories.is_empty():
		entries.append("· 被记住的共同经历：" + "、".join(weekend_memories) + "。")
	var closest := _closest_roommate()
	entries.append("· 关系总结：你目前与%s最熟悉（%d / 100）。" % [closest["name"], closest["score"]])
	if not week_one_room_conflict_outcome.is_empty():
		entries.append("· 大厨与舞者目前的相处值：%d / 100。" % relationship_chef_dancer)
	dialogue_label.text = "\n".join(entries)
	hint_label.text = "这些经历和关系变化会延续到之后的共同生活。"
	_clear_choices()
	if weekly_cycle_active:
		if weekly_cycle_stage == "week_two_review_finished":
			_add_choice("返回周日复盘结果", _show_week_two_wrap_result, 300.0)
		elif weekly_meeting_open:
			_add_choice("返回本周日志", _start_weekly_meeting, 260.0)
		elif weekly_day >= 5 and not sunday_completed:
			_add_choice("继续到周日早晨", _start_sunday, 260.0)
		elif sunday_completed:
			_add_choice("生成本周日志", _start_weekly_meeting, 260.0)
		elif weekly_story_week:
			_add_choice("返回当前剧情", _return_to_weekly_story, 260.0)
		elif weekly_household_intro_active:
			if makeup_task_active:
				_add_choice("返回周二晚补做", _start_tuesday_makeup_evening, 260.0)
			elif dance_rehearsal_active:
				_add_choice("返回周三晚排练", _start_wednesday_rehearsal, 260.0)
			elif not dancer_rehearsal_invited and monday_completed:
				_add_choice("继续到舞者的邀请", _dancer_rehearsal_invitation, 260.0)
			else:
				_add_choice("继续本周日常安排", _continue_after_monday_cycle, 260.0)
		else:
			_add_choice("返回当天结算", _weekly_return_day_result, 260.0)
	else:
		if not sunday_completed:
			_add_choice("继续到周日早晨", _start_sunday)
		if monday_completed and not monday_evening_completed:
			_add_choice("继续到周一晚饭后", _start_monday_evening)
	_add_choice("回到开始界面", _restart_evening)

func _return_to_weekly_story() -> void:
	match weekly_story_stage:
		"opening":
			_show_opening()
		"weekday":
			_start_weekly_day()
		"weekday_result":
			_weekly_show_day_result(weekly_last_task_completed)
		"weekend":
			_start_weekend_activities()
		"dinner", "sunday", "sunday_morning":
			_start_sunday()
		"sunday_finish":
			_finish_sunday()
		"weekly_meeting":
			_start_weekly_meeting()
		_:
			_show_opening()

func _weekly_return_day_result() -> void:
	_weekly_show_day_result(weekly_last_task_completed)

func _start_sunday() -> void:
	if weekly_cycle_active:
		weekly_cycle_stage = "sunday"
	if weekly_story_week:
		weekly_story_stage = "sunday_morning"
	var closest := _closest_roommate()
	var morning_place := "厨房"
	match closest["name"]:
		"广告人", "舞者":
			morning_place = "客厅"
		"哲学家":
			morning_place = "露台"
	_set_scene(morning_place, "第%d周 周日   09:15" % weekly_week if weekly_cycle_active else "周日   09:15")
	speaker_label.text = closest["name"]
	var relationship_opener := _sunday_relationship_opener(closest["name"], closest["score"])
	var memory_line := _sunday_memory_callback(closest["name"])
	if not memory_line.is_empty():
		dialogue_label.text = relationship_opener + "\n\n" + memory_line
	elif mindset_shift.is_empty():
		dialogue_label.text = relationship_opener + "“今天打算怎么过？”周末的相处让你们比初见时熟悉了一些。"
	else:
		dialogue_label.text = relationship_opener + "“这几天发生的事，有没有让你对面谈和接下来的生活多想明白一点？”"
	hint_label.text = "当前关系最高的室友会先来和你说话；亲疏程度也会改变周日的开场语气。"
	_clear_choices()
	if weekly_cycle_active and weekly_week == 1 and philosopher_ai_route_active and not philosopher_sunday_followup_done:
		_add_choice("问问哲学家那段经历", _philosopher_sunday_followup, 350.0)
		_add_choice("先开始今天的安排", _skip_philosopher_sunday_followup, 350.0)
		return
	_show_sunday_daily_choices()

func _show_sunday_daily_choices() -> void:
	_clear_choices()
	if weekly_cycle_active:
		_add_choice("和室友分享一个小目标", _sunday_share_plan, 260.0)
		_add_choice("独自静一会儿，整理思绪", _sunday_reflect, 260.0)
		if not weekly_chore_done:
			_add_choice("先完成公共区域打扫", _cycle_clean_chore, 260.0)
	else:
		_add_choice("和室友分享：我想先完成一件小事。", _sunday_share_plan)
		_add_choice("先独自静一会儿，把思绪理顺。", _sunday_reflect)

func _skip_philosopher_sunday_followup() -> void:
	philosopher_sunday_followup_done = true
	day_log.append("周日：先把哲学家的故事放在心里，继续处理今天的安排。")
	_show_sunday_daily_choices()

func _philosopher_sunday_followup() -> void:
	_set_scene("露台", "第1周 周日   09:30")
	speaker_label.text = "哲学家 · 备课"
	dialogue_label.text = "哲学家正整理下周课程的讲义，桌上放着一张旧的评估表。他指着表格里那一栏：“我当时知道完成率看不见学生的全部生活，却还是帮着把它做成了结论。你觉得我那时为什么没有停下来？”"
	hint_label.text = "你可以追问他的选择、表达理解，或告诉他你不同意当时的做法。"
	_clear_choices()
	_add_choice("追问他为何仍支持上线", _answer_philosopher_sunday.bind("question"), 260.0)
	_add_choice("理解压力，但认为应该再等等", _answer_philosopher_sunday.bind("understand"), 260.0)
	_add_choice("不同意：责任应由团队共同承担", _answer_philosopher_sunday.bind("challenge"), 260.0)

func _answer_philosopher_sunday(response: String) -> void:
	philosopher_sunday_followup_done = true
	philosopher_sunday_response = response
	_remember("周日继续谈哲学家的AI经历：" + response)
	match response:
		"question":
			relationship_philosopher = clampi(relationship_philosopher + 2, 0, 100)
			day_log.append("周日：追问哲学家为何明知评估有盲区仍支持上线；哲学家关系 +2。")
			dialogue_label.text = "哲学家没有回避：“我怕项目停下来以后，之前做的一切都变得毫无意义。我把继续推进说成务实，其实也在躲避承认自己判断错了。”他把那张表收起来，承认这不是替自己开脱。"
			hint_label.text = "哲学家承认自己当时也在保护已经投入的努力；关系 +2。"
		"understand":
			relationship_philosopher = clampi(relationship_philosopher + 4, 0, 100)
			day_log.append("周日：理解哲学家当时承受的上线压力，同时表达应该再等等；哲学家关系 +4。")
			dialogue_label.text = "哲学家点点头：“那时每个人都怕延期会让项目失去机会。我希望有人当时能像你这样说：压力是真的，可它不能替我们决定谁来承担风险。”他看起来轻松了一点，也没有把自己的责任推给团队。"
			hint_label.text = "你理解了压力，也没有替他的选择开脱；哲学家关系 +4。"
		"challenge":
			relationship_philosopher = clampi(relationship_philosopher + 1, 0, 100)
			day_log.append("周日：提出 AI 误判应由整个团队共同承担；哲学家关系 +1。")
			dialogue_label.text = "哲学家想了一会儿：“团队确实有责任，但我不能用‘大家都有份’来抹掉自己那一票。”他接受了你的反对，也补充说，团队责任应该落实成能发现问题、暂停系统和修正结果的具体安排。"
			hint_label.text = "你们没有完全同意，但哲学家愿意把不同意见继续谈下去；关系 +1。"
	_update_status()
	_clear_choices()
	_add_choice("继续今天的安排", _show_sunday_daily_choices, 350.0)

func _remember(memory: String) -> void:
	if not weekend_memories.has(memory):
		weekend_memories.append(memory)

func _sunday_relationship_opener(roommate: String, score: int) -> String:
	if score >= 70:
		return "%s看见你醒来，熟络地把早餐往你这边推了推，像是早就等着和你聊几句。" % roommate
	if score < 45:
		return "%s先轻轻敲了敲门，确认你愿意聊天后，才在门边问候你。" % roommate
	return "%s看见你起身，像平常一样和你打了声招呼。" % roommate

func _sunday_memory_callback(roommate: String) -> String:
	if declined_dinner_plan:
		return "大厨把热好的汤放到桌上：“昨天没赶上饭局吧？我特意给你留了一碗。等会儿广告人还要把昨晚的趣事讲给你听。”"
	if dancer_peanut_memory:
		if dancer_peanut_dish_served:
			return "舞者笑着说：“昨天我提醒你不太吃花生，谢谢你没把那件小事当成什么大问题。下次我再给你推荐我喜欢的口味。”"
		return "舞者把茶杯放下，笑着说：“昨天你还记得我不喜欢花生。只是留意到这样的小事，也会让人觉得被放在心上。”"
	if weekend_memories.has("和大厨默契备菜"):
		if roommate == "大厨":
			return "大厨把茶递给你：“昨天递菜的节奏配得真不错。下次厨房忙起来，咱们再试一次？”"
		return "%s端着茶说：“大厨刚才还在夸昨天你们递菜配合得好。下次我也去厨房看看。”" % roommate
	if weekend_memories.has("和大厨备菜时手忙脚乱"):
		if roommate == "大厨":
			return "大厨把茶递给你：“昨天咱俩在厨房有点手忙脚乱，不过那锅汤最后还是做好了。下次慢慢来。”"
		return "%s笑着说：“大厨刚才提起昨天你们在厨房有点手忙脚乱，不过那锅汤最后还是做好了。”" % roommate
	if weekend_memories.has("和广告人、舞者选了热闹歌单"):
		return "%s笑着指指客厅：“昨天那首节奏特别强的歌，舞者今天早上还在哼。下次晚饭前再放一次吧。”" % roommate
	if weekend_memories.has("和广告人、舞者选了柔和歌单"):
		return "%s说：“昨天那首柔和的歌我记住了。早上放着它，连收拾东西都没那么赶了。”" % roommate
	if weekend_memories.has("和广告人、舞者轮流选歌"):
		return "%s指指音箱：“昨天大家轮流选歌挺有意思的。广告人说，下次可以把每个人的歌都加进去。”" % roommate
	if weekend_memories.has("和哲学家讨论AI增长与责任"):
		if roommate == "哲学家":
			return "哲学家在露台给你留了茶：“昨天你说产品要先证明价值。我还在想，怎样才能在扩大使用时也及时发现那些被误判的人。”"
		return "%s说：“哲学家昨天和你聊了 AI 产品的增长。他说你愿意把误判责任摆出来讨论，这让他想起以前做教育平台时的一位学生。”" % roommate
	if weekend_memories.has("和哲学家讨论AI误判的保障"):
		if roommate == "哲学家":
			return "哲学家把茶递给你：“昨天你提到申诉和人工复核。我回去又想了想，保障不该只写在发布清单里，还得让人真的找得到。”"
		return "%s说：“哲学家昨天提起你们谈到 AI 误判怎么补救。他今天一早就在想，怎样让用户真的能提出异议。”" % roommate
	if weekend_memories.has("听哲学家讲教育AI评估经历"):
		if roommate == "哲学家":
			return "哲学家在露台给你留了茶：“昨天你问起我在教育平台的经历。我整理讲义时找到了旧评估表，想听我继续说吗？”"
		return "%s说：“哲学家昨天提到自己在教育平台做过评估模型。他似乎还有些话想讲，已经带着旧讲义去露台了。”" % roommate
	if weekend_memories.has("和哲学家讨论一次面谈的分量"):
		if roommate == "哲学家":
			return "哲学家在露台给你留了位置：“昨天我们说，面谈结果不能替整段经历下结论。今天回头看，你还这么觉得吗？”"
		return "%s说：“昨天你和哲学家聊到面谈结果不代表全部努力。他刚才还在露台等你，想知道你今天回头看是什么感觉。”" % roommate
	if weekend_memories.has("对哲学家承认自己有些失落"):
		if roommate == "哲学家":
			return "哲学家在露台给你留了位置：“昨天你愿意承认失落，这挺不容易的。今天感觉好一点了吗？”"
		return "%s说：“昨天你和哲学家聊了面谈的失落。他让我问问你，今天感觉有没有好一点。”" % roommate
	if weekend_memories.has("听哲学家聊如何看待失败"):
		if roommate == "哲学家":
			return "哲学家在露台给你留了位置：“昨天说到结果能告诉我们什么。你后来想到下一步了吗？不用现在就决定。”"
		return "%s说：“哲学家昨天跟我讲了你们聊到的事。结果能提供信息，但不用急着现在就决定下一步。”" % roommate
	if weekend_memories.has("和室友分享菜和生活故事"):
		return "%s看见你起来，提起昨晚饭桌上的故事：“你说的那道菜我记住了。下次也讲讲你创业时最有意思的一件事吧。”" % roommate
	if weekend_memories.has("帮大厨把晚饭端上桌"):
		return "%s笑着说：“昨天多亏你一起端菜，大家才能那么快开饭。今天早上想先做点什么？”" % roommate
	return "广告人朝你挥挥手：“昨天的饭局还挺开心的。下次我们再一起弄点吃的吧。”"

func _sunday_share_plan() -> void:
	sunday_shared_plan = true
	spatial_harmony = clampi(spatial_harmony + 5, 0, 100)
	if weekly_cycle_active:
		weekly_care_choices += 1
	player_extroversion = clampi(player_extroversion + 5, 0, 100)
	var closest := _closest_roommate()
	_increase_roommate_relationship(closest["name"], 4)
	mindset_shift = "我不必一次解决所有问题，先完成一件眼下能做的事。"
	day_log.append("周日：和%s分享本周小目标，空间和睦 +5、外向 +5、关系 +4。" % closest["name"])
	day_log.append("心态转变：我不必一次解决所有问题，先完成一件眼下能做的事。")
	_update_status()
	speaker_label.text = closest["name"]
	dialogue_label.text = "听完你的想法，%s说：“这件事听起来做得到。等你开始了，也可以告诉我们进展。”" % closest["name"]
	hint_label.text = "你把接下来的一步说了出来，室友愿意陪你记着这件事。"
	_clear_choices()
	_add_choice("结束这个周末", _finish_sunday)

func _sunday_reflect() -> void:
	player_mood = clampi(player_mood + 6, 0, 100)
	sunday_shared_plan = false
	mindset_shift = "先照顾好当下的自己，也是在为之后做准备。"
	day_log.append("周日：独自整理思绪，心情 +6。")
	day_log.append("心态转变：先照顾好当下的自己，也是在为之后做准备。")
	_update_status()
	speaker_label.text = "你"
	dialogue_label.text = "你走到露台安静坐了一会儿。没有急着决定下一步，呼吸慢下来后，脑子也清楚了一些。"
	hint_label.text = "你给自己留出了一点恢复的时间。"
	_clear_choices()
	_add_choice("结束这个周末", _finish_sunday)

func _finish_sunday() -> void:
	sunday_completed = true
	var chore_missed_this_week := false
	if weekly_cycle_active and not weekly_chore_resolved:
		weekly_chore_resolved = true
		chore_missed_this_week = true
		_expire_current_task()
		spatial_harmony = clampi(spatial_harmony - 9, 0, 100)
		relationship_chef = clampi(relationship_chef - 5, 0, 100)
		relationship_advertiser = clampi(relationship_advertiser - 2, 0, 100)
		player_mood = clampi(player_mood - 3, 0, 100)
		weekly_last_task_completed = false
		day_log.append("第%d周周日：公共区域打扫一直没完成，室友最后一起收拾；空间和睦 -9、大厨关系 -5、广告人关系 -2、心情 -3。" % weekly_week)
		_update_status()
	if weekly_story_week:
		weekly_story_stage = "sunday_finish"
		if not weekly_intro_tallied:
			weekly_tasks_total += visited_activities.size()
			weekly_tasks_done += visited_activities.size()
			weekly_intro_tallied = true
			day_log.append("第1周：完成周末共同活动 %d 项，已计入例会回顾。" % visited_activities.size())
	_set_scene("客厅", "第%d周 周日   10:00" % weekly_week if weekly_cycle_active else "周日   10:00")
	if chore_missed_this_week:
		speaker_label.text = "周日 · 公共区域"
		dialogue_label.text = "你发现公共区域还是没有收拾。大厨和广告人已经把客厅简单整理好，没人责备你，但大家都知道这件事最后还是落在了室友身上。"
		hint_label.text = "公共卫生待办已错过期限；本周日志会记录室友关系与和睦值的变化。"
	else:
		speaker_label.text = "周日 · 上午"
		if sunday_shared_plan:
			dialogue_label.text = "早餐后，你把这周想完成的小事记在手机里。Loft 里有人在收拾，有人在找钥匙，新的日常已经开始了。"
			hint_label.text = "这周末的相遇和决定都记进了生活日志。"
		else:
			dialogue_label.text = "回到屋里时，室友们正各自准备出门。你还没有想好所有事情，但已经不必逼自己今天就想清楚。"
			hint_label.text = "你给接下来的生活留出了一点余地。"
	_clear_choices()
	if weekly_cycle_active:
		_add_choice("生成本周日志", _start_weekly_meeting, 260.0)
	elif weekly_story_week:
		_add_choice("进入第一周周末例会", _start_weekly_meeting, 260.0)
	else:
		_add_choice("进入周一：Loft生活会议", _start_monday, 260.0)
	_add_choice("查看更新后的生活日志", _show_weekend_log, 260.0)
	_add_choice("回到开始界面", _restart_evening, 260.0)

func _start_monday() -> void:
	if weekly_cycle_active:
		_start_cycle_monday_meeting()
		return
	_set_scene("客厅", "周一   08:40")
	dialogue_panel.position = Vector2(36, 275)
	dialogue_panel.size = Vector2(888, 245)
	dialogue_label.custom_minimum_size = Vector2(820, 95)
	speaker_label.text = "周一 · Loft生活会议"
	if spatial_harmony >= 65:
		dialogue_label.text = "早餐后，广告人拿出一张便签：“我们住在一起也有几天了，要不把公共区域的收拾方式定下来？”大家很自然地围到桌边。"
		hint_label.text = "周末积累的和睦让大家更容易一起商量。"
	else:
		dialogue_label.text = "早餐后，大家发现厨房台面和客厅都有些乱。广告人找来便签：“要不要定个简单的收拾办法？这样也不用总是一个人做。”"
		hint_label.text = "这是 Loft 的第一次生活会议，大家还在摸索适合彼此的节奏。"
	if declined_dinner_plan:
		dialogue_label.text += " 舞者提醒大家，周末每个人的安排不一样，最好留些调整空间。"
	elif sunday_shared_plan:
		dialogue_label.text += " 你昨天说想先完成一件小事，大家也问你愿不愿意从这件共同的小事开始。"
	else:
		dialogue_label.text += " 哲学家说，规则最好是大家都能参与决定的。"
	_clear_choices()
	_add_choice("我可以负责晚饭后的厨房收拾", _monday_kitchen_duty, 260.0)
	_add_choice("把公共区域拆成小任务，轮流来", _monday_small_tasks, 260.0)
	_add_choice("先试一周，周末再一起调整", _monday_trial_week, 260.0)

func _start_cycle_monday_meeting() -> void:
	if weekly_week == 2:
		_start_week_two_monday_event()
		return
	weekly_cycle_stage = "monday_meeting"
	_set_scene("客厅", "第%d周 周一   08:40" % weekly_week)
	speaker_label.text = "第%d周 · Loft生活例会" % weekly_week
	dialogue_label.text = "早餐后，广告人拿出便签，大家商量公共区域的卫生怎么分担。大厨希望厨房和餐桌保持整洁，舞者提议把清扫安排在各自有空的时候。"
	hint_label.text = "这周确定一项公共卫生待办：周日之前完成。"
	dialogue_panel.position = Vector2(36, 275)
	dialogue_panel.size = Vector2(888, 245)
	dialogue_label.custom_minimum_size = Vector2(820, 95)
	_clear_choices()
	_add_choice("我来负责，周日前清扫", _cycle_assign_chore.bind("personal"), 270.0)
	_add_choice("分区轮值，我负责客餐厅", _cycle_assign_chore.bind("rotate"), 270.0)
	_add_choice("一起打扫，我做检查", _cycle_assign_chore.bind("shared"), 270.0)

func _start_week_two_monday_event() -> void:
	weekly_cycle_stage = "week_two_monday_event"
	_set_scene("客厅", "第2周 周一   08:40")
	dialogue_panel.position = Vector2(36, 275)
	dialogue_panel.size = Vector2(888, 245)
	dialogue_label.custom_minimum_size = Vector2(820, 95)
	_clear_choices()
	if weekly_previous_chore_done:
		relationship_chef = clampi(relationship_chef + 1, 0, 100)
		relationship_advertiser = clampi(relationship_advertiser + 1, 0, 100)
		relationship_dancer = clampi(relationship_dancer + 1, 0, 100)
		relationship_philosopher = clampi(relationship_philosopher + 1, 0, 100)
		spatial_harmony = clampi(spatial_harmony + 2, 0, 100)
		day_log.append("第2周周一：因为按约完成了上周的打扫，大家对你更放心；四位室友关系各 +1、空间和睦 +2。")
		speaker_label.text = "第2周周一 · 大厨"
		dialogue_label.text = "早餐后，大厨把一只小茶杯递给你：“上周你按约把公共区域收拾好了，周末大家回来都轻松不少。这是我做菜时顺手烧的小杯子。”广告人接着问你要不要周末和大家一起去逛市集。"
		hint_label.text = "上周的守约让大家更信任你；这段周一剧情结束后，本次试玩也会收住。"
		_add_choice("收下茶杯，答应和大家一起去", _week_two_accept_outing, 350.0)
		_add_choice("谢谢大家，提议改天在家一起喝茶", _week_two_host_tea, 405.0)
	else:
		speaker_label.text = "第2周周一 · 公共区域"
		dialogue_label.text = "早餐后，大厨把上周的便签放在桌上。客厅虽然已经收拾干净，但那是室友们临时一起补上的。大厨坦白说自己有些失望，广告人没有接上市集的话题，等着听你怎么回应。"
		hint_label.text = "上周漏掉的待办已影响信任；你可以为此道歉，或坦诚说明当时的状态。"
		_add_choice("认真道歉，承认让大家替我收尾了", _week_two_apologize, 405.0)
		_add_choice("解释最近工作很累，也听听大家的感受", _week_two_explain, 405.0)
	_update_status()

func _week_two_accept_outing() -> void:
	player_mood = clampi(player_mood + 3, 0, 100)
	player_extroversion = clampi(player_extroversion + 2, 0, 100)
	day_log.append("第2周周一：收下大厨送的小茶杯，并答应和大家一起逛市集；心情 +3、外向 +2。")
	_finish_week_two_monday_event("你把茶杯小心收好，答应和大家一起去市集。广告人已经开始列摊位清单，舞者说到时可以慢慢逛，不用赶时间。")

func _week_two_host_tea() -> void:
	spatial_harmony = clampi(spatial_harmony + 2, 0, 100)
	relationship_chef = clampi(relationship_chef + 2, 0, 100)
	day_log.append("第2周周一：提议改天在家一起喝茶；空间和睦 +2、大厨关系 +2。")
	_finish_week_two_monday_event("你谢谢大厨的心意，也提议找个晚上在家一起喝茶。大家很快开始讨论要准备什么点心，市集的安排也留待下次再说。")

func _week_two_apologize() -> void:
	relationship_chef = clampi(relationship_chef + 2, 0, 100)
	spatial_harmony = clampi(spatial_harmony + 2, 0, 100)
	day_log.append("第2周周一：向大家道歉，承认上周让室友替自己收尾；大厨关系 +2、空间和睦 +2。")
	_finish_week_two_monday_event("你承认上周没有完成约定，让大家临时多做了事。大厨点点头，说谢谢你愿意把话说开；广告人也把市集计划重新提了出来，但大家决定之后再约。")

func _week_two_explain() -> void:
	relationship_philosopher = clampi(relationship_philosopher + 1, 0, 100)
	day_log.append("第2周周一：坦诚说出工作疲惫，也听室友讲了他们临时收尾时的感受；哲学家关系 +1。")
	_finish_week_two_monday_event("你说最近确实很累，但也承认大家临时收尾并不公平。哲学家接过话，说理解原因能帮助彼此沟通，却不能替代共同承担。屋里的气氛缓和了一点。")

func _finish_week_two_monday_event(result_text: String) -> void:
	weekly_cycle_stage = "week_two_monday_finished"
	_update_status()
	speaker_label.text = "第2周周一 · 早晨"
	dialogue_label.text = result_text
	hint_label.text = "本次回应已记入生活日志。周二会由当前关系最高的室友接着和你说话。"
	_clear_choices()
	_add_choice("继续到周二", _start_week_two_tuesday, 350.0)

func _start_week_two_tuesday() -> void:
	weekly_day = 1
	weekly_cycle_stage = "week_two_tuesday"
	var closest := _closest_roommate()
	weekly_tuesday_roommate = closest["name"]
	_set_scene("厨房" if weekly_previous_chore_done else "客厅", "第2周 周二   19:10")
	speaker_label.text = "第2周周二 · " + closest["name"]
	if weekly_previous_chore_done:
		dialogue_label.text = "%s在厨房遇见你，手里拿着刚买回来的面包：“上周你按约完成了打扫，大家回来时都轻松了不少。下班后要不要一起去楼下买点吃的？”" % closest["name"]
		hint_label.text = "上周的守约留下了信任；这次邀请来自目前关系最高的室友。"
		_clear_choices()
		_add_choice("好啊，一起去买点吃的", _week_two_tuesday_accept, 350.0)
		_add_choice("谢谢你邀请，我今晚想休息", _week_two_tuesday_rest, 405.0)
	else:
		dialogue_label.text = "%s在客厅整理便签，见你回来后停下手里的事：“上周的打扫最后是大家一起收尾的。我想知道你后来怎么想；以后如果赶不上，能不能早点告诉我们？”" % closest["name"]
		hint_label.text = "周一的回应之后，关系最高的室友想继续谈谈如何提前沟通。"
		_clear_choices()
		_add_choice("答应以后尽早说一声", _week_two_tuesday_communicate, 350.0)
		_add_choice("听听那天大家临时收尾是什么感受", _week_two_tuesday_listen, 405.0)

func _week_two_tuesday_accept() -> void:
	var closest := _closest_roommate()
	weekly_tuesday_memory_tag = "答应和%s一起买吃的" % closest["name"]
	_remember(weekly_tuesday_memory_tag)
	_increase_roommate_relationship(closest["name"], 2)
	player_extroversion = clampi(player_extroversion + 2, 0, 100)
	day_log.append("第2周周二：接受%s的邀请一起买吃的；关系 +2、外向 +2。" % closest["name"])
	_finish_week_two_tuesday("你们一起下楼买了些吃的，边走边聊最近的生活。%s说，和愿意一起分担的人相处，日子会轻松很多。" % closest["name"], "接受邀请：与%s关系 +2、外向 +2。" % closest["name"])

func _week_two_tuesday_rest() -> void:
	var closest := _closest_roommate()
	weekly_tuesday_memory_tag = "婉拒%s的邀请并在家休息" % closest["name"]
	_remember(weekly_tuesday_memory_tag)
	player_mood = clampi(player_mood + 2, 0, 100)
	day_log.append("第2周周二：婉拒%s的邀请，在家休息；心情 +2，关系没有下降。" % closest["name"])
	_finish_week_two_tuesday("你谢过%s，决定今晚留在家里。对方说没关系，把面包分了一半放在桌上，约你有精神时再一起出门。" % closest["name"], "婉拒邀请并休息：心情 +2，关系没有下降。")

func _week_two_tuesday_communicate() -> void:
	var closest := _closest_roommate()
	weekly_tuesday_memory_tag = "答应遇到困难时尽早和%s沟通" % closest["name"]
	_remember(weekly_tuesday_memory_tag)
	_increase_roommate_relationship(closest["name"], 2)
	spatial_harmony = clampi(spatial_harmony + 2, 0, 100)
	day_log.append("第2周周二：答应以后遇到困难会尽早沟通；与%s关系 +2、空间和睦 +2。" % closest["name"])
	_finish_week_two_tuesday("你答应以后遇到困难会尽早说。%s点点头：“这样我们就能一起想办法，不用等到事情落下来才猜发生了什么。”" % closest["name"], "主动约定提前沟通：与%s关系 +2、空间和睦 +2。" % closest["name"])

func _week_two_tuesday_listen() -> void:
	var closest := _closest_roommate()
	weekly_tuesday_memory_tag = "听%s讲完临时收尾的感受" % closest["name"]
	_remember(weekly_tuesday_memory_tag)
	_increase_roommate_relationship(closest["name"], 1)
	weekly_care_choices += 1
	day_log.append("第2周周二：听%s讲临时收尾的感受；关系 +1。" % closest["name"])
	_finish_week_two_tuesday("%s说，那天大家并不是想责怪你，只是临时分工时有些慌乱。你听完后，两个人都觉得这件事终于说得更清楚了。" % closest["name"], "认真听室友讲完：与%s关系 +1。" % closest["name"])

func _finish_week_two_tuesday(result_text: String, result_hint: String) -> void:
	weekly_cycle_stage = "week_two_tuesday_finished"
	_update_status()
	speaker_label.text = "第2周周二 · 当日回响"
	dialogue_label.text = result_text
	hint_label.text = result_hint + " 这段经历会在周三继续被提起。"
	_clear_choices()
	_add_choice("继续到周三", _start_week_two_wednesday, 350.0)

func _start_week_two_wednesday() -> void:
	weekly_day = 2
	weekly_cycle_stage = "week_two_wednesday"
	var roommate := weekly_tuesday_roommate
	_set_scene("客厅", "第2周 周三   19:20")
	speaker_label.text = "第2周周三 · " + roommate
	if weekly_tuesday_memory_tag.begins_with("答应和"):
		dialogue_label.text = "%s把昨晚买回来的面包放在桌上：“昨天一起出门还挺放松的。我顺手多带了一份回来，今天可以接着吃。”" % roommate
		hint_label.text = "记忆回响：%s记得你们周二一起买吃的。" % roommate
	elif weekly_tuesday_memory_tag.begins_with("婉拒"):
		dialogue_label.text = "%s把一小袋面包放到桌上：“昨天你想休息，我就没打扰你。今天路过店里顺手带了一份，看看你现在想不想吃。”" % roommate
		hint_label.text = "记忆回响：%s记得你周二选择休息，也给你留了点心。" % roommate
	elif weekly_tuesday_memory_tag.begins_with("答应遇到困难"):
		dialogue_label.text = "%s在客厅遇见你，先告诉你自己晚些时候要出门：“我想起你说遇到困难会早点讲，所以先和你说一声。上周那件事，我们不用再靠猜了。”" % roommate
		hint_label.text = "记忆回响：%s记得你答应以后尽早沟通，也用行动回应了这个约定。" % roommate
	else:
		dialogue_label.text = "%s坐在客厅，见你回来后接着聊起上周：“谢谢你昨天愿意听我把临时收尾的事讲完。我后来也想了想，下次可以早点开口求助。”" % roommate
		hint_label.text = "记忆回响：%s记得你愿意听完那段经历，也继续分享了自己的想法。" % roommate
	_clear_choices()
	_add_choice("留下来继续聊一会儿", _week_two_wednesday_chat, 350.0)
	_add_choice("收下点心，先回房休息", _week_two_wednesday_rest, 350.0)

func _week_two_wednesday_chat() -> void:
	_increase_roommate_relationship(weekly_tuesday_roommate, 2)
	player_extroversion = clampi(player_extroversion + 2, 0, 100)
	day_log.append("第2周周三：继续和%s聊天；关系 +2、外向 +2，回应了周二留下的记忆。" % weekly_tuesday_roommate)
	_finish_week_two_wednesday("你们又聊了一会儿。昨天说过的话没有停在当时，而是变成了今天相处时的一点体贴。", "留下聊天：与%s关系 +2、外向 +2。" % weekly_tuesday_roommate)

func _week_two_wednesday_rest() -> void:
	player_mood = clampi(player_mood + 3, 0, 100)
	day_log.append("第2周周三：收下%s留的点心后回房休息；心情 +3，关系没有下降。" % weekly_tuesday_roommate)
	_finish_week_two_wednesday("你收下点心，和%s道了谢，然后回房休息。对方没有挽留，只说改天再聊。" % weekly_tuesday_roommate, "收下点心并休息：心情 +3，关系没有下降。")

func _finish_week_two_wednesday(result_text: String, result_hint: String) -> void:
	weekly_cycle_stage = "week_two_wednesday_finished"
	_update_status()
	speaker_label.text = "第2周周三 · 当日回响"
	dialogue_label.text = result_text
	hint_label.text = result_hint
	_clear_choices()
	if philosopher_ai_route_active and not philosopher_ai_decision_done:
		hint_label.text += " 合作方刚发来一封和产品上线有关的邮件。"
		_add_choice("查看合作方的上线提议", _start_philosopher_launch_decision, 350.0)
	elif dancer_showcase_route_active and not dancer_showcase_callback_done:
		hint_label.text += " 舞者也提过她要办的社区活动。"
		_add_choice("继续到周四，听听她的演出后来怎么样", _advance_to_dancer_showcase_callback, 350.0)
	else:
		hint_label.text += " 大家约好周末一起回顾这两周的共同生活。"
		_add_choice("继续到周日合住复盘", _start_week_two_wrap_meeting, 350.0)

func _advance_to_dancer_showcase_callback() -> void:
	weekly_day = 3
	_start_weekly_day()

func _start_week_two_dancer_showcase_callback() -> void:
	dancer_showcase_callback_done = true
	weekly_cycle_stage = "dancer_showcase_callback"
	_set_scene("客厅", "第2周 周四   19:30")
	speaker_label.text = "舞者 · 演出之后"
	match dancer_showcase_choice:
		"help":
			dialogue_label.text = "舞者把几张手写反馈放在桌上：“那天真的有人中途加入，最后连平时只坐在旁边看的邻居都跟着跳了几步。你帮我把流程拆松一点，大家就没那么怕做错。”"
			hint_label.text = "你上周帮她整理了活动流程；她记得这份具体的支持。"
		"listen":
			dialogue_label.text = "舞者说她把演出改成了开放练习：“我先讲自己为什么喜欢跳舞，然后邀请大家跟一小段。没有人需要站出来表演，结果反而来了不少人。”她看起来比上周轻松。"
			hint_label.text = "上周你先听她说出担心的事；她把活动改成了更自在的形式。"
		_:
			dialogue_label.text = "舞者说活动最后只办成了一次小小的开放练习：“我请广告人帮我转发，来了几位邻居。你上周说自己帮不上，我就没再把计划排得那么满。”她没有显得失望，反而像是松了口气。"
			hint_label.text = "你上周坦白了自己的边界；她据此调整计划，没有把没兑现的承诺留在两人之间。"
	if relationship_chef_dancer >= 55:
		dialogue_label.text += "\n\n大厨帮她提前腾出了客厅，两人按商量好的时间把椅子摆回去。"
	elif relationship_chef_dancer <= 46:
		dialogue_label.text += "\n\n大厨和舞者各自安排了准备时间，没有再争论，但还需要一点时间重新熟悉彼此的节奏。"
	else:
		dialogue_label.text += "\n\n大厨和舞者轮流使用客厅，虽然不算默契，至少都知道对方什么时候需要空间。"
	hint_label.text += " 大厨与舞者的相处值：%d / 100。" % relationship_chef_dancer
	_clear_choices()
	_add_choice("替她高兴，聊聊那天最开心的部分", _dancer_showcase_callback_response.bind("celebrate"), 350.0)
	_add_choice("问问她下次还想邀请谁一起准备", _dancer_showcase_callback_response.bind("ask"), 350.0)

func _dancer_showcase_callback_response(response: String) -> void:
	if response == "celebrate":
		relationship_dancer = clampi(relationship_dancer + 2, 0, 100)
		player_extroversion = clampi(player_extroversion + 1, 0, 100)
		day_log.append("第2周周四：和舞者回味社区演出；舞者关系 +2、外向 +1。")
		_finish_dancer_showcase_callback("舞者讲起邻居第一次跟着音乐动起来的样子。你们笑了一会儿，她说下次想把音箱交给第一次来的人选歌。", "你和舞者一起庆祝这次尝试；舞者关系 +2、外向 +1。")
	else:
		relationship_dancer = clampi(relationship_dancer + 1, 0, 100)
		player_mood = clampi(player_mood + 2, 0, 100)
		day_log.append("第2周周四：询问舞者下次想和谁准备活动；舞者关系 +1、心情 +2。")
		_finish_dancer_showcase_callback("舞者想了想，说下次想邀请一个平时只在边上看的邻居一起挑音乐。你听她把主意说完，她已经开始盘算下一次开放练习了。", "你继续关心她接下来的想法；舞者关系 +1、心情 +2。")

func _finish_dancer_showcase_callback(result_text: String, result_hint: String) -> void:
	weekly_cycle_stage = "week_two_finished"
	_update_status()
	speaker_label.text = "第2周周四 · 回响收束"
	dialogue_label.text = result_text
	hint_label.text = result_hint + " 这段共同经历已记入生活日志。"
	_clear_choices()
	_add_choice("继续到周日合住复盘", _start_week_two_wrap_meeting, 350.0)

func _start_week_two_wrap_meeting() -> void:
	weekly_day = 6
	weekly_cycle_stage = "week_two_wrap_meeting"
	_set_scene("客厅", "第2周 周日   10:30")
	speaker_label.text = "第2周 · 合住复盘"
	var recap := PackedStringArray()
	recap.append("两周的日常告一段落，大家在客厅坐下来聊聊：哪些安排让共同生活更轻松，哪些事还需要继续磨合。")
	if weekly_previous_chore_done:
		recap.append("第一周的公共卫生按时完成，大家记得那次约定确实有人一起守住了。")
	else:
		recap.append("第一周的公共卫生最后由室友们一起收尾，大家也谈到以后怎样更早说出做不到的事。")
	if not week_one_room_conflict_outcome.is_empty():
		if relationship_chef_dancer >= 55:
			recap.append("大厨和舞者说，最近已经能把客厅时段商量清楚。")
		elif relationship_chef_dancer <= 46:
			recap.append("大厨和舞者承认，客厅安排暂时不再争论了，但有些话还没完全说开。")
		else:
			recap.append("大厨和舞者说，彼此已经知道对方在意什么，还在练习怎么协调。")
	if dancer_showcase_route_active:
		match dancer_showcase_choice:
			"help":
				recap.append("舞者提起社区舞蹈分享，也感谢你当时帮她把流程整理得更轻松。")
			"listen":
				recap.append("舞者提起社区舞蹈分享，说你当时愿意先听她讲完，让她看清自己真正担心的事。")
			_:
				recap.append("舞者提起社区舞蹈分享，也说你当时坦白帮不上，让她及时把活动规模调整到适合自己的程度。")
	if philosopher_ai_route_active and philosopher_ai_decision_done:
		recap.append("哲学家把最近关于产品责任的讨论也带进复盘，大家没有要求彼此立刻给出相同答案。")
	if work_reputation >= 70:
		recap.append("这两周的工作表现让你收到了外地新项目的邀请。它意味着职业上的下一步，也意味着离开这间逐渐熟悉的 Loft。")
	else:
		recap.append("工作仍在继续，但你目前还没有收到需要离开 Loft 的正式机会。")
	dialogue_label.text = "\n\n".join(recap)
	hint_label.text = "你可以先谈实际安排、分享彼此的需要，或承认有些问题还需要时间。"
	_clear_choices()
	_add_choice("先把家务和客厅使用写成简单约定", _week_two_review_set_rules, 300.0)
	_add_choice("每个人轮流说说这两周真正需要什么", _week_two_review_share_needs, 320.0)
	_add_choice("承认还有事没说开，约好之后再回来谈", _week_two_review_leave_room, 320.0)

func _week_two_review_set_rules() -> void:
	spatial_harmony = clampi(spatial_harmony + 3, 0, 100)
	relationship_chef = clampi(relationship_chef + 1, 0, 100)
	relationship_dancer = clampi(relationship_dancer + 1, 0, 100)
	if not week_one_room_conflict_outcome.is_empty():
		relationship_chef_dancer = clampi(relationship_chef_dancer + 2, 0, 100)
	day_log.append("第2周周日合住复盘：把家务和客厅使用写成可调整的约定；空间和睦 +3，大厨与舞者对玩家的关系各 +1。")
	if not week_one_room_conflict_outcome.is_empty():
		day_log.append("复盘时大厨与舞者达成新的空间约定；两人相处值 +2。")
	var rules_hint := "你们先把实际安排说清楚；空间和睦 +3，大厨与舞者对你的关系各 +1。"
	if not week_one_room_conflict_outcome.is_empty():
		rules_hint += "两人相处值 +2。"
	_finish_week_two_wrap_meeting("大家把公共区域的使用时段和卫生安排写成一张可以修改的便签。大厨补上收尾步骤，舞者写下排练时间；两个人都说，有具体安排就比较容易开口。", rules_hint)

func _week_two_review_share_needs() -> void:
	for roommate in ["大厨", "广告人", "舞者", "哲学家"]:
		_increase_roommate_relationship(roommate, 1)
	player_mood = clampi(player_mood + 2, 0, 100)
	player_extroversion = clampi(player_extroversion + 2, 0, 100)
	day_log.append("第2周周日合住复盘：每个人分享近况和需要；四位室友关系各 +1、心情 +2、外向 +2。")
	_finish_week_two_wrap_meeting("广告人说最近需要一点不必安排活动的空档；哲学家希望有人能直接说不同意见；大厨和舞者也各自说了对客厅的期待。你发现，很多摩擦来自大家还没来得及说明自己在意什么。", "你们轮流说出了需要；四位室友关系各 +1，心情和外向各 +2。")

func _week_two_review_leave_room() -> void:
	player_mood = clampi(player_mood + 1, 0, 100)
	spatial_harmony = clampi(spatial_harmony + 1, 0, 100)
	day_log.append("第2周周日合住复盘：没有强求当场解决所有问题，约好之后继续沟通；心情 +1、空间和睦 +1。")
	_finish_week_two_wrap_meeting("没有人试着把所有问题一次说完。你们先约好，遇到客厅安排或家务做不到时尽量提前说明；剩下的分歧留到下一次再谈。", "你们为还没解决的问题留出继续沟通的空间；心情 +1、空间和睦 +1。")

func _finish_week_two_wrap_meeting(result_text: String, result_hint: String) -> void:
	weekly_cycle_stage = "week_two_review_finished"
	week_two_review_result = result_text
	week_two_review_hint = result_hint
	_show_week_two_wrap_result()

func _show_week_two_wrap_result() -> void:
	_update_status()
	_set_scene("客厅", "第2周 周日   11:00")
	speaker_label.text = "第2周 · 复盘结果"
	dialogue_label.text = week_two_review_result
	hint_label.text = week_two_review_hint + " 这次合住复盘已写入生活日志。"
	_clear_choices()
	_add_choice("查看第二周生活日志", _show_weekend_log, 300.0)
	if work_reputation >= 70:
		_add_choice("接受外地项目，离开 Loft", _choose_work_departure, 300.0)
	_add_choice("结束试玩，回到开始界面", _restart_evening, 350.0)

func _choose_work_departure() -> void:
	weekly_cycle_stage = "work_departure_ending"
	day_log.append("结局选择：接受外地项目，离开 Loft。工作声望达到 %d；这是主动选择的职业新阶段。" % work_reputation)
	_set_scene("Loft 门口", "两周后 · 清晨")
	speaker_label.text = "结局 · 去往新的工作"
	dialogue_label.text = "你接受了外地项目。离开前，大家在门口帮你搬最后一个纸箱。大厨把茶叶塞进你手里，广告人说以后还要约线上聚餐；舞者和哲学家也各自发来一句简短的祝福。你确实离开了 Loft，但这里共同生活过的痕迹没有因此消失。"
	hint_label.text = "工作声望 %d / 100。离开不是数值自动触发，而是你在机会出现后亲自做出的选择。" % work_reputation
	_clear_choices()
	_add_choice("查看生活日志", _show_weekend_log, 300.0)
	_add_choice("回到开始界面", _restart_evening, 300.0)

func _start_philosopher_launch_decision() -> void:
	weekly_cycle_stage = "philosopher_launch_decision"
	_set_scene("客厅", "第2周 周三   20:10")
	speaker_label.text = "哲学家 · 合作方邮件"
	var prior_stance := ""
	match philosopher_ai_opening_stance:
		"growth":
			prior_stance = "“你那天说产品要先证明价值。”哲学家看了看邮件。"
		"safeguards":
			prior_stance = "“你那天提过，先把申诉机制准备好。”哲学家看了看邮件。"
		_:
			prior_stance = "“周六你问起我在教育平台的经历。”哲学家看了看邮件。"
	if philosopher_sunday_response == "question":
		prior_stance += "“周日你追问我为什么没有停下来。我也在想，这次我们要不要现在就把问题说清楚？”"
	elif philosopher_sunday_response == "understand":
		prior_stance += "“周日你说理解压力，但仍觉得应该再等等。我想知道你现在会怎么选。”"
	elif philosopher_sunday_response == "challenge":
		prior_stance += "“周日你提醒我，团队责任要落到实际做法上。”"
	dialogue_label.text = "周三晚上，合作方发来邮件，希望下周扩大 AI 产品的使用范围，并建议等上线后再处理申诉和人工复核。" + prior_stance + "你需要决定怎么回复。"
	hint_label.text = "三种决定都会带来代价：发布进度、团队压力，以及用户遇到误判时能否得到帮助。"
	_clear_choices()
	_add_choice("按计划扩大上线", _philosopher_launch_as_planned, 250.0)
	_add_choice("推迟上线，先补保障", _philosopher_delay_launch, 250.0)
	_add_choice("小范围试行并人工复核", _philosopher_limited_pilot, 290.0)

func _philosopher_launch_as_planned() -> void:
	_remember("哲学家支线结局：按计划扩大上线")
	philosopher_ai_decision_done = true
	relationship_philosopher = clampi(relationship_philosopher - 2, 0, 100)
	player_extroversion = clampi(player_extroversion + 2, 0, 100)
	mindset_shift = "上线之后的承诺，必须变成有人负责的检查与纠正。"
	day_log.append("第2周周三：决定按计划扩大 AI 产品上线；哲学家关系 -2、外向 +2。")
	day_log.append("心态转变：上线后的检查与纠正必须有人负责。")
	_finish_philosopher_launch("你回复合作方，同意按计划扩大上线。哲学家没有替你做决定，只提醒你把问题反馈和修正的责任写清楚。他仍担心上线后有人被误判，但看得出你愿意面对这份责任。", "按计划扩大上线：哲学家关系 -2、外向 +2。产品推进较快，哲学家对上线后的监督仍有顾虑。")

func _philosopher_delay_launch() -> void:
	_remember("哲学家支线结局：推迟上线补充保障")
	philosopher_ai_decision_done = true
	relationship_philosopher = clampi(relationship_philosopher + 5, 0, 100)
	player_mood = clampi(player_mood - 2, 0, 100)
	mindset_shift = "承担责任有时意味着接受延期和机会成本。"
	day_log.append("第2周周三：决定推迟扩大上线，先建立申诉与人工复核；哲学家关系 +5、心情 -2。")
	day_log.append("心态转变：承担责任有时意味着接受延期和机会成本。")
	_finish_philosopher_launch("你告诉合作方，申诉与人工复核准备好之前，不扩大使用范围。对方提醒你延期会增加成本；哲学家也承认这不是轻松的决定。他没有庆祝，只说愿意陪你一起检查这套保障是否真的能用。", "推迟上线：哲学家关系 +5、心情 -2。风险保障更充分，项目会承受延期压力。")

func _philosopher_limited_pilot() -> void:
	_remember("哲学家支线结局：小范围试行并人工复核")
	philosopher_ai_decision_done = true
	relationship_philosopher = clampi(relationship_philosopher + 3, 0, 100)
	player_mood = clampi(player_mood + 2, 0, 100)
	mindset_shift = "可以逐步验证产品价值，同时让受影响的人知道边界并能提出异议。"
	day_log.append("第2周周三：决定小范围试行 AI 产品，公开限制并保留人工复核；哲学家关系 +3、心情 +2。")
	day_log.append("心态转变：逐步验证产品价值，也要让人知道系统边界并能提出异议。")
	_finish_philosopher_launch("你提出先邀请少量用户试行，明确说明系统限制，并保留人工复核和退出渠道。合作方同意重新估算进度。哲学家说这不能保证没人受伤，但至少让误判更容易被发现和纠正。", "小范围试行：哲学家关系 +3、心情 +2。推进较慢，但能在扩大前观察误判并改进。")

func _finish_philosopher_launch(result_text: String, result_hint: String) -> void:
	weekly_cycle_stage = "week_two_wednesday_finished"
	_update_status()
	speaker_label.text = "哲学家 · 故事收束"
	dialogue_label.text = result_text
	hint_label.text = result_hint + " 这段经历已记入本周生活日志。"
	_clear_choices()
	if dancer_showcase_route_active and not dancer_showcase_callback_done:
		hint_label.text += " 你想起来，舞者说过她的社区活动要在这周举办。"
		_add_choice("继续到周四，听听舞者的演出回响", _advance_to_dancer_showcase_callback, 350.0)
	else:
		hint_label.text += " 大家约好周末一起回顾这两周的共同生活。"
		_add_choice("继续到周日合住复盘", _start_week_two_wrap_meeting, 350.0)

func _cycle_assign_chore(style: String) -> void:
	weekly_tasks_total = 1
	weekly_tasks_done = 0
	weekly_chore_done = false
	weekly_chore_resolved = false
	weekly_dinner_decided = false
	current_task = "打扫公共区域"
	_set_current_task(current_task, "周日之前")
	weekly_cycle_stage = "monday_evening"
	monday_completed = true
	day_log.append("第%d周周一生活例会：约定本周日之前完成公共卫生打扫。" % weekly_week)
	match style:
		"personal":
			relationship_chef = clampi(relationship_chef + 2, 0, 100)
			dialogue_label.text = "你说自己可以负责公共区域的清扫。大厨提醒大家把常用的清洁用品放回固定位置。"
		"rotate":
			spatial_harmony = clampi(spatial_harmony + 2, 0, 100)
			dialogue_label.text = "大家把公共区域分成几块，你负责客厅和餐桌。广告人把周日之前的期限写在便签上。"
		_:
			relationship_advertiser = clampi(relationship_advertiser + 2, 0, 100)
			dialogue_label.text = "你们约好周末前一起打扫，你负责最后检查公共区域。舞者说这样比较容易按各自的时间完成。"
	speaker_label.text = "周一 · 生活例会"
	hint_label.text = "右上角已记下待办：打扫公共区域，周日之前完成。周中不会新增待办。"
	_update_status()
	_clear_choices()
	_add_choice("回家后看看大厨泡的茶", _cycle_monday_evening, 350.0)

func _monday_kitchen_duty() -> void:
	monday_plan = "kitchen"
	if weekly_household_intro_active:
		weekly_tasks_total += 1
		weekly_efficiency_choices += 1
	_set_current_task("和大厨一起收拾厨房")
	spatial_harmony = clampi(spatial_harmony + 5, 0, 100)
	relationship_chef = clampi(relationship_chef + 5, 0, 100)
	player_extroversion = clampi(player_extroversion + 2, 0, 100)
	_remember("答应一起负责饭后厨房收拾")
	day_log.append("周一：答应一起负责饭后厨房收拾，空间和睦 +5，与大厨关系 +5、外向 +2。")
	speaker_label.text = "大厨"
	dialogue_label.text = "大厨笑了：“那我做饭，你饭后搭把手收台面。其他人轮流洗碗，谁有事也可以提前说。”大家把第一周的安排写了下来。"
	hint_label.text = "你和大厨先承担厨房的一小部分，其他人也分到了轮值任务。"
	_finish_monday_choice()

func _monday_small_tasks() -> void:
	monday_plan = "tasks"
	if weekly_household_intro_active:
		weekly_tasks_total += 1
		weekly_care_choices += 1
	_set_current_task("擦完公共餐桌")
	spatial_harmony = clampi(spatial_harmony + 8, 0, 100)
	relationship_philosopher = clampi(relationship_philosopher + 4, 0, 100)
	relationship_advertiser = clampi(relationship_advertiser + 3, 0, 100)
	_remember("和室友把家务拆成小任务")
	day_log.append("周一：把家务拆成小任务轮值，空间和睦 +8；与哲学家关系 +4、与广告人 +3。")
	speaker_label.text = "哲学家 · 广告人"
	dialogue_label.text = "你们把倒垃圾、擦桌面、整理客厅拆成几件小事，轮流写到便签上。哲学家说这样每个人都能看见自己的责任，广告人已经把表格画得五颜六色。"
	hint_label.text = "任务变得具体，也更容易互相提醒，而不是等某个人来收拾残局。"
	_finish_monday_choice()

func _monday_trial_week() -> void:
	monday_plan = "trial"
	if weekly_household_intro_active:
		weekly_tasks_total += 1
		weekly_care_choices += 1
	_set_current_task("记下今天的家务执行情况")
	spatial_harmony = clampi(spatial_harmony + 6, 0, 100)
	relationship_advertiser = clampi(relationship_advertiser + 4, 0, 100)
	relationship_dancer = clampi(relationship_dancer + 4, 0, 100)
	_remember("约好先试行一周再调整家务")
	day_log.append("周一：约好先试行一周再调整，空间和睦 +6；与广告人、舞者关系各 +4。")
	speaker_label.text = "广告人 · 舞者"
	dialogue_label.text = "广告人提议先随手记下谁做了什么，周末再看要不要改。舞者点头：“每个人的日程会变，能商量的安排才容易一直做下去。”"
	hint_label.text = "大家没有一次定死所有规矩，而是约好先一起试试看。"
	_finish_monday_choice()

func _finish_monday_choice() -> void:
	monday_completed = true
	_update_status()
	day_log.append("共同生活继续：周一的家务安排由大家一起商定。")
	dialogue_panel.position = Vector2(36, 285)
	dialogue_panel.size = Vector2(888, 230)
	dialogue_label.custom_minimum_size = Vector2(820, 75)
	_clear_choices()
	_add_choice("继续到周一晚饭后", _start_monday_evening, 260.0)
	_add_choice("查看更新后的生活日志", _show_weekend_log, 260.0)
	_add_choice("回到开始界面", _restart_evening, 260.0)

func _start_monday_evening() -> void:
	_set_scene("晚间地图", "周一   19:10")
	speaker_label.text = "周一 · 晚上"
	dialogue_label.text = "周一晚上，你回到家了。你选择："
	hint_label.text = "点击房间进入；也可以直接回房休息。"
	_clear_choices()
	_add_choice("太累了，先回房休息", _monday_evening_forget, 405.0)

func _enter_evening_room(room: String) -> void:
	var room_name := "厨房" if room == "kitchen" else "客厅" if room == "living_room" else "露台"
	_set_scene(room_name, time_text)
	speaker_label.text = room_name
	var task_room := "living_room" if monday_plan == "tasks" else "kitchen"
	if dance_rehearsal_active:
		task_room = "living_room"
	_clear_choices()
	if room == task_room:
		if dance_rehearsal_active:
			dialogue_label.text = "客厅里的茶几和椅子还没挪开。舞者已经把音乐和练习鞋放在一旁，留出空间就能开始排练。"
		elif makeup_task_active:
			dialogue_label.text = "你想起答应补做的事，厨房台面还留着需要收拾的痕迹。" if room == "kitchen" else "餐桌旁还放着那张家务清单，你答应补做的项目仍在那里。"
		elif room == "kitchen":
			if monday_plan == "trial":
				dialogue_label.text = "厨房的灯还亮着，冰箱边贴着一张记录纸，笔放在台面上。"
			else:
				dialogue_label.text = "厨房的灯还亮着，台面上放着一块干净的抹布。"
		else:
			dialogue_label.text = "客厅里安静下来，餐桌和冰箱边的便签还留在原处。"
		hint_label.text = "你可以在这里动手，也可以继续去别的地方。"
		_add_choice("动手处理", _evening_follow_selected, 260.0)
		_add_choice("继续去别处看看", _return_to_evening_map, 260.0)
		_add_choice("先回房休息", _evening_rest_selected, 260.0)
	else:
		dialogue_label.text = "你在%s转了一圈，屋里很安静。" % room_name
		hint_label.text = ""
		_add_choice("回到Loft平面图", _return_to_evening_map, 260.0)
		_add_choice("先回房休息", _evening_rest_selected, 260.0)

func _return_to_evening_map() -> void:
	_set_scene("晚间地图", time_text)
	speaker_label.text = "周三 · 晚上" if dance_rehearsal_active else "周二 · 晚上" if makeup_task_active else "周一 · 晚上"
	dialogue_label.text = "周三晚上，你回到家了。你选择：" if dance_rehearsal_active else "周二晚上，你回到家了。你选择：" if makeup_task_active else "周一晚上，你回到家了。你选择："
	hint_label.text = "右上角还记着你答应舞者的事；点击房间进入，也可以先休息。" if dance_rehearsal_active else "记得右上角的补做待办；点击房间进入，也可以先休息。" if makeup_task_active else "点击房间进入；也可以直接回房休息。"
	_clear_choices()
	_add_choice("太累了，先回房休息", _evening_rest_selected, 405.0)

func _evening_follow_selected() -> void:
	if dance_rehearsal_active:
		_complete_dancer_rehearsal()
	elif makeup_task_active:
		_tuesday_makeup_follow_plan()
	else:
		_monday_evening_follow_plan()

func _evening_rest_selected() -> void:
	if dance_rehearsal_active:
		_miss_dancer_rehearsal()
	elif makeup_task_active:
		_tuesday_makeup_missed()
	else:
		_monday_evening_forget()

func _monday_evening_follow_plan() -> void:
	_complete_current_task()
	if weekly_household_intro_active:
		weekly_tasks_done += 1
	spatial_harmony = clampi(spatial_harmony + 4, 0, 100)
	_remember("周一晚按约定完成家务")
	match monday_plan:
		"kitchen":
			relationship_chef = clampi(relationship_chef + 4, 0, 100)
			dialogue_label.text = "你把台面和碗收拾好。大厨已经泡上茶，递给你一杯：“说到做到的感觉真不错，明天也不用一个人对着满台碗发愁了。”"
			day_log.append("周一晚：按约定和大厨收拾厨房，空间和睦 +4，与大厨关系 +4。")
		"tasks":
			relationship_philosopher = clampi(relationship_philosopher + 3, 0, 100)
			relationship_advertiser = clampi(relationship_advertiser + 2, 0, 100)
			dialogue_label.text = "你擦完桌面，哲学家也正好倒完垃圾。广告人放下笔：“第一次轮值就成功，表格可以先不用画得更复杂了。”"
			day_log.append("周一晚：按小任务表完成分工，空间和睦 +4；哲学家关系 +3、广告人 +2。")
		"trial":
			relationship_advertiser = clampi(relationship_advertiser + 3, 0, 100)
			dialogue_label.text = "你完成了记录纸上的第一项。广告人把它打了个勾：“这周有例子可看了，周末我们就知道哪些安排顺手。”"
			day_log.append("周一晚：完成试行安排中的第一项，空间和睦 +4，与广告人关系 +3。")
	hint_label.text = "你履行了早上共同商定的安排。"
	_finish_monday_evening()

func _monday_evening_forget() -> void:
	monday_forgot_chore = true
	_set_scene("客厅", "周二   07:20")
	_expire_current_task()
	player_mood = clampi(player_mood + 4, 0, 100)
	spatial_harmony = clampi(spatial_harmony - 8, 0, 100)
	_remember("周一晚太累忘了履行家务约定")
	day_log.append("周一晚：工作太累，回房休息后忘了家务；心情 +4、空间和睦 -8。")
	match monday_plan:
		"kitchen":
			relationship_chef = clampi(relationship_chef - 5, 0, 100)
			speaker_label.text = "大厨"
			dialogue_label.text = "你本想躺十分钟，醒来时已经是第二天早上。台面和碗最后由大厨一个人收好了。他没有责备你，只说：“你累我理解，下次能不能先告诉我一声？”"
			day_log.append("与大厨关系 -5：他独自收拾了厨房，希望下次能提前沟通。")
		"tasks":
			relationship_philosopher = clampi(relationship_philosopher - 4, 0, 100)
			relationship_advertiser = clampi(relationship_advertiser - 2, 0, 100)
			speaker_label.text = "哲学家 · 广告人"
			dialogue_label.text = "你回房休息后忘了擦桌面，第二天早上才想起来。哲学家和广告人把它收拾好了。哲学家说：“大家能临时换班，但得先知道你没法完成。”广告人把这条写到便签上。"
			day_log.append("与哲学家关系 -4、与广告人 -2：室友补上了遗漏的任务。")
		"trial":
			relationship_advertiser = clampi(relationship_advertiser - 3, 0, 100)
			relationship_dancer = clampi(relationship_dancer - 2, 0, 100)
			speaker_label.text = "广告人 · 舞者"
			dialogue_label.text = "你太累了，回房后很快睡着，第二天早上才想起记录纸上的任务没做。舞者替你收拾了客厅。广告人说：“试行可以调整，不过最好留句话，大家就不用猜了。”"
			day_log.append("与广告人关系 -3、与舞者 -2：室友补上了遗漏的任务，希望临时有变时互相告知。")
	hint_label.text = "你得到了一些休息，但遗漏的家务让室友多做了一份。"
	_finish_monday_evening()

func _finish_monday_evening() -> void:
	monday_evening_completed = true
	_update_status()
	dialogue_panel.position = Vector2(36, 285)
	dialogue_panel.size = Vector2(888, 230)
	dialogue_label.custom_minimum_size = Vector2(820, 75)
	_clear_choices()
	if monday_forgot_chore:
		_add_choice("道歉，并约好今天补做", _monday_repair_missed_chore, 405.0)
		_add_choice("先不提这件事", _monday_avoid_missed_chore, 405.0)
	else:
		_add_choice("进入周二早晨", _start_tuesday_after_completed_chore, 260.0)
		_add_choice("查看更新后的生活日志", _show_weekend_log, 260.0)
		_add_choice("回到开始界面", _restart_evening, 260.0)

func _monday_repair_missed_chore() -> void:
	_note_task_makeup()
	spatial_harmony = clampi(spatial_harmony + 3, 0, 100)
	match monday_plan:
		"kitchen":
			relationship_chef = clampi(relationship_chef + 4, 0, 100)
		"tasks":
			relationship_philosopher = clampi(relationship_philosopher + 3, 0, 100)
			relationship_advertiser = clampi(relationship_advertiser + 2, 0, 100)
		"trial":
			relationship_advertiser = clampi(relationship_advertiser + 3, 0, 100)
			relationship_dancer = clampi(relationship_dancer + 2, 0, 100)
	_remember("周二早晨为漏做的家务道歉并约好补做")
	day_log.append("周二早晨：为漏做家务道歉并约好补做，空间和睦 +3，相关室友关系有所修复。")
	match monday_plan:
		"kitchen":
			speaker_label.text = "大厨"
			dialogue_label.text = "你向大厨道歉，说昨天工作太累，回家后就睡着了，也答应找时间把厨房补收拾好。他说：“下次提前告诉我就好。”气氛缓和了一些，但昨天的空缺没有被抹掉。"
		"tasks":
			speaker_label.text = "哲学家 · 广告人"
			dialogue_label.text = "你向哲学家和广告人道歉，说昨天工作太累，回家后就睡着了，也答应找时间把桌面补擦好。广告人点头：“留句话，我们就能换班。”"
		"trial":
			speaker_label.text = "广告人 · 舞者"
			dialogue_label.text = "你向广告人和舞者道歉，说昨天工作太累，回家后就睡着了，也答应之后把漏下的记录补上。舞者说：“试行可以调整，下次告诉我们就好。”"
	hint_label.text = "沟通修复了一部分关系；新的补做待办已经记在右上角，期限是周三之前。"
	_finish_tuesday_morning()

func _monday_avoid_missed_chore() -> void:
	spatial_harmony = clampi(spatial_harmony - 2, 0, 100)
	match monday_plan:
		"kitchen":
			relationship_chef = clampi(relationship_chef - 2, 0, 100)
		"tasks":
			relationship_philosopher = clampi(relationship_philosopher - 2, 0, 100)
		"trial":
			relationship_advertiser = clampi(relationship_advertiser - 2, 0, 100)
	day_log.append("周二早晨：没有回应漏做的家务，空间和睦 -2，相关室友关系 -2。")
	speaker_label.text = "周二 · 早餐"
	dialogue_label.text = "你没有提起昨晚的事，室友们也没有追问。早餐桌上的话题很快转开了，只是原本自然的气氛还没有完全回来。"
	hint_label.text = "没有解释，大家只能先把这件事放在心里。"
	_finish_tuesday_morning()

func _start_tuesday_after_completed_chore() -> void:
	_set_scene("厨房", "周二   07:30")
	match monday_plan:
		"kitchen":
			speaker_label.text = "周二 · 早餐"
			dialogue_label.text = "早上经过厨房，台面还是干净的。大厨一边烧水一边说：“昨天大家一起收拾，今天早上轻松多了。”新的一天开始了。"
			hint_label.text = "你按约完成了家务，室友们也感受到共同分担的变化。"
		"tasks":
			_set_scene("客厅", "周二   07:30")
			speaker_label.text = "周二 · 早餐"
			dialogue_label.text = "公共餐桌已经擦干净了。哲学家把清单折好放在冰箱边，广告人说：“具体写下来之后，谁负责什么一眼就能看见。”"
			hint_label.text = "你完成了自己的轮值任务，室友更容易按同一份清单分工。"
		"trial":
			_set_scene("客厅", "周二   07:30")
			speaker_label.text = "周二 · 早餐"
			dialogue_label.text = "广告人在记录纸上给昨天的家务打了勾。舞者说：“有了第一天的记录，周末调整起来就有依据了。”"
			hint_label.text = "你完成了试行安排中的记录，大家有了之后讨论的起点。"
	match monday_plan:
		"kitchen":
			day_log.append("周二早晨：共同分担的厨房保持整洁，室友注意到了这项安排。")
		"tasks":
			day_log.append("周二早晨：轮值清单上的公共餐桌任务已完成，室友开始沿用这套分工。")
		"trial":
			day_log.append("周二早晨：家务执行情况已记录，试行安排有了第一条反馈。")
	_clear_choices()
	_add_choice("查看更新后的生活日志", _show_weekend_log, 260.0)
	_add_choice("听舞者说起周三的排练", _dancer_rehearsal_invitation, 260.0)
	if weekly_household_intro_active:
		_add_choice("继续本周日常安排", _continue_after_monday_cycle, 260.0)
	_add_choice("回到开始界面", _restart_evening, 260.0)

func _finish_tuesday_morning() -> void:
	_set_scene("客厅", "周二   07:30")
	_update_status()
	_clear_choices()
	if makeup_task_active:
		_add_choice("周二晚上，回家后去补做", _start_tuesday_makeup_evening, 260.0)
	else:
		_add_choice("听舞者说起周三的排练", _dancer_rehearsal_invitation, 260.0)
		if weekly_household_intro_active:
			_add_choice("继续本周日常安排", _continue_after_monday_cycle, 260.0)
	_add_choice("查看更新后的生活日志", _show_weekend_log, 260.0)
	_add_choice("回到开始界面", _restart_evening, 260.0)

func _start_tuesday_makeup_evening() -> void:
	_set_scene("晚间地图", "周二   20:15")
	speaker_label.text = "周二 · 晚上"
	dialogue_label.text = "周二晚上，你回到家了。你选择："
	hint_label.text = "右上角还记着你答应补做的事。点击房间进入，也可以先休息。"
	_clear_choices()
	_add_choice("今天太累了，再休息一晚", _evening_rest_selected, 405.0)

func _tuesday_makeup_follow_plan() -> void:
	_complete_current_task("周二晚上")
	if weekly_household_intro_active:
		weekly_tasks_done += 1
	makeup_task_active = false
	spatial_harmony = clampi(spatial_harmony + 4, 0, 100)
	_remember("周二晚兑现补做家务的承诺")
	day_log.append("周二晚：兑现补做承诺，空间和睦 +4，相关室友关系得到进一步修复。")
	match monday_plan:
		"kitchen":
			relationship_chef = clampi(relationship_chef + 4, 0, 100)
			speaker_label.text = "大厨"
			dialogue_label.text = "你把厨房收拾好。大厨看了一眼，轻轻点头：“谢谢你记得这件事。昨天的确有点累，不过现在我们把它说开了。”"
		"tasks":
			relationship_philosopher = clampi(relationship_philosopher + 3, 0, 100)
			relationship_advertiser = clampi(relationship_advertiser + 2, 0, 100)
			speaker_label.text = "哲学家 · 广告人"
			dialogue_label.text = "你擦完公共餐桌。广告人把清单上的补做项勾掉，哲学家说：“承诺晚了一天，但还是被认真对待了。”"
		"trial":
			relationship_advertiser = clampi(relationship_advertiser + 3, 0, 100)
			relationship_dancer = clampi(relationship_dancer + 2, 0, 100)
			speaker_label.text = "广告人 · 舞者"
			dialogue_label.text = "你补上了记录纸上的家务记录。舞者说：“现在这周的记录完整了。”广告人把补做的一项也打了勾。"
	day_log.append("室友看到玩家兑现了承诺；相关关系有所回升。")
	hint_label.text = "补做完成。迟到没有被抹去，但你的承诺也没有落空。"
	_update_status()
	_finish_makeup_evening()

func _tuesday_makeup_missed() -> void:
	_expire_current_task()
	makeup_task_active = false
	spatial_harmony = clampi(spatial_harmony - 6, 0, 100)
	_remember("周二晚再次错过补做承诺")
	day_log.append("周二晚：再次错过补做承诺，空间和睦 -6，相关室友关系下降。")
	match monday_plan:
		"kitchen":
			relationship_chef = clampi(relationship_chef - 4, 0, 100)
			speaker_label.text = "大厨"
			dialogue_label.text = "你又把补做的事往后放了。大厨没有多说，只把台面重新收拾了一遍。"
		"tasks":
			relationship_philosopher = clampi(relationship_philosopher - 3, 0, 100)
			relationship_advertiser = clampi(relationship_advertiser - 2, 0, 100)
			speaker_label.text = "哲学家 · 广告人"
			dialogue_label.text = "你没有补擦餐桌。广告人把清单收起来，哲学家说：“这次我们需要重新商量，不能继续默认你会补上。”"
		"trial":
			relationship_advertiser = clampi(relationship_advertiser - 3, 0, 100)
			relationship_dancer = clampi(relationship_dancer - 2, 0, 100)
			speaker_label.text = "广告人 · 舞者"
			dialogue_label.text = "记录纸上的补做项仍然空着。舞者把笔收好，广告人说：“试行安排也得有个可信的记录才行。”"
	hint_label.text = "这一次的补做承诺也没有兑现，室友开始重新评估这份安排。"
	_update_status()
	_finish_makeup_evening()

func _finish_makeup_evening() -> void:
	dialogue_panel.position = Vector2(36, 285)
	dialogue_panel.size = Vector2(888, 230)
	dialogue_label.custom_minimum_size = Vector2(820, 75)
	_clear_choices()
	if not dancer_rehearsal_invited:
		_add_choice("听舞者说起周三的排练", _dancer_rehearsal_invitation, 260.0)
	if weekly_household_intro_active and not makeup_task_active and not dance_rehearsal_active:
		_add_choice("继续本周日常安排", _continue_after_monday_cycle, 260.0)
	_add_choice("查看更新后的生活日志", _show_weekend_log, 260.0)
	_add_choice("回到开始界面", _restart_evening, 260.0)

func _dancer_rehearsal_invitation() -> void:
	dancer_rehearsal_invited = true
	_set_scene("客厅", "周二   08:05")
	speaker_label.text = "舞者"
	dialogue_label.text = "吃早餐时，舞者提到：“明晚我想在客厅排一段新舞，但得先把茶几和椅子挪开。你下班回来时，能帮我一起腾出地方吗？”"
	hint_label.text = "她没有催你，只是在确认你是否愿意把这件事排进明天的安排。"
	_clear_choices()
	_add_choice("好，明晚我回来后帮你整理客厅。", _promise_dancer_rehearsal, 405.0)
	_add_choice("明天不太确定，先不答应。", _decline_dancer_rehearsal, 405.0)

func _promise_dancer_rehearsal() -> void:
	dance_rehearsal_active = true
	if weekly_household_intro_active:
		weekly_tasks_total += 1
	_set_current_task("和舞者一起腾出客厅排练空间", "周三晚上")
	relationship_dancer = clampi(relationship_dancer + 3, 0, 100)
	_remember("答应周三帮舞者准备客厅排练空间")
	day_log.append("周二：答应周三晚帮舞者整理客厅供排练，舞者关系 +3。")
	speaker_label.text = "舞者"
	dialogue_label.text = "舞者松了口气：“太好了，我下班后回来就开始。你到了以后，我们一起挪，不用你一个人弄。”"
	hint_label.text = "待办已记在右上角。明晚回家后，舞者不会再提醒你；你需要自己记得这项约定。"
	_update_status()
	_clear_choices()
	_add_choice("进入周三晚上", _start_wednesday_rehearsal, 260.0)
	_add_choice("查看更新后的生活日志", _show_weekend_log, 260.0)
	_add_choice("回到开始界面", _restart_evening, 260.0)

func _decline_dancer_rehearsal() -> void:
	dialogue_label.text = "你说周三的安排还不确定，不想先答应下来。舞者点点头：“没关系，我再想想怎么挪。”"
	hint_label.text = "你没有接下这项安排，也避免了留下做不到的承诺。"
	day_log.append("周二：没有答应帮舞者布置排练空间，避免形成未确认的约定。")
	_clear_choices()
	_add_choice("查看更新后的生活日志", _show_weekend_log, 260.0)
	if weekly_household_intro_active:
		_add_choice("继续本周日常安排", _continue_after_monday_cycle, 260.0)
	_add_choice("回到开始界面", _restart_evening, 260.0)

func _start_wednesday_rehearsal() -> void:
	_set_scene("晚间地图", "周三   19:30")
	speaker_label.text = "周三 · 晚上"
	dialogue_label.text = "周三晚上，你回到家了。你选择："
	hint_label.text = "右上角还记着答应舞者的事。点击房间进入；也可以先回房休息。"
	_clear_choices()
	_add_choice("今天太累了，先休息。", _evening_rest_selected, 405.0)

func _complete_dancer_rehearsal() -> void:
	_complete_current_task("周三晚上")
	if weekly_household_intro_active:
		weekly_tasks_done += 1
	dance_rehearsal_active = false
	dancer_rehearsal_resolved = true
	spatial_harmony = clampi(spatial_harmony + 4, 0, 100)
	relationship_dancer = clampi(relationship_dancer + 5, 0, 100)
	player_extroversion = clampi(player_extroversion + 2, 0, 100)
	_remember("和舞者一起整理客厅并看她排练")
	day_log.append("周三晚：和舞者一起腾出排练空间，空间和睦 +4、舞者关系 +5、外向 +2。")
	speaker_label.text = "舞者"
	dialogue_label.text = "你和舞者把茶几推到墙边，再把椅子摆好。音乐响起后，她跳了一小段新编舞，最后笑着说：“有人一起把空间准备好，感觉完全不一样。”"
	hint_label.text = "客厅重新变成大家可以共享的空间，也成了你和舞者的一段共同记忆。"
	_update_status()
	_finish_makeup_evening()

func _miss_dancer_rehearsal() -> void:
	_expire_current_task()
	dance_rehearsal_active = false
	dancer_rehearsal_resolved = true
	spatial_harmony = clampi(spatial_harmony - 5, 0, 100)
	relationship_dancer = clampi(relationship_dancer - 5, 0, 100)
	_remember("周三晚没能帮舞者准备排练空间")
	day_log.append("周三晚：没有回客厅帮忙准备排练，空间和睦 -5、舞者关系 -5。")
	speaker_label.text = "舞者"
	dialogue_label.text = "你回房休息后，舞者自己把家具挪开了。客厅的音乐声响了一会儿，很快又停下来。第二天，她只说：“昨晚我自己弄好了。”"
	hint_label.text = "你确实需要休息，但没有提前告诉舞者，让她独自完成了准备。"
	_update_status()
	_finish_makeup_evening()

func _increase_roommate_relationship(roommate: String, amount: int) -> void:
	match roommate:
		"大厨":
			relationship_chef = clampi(relationship_chef + amount, 0, 100)
		"广告人":
			relationship_advertiser = clampi(relationship_advertiser + amount, 0, 100)
		"舞者":
			relationship_dancer = clampi(relationship_dancer + amount, 0, 100)
		"哲学家":
			relationship_philosopher = clampi(relationship_philosopher + amount, 0, 100)

func _closest_roommate() -> Dictionary:
	var closest := {"name": "大厨", "score": relationship_chef}
	if relationship_advertiser > closest["score"]:
		closest = {"name": "广告人", "score": relationship_advertiser}
	if relationship_dancer > closest["score"]:
		closest = {"name": "舞者", "score": relationship_dancer}
	if relationship_philosopher > closest["score"]:
		closest = {"name": "哲学家", "score": relationship_philosopher}
	return closest

func _restart_evening() -> void:
	_reset_run()
	_show_start_menu()

func _reset_run() -> void:
	player_mood = 35
	relationship_chef = 50
	relationship_advertiser = 50
	relationship_dancer = 50
	relationship_philosopher = 50
	relationship_chef_dancer = 50
	week_one_room_conflict_outcome = ""
	dancer_peanut_memory = false
	dancer_peanut_dish_served = false
	dancer_showcase_route_active = false
	dancer_showcase_intro_done = false
	dancer_showcase_choice = ""
	dancer_showcase_callback_done = false
	week_two_review_result = ""
	week_two_review_hint = ""
	philosopher_ai_route_active = false
	philosopher_ai_decision_done = false
	philosopher_sunday_followup_done = false
	philosopher_ai_opening_stance = ""
	philosopher_sunday_response = ""
	spatial_harmony = 50
	player_extroversion = 50
	work_reputation = 50
	work_task = ""
	work_task_active = false
	work_task_done = false
	work_choice = ""
	joined_dinner_plan = false
	declined_dinner_plan = false
	sunday_completed = false
	sunday_shared_plan = false
	monday_completed = false
	monday_evening_completed = false
	monday_forgot_chore = false
	makeup_task_active = false
	dance_rehearsal_active = false
	dancer_rehearsal_invited = false
	dancer_rehearsal_resolved = false
	weekly_cycle_active = false
	weekly_story_week = false
	weekly_household_intro_active = false
	weekly_intro_tallied = false
	weekly_story_stage = ""
	weekly_meeting_open = false
	weekly_week = 1
	weekly_day = 0
	weekly_harmony_start = 50
	weekly_pending_harmony = 0
	weekly_tasks_total = 0
	weekly_tasks_done = 0
	weekly_efficiency_choices = 0
	weekly_care_choices = 0
	consecutive_low_weeks = 0
	weekly_challenge_active = false
	weekly_last_task_completed = false
	weekly_chore_done = false
	weekly_chore_resolved = false
	weekly_previous_chore_done = false
	weekly_tuesday_memory_tag = ""
	weekly_tuesday_roommate = ""
	weekly_cycle_stage = ""
	weekly_dinner_decided = false
	weekly_log_start_index = 0
	weekly_meeting_dialogue = ""
	weekly_meeting_hint = ""
	monday_plan = ""
	current_task = ""
	current_task_active = false
	task_name_label.text = ""
	task_deadline_label.text = ""
	work_task_name_label.text = "— 暂无工作待办"
	work_task_deadline_label.text = ""
	task_panel.visible = false
	visited_activities.clear()
	weekend_memories.clear()
	day_log.clear()
	mindset_shift = ""
	cooking_minigame_active = false
	cooking_phase = 0.0
	cooking_direction = 1.0
	cooking_hits = 0
	cooking_attempts = 0
	cooking_row.visible = false
	dialogue_panel.position = Vector2(36, 365)
	dialogue_panel.size = Vector2(888, 148)
	dialogue_label.custom_minimum_size = Vector2(820, 42)
	dialogue_label.add_theme_font_size_override("font_size", 19)
	_update_status()

func _add_choice(text: String, action: Callable, button_width: float = 405.0) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(button_width, 34)
	button.add_theme_font_size_override("font_size", 15)
	button.add_theme_color_override("font_color", INK)
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("#f1dfc7")
	normal.set_corner_radius_all(8)
	normal.content_margin_left = 12
	normal.content_margin_right = 12
	button.add_theme_stylebox_override("normal", normal)
	button.pressed.connect(action)
	choice_row.add_child(button)
	choice_buttons.append(button)

func _clear_choices() -> void:
	for button in choice_buttons:
		button.queue_free()
	choice_buttons.clear()

func _draw() -> void:
	match place:
		"Loft地图":
			_draw_loft_map()
		"晚间地图":
			_draw_evening_map()
		"客厅":
			_draw_living_room()
		"露台":
			_draw_balcony()
		"饭厅":
			_draw_dining_room()
		_:
			_draw_kitchen()
	if place not in ["Loft地图", "晚间地图"]:
		draw_string(ThemeDB.fallback_font, Vector2(64, 300), place, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("#fff0d4"))

func _input(event: InputEvent) -> void:
	if place == "晚间地图":
		if not (event is InputEventMouseButton):
			return
		var chore_click := event as InputEventMouseButton
		if chore_click.button_index != MOUSE_BUTTON_LEFT or not chore_click.pressed:
			return
		var chore_position := chore_click.position
		if Rect2(65, 100, 280, 210).has_point(chore_position):
			_enter_evening_room("kitchen")
		elif Rect2(365, 100, 280, 210).has_point(chore_position):
			_enter_evening_room("living_room")
		elif Rect2(665, 100, 230, 210).has_point(chore_position):
			_enter_evening_room("balcony")
		return
	if place != "Loft地图":
		return
	if not (event is InputEventMouseButton):
		return
	var mouse_event := event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return
	var click_position := mouse_event.position
	if Rect2(65, 100, 280, 210).has_point(click_position) and not visited_activities.has("chef"):
		_activity_chef()
	elif Rect2(365, 100, 280, 210).has_point(click_position) and not visited_activities.has("living_room"):
		_activity_living_room()
	elif Rect2(665, 100, 230, 210).has_point(click_position) and not visited_activities.has("philosopher"):
		_activity_philosopher()

func _draw_loft_map() -> void:
	draw_rect(Rect2(0, 0, 960, 540), Color("#493e55"))
	draw_rect(Rect2(0, 0, 960, 540), Color("#302c3b"))
	# 简化的平面图：三个可选房间与连接它们的走廊。
	draw_rect(Rect2(50, 85, 860, 250), Color("#d7b992"))
	_draw_map_room(Rect2(65, 100, 280, 210), "chef", Color("#e6c99f"))
	_draw_map_room(Rect2(365, 100, 280, 210), "living_room", Color("#d9c9a9"))
	_draw_map_room(Rect2(665, 100, 230, 210), "philosopher", Color("#6e7281"))
	# 厨房台面和灶台
	draw_rect(Rect2(90, 145, 95, 22), Color("#9c705c"))
	draw_rect(Rect2(95, 178, 62, 45), Color("#c58e6d"))
	draw_circle(Vector2(115, 196), 7, Color("#634d4c"))
	draw_circle(Vector2(137, 196), 7, Color("#634d4c"))
	# 客厅沙发和茶几
	draw_rect(Rect2(405, 145, 195, 65), Color("#687a72"))
	draw_rect(Rect2(435, 230, 135, 32), Color("#9b755c"))
	# 露台栏杆与绿植
	draw_rect(Rect2(690, 145, 180, 8), Color("#f0d0a0"))
	for x in [705, 750, 795, 840]:
		draw_rect(Rect2(x, 148, 5, 45), Color("#f0d0a0"))
	draw_circle(Vector2(718, 238), 23, Color("#557262"))
	draw_circle(Vector2(846, 238), 25, Color("#557262"))
	draw_string(ThemeDB.fallback_font, Vector2(92, 292), _map_room_label("chef", "厨房 · 大厨"), HORIZONTAL_ALIGNMENT_LEFT, -1, 18, INK)
	draw_string(ThemeDB.fallback_font, Vector2(392, 292), _map_room_label("living_room", "客厅 · 广告人／舞者"), HORIZONTAL_ALIGNMENT_LEFT, -1, 18, INK)
	draw_string(ThemeDB.fallback_font, Vector2(692, 292), _map_room_label("philosopher", "露台 · 哲学家"), HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("#fff4df"))

func _draw_evening_map() -> void:
	draw_rect(Rect2(0, 0, 960, 540), Color("#302c3b"))
	draw_rect(Rect2(50, 85, 860, 250), Color("#d7b992"))
	draw_rect(Rect2(65, 100, 280, 210), Color("#e6c99f"))
	draw_rect(Rect2(365, 100, 280, 210), Color("#d9c9a9"))
	draw_rect(Rect2(665, 100, 230, 210), Color("#6e7281"))
	for rect in [Rect2(65, 100, 280, 210), Rect2(365, 100, 280, 210), Rect2(665, 100, 230, 210)]:
		draw_rect(rect, Color("#f0bf6e"), false, 4)
	draw_rect(Rect2(90, 145, 95, 22), Color("#9c705c"))
	draw_rect(Rect2(95, 178, 62, 45), Color("#c58e6d"))
	draw_rect(Rect2(405, 145, 195, 65), Color("#687a72"))
	draw_rect(Rect2(435, 230, 135, 32), Color("#9b755c"))
	draw_rect(Rect2(690, 145, 180, 8), Color("#f0d0a0"))
	for x in [705, 750, 795, 840]:
		draw_rect(Rect2(x, 148, 5, 45), Color("#f0d0a0"))
	draw_string(ThemeDB.fallback_font, Vector2(92, 292), "厨房", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, INK)
	draw_string(ThemeDB.fallback_font, Vector2(392, 292), "客厅", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, INK)
	draw_string(ThemeDB.fallback_font, Vector2(692, 292), "露台", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("#fff4df"))

func _draw_map_room(room: Rect2, activity: String, fill: Color) -> void:
	var room_fill := fill
	var border := Color("#f0bf6e")
	if visited_activities.has(activity):
		room_fill = fill.darkened(0.42)
		border = Color("#7d8b7b")
	draw_rect(room, room_fill)
	draw_rect(room, border, false, 4)

func _map_room_label(activity: String, label: String) -> String:
	if visited_activities.has(activity):
		return label + " · 已去过"
	return label

func _draw_kitchen() -> void:
	draw_rect(Rect2(0, 0, 960, 540), Color("#594550"))
	draw_rect(Rect2(0, 0, 960, 330), Color("#c98f76"))
	draw_rect(Rect2(0, 330, 960, 210), Color("#9b6956"))
	draw_rect(Rect2(620, 68, 260, 184), Color("#41445f"))
	draw_rect(Rect2(632, 80, 236, 160), Color("#555573"))
	for p in [Vector2(665, 112), Vector2(735, 93), Vector2(818, 135), Vector2(784, 186), Vector2(690, 207)]:
		draw_circle(p, 2.5, Color("#ffe2a0"))
	draw_rect(Rect2(744, 80, 10, 160), Color("#d39b7a"))
	draw_rect(Rect2(632, 155, 236, 8), Color("#d39b7a"))
	draw_rect(Rect2(0, 235, 570, 105), Color("#d8aa7b"))
	for x in [20, 155, 290, 425]:
		draw_rect(Rect2(x, 250, 120, 78), Color("#edc99c"))
		draw_line(Vector2(x + 60, 258), Vector2(x + 60, 320), Color("#c48c68"), 2)
		draw_circle(Vector2(x + 106, 288), 3, Color("#9b6658"))
	draw_rect(Rect2(0, 335, 590, 20), Color("#71514c"))
	draw_rect(Rect2(35, 355, 520, 8), Color("#593f40"))
	draw_line(Vector2(275, 0), Vector2(275, 88), Color("#594550"), 4)
	draw_colored_polygon(PackedVector2Array([Vector2(228, 95), Vector2(322, 95), Vector2(302, 125), Vector2(248, 125)]), Color("#f6c878"))
	draw_circle(Vector2(275, 180), 72, Color(1.0, 0.75, 0.43, 0.10))
	draw_colored_polygon(PackedVector2Array([Vector2(365, 309), Vector2(382, 276), Vector2(436, 276), Vector2(451, 309)]), Color("#7b5251"))
	draw_circle(Vector2(408, 305), 25, Color("#9b6860"))
	draw_arc(Vector2(408, 278), 11, PI, TAU, 24, Color("#f5dfbd"), 3)
	draw_arc(Vector2(399, 263), 10, PI, TAU, 24, Color("#f5dfbd"), 2)
	draw_line(Vector2(432, 296), Vector2(449, 289), Color("#7b5251"), 5)
	_draw_person(Vector2(210, 258), Color("#638276"), Color("#e7b891"), true)
	_draw_person(Vector2(500, 263), Color("#72728c"), Color("#e8bd9d"), false)
	draw_rect(Rect2(385, 325, 155, 10), Color("#8a5e4b"))
	draw_rect(Rect2(398, 335, 8, 25), Color("#704a43"))
	draw_rect(Rect2(520, 335, 8, 25), Color("#704a43"))
	draw_rect(Rect2(414, 312, 18, 12), Color("#f4e3c8"))
	draw_arc(Vector2(432, 318), 6, -PI/2, PI/2, 16, Color("#f4e3c8"), 2)

func _draw_living_room() -> void:
	draw_rect(Rect2(0, 0, 960, 540), Color("#493e55"))
	draw_rect(Rect2(0, 0, 960, 332), Color("#a87977"))
	draw_rect(Rect2(0, 332, 960, 208), Color("#76564f"))
	draw_rect(Rect2(90, 70, 250, 165), Color("#41445f"))
	draw_rect(Rect2(102, 82, 226, 141), Color("#59617a"))
	draw_line(Vector2(215, 82), Vector2(215, 223), Color("#d5a17e"), 7)
	draw_line(Vector2(102, 154), Vector2(328, 154), Color("#d5a17e"), 7)
	# 沙发、抱枕与落地灯
	draw_rect(Rect2(160, 260, 450, 95), Color("#687a72"))
	draw_rect(Rect2(135, 292, 45, 80), Color("#52665f"))
	draw_rect(Rect2(590, 292, 45, 80), Color("#52665f"))
	draw_rect(Rect2(235, 270, 72, 48), Color("#d7a67f"))
	draw_rect(Rect2(505, 270, 72, 48), Color("#d7a67f"))
	draw_line(Vector2(790, 95), Vector2(790, 317), Color("#503f49"), 5)
	draw_colored_polygon(PackedVector2Array([Vector2(750, 100), Vector2(830, 100), Vector2(815, 133), Vector2(765, 133)]), Color("#f4ce91"))
	_draw_person(Vector2(190, 252), Color("#638276"), Color("#e7b891"), true)
	_draw_person(Vector2(355, 253), Color("#bd786b"), Color("#e8bd9d"), false)
	_draw_person(Vector2(520, 253), Color("#c29a62"), Color("#e8bd9d"), false)
	_draw_person(Vector2(685, 253), Color("#567b83"), Color("#e8bd9d"), false)
	_draw_person(Vector2(850, 255), Color("#72728c"), Color("#e8bd9d"), false)

func _draw_balcony() -> void:
	draw_rect(Rect2(0, 0, 960, 540), Color("#30394f"))
	draw_rect(Rect2(0, 0, 960, 342), Color("#41445f"))
	for p in [Vector2(100, 90), Vector2(205, 165), Vector2(325, 73), Vector2(460, 132), Vector2(610, 82), Vector2(805, 154), Vector2(880, 70), Vector2(720, 220)]:
		draw_circle(p, 2.5, Color("#ffe2a0"))
	draw_rect(Rect2(0, 342, 960, 198), Color("#76564f"))
	# 露台栏杆与几盆植物
	draw_rect(Rect2(0, 295, 960, 10), Color("#d39b7a"))
	for x in [60, 235, 410, 585, 760, 935]:
		draw_rect(Rect2(x, 300, 7, 75), Color("#d39b7a"))
	draw_rect(Rect2(72, 355, 58, 26), Color("#9b6956"))
	draw_circle(Vector2(100, 337), 28, Color("#557262"))
	draw_rect(Rect2(829, 355, 58, 26), Color("#9b6956"))
	draw_circle(Vector2(858, 338), 31, Color("#557262"))
	_draw_person(Vector2(390, 260), Color("#638276"), Color("#e7b891"), true)
	_draw_person(Vector2(555, 263), Color("#72728c"), Color("#e8bd9d"), false)

func _draw_dining_room() -> void:
	draw_rect(Rect2(0, 0, 960, 540), Color("#493e55"))
	draw_rect(Rect2(0, 0, 960, 342), Color("#b98572"))
	draw_rect(Rect2(0, 342, 960, 198), Color("#76564f"))
	draw_rect(Rect2(105, 68, 210, 140), Color("#41445f"))
	draw_rect(Rect2(117, 80, 186, 116), Color("#59617a"))
	draw_line(Vector2(210, 80), Vector2(210, 196), Color("#d5a17e"), 6)
	draw_line(Vector2(117, 138), Vector2(303, 138), Color("#d5a17e"), 6)
	# 灯光、室友和摆满菜肴的长桌
	draw_line(Vector2(480, 0), Vector2(480, 70), Color("#594550"), 4)
	draw_colored_polygon(PackedVector2Array([Vector2(435, 76), Vector2(525, 76), Vector2(508, 105), Vector2(452, 105)]), Color("#f6c878"))
	for x in [140, 310, 480, 650, 820]:
		draw_circle(Vector2(x, 270), 27, Color("#8b6157"))
	_draw_person(Vector2(140, 195), Color("#638276"), Color("#e7b891"), true)
	_draw_person(Vector2(310, 195), Color("#bd786b"), Color("#e8bd9d"), false)
	_draw_person(Vector2(480, 195), Color("#c29a62"), Color("#e8bd9d"), false)
	_draw_person(Vector2(650, 195), Color("#567b83"), Color("#e8bd9d"), false)
	_draw_person(Vector2(820, 195), Color("#72728c"), Color("#e8bd9d"), false)
	draw_rect(Rect2(75, 270, 810, 28), Color("#815b4d"))
	draw_rect(Rect2(110, 298, 20, 75), Color("#65473f"))
	draw_rect(Rect2(830, 298, 20, 75), Color("#65473f"))
	for x in [210, 380, 550, 720]:
		draw_circle(Vector2(x, 264), 15, Color("#f1dfc7"))
		draw_circle(Vector2(x, 264), 8, Color("#bf8064"))

func _draw_person(center: Vector2, clothes: Color, skin: Color, apron: bool) -> void:
	draw_line(center + Vector2(-10, 54), center + Vector2(-12, 84), Color("#55434b"), 8)
	draw_line(center + Vector2(10, 54), center + Vector2(12, 84), Color("#55434b"), 8)
	draw_rect(Rect2(center.x - 24, center.y + 4, 48, 57), clothes)
	if apron:
		draw_colored_polygon(PackedVector2Array([center + Vector2(-15, 18), center + Vector2(15, 18), center + Vector2(12, 55), center + Vector2(-12, 55)]), Color("#f0d4b2"))
	draw_circle(center + Vector2(0, -12), 25, skin)
	draw_arc(center + Vector2(0, -15), 25, PI, TAU + 0.2, 32, Color("#574044"), 12)
	draw_circle(center + Vector2(-8, -12), 2, INK)
	draw_circle(center + Vector2(8, -12), 2, INK)
	draw_arc(center + Vector2(0, -5), 6, 0.15, PI - 0.15, 16, Color("#a65c57"), 2)
