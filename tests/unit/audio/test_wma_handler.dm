/test/unit/audio/test_wma_handler
    name = "WMA Handler Tests"

    var/wma_handler = null

    Setup()
        wma_handler = new /obj/audio/wma_handler()

    TestDecode()
        var/test_file = new /datum/file("test.wma")
        var/result = wma_handler.Decode(test_file)
        assert(result != null, "WMA decoding failed")

    TestChannels()
        var/channels = wma_handler.GetChannels()
        assert(channels == 3, "Incorrect number of channels for WMA")