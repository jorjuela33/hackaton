//
//  RecordController.swift
//  App
//
//  Created by Jorge Orjuela on 6/5/19.
//

import Vapor

// Controls basic CRUD operations on `Log`s.
final class RecordsController {

    // MARK: Instance methods

    /// Saves a decoded `Todo` to the database.
    func start(_ req: Request) throws -> Future<HTTPResponse> {
        let sessionID = UUID()
        let client = HTTPClient.connect(scheme: .https, hostname: "agent.electricimp.com", on: req)
        return client.flatMap(to: HTTPResponse.self) { client in
            let request = HTTPRequest(
                method: .POST,
                url: "https://agent.electricimp.com/l4sXf_VjfBh9/start",
                body: HTTPBody(string: sessionID.uuidString)
            )
            return client.send(request).map({ response in
                return response.status == .ok ? HTTPResponse(status: .ok, body: "Scan started") : HTTPResponse(status: .internalServerError)
            })
        }
    }

    /// Returns a list of all `Log`s.
    func stop(_ req: Request) throws -> Future<HTTPResponse> {
        let client = HTTPClient.connect(scheme: .https, hostname: "agent.electricimp.com", on: req)
        return client.flatMap(to: HTTPResponse.self) { client in
            let request = HTTPRequest(
                method: .POST,
                url: "https://agent.electricimp.com/l4sXf_VjfBh9/stop"
               )
            return client.send(request).map({ response in
                return response.status == .ok ? HTTPResponse(status: .ok, body: "Scan Stopped") : HTTPResponse(status: .internalServerError)
            })
        }
    }
}

extension RecordsController: RouteCollection {

    // MARK: RouteCollection

    func boot(router: Router) throws {
        let group = router.grouped("api")
        group.get("logs/start", use: start)
        group.get("logs/stop", use: stop)
    }
}
