//
//  KSModel.swift
//  App
//
//  Created by Jorge Orjuela on 6/6/19.
//

import FluentPostgreSQL
import Vapor

protocol KSModel: Model, Content, Migration, Parameter, PostgreSQLTable where Self.ID == UUID, Self.Database == PostgreSQLDatabase {
    var id: UUID? { get set }
    var createdAt: Date? { get set }
    var deletedAt: Date? { get set }
    var updatedAt: Date? { get set }
}

extension KSModel {
    static var createdAtKey: TimestampKey? {
        return \.createdAt
    }

    static var idKey: IDKey {
        return \.id
    }

    static var deletedAtKey: TimestampKey? {
        return \.deletedAt
    }

    static var updatedAtKey: TimestampKey? {
        return \.updatedAt
    }
}
