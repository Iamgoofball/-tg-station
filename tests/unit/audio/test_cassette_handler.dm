/test/unit/audio/test_cassette_handler
    name = "Cassette Handler Tests"

    var/cassette_handler = null

    Setup()
        cassette_handler = new /obj/audio/cassette_handler()

    TestDecode()
        var/test_file = new /datum/file("test.cassette")
        var/result = cassette_handler.Decode(test_file)
        assert(result != null, "Cassette decoding failed")

    TestChannels()
        var/channels = cassette_handler.GetChannels()
        assert(channels == 2, "Incorrect number of channels for Cassette")