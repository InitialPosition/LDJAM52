function scr_gui_draw_gui() {
	draw_sprite_ext(spr_blood_bar, 20 - round(obj_game_manager.blood_level), 32, 630, 2, 2, 0, c_white, 1);
	draw_sprite_ext(spr_sprint_bar, 20 - round(obj_game_manager.sprint_energy), 32, 662, 2, 2, 0, c_white, 1);
	
	if !obj_game_manager.can_sprint {
		draw_sprite_ext(spr_sprint_bar_disable, 0, 32, 662, 2, 2, 0, c_white, 1);
	}
	
	draw_sprite_ext(spr_clock, 0, 512, 630, 2, 2, 0, c_white, 1);
	
	draw_set_font(fnt_text);
	draw_text(560, 635, obj_game_manager.hr_str + ":" + obj_game_manager.mn_str);
	draw_text(560, 666, "SURVIVE UNTIL 12");
}
