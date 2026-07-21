/obj/audio/audio_manager
    // Existing code...

    var/flac_handler = null
    var/wma_handler = null
    var/cassette_handler = null
    var/dolby_handler = null

    New()
        // Existing initialization...

        flac_handler = new /obj/audio/flac_handler()
        wma_handler = new /obj/audio/wma_handler()
        cassette_handler = new /obj/audio/cassette_handler()
        dolby_handler = new /obj/audio/dolby_handler()

    PlaySound(file, format)
        switch(format)
            case "flac"
                return flac_handler.Decode(file)
            case "wma"
                return wma_handler.Decode(file)
            case "cassette"
                return cassette_handler.Decode(file)
            case "dolby"
                return dolby_handler.Decode(file)
            else
                // Existing code for other formats