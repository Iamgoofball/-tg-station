//Crew has to create dna vault
// Cargo can order DNA samplers + DNA vault boards
// DNA vault requires x animals ,y plants, z human dna
// DNA vaults require high tier stock parts and cold
/datum/station_goal/dna_vault
	name = "DNA Vault"
	var/animal_count
	var/human_count
	var/plant_count

/datum/station_goal/dna_vault/New()
	..()
	animal_count = rand(15,20) //might be too few given ~15 roundstart stationside ones
	human_count = rand(round(0.75 * ticker.totalPlayersReady) , ticker.totalPlayersReady) // 75%+ roundstart population.
	var/non_standard_plants = non_standard_plants_count()
	plant_count = rand(round(0.7 * non_standard_plants),round(0.9 * non_standard_plants))

/datum/station_goal/dna_vault/proc/non_standard_plants_count()
	. = 0
	for(var/T in subtypesof(/obj/item/seeds)) //put a cache if it's used anywhere else
		var/obj/item/seeds/S = T
		if(initial(S.rarity) > 0)
			.++

/datum/station_goal/dna_vault/get_report()
	return {"Our long term prediction systems say there's 99% chance of system-wide cataclysm in near future.
	 We need you to construct DNA Vault aboard your station.

	 DNA Vault needs to contain samples of:
	 [animal_count] unique animal data
	 [plant_count] unique non-standard plant data
	 [human_count] unique sapient humanoid DNA data

	 Base vault parts should be availible for shipping by your cargo shuttle."}


/datum/station_goal/dna_vault/on_report()
	var/datum/supply_pack/P = SSshuttle.supply_packs[/datum/supply_pack/misc/dna_vault]
	P.special_enabled = TRUE

	P = SSshuttle.supply_packs[/datum/supply_pack/misc/dna_probes]
	P.special_enabled = TRUE

/datum/station_goal/dna_vault/check_completion()
	for(var/obj/machinery/dna_vault/V in machines)
		if(V.animals.len >= animal_count && V.plants.len >= plant_count && V.dna >= human_count)
			return TRUE
	return FALSE


/obj/item/device/dna_probe
	name = "DNA Sampler"
	desc = "Can be used to take chemical and genetic samples of pretty much anything."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	flags = NOBLUDGEON
	var/list/animals = list()
	var/list/plants = list()
	var/list/dna = list()

/obj/item/device/dna_probe/proc/clear_data()
	animals = list()
	plants = list()
	dna = list()

var/list/non_simple_animals = typecacheof(list(/mob/living/carbon/monkey)|subtypesof(/mob/living/carbon/alien))

/obj/item/device/dna_probe/afterattack(atom/target, mob/user, proximity)
	..()
	if(!proximity || !target)
		return
	//tray plants
	if(istype(target,/obj/machinery/hydroponics))
		var/obj/machinery/hydroponics/H = target
		if(!H.myseed)
			return
		if(!H.harvest)// So it's bit harder.
			user << "<span clas='warning'>Plants needs to be ready to harvest to perform full data scan.</span>" //Because space dna is actually magic
			return
		if(plants[H.myseed.type])
			user << "<span class='notice'>Plant data already present in local storage.<span>"
			return
		plants[H.myseed.type] = 1
		user << "<span class='notice'>Plant data added to local storage.<span>"

	//animals
	if(isanimal(target) || is_type_in_typecache(target.type,non_simple_animals))
		if(isanimal(target))
			var/mob/living/simple_animal/A = target
			if(!A.healable)//simple approximation of being animal not a robot or similar
				user << "<span class='warning'>No compatibile DNA detected</span>"
				return
		if(animals[target.type])
			user << "<span class='notice'>Animal data already present in local storage.<span>"
			return
		animals[target.type] = 1
		user << "<span class='notice'>Animal data added to local storage.<span>"

	//humans
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(dna[H.dna.uni_identity])
			user << "<span class='notice'>Humanoid data already present in local storage.<span>" 
			return
		dna[H.dna.uni_identity] = 1
		user << "<span class='notice'>Humanoid data added to local storage.<span>"


/obj/item/weapon/circuitboard/machine/dna_vault
	name = "circuit board (DNA Vault)"
	build_path = /obj/machinery/dna_vault
	origin_tech = "engineering=2;combat=2;bluespace=2" //No freebies!
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor/quadratic = 5,
							/obj/item/stack/cable_coil = 2)

/obj/machinery/dna_vault
	name = "DNA Vault"
	desc = "Break glass in case of apocalypse."
	icon = 'icons/obj/machines/dna_vault.dmi'
	icon_state = "vault"
	density = 1
	anchored = 1
	idle_power_usage = 5000
	pixel_x = -32
	pixel_y = -64
	luminosity = 1
	var/list/animals = list()
	var/list/plants = list()
	var/list/dna = list()

	var/list/obj/structure/fillers = list()

/obj/machinery/dna_vault/New()
	//TODO: Replace this,bsa and gravgen with some big machinery datum
	var/list/occupied = list()
	for(var/direct in list(EAST,WEST,SOUTHEAST,SOUTHWEST))
		occupied += get_step(src,direct)
	occupied += locate(x+1,y-2,z)
	occupied += locate(x-1,y-2,z)

	for(var/T in occupied)
		var/obj/structure/filler/F = new(T)
		F.parent = src
		fillers += F

/obj/machinery/dna_vault/Destroy()
	for(var/V in fillers)
		var/obj/structure/filler/filler = V
		filler.parent = null
		qdel(filler)
	. = ..()


/obj/machinery/dna_vault/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = physical_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "dna_vault", name, 250, 200, master_ui, state)
		ui.open()

/obj/machinery/dna_vault/ui_data() //TODO Make it % bars maybe
	var/list/data = list()
	data["plants"] = plants.len
	data["animals"] = animals.len
	data["dna"] = dna.len
	return data

/obj/machinery/dna_vault/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/device/dna_probe))
		var/obj/item/device/dna_probe/P = I
		var/uploaded = 0
		for(var/plant in P.plants)
			if(!plants[plant])
				uploaded++
				plants[plant] = 1
		for(var/animal in P.animals)
			if(!animals[animal])
				uploaded++
				animals[animal] = 1
		for(var/ui in P.dna)
			if(!dna[ui])
				uploaded++
				dna[ui] = 1
		P.clear_data()
		user << "<span class='notice'>[uploaded] new datapoints uploaded.</span>"
	else
		..()


