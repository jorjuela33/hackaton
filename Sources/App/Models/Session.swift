//
//  Session.swift
//  App
//
//  Created by Jorge Orjuela on 6/6/19.
//

import FluentPostgreSQL
import Vapor

/// A single entry of a Log list.
struct Session: KSModel {
    /// The unique identifier for this `Session`.
    var id: UUID?

    /// When was created this `Session`.
    var createdAt: Date?

    /// When was deleted this `Session`.
    var deletedAt: Date?

    // This session's related logs
    var logs: Children<Session, Log> {
        return children(\.id)
    }

    /// A name describing what this `Session`.
    var name: String

    /// When was updated this `Session`.
    var updatedAt: Date?

    /// Creates a new `Session`.
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
