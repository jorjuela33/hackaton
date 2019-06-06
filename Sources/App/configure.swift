import GoogleCloud
import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    guard
        let portString = Environment.get("PORT"),

        let port = Int(portString) else {
        fatalError()
    }

    let serverConfigure = NIOServerConfig.default(hostname: "0.0.0.0", port: port)
    services.register(serverConfigure)
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a Postgres database
   /* guard let databaseURL = Environment.get("DATABASE_URL") else {
        fatalError()
    }

    let config = PostgreSQLDatabaseConfig(url: databaseURL)!
    let postgres = PostgreSQLDatabase(config: config)*/

    /// Google cloud storage
    let cloudConfig = GoogleCloudProviderConfig(project: "1079974283277", credentialFile: "Sources/App/kisi-hackathon-s19b-84dd50fd2eb8.json")
    services.register(cloudConfig)
    
    services.register(GoogleCloudStorageConfig.default())
    try services.register(GoogleCloudProvider())

    // Register the configured SQLite database to the database config.
    /*var databases = DatabasesConfig()
    databases.add(database: postgres, as: .psql)
    services.register(databases)*/

    // Configure migrations
    /*var migrations = MigrationConfig()
    migrations.add(model: Log.self, database: .psql)
    migrations.add(model: Session.self, database: .psql)
    services.register(migrations)*/
}
