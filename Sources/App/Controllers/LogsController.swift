import Foundation
import Vapor

struct LogData: Content {
    let delta: Int
    let rssi: Int
}

struct LogParameters: Content {
    enum CodingKeys: String, CodingKey {
        case deviceID = "device_id"
        case data
    }

    let deviceID: String
    let data: [LogData]
}

/// Controls basic CRUD operations on `Log`s.
final class LogsController {

    // MARK: Instance methods

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request, log: LogParameters) throws -> Future<HTTPStatus> {
        let sessionID = UUID()
        return try log.data.map({ try Log(id: nil, delta: $0.delta, rssi: $0.rssi, session: sessionID, deviceID: UUID(uuidString: log.deviceID)!).create(on: req) })
        .flatten(on: req).transform(to: .ok)
    }

    /// Returns a list of all `Log`s.
    func read(_ req: Request) throws -> Future<[Log]> {
        return Log.query(on: req).all()
    }
}

extension LogsController: RouteCollection {

    // MARK: RouteCollection

    func boot(router: Router) throws {
        let group = router.grouped("api/devices")
        group.get("logs", use: read)
        group.post(LogParameters.self, at: "logs", use: create)
    }
}
