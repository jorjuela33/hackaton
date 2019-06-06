import GoogleCloud
import Vapor

struct LogData: Content {
    let delta: Int
    let rssi: Int
}

struct LogParameters: Content {
    enum CodingKeys: String, CodingKey {
        case deviceID = "device_id"
        case data
        case name
        case sessionID = "session_id"
    }

    let deviceID: String
    let data: [LogData]
    let name: String
    let sessionID: UUID
}

/// Controls basic CRUD operations on `Log`s.
final class LogsController {

    // MARK: Instance methods

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request, log: LogParameters) throws -> Future<HTTPResponse> {
        let cloudStorage = try req.make(GoogleCloudStorageClient.self)
        let data = try JSONEncoder().encode(log)
        return try cloudStorage.object.createSimpleUpload(
            bucket: "kisi-wtu-collection",
            data: data,
            name: "\(log.name)-\(log.deviceID)",
            mediaType: .json
        )
        .map({ _ in
            return HTTPResponse(status: .created, body: "Created")
        })
    }
/*
    /// Returns a list of all `Log`s.
    func read(_ req: Request) throws -> Future<[LogResponse]> {
        let sessionID = try req.parameters.next(String.self)
        return Session.query(on: req).filter(\.id, .equal, UUID(sessionID))
            .first()
            .unwrap(or: Abort(.notFound, reason: "Session not found."))
            .flatMap({ session in
                return try Log.query(on: req).filter(\.sessionID, .equal, session.requireID()).sort(\.deviceID, .ascending).all().map({ logs in
                    var response: [LogResponse] = []
                    if !logs.isEmpty {
                        var logResponse = LogResponse(deviceID: "", data: [], sessionID: UUID())
                        for log in logs {
                            var time = log.delta + (logResponse.data.last?.time ?? 0)
                            if logResponse.deviceID != log.deviceID && !logResponse.deviceID.isEmpty {
                                response.append(logResponse)
                                time = 0
                            }

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
    }*/
}

extension LogsController: RouteCollection {

    // MARK: RouteCollection

    func boot(router: Router) throws {
        let group = router.grouped("api")
        group.post(LogParameters.self, at: "logs", use: create)
    }
}
