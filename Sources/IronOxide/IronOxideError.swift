import protocol Foundation.LocalizedError

public enum IronOxideError: LocalizedError {
    case error(String)
    public var errorDescription: String? {
        switch self {
        case let .error(message):
            return message
        }
    }
}
