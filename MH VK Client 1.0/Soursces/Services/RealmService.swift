////
////  RealmService.swift
////  MH VK Client 1.0
////
////  Created by Vitaly Khomatov on 26.01.2020.
////  Copyright © 2020 Macrohard. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//
//
//class RealmService {
//
//    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//
////    static func get<T: Object>(_ type: T.Type, primaryKey: Int,
////                               configuration: Realm.Configuration = deleteIfMigration,
////                               update: Realm.UpdatePolicy = .modified)
////        throws -> T? {
////            let realm = try Realm(configuration: configuration)
////            print("Realm get: \(String(describing: configuration.fileURL))")
////
////            return realm.object(ofType: type, forPrimaryKey: primaryKey)
////    }
//
//
//    static func save<T: Object>(items: [T],
//                                configuration: Realm.Configuration = deleteIfMigration,
//                                update: Realm.UpdatePolicy = .all)
//        throws {
//            let realm = try Realm(configuration: configuration)
//            print("Realm \(String(describing: configuration.fileURL!))" )
//            try realm.write {
//                realm.add(items.self, update: update)
//            }
//    }
//
//
////    static func delete<T: Object>(items: [T],
////                                  configuration: Realm.Configuration = deleteIfMigration,
////                                  update: Realm.UpdatePolicy = .all)
////        throws {
////            let realm = try Realm(configuration: configuration)
////            print("Realm delete: \(String(describing: configuration.fileURL))" )
////            try realm.write {
////                realm.delete(items.self)
////            }
////    }
//
//
//}
//

