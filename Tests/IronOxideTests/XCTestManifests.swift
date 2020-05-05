#if !canImport(ObjectiveC)
    import XCTest

    extension CommonStructsTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__CommonStructsTests = [
            ("testRustBytesRoundtripEqualitySigned", testRustBytesRoundtripEqualitySigned),
            ("testRustBytesRoundtripEqualityUnsigned", testRustBytesRoundtripEqualityUnsigned),
            ("testRustBytesValidateBytesAsFailure", testRustBytesValidateBytesAsFailure),
            ("testRustBytesValidateBytesAsSuccess", testRustBytesValidateBytesAsSuccess),
        ]
    }

    extension GroupTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__GroupTests = [
            ("testGroupFunctions", testGroupFunctions),
        ]
    }

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
            ("testRustVecToBytesi32", testRustVecToBytesi32),
            ("testRustVecToBytesi8", testRustVecToBytesi8),
            ("testTimestampToDate", testTimestampToDate),
            ("testToOptionNone", testToOptionNone),
            ("testToOptionSome", testToOptionSome),
            ("testToResultOpaquePointerWithFailure", testToResultOpaquePointerWithFailure),
            ("testToResultOpaquePointerWithSuccess", testToResultOpaquePointerWithSuccess),
            ("testToResultOptionWithFailure", testToResultOptionWithFailure),
            ("testToResultOptionWithSuccess", testToResultOptionWithSuccess),
            ("testUtf8RoundTrip", testUtf8RoundTrip),
        ]
    }

    public func __allTests() -> [XCTestCaseEntry] {
        return [
            testCase(CommonStructsTests.__allTests__CommonStructsTests),
            testCase(GroupTests.__allTests__GroupTests),
            testCase(UserTests.__allTests__UserTests),
            testCase(UtilTests.__allTests__UtilTests),
        ]
    }
#endif
