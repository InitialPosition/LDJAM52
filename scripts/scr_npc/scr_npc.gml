function scr_npc_init() {
	current_path = path_add();
	
	current_target = noone;
	idle_target = instance_create_layer(x, y + 16, "Targets", obj_npc_target_idle);

	worker_speed = random_range(0.7, 0.9);
	
	work_timer_min = 60;
	work_timer_max = 240;
	alarm[0] = irandom_range(work_timer_min, work_timer_max);
	
	xprev = x;
	yprev = y;
	
	sprite_index = spr_nurse_idle;
}

function scr_npc_update() {
	scr_npc_update_sprite();
}

function scr_npc_update_sprite() {
	// update sprite based on position
	var _xx = x;
	var _yy = y;
	
	var _left = false;
	var _right = false;
	var _up = false;
	var _down = false;
	
	if _xx > xprev {
		// moving right
		_right = true;
	}
	if _xx < xprev {
		// moving left
		_left = true;
	}
	if _yy > yprev {
		// moving down
		_down = true;
	}
	if _yy < yprev {
		// moving up
		_up = true;
	}
	
	if _down {
		sprite_index = spr_nurse_down_walk;
	}
	else if _up {
		sprite_index = spr_nurse_up_walk;
	}
	else if _left {
		sprite_index = spr_nurse_left_walk;
	}
	else if _right {
		sprite_index = spr_nurse_right_walk;
	}
	else {
		sprite_index = spr_nurse_work;
	}
	
	// override if sees player
	if scr_npc_check_player_visible() {
		if sprite_index == spr_nurse_left_walk {
			if obj_player.x < x {
				sprite_index = spr_nurse_suspicious;
			}
		}
		if sprite_index == spr_nurse_right_walk {
			if obj_player.x > x {
				sprite_index = spr_nurse_suspicious;
			}
		}
		if sprite_index == spr_nurse_up_walk {
			if obj_player.y < y {
				sprite_index = spr_nurse_suspicious;
			}
		}
		if sprite_index == spr_nurse_down_walk {
			if obj_player.y > y {
				sprite_index = spr_nurse_suspicious;
			}
		}
		if sprite_index == spr_nurse_suspicious {
			if instance_exists(obj_harvest_action) {
				if !audio_is_playing(snd_scream) {
					audio_play_sound(snd_scream, 1, 0)
				}
				sprite_index = spr_nurse_shocked;
				if alarm[1] == -1 {
					alarm[1] = 30;
				}
			}
		}
	}
	
	xprev = x;
	yprev = y;
}

function scr_npc_pick_next_target() {
	var _new_target = scr_target_find_next_target();
	
	// if there is currently no free target available, cancel
	if _new_target == noone {
		_new_target = idle_target;
	}
	
	// set selected target to occupied
	_new_target.is_queued = true;
	current_target = _new_target;
	
	// otherwise, start moving to the new target
	scr_pathfinding_get_path(self, _new_target);
	path_shift(current_path, -8, -8);
	
	// immediately finish if already at final position
	if path_get_length(current_path) == 0 {
		scr_npc_work_on_target();
	}
	
	path_start(current_path, worker_speed, path_action_stop, true);
}

function scr_npc_work_on_target() {
	// remove finished target from system
	
	xprev = x;
	yprev = y;
	
	if current_target != idle_target {
		with current_target {
			if destroy_on_finish {
				instance_destroy();
			} else {
				is_queued = false;
			}
		}
		
		if distance_to_object(instance_nearest(x, y, obj_bed)) < 32 {
			with instance_nearest(x, y, obj_bed) {
				scr_bed_reset();
			}
		}
		
		sprite_index = spr_nurse_down_walk;
	}
	current_target = noone;
	
	// set new timer to work on next target
	alarm[0] = irandom_range(work_timer_min, work_timer_max);
}

function scr_npc_check_player_visible() {
	if distance_to_object(obj_player) > 140 {
		return false;
	}
	
	if collision_line(x + 8, y + 8, obj_player.x + 8, obj_player.y + 8, obj_wall, true, true) {
		return false;
	}
	return true;
}

function scr_npc_check_player_still_suspicious() {
	if scr_npc_check_player_visible() and instance_exists(obj_harvest_action) {
		if sprite_index == spr_nurse_shocked or sprite_index == spr_nurse_suspicious {
			room_goto(rm_gameover)
		}
	}
}
