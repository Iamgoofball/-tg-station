// Sample .dm file with tab indentation — before formatting
// tgstation-style tabs will be converted to spaces by dmlint --fix

/obj/machinery/example_machine
    name = "Example Machine"
    desc = "A machine that demonstrates tab-to-space conversion."
    icon_state = "example"

/obj/machinery/example_machine/process()
    if(stat & NOPOWER)
        return
    if(use_power)
        use_power(100)
        do_work()

/obj/machinery/example_machine/proc/do_work()
    var/datum/gas_mixture/air = loc.return_air()
    if(air)
        air.adjust_multi(
            "co2" = 1,
            "n2o" = 2,
        )
    return TRUE
