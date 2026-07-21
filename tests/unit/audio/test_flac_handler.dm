/test/unit/audio/test_flac_handler
    name = "FLAC Handler Tests"

    var/flac_handler = null

    Setup()
        flac_handler = new /obj/audio/flac_handler()

    TestDecode()
        var/test_file = new /datum/file("test.flac")
        var/result = flac_handler.Decode(test_file)
        assert(result != null, "FLAC decoding failed")

    TestChannels()
        var/channels = flac_handler.GetChannels()
        assert(channels == 8, "Incorrect number of channels for FLAC")