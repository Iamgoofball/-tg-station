/test/unit/audio/test_dolby_handler
    name = "Dolby Handler Tests"

    var/dolby_handler = null

    Setup()
        dolby_handler = new /obj/audio/dolby_handler()

    TestDecode()
        var/test_file = new /datum/file("test.dolby")
        var/result = dolby_handler.Decode(test_file)
        assert(result != null, "Dolby decoding failed")

    TestChannels()
        var/channels = dolby_handler.GetChannels()
        assert(channels == 6, "Incorrect number of channels for Dolby AC-3")