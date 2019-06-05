import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
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
    let config = PostgreSQLDatabaseConfig(
        hostname: "ec2-54-247-85-251.eu-west-1.compute.amazonaws.com",
        port: 5432,
        username: "jlzkutgzeomoai",
        database: "dcfm5plhfl4kf3",
        password: "890347662d62cc34e74b1fb59c5dbe53d810c15cd8386fd271a3f537768ce590",
        transport: .cleartext
    )
    let postgres = PostgreSQLDatabase(config: config)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgres, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Log.self, database: .psql)
    services.register(migrations)
}
