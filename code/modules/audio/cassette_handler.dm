/obj/audio/cassette_handler
    name = "Compact Cassette Audio Handler"
    desc = "Handles Compact Cassette audio format with external hardware integration"

    var/cassette_interface = null

    New()
        cassette_interface = new /obj/hardware/cassette_interface()

    Decode(file)
        if(!cassette_interface)
            cassette_interface = new /obj/hardware/cassette_interface()

        return cassette_interface.Decode(file)

    GetChannels()
        if(cassette_interface)
            return cassette_interface.GetChannels()
        else
            return 0