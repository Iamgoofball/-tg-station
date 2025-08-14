/datum/export/tgmc_squad_leader_dogtags
	cost = CARGO_CRATE_VALUE*50
	k_elasticity = 0
	k_recovery_elasticity = 0
	unit_name = "TGMC squad leader dogtags"
	export_types = list(/obj/item/card/id/tgmc/leader)

/datum/export/tgmc_squad_leader_dogtags/sell_object(obj/sold_item, datum/export_report/report, dry_run, apply_elastic)
	priority_announce(
		text = "Hello, crew of [station_name()]! This is the Acting Quartermaster of the TerraGov Marine Corps. We've received the dogtags your Cargo department \
		sent us, and we've confirmed these belong to the leader of a dangerous terrorist cell threatening the proud citizens of the Spinward Stellar Coalition! \
		TerraGov would like to formally thank you for your service in stamping out piracy, and we apologize that these wayward souls sought fit to trouble you today. \
		As such, please accept this complimentary gift of [cost] credits. \
		\n\
		\n\
		Okay, my boss is off the line now. We just popped the last quartermaster for selling goods to these guys thanks to travel logs on the microchip \
		in those tags you sent in, and there's hundreds of crates off-the-books in a warehouse my men just found that my predecessor was using to store \
		the \"lost\" equipment in. Legally, we can't reclaim it, it's all potentially been tampered with by those weird corporate benefactors those guys \
		had, and there's spraypainted blood red snakes in the shape of the letter S all over the crates. As a thank you for getting me this sweet promotion, \
		we can have some of it fall off the back of the shuttle into your own. If anyone asks, you got it from their ship.",
		title = "Regarding the Terrorists",
		sender_override = "TerraGov Marine Corps Requisitions Department",
		has_important_message = TRUE
	)
	for(var/pack_id in SSshuttle.supply_packs)
		var/datum/supply_pack/pack = SSshuttle.supply_packs[pack_id]
		if(!istype(pack, /datum/supply_pack/tgmc))
			continue
		pack.special_enabled = TRUE
	. = ..()

/datum/export/tgmc_dogtags
	k_elasticity = 0
	k_recovery_elasticity = 0
	cost = CARGO_CRATE_VALUE*5
	unit_name = "TGMC dogtags"
	export_types = list(/obj/item/card/id/tgmc/marine, /obj/item/card/id/tgmc/corpsman, /obj/item/card/id/tgmc/engineer)
