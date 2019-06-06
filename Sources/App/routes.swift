import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    /// Logs
    let logsController = LogsController()
    try router.register(collection: logsController)

    /// Records
    let recordsController = RecordsController()
    try router.register(collection: recordsController)

    /// Sessions
    let sessionsController = SessionsController()
    try router.register(collection: sessionsController)
}
