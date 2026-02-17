import Foundation

public struct DiscordUser: Codable, Sendable, Identifiable {
    public let id: String
    public let username: String
    public let discriminator: String
    public let globalName: String?
    public let avatar: String?
    public let bot: Bool?
    public let system: Bool?
    public let mfaEnabled: Bool?
    public let banner: String?
    public let accentColor: Int?
    public let locale: String?
    public let verified: Bool?
    public let email: String?
    public let flags: Int?
    public let premiumType: Int?
    public let publicFlags: Int?
    public let avatarDecorationData: AvatarDecorationData?

    public var displayName: String {
        globalName ?? username
    }

    public var avatarURL: URL? {
        guard let avatar else { return nil }
        return URL(string: "https://cdn.discordapp.com/avatars/\(id)/\(avatar).png")
    }

    public var bannerURL: URL? {
        guard let banner else { return nil }
        return URL(string: "https://cdn.discordapp.com/banners/\(id)/\(banner).png")
    }

    public var tag: String {
        discriminator == "0" ? username : "\(username)#\(discriminator)"
    }
}

public struct AvatarDecorationData: Codable, Sendable {
    public let asset: String?
    public let skuId: String?
}
