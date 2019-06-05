import Vapor

/// Controls basic CRUD operations on `Log`s.
final class LogsController {

    // MARK: Instance methods

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request, log: Log) throws -> Future<Log> {
        return try req.content.decode(Log.self).flatMap { todo in
            return todo.save(on: req)
        }
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
        group.post(Log.self, at: "logs", use: create)
    }
}
