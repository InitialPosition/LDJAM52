scr_harvest_action_init();

if audio_is_playing(snd_harvest2) {
	audio_stop_sound(snd_harvest2)
}

audio_play_sound(snd_harvest2, 1, 0)