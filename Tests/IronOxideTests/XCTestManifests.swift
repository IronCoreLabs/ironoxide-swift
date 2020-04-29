#if !canImport(ObjectiveC)
    import XCTest

    extension UserTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__UserTests = [
            ("testGetPublicKey", testGetPublicKey),
            ("testListDevices", testListDevices),
        ]
    }

    extension UtilTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__UtilTests = [
            ("testBoolToInt", testBoolToInt),
            ("testIntToBool", testIntToBool),
            ("testTimestampToDate", testTimestampToDate),
            ("testUtf8RoundTrip", testUtf8RoundTrip),
        ]
    }

    public func __allTests() -> [XCTestCaseEntry] {
        [
            testCase(UserTests.__allTests__UserTests),
            testCase(UtilTests.__allTests__UtilTests),
        ]
    }
#endif
