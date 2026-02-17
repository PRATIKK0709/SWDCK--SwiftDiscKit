import Foundation

public enum DiscordError: Error, LocalizedError {
    case invalidToken
    case rateLimited(retryAfter: Double)
    case gatewayDisconnected(code: Int?, reason: String?)
    case decodingFailed(type: String, underlying: Error)
    case missingPermissions(endpoint: String)
    case resourceNotFound(endpoint: String)
    case validationFailed(message: String)
    case invalidRequest(message: String)
    case httpError(statusCode: Int, body: String)
    case websocketError(underlying: Error)
    case connectionFailed(reason: String)
    case interactionAlreadyAcknowledged
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .invalidToken:
            return "The bot token is invalid or unauthorized. Check your Discord bot token."
        case .rateLimited(let retryAfter):
            return "Rate limited by Discord. Retry after \(retryAfter) seconds."
        case .gatewayDisconnected(let code, let reason):
            return "Gateway disconnected. Code: \(code.map(String.init) ?? "none"), Reason: \(reason ?? "none")"
        case .decodingFailed(let type, let underlying):
            return "Failed to decode '\(type)': \(underlying.localizedDescription)"
        case .missingPermissions(let endpoint):
            return "Missing permissions for endpoint '\(endpoint)'. Check your bot role permissions and channel/guild access."
        case .resourceNotFound(let endpoint):
            return "Resource not found at '\(endpoint)'. Verify the IDs (guild/channel/message/user) are correct."
        case .validationFailed(let message):
            return "Discord rejected the request data: \(message)"
        case .invalidRequest(let message):
            return "Invalid Discord API request: \(message)"
        case .httpError(let code, let body):
            return "HTTP \(code): \(body)"
        case .websocketError(let underlying):
            return "WebSocket error: \(underlying.localizedDescription)"
        case .connectionFailed(let reason):
            return "Connection failed: \(reason)"
        case .interactionAlreadyAcknowledged:
            return "This interaction has already been acknowledged."
        case .unknown(let msg):
            return "Unknown error: \(msg)"
        }
    }
}
