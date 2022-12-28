SUBSYSTEM_DEF(html_audio)
	name = "HTML Audio"
	init_order = INIT_ORDER_HTMLAUDIO
	flags = SS_NO_FIRE
	var/max_channels = 128 // set this to how many total channels you want
	var/list/channel_assignment = list() // list([atom in the world] = 1, [atom in the world] = 2, etc.) for keeping track of what channels are in use and by what
	var/list/listeners = list() // list of listeners to update when audio gets added
	var/list/active_urls = list() // list("url_here", ...), ref'd by active_urls[channel_id]
	var/browse_txt

/datum/controller/subsystem/html_audio/Initialize()
	// TODO: rewrite this shit lmfao
	browse_txt = {"
			<META http-equiv="X-UA-Compatible" content="IE=edge">"}
	for(var/i in 1 to max_channels)
		browse_txt += {"
			<audio id="channel_[i]" volume="0">
				<source type="audio/mpeg"/>
			</audio>"}
	browse_txt += {"
			<script>
			function setVolume(volume, element_id)
			{
				var audio_player = document.getElementById(element_id);
				audio_player.volume = parseFloat(volume);
			}
			function playAudio(url, element_id)
			{
				console.log(url)
				var audio_player = document.getElementById(element_id);
				audio_player.pause();
				audio_player.src = url;
				audio_player.load();
				audio_player.play();
			}
			</script>
	"}
	return SS_INIT_SUCCESS

/datum/controller/subsystem/html_audio/proc/register_listener(atom/movable/listener)
	listeners += listener
	INVOKE_ASYNC(src, PROC_REF(jank_ass_browse_check), listener) // per MSO this gotta be async
	RegisterSignal(listener, COMSIG_MOVABLE_MOVED, PROC_REF(handle_listener_move)) // calls update_listener_volume
	RegisterSignal(listener, COMSIG_PARENT_QDELETING, PROC_REF(unregister_listener))

/datum/controller/subsystem/html_audio/proc/update_listener_volume(atom/movable/listener)
	for(var/channel_id in channel_assignment)
		var/atom/channel_atom = channel_assignment[channel_id]
		// TODO: check if dist > 14 tiles, if so set volume on channel to 0 and continue, otherwise calc volume based on distance of tiles, ((10 - distance) * 0.1) * (volume * 0.01)
		// pass info to JS functions for each channel via <<
/datum/controller/subsystem/html_audio/proc/unregister_listener(atom/soon_to_be_qdelled_listener)
	SIGNAL_HANDLER
	UnregisterSignal(soon_to_be_qdelled_listener, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
	listeners.Remove(soon_to_be_qdelled_listener)

/datum/controller/subsystem/html_audio/proc/jank_ass_browse_check(checked_person)
    if (!winexists(checked_person, "html_audio_player"))
      send_browse(C)

/datum/controller/subsystem/html_audio/proc/register_player(atom/movable/player)
	// TODO: code this

/datum/controller/subsystem/html_audio/proc/deregister_player(atom/movable/player)
	// TODO: code this

/datum/controller/subsystem/html_audio/proc/play_audio(atom/movable/player, channel_id)
	// TODO: code this
