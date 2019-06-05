import FluentPostgreSQL
import Vapor

/// A single entry of a Log list.
struct Log: PostgreSQLModel {
    /// The unique identifier for this `Log`.
    var id: Int?

    /// A delta describing what this `Log` entails.
    var delta: Int

    /// A rssi describing what this `Log` entails.
    var rssi: Int

    /// The uuid of the reader.
    var uuid: UUID

    /// Creates a new `Todo`.
    init(id: Int? = nil, delta: Int, rssi: Int, uuid: UUID) {
        self.id = id
        self.delta = delta
        self.rssi = rssi
        self.uuid = uuid
    }
}

/// Allows `Log` to be used as a dynamic migration.
extension Log: Migration { }

/// Allows `Log` to be encoded to and decoded from HTTP messages.
extension Log: Content { }

/// Allows `Log` to be used as a dynamic parameter in route definitions.
extension Log: Parameter { }
