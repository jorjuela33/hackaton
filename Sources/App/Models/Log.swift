
import Vapor

/// A single entry of a Log list.
struct Log: KSModel {
    /// The unique identifier for this `Log`.
    var id: UUID?

    /// When was created this `Log`.
    var createdAt: Date?

    /// When was deleted this `Log`.
    var deletedAt: Date?

    /// A delta describing what this `Log` entails.
    var delta: Int

    /// A rssi describing what this `Log` entails.
    var rssi: Int

    /// The uuid of the reader.
    var deviceID: String

    ///
    var sessionID: UUID?

    /// When was updated this `Log`.
    var updatedAt: Date?

    /// Creates a new `Log`.
    init(id: UUID? = nil, delta: Int, rssi: Int, sessionID: UUID, deviceID: String) {
        self.id = id
        self.delta = delta
        self.rssi = rssi
        self.deviceID = deviceID
        self.sessionID = sessionID
    }
}
