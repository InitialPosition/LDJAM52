function scr_harvest_action_init() {
	harvest_duration = 60 * 3;			// 60 * X frames where X is the number of seconds
	harvest_target = noone;
	animation_interval = round(harvest_duration / 14);
	
	alarm[0] = harvest_duration;
}

function scr_harvest_action_update() {
	// cancel if player lets go of interact
	if !obj_player.interact_held {
		
		with obj_player {
			draw_disabled = false;
		}
		
		instance_destroy();
	}
}

function scr_harvest_set_bed_target(_harvest_action, _bed) {
	_harvest_action.harvest_target = _bed;
}

function scr_harvest_action_finish() {
	with harvest_target {
		scr_bed_harvest();
	}
	
	with obj_player {
		draw_disabled = false;
	}
	
	if audio_is_playing(snd_harvest) {
	audio_stop_sound(snd_harvest)
}

audio_play_sound(snd_harvest, 1, 0)
	
	instance_destroy();
}

function scr_harvest_action_draw() {
	draw_sprite(spr_harvest_bar, round((harvest_duration - alarm[0]) / animation_interval), x - 26, y + 16);
}
