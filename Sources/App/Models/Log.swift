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
    var deviceID: String

    ///
    var session: UUID

    /// Creates a new `Todo`.
    init(id: Int? = nil, delta: Int, rssi: Int, session: UUID, deviceID: String) {
        self.id = id
        self.delta = delta
        self.rssi = rssi
        self.deviceID = deviceID
        self.session = session
    }
}

/// Allows `Log` to be used as a dynamic migration.
extension Log: Migration { }

/// Allows `Log` to be encoded to and decoded from HTTP messages.
extension Log: Content { }

/// Allows `Log` to be used as a dynamic parameter in route definitions.
extension Log: Parameter { }
