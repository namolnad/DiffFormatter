/**
 * A structure describing the left and right delimiters surrounding
 * a commit message tag.
 */
public struct DelimiterPair: Codable, Equatable {
    /**
     * The left-hand tag delimiter.
     */
    public let left: String

    /**
     * The right-hand tag delimiter.
     */
    public let right: String
}

/// :nodoc:
extension DelimiterPair {
    static let defaultInput: DelimiterPair = .init(left: "[", right: "]")
    static let defaultOutput: DelimiterPair = .init(left: "|", right: "|")
    static let blank: DelimiterPair = .init(left: "", right: "")
}

/// :nodoc:
extension DelimiterPair {
    var isBlank: Bool {
        left.isEmpty ||
            right.isEmpty
    }
}
