//
//  SessionsController.swift
//  App
//
//  Created by Jorge Orjuela on 6/6/19.
//

import Vapor

/// Controls basic CRUD operations on `Session`s.
final class SessionsController {

    // MARK: Instance methods

    /// Saves a decoded `Session` to the database.
    func create(_ req: Request, session: Session) throws -> Future<Session> {
        return session.save(on: req)
    }

    /// Returns a list of all `Session`s.
    func read(_ req: Request) throws -> Future<[Session]> {
        return Session.query(on: req).sort(\.id, .ascending).all()
    }
}

extension SessionsController: RouteCollection {

    // MARK: RouteCollection

    func boot(router: Router) throws {
        let group = router.grouped("api")
        group.get("sessions", use: read)
        group.post(Session.self, at: "sessions", use: create)
    }
}
