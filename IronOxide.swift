import libironoxide
import protocol Foundation.LocalizedError

/**
 * Error enum for all errors that come out of the IronOxide native library
 */
public enum IronOxideError: LocalizedError {
    case error(String)
    public var errorDescription: String? {
        switch self {
            case .error(let message):
                return message
        }
    }
}

public struct User {
    public static func userVerify(jwt: String) -> Result<Optional<UserResult>, IronOxideError>{
        let val  = CRustOptionUnion4232const3232c_void(uninit: 0)
        let timeout = CRustOption4232const3232c_void(val: val, is_some: 0)
        let op = IronOxide_userVerify(Util.swiftStringToRust(jwt), timeout)
        if(op.is_ok == 0){
            return Result.failure(IronOxideError.error(Util.rustStringToSwift(str: op.data.err, fallbackError: "Failed to make request to verify user.")))
        }
        if(op.data.ok.is_some == 0){
            return Result.success(Optional.none)
        }
        return Result.success(UserResult(OpaquePointer(op.data.ok.val.data)))
   }

    public static func userCreate(){

    }

    public static func generateNewDevice(){

    }
}

public func initialize() /*-> Result<SDK, IronOxideError>*/{

}
