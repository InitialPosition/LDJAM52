audio_stop_all()

if room == rm_hospital2 or room == rm_hospital3 {
	if !audio_is_playing(mus_level) {
		audio_play_sound(mus_level, 1, 1);
	}
}

if room == rm_mainMenu {
	if !audio_is_playing(mus_theme) {
		audio_play_sound(mus_theme, 1, 1);
	}
}
