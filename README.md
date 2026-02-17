# SwiftDiscKit

`SwiftDiscKit` is a Swift Package for building Discord bots with:

- Swift Concurrency (`async/await`)
- Discord REST API (`v10`)
- Discord Gateway (`WebSocket`)
- Slash commands and interaction handling
- Components V2 message/interaction support (including modal inputs)

## Current Scope

This repository currently implements:

- Gateway connect, identify, heartbeat, reconnect, and session resume
- Event handling for:
  - `MESSAGE_CREATE`
  - `INTERACTION_CREATE`
  - `READY`
- REST endpoints:
  - Send message
  - Edit message
  - Get message
  - Get messages (history query)
  - Bulk delete messages
  - Send Components V2 message
  - Send Components V2 message with file attachments (multipart upload)
  - Get channel
  - Get guild
  - Get guild member
  - Get guild roles
  - Get user
  - Delete message
  - Create slash command (global/guild)
  - Bulk overwrite slash commands (global/guild)
  - Interaction response
  - Interaction modal response (`type=9`)
  - Deferred response
  - Edit original interaction response
  - Followup interaction message
  - Get/Edit/Delete followup interaction message
- Modal submit decoding helpers:
  - Submitted component values
  - Submitted file IDs and resolved file metadata
- Built-in rate-limit handling (bucket + global handling, retries)

## Package Layout

```text
Sources/DiscordKit/
  DiscordBot.swift
  DiscordError.swift
  REST/
    RESTClient.swift
    Routes.swift
    RateLimiter.swift
  Gateway/
    GatewayClient.swift
    HeartbeatManager.swift
    GatewayModels.swift
  Models/
    Message.swift
    User.swift
    Channel.swift
    Guild.swift
    Interaction.swift
    ComponentV2.swift
  Commands/
    SlashCommand.swift
    CommandRegistry.swift
  Utilities/
    Logger.swift
    JSONCoder.swift

Examples/
  Bot.swift
```

## Requirements

- Swift 5.9+
- macOS 14+ / iOS 17+

## Build and Test

```bash
cd /Users/pratikray/Desktop/Swift/SwiftDiscKit
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
swift build
swift test
```

## Run the Demo Bot

The repository includes one executable target: `DiscordKitBot` (single file).

```bash
cd /Users/pratikray/Desktop/Swift/SwiftDiscKit
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
swift run DiscordKitBot
```

`Examples/Bot.swift` includes local default guild/channel IDs.  
Set bot token through environment (or edit `LocalDefaults.token`):

```bash
export BOT_TOKEN="..."
export TEST_GUILD_ID="..."
export TEST_CHANNEL_ID="..."
swift run DiscordKitBot
```

## Public API (Implemented)

### Bot lifecycle and events

```swift
let bot = DiscordBot(
    token: token,
    intents: [.guilds, .guildMessages, .directMessages, .messageContent],
    commandSyncMode: .none // or .global
)

bot.onReady { ready in ... }
bot.onMessage { message in ... }
bot.onInteraction { interaction in ... }
try await bot.setPresence(status: .online, activity: DiscordActivity(name: "Serving", type: .playing))

try await bot.start()
await bot.stop()
```

### Message and channel helpers

```swift
let sent = try await bot.sendMessage(to: channelId, content: "hello")
let channel = try await bot.getChannel(channelId)
let guild = try await bot.getGuild(guildId)
let user = try await bot.getUser(userId)
let member = try await bot.getGuildMember(guildId: guildId, userId: userId)
let roles = try await bot.getGuildRoles(guildId)
let fetched = try await bot.getMessage(channelId: channelId, messageId: sent.id)
let history = try await bot.getMessages(channelId: channelId, query: MessageHistoryQuery(limit: 20))
let edited = try await bot.editMessage(channelId: channelId, messageId: sent.id, content: "updated")
try await bot.bulkDeleteMessages(channelId: channelId, messageIds: [sent.id])
try await bot.deleteMessage(channelId: channelId, messageId: sent.id)
```

### Slash command APIs

```swift
bot.slashCommand("ping", description: "Ping") { interaction in
    try await interaction.respond("Pong")
}

try await bot.syncSlashCommands(guildId: guildId)
try await bot.clearSlashCommands(guildId: guildId)

let command = try await bot.createSlashCommand(
    "singlecreate",
    description: "Direct create endpoint",
    guildId: guildId
)
```

### Interaction response APIs

```swift
try await interaction.respond("Immediate response")
try await interaction.defer_()
try await interaction.editResponse("Edited response")
_ = try await interaction.followUp("Followup")
let followup = try await interaction.getFollowUp(messageId: "...")
_ = try await interaction.editFollowUp(messageId: followup.id, content: "Edited followup")
try await interaction.deleteFollowUp(messageId: followup.id)
try await interaction.presentModal(
    customId: "upload_modal",
    title: "Upload Demo",
    components: [
        ComponentV2Label(
            label: "Upload files",
            component: .fileUpload(ComponentV2FileUpload(customId: "files"))
        )
    ]
)
```

### Components V2 APIs

```swift
try await interaction.respondComponentsV2(components)

_ = try await bot.sendComponentsV2Message(
    to: channelId,
    components: components
)

_ = try await bot.sendComponentsV2Message(
    to: channelId,
    components: components,
    attachments: [
        DiscordFileUpload(filename: "demo.txt", data: Data("hello".utf8), contentType: "text/plain")
    ]
)
```

## Components V2 Types Implemented

- `container`
- `section`
- `text_display`
- `separator`
- `action_row`
- `button` (primary/secondary/success/danger/link/premium)
- `string_select`
- `user_select`
- `role_select`
- `mentionable_select`
- `channel_select`
- `text_input`
- `label`
- `file_upload`
- `radio_group`
- `checkbox_group`
- `checkbox`
- `thumbnail`
- `media_gallery`
- `file`

## Demo Commands in `Examples/Bot.swift`

Text commands:

- `!ping`
- `!channel <channel_id>`
- `!guild <guild_id>`
- `!roles <guild_id>`
- `!user <user_id>`
- `!member <guild_id> <user_id>`
- `!say <channel_id> <text>`
- `!msgget <channel_id> <message_id>`
- `!msghistory <channel_id> [limit]`
- `!msgedit <channel_id> <message_id> <text>`
- `!bulkdelete <channel_id> <id1,id2,...>`
- `!status <online|idle|dnd|invisible> [activity]`
- `!componentsv2`
- `!delete-last`
- `!register-single`

Slash commands:

- `/ping`
- `/singleping`
- `/deferdemo`
- `/channelinfo`
- `/guildinfo`
- `/roles`
- `/userinfo`
- `/memberinfo`
- `/say`
- `/message_get`
- `/message_history`
- `/message_edit`
- `/bulk_delete`
- `/delete_last`
- `/followup_flow`
- `/set_status`
- `/componentsv2`
- `/components_modal`

## Notes

- The demo bot uses `commandSyncMode: .none` and manually syncs guild commands to avoid global/guild duplicate command listings.
- The demo clears global and guild command scopes once on first ready event before syncing guild commands.
- Use a private test server when experimenting with command registration and Components V2 payloads.

## Endpoint Coverage

- `docs/discord-api-endpoint-coverage.md`

## Security

- `SECURITY.md` describes vulnerability reporting.
- GitHub branch protection, required CI, and security analysis are configured at repository level.

## License

MIT
