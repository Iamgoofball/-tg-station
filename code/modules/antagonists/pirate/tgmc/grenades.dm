/obj/item/grenade/m40
	name = "\improper M40 HEDP grenade"
	desc = "A small, but deceptively strong high explosive grenade that has been phasing out the M15 fragmentation grenades. \
	Capable of being loaded in the any grenade launcher, or thrown by hand."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/weapons/tgmc_nades.dmi'
	icon_state = "grenade"
	inhand_icon_state = "flashbang"
	worn_icon_state = "minibomb"
	det_time = 4 SECONDS
	ex_dev = 0
	ex_heavy = 0
	ex_light = 4
	ex_flame = 0
	delete_on_detonation = TRUE

/obj/item/grenade/m40/incendiary
	name = "\improper M40 HIDP incendiary grenade"
	desc = "The M40 HIDP is a small, but deceptively strong incendiary grenade. It is set to detonate in 4 seconds."
	icon_state = "grenade_fire"
	ex_flame = 2
	ex_light = 0

/obj/item/grenade/m40/incendiary/on_detonation()
	for(var/turf/found_turf in range(ex_flame, src))
		if(isopenturf(found_turf))
			new /obj/effect/hotspot(found_turf)
		for(var/mob/living/carbon/possible_victim in found_turf)
			possible_victim.adjust_fire_stacks(15)
			possible_victim.ignite_mob()
			possible_victim.take_damage(25, BURN, FIRE)

/obj/effect/particle_effect/fluid/smoke/bad/nine_second
	lifetime = 9 SECONDS

/obj/effect/particle_effect/fluid/smoke/phosphorus
	lifetime = 9 SECONDS
	alpha = 145
	opacity = FALSE
	color = "#DBCBB9"

/obj/effect/particle_effect/fluid/smoke/phosphorus/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/particle_effect/fluid/smoke/phosphorus/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(ishuman(arrived))
		var/mob/living/carbon/human/smoker = arrived
		if(prob(30))
			smoker.drop_all_held_items()
		smoker.apply_damage(27, BURN)
		to_chat(smoker, span_danger("It feels as if you've been dumped into an open fire!"))
		var/obj/item/organ/lungs/lungs = smoker.get_organ_slot(ORGAN_SLOT_LUNGS)
		if(lungs && !(lungs.organ_flags & ORGAN_ROBOTIC))
			if(prob(30))
				INVOKE_ASYNC(smoker, TYPE_PROC_REF(/mob/living/carbon/human, emote), "gasp")
			smoker.apply_damage(4, OXY)
		var/obj/item/organ/eyes/eyes = smoker.get_organ_slot(ORGAN_SLOT_EYES)
		if(eyes && !(eyes.organ_flags & ORGAN_ROBOTIC))
			smoker.adjust_eye_blur(4 SECONDS)

/obj/item/grenade/m40/phosphorus
	name = "\improper M40 HPDP grenade"
	desc = "The M40 HPDP is a small, but powerful phosphorus grenade. It is set to detonate in 2 seconds."
	icon_state = "grenade_phos"
	det_time = 2 SECONDS
	ex_light = 0

/obj/item/grenade/m40/phosphorus/on_detonation()
	do_smoke(6, location = get_turf(src), smoke_type = /obj/effect/particle_effect/fluid/smoke/phosphorus)
	for(var/turf/found_turf in range(4, src))
		if(isopenturf(found_turf))
			new /obj/effect/hotspot(found_turf)
		for(var/mob/living/carbon/possible_victim in found_turf)
			possible_victim.adjust_fire_stacks(15)
			possible_victim.ignite_mob()
			possible_victim.apply_damage(25, BURN)
	for(var/turf/found_turf in range(1, src))
		for(var/mob/living/carbon/possible_victim in found_turf)
			possible_victim.adjust_fire_stacks(75)
			possible_victim.ignite_mob()
			possible_victim.apply_damage(15, BURN)

/obj/item/grenade/m40/smoke
	name = "\improper M40 HSDP smoke grenade"
	desc = "The M40 HSDP is a small, but powerful smoke grenade. Based off the same platform as the M40 HEDP. It is set to detonate in 2 seconds."
	icon_state = "grenade_smoke"
	det_time = 2 SECONDS
	ex_light = 0

/obj/item/grenade/m40/smoke/on_detonation()
	do_smoke(6, location = get_turf(src), smoke_type = /obj/effect/particle_effect/fluid/smoke/bad/nine_second)

/obj/effect/particle_effect/fluid/smoke/transparent/tactical
	alpha = 40
	lifetime = 11 SECONDS

/obj/effect/particle_effect/fluid/smoke/transparent/tactical/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/particle_effect/fluid/smoke/transparent/tactical/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(ishuman(arrived))
		var/mob/living/carbon/human/cloaker = arrived
		cloaker.apply_status_effect(/datum/status_effect/tgmc_cloaked)

/datum/status_effect/tgmc_cloaked
	id = "tgmc_cloaked"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/tgmc_cloaked

/atom/movable/screen/alert/status_effect/tgmc_cloaked
	name = "Cloaked"
	desc = "You're cloaked and hard to see as long as you're standing in smoke."
	icon_state = "tgmc_cloaked"

/datum/status_effect/tgmc_cloaked/on_apply()
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/human_owner = owner
	human_owner.alpha = 5
	return TRUE

/datum/status_effect/tgmc_cloaked/tick(seconds_between_ticks)
	. = ..()
	var/obj/effect/particle_effect/fluid/smoke/smoke = locate() in owner.loc
	if(!smoke)
		qdel(src)

/datum/status_effect/tgmc_cloaked/on_remove()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	human_owner.alpha = 255

/obj/item/grenade/m40/cloaking
	name = "\improper M40-2 SCDP smoke grenade"
	desc = "A sophisticated version of the M40 HSDP with a slighty improved smoke screen payload. It's set to detonate in 2 seconds."
	icon_state = "grenade_cloak"
	det_time = 2 SECONDS

/obj/item/grenade/m40/cloaking/on_detonation()
	do_smoke(7, location = get_turf(src), smoke_type = /obj/effect/particle_effect/fluid/smoke/transparent/tactical)

/obj/item/grenade/m40/m15
	name = "\improper M15 fragmentation grenade"
	desc = "An outdated TGMC fragmentation grenade. With decades of service in the TGMC, the old M15 Fragmentation Grenade is slowly being replaced \
	with the slightly safer M40 HEDP. It is set to detonate in 4 seconds."
	icon_state = "grenade_ex"
	det_time = 4 SECONDS
	ex_light = 5

/obj/projectile/bullet/shrapnel/hefa_buckshot
	name = "flying HEFA buckshot"
	icon_state = "tgmc_bullet"
	damage = 30
	range = 20

/obj/projectile/bullet/shrapnel/hefa_buckshot/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human = target
		human.Knockdown(2 SECONDS)
		var/atom/throw_target = get_edge_target_turf(human, get_dir(starting, human))
		human.throw_at(throw_target, 2)

/obj/item/grenade/m40/hefa
	name = "\improper M25 HEFA grenade"
	desc = "High explosive fragmentation grenades cause a powerful yet very small explosion combined with a scattering ring of buckshot shrapnel, \
	please throw very, very, VERY far away."
	icon_state = "grenade_hefa2"
	shrapnel_type = /obj/projectile/bullet/shrapnel/hefa_buckshot
	shrapnel_radius = 4
	det_time = 4 SECONDS

/obj/item/grenade/m40/lasburster
	name = "\improper M80 lasburster grenade"
	desc = "Lasburster grenades are supercharged to scatter a beam around them when detonating. Keep far away from friendlies. \
	Or don't. I'm just a label."
	icon_state = "grenade_lasburster"
	shrapnel_type = /obj/projectile/beam/laser
	shrapnel_radius = 4
	det_time = 4 SECONDS

/obj/item/grenade/m40/emp
	name = "\improper EMP grenade"
	desc = "A compact device that releases a strong electromagnetic pulse on activation. Is capable of damaging or degrading various \
	electronic systems. Capable of being loaded in the any grenade launcher, or thrown by hand."
	icon_state = "emp"
	ex_light = 0

/obj/item/grenade/m40/emp/on_detonation()
	empulse(get_turf(src), 2, 5)
