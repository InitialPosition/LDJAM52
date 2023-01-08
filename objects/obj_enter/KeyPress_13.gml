/// @description 





if alarm[0] == -1 {
	audio_stop_all()
	audio_play_sound(snd_gamestart, 1, 0)
	alarm[0] = 60
}