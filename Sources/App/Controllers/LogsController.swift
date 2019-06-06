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
        case sessionID = "session_id"
    }

    let deviceID: String
    let data: [LogData]
    let sessionID: UUID
}

struct LogResponse: Content {
    enum CodingKeys: String, CodingKey {
        case deviceID = "device_id"
        case data
        case sessionID = "session_id"
    }

    let deviceID: String
    let data: [LogResponseData]
    let sessionID: UUID
}

struct LogResponseData: Content {
    enum CodingKeys: String, CodingKey {
        case rssi
        case time
    }

    let rssi: Int
    let time: Int
}

/// Controls basic CRUD operations on `Log`s.
final class LogsController {

    // MARK: Instance methods

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request, log: LogParameters) throws -> Future<HTTPStatus> {
        return log.data.map({ Log(delta: $0.delta, rssi: $0.rssi, sessionID: log.sessionID, deviceID: log.deviceID).create(on: req) })
            .flatten(on: req).transform(to: .ok)
    }

    /// Returns a list of all `Log`s.
    func read(_ req: Request) throws -> Future<[LogResponse]> {
        let sessionID = try req.parameters.next(String.self)
        return Session.query(on: req).filter(\.id, .equal, UUID(sessionID))
            .first()
            .unwrap(or: Abort(.notFound, reason: "Session not found."))
            .flatMap({ session in
                return try Log.query(on: req).filter(\.sessionID, .equal, session.requireID()).all().map({ logs in
                    var response: [LogResponse] = []
                    if !logs.isEmpty {
                        var logResponse = LogResponse(deviceID: "", data: [], sessionID: UUID())
                        for log in logs {
                            if logResponse.deviceID != log.deviceID && !logResponse.deviceID.isEmpty {
                                response.append(logResponse)
                            }

                            let time = log.delta + (logResponse.data.last?.time ?? 0)
                            logResponse = LogResponse(
                                deviceID: log.deviceID,
                                data: logResponse.data + [LogResponseData(rssi: log.rssi, time: time)],
                                sessionID: logResponse.sessionID
                            )
                        }
                        response.append(logResponse)
                    }
                    return response
                })
            })
    }
}

extension LogsController: RouteCollection {

    // MARK: RouteCollection

    func boot(router: Router) throws {
        var group = router.grouped("api")
        group.get("sessions", String.parameter, "logs", use: read)

        group = router.grouped("api")
        group.post(LogParameters.self, at: "logs", use: create)
    }
}
