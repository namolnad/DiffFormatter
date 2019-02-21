//
//  Contributor.swift
//  Finch
//
//  Created by Dan Loman on 7/5/18.
//  Copyright © 2018 DHL. All rights reserved.
//

/**
 * A structure to describe a given project contributor.
 */
public struct Contributor {
    /**
     * The contributor's emails. Either singular or list style
     * keys are acceptable in the config file.
     */
    public let emails: [String]

    /**
     * The contributor's custom handle/username for display in final output.
     */
    public let handle: String
}

/// :nodoc:
extension Contributor: Codable {
    enum CodingKeys: String, CodingKey {
        case email
        case emails
        case handle
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let emails: [String] = container.optionalDecode(forKey: .emails) {
            self.emails = emails
        } else {
            let email: String = try container.decode(forKey: .email)
            self.emails = [email]
        }
        self.handle = try container.decode(forKey: .handle)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if emails.count == 1, let email = emails.first {
            try container.encode(email, forKey: .email)
        } else {
            try container.encode(emails, forKey: .emails)
        }

        try container.encode(handle, forKey: .handle)
    }
}

/// :nodoc:
extension Contributor {
    static let example1: Contributor = .init(
        emails: [
            "esme.squalor@example.com",
            "esmeDevAccount@github.com"
        ],
        handle: "GigiGeniveve"
    )

    static let example2: Contributor = .init(
        emails: [
            "violet.baudelaire@gmail.com"
        ],
        handle: "OlafIsEvil"
    )
}
