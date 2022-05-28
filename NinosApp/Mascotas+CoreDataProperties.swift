//
//  Mascotas+CoreDataProperties.swift
//  NinosApp
//
//  Created by Edgar Cruz Reyes on 27/05/22.
//

import Foundation
import CoreData
extension Mascotas {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mascotas>{
        return NSFetchRequest<Mascotas>(entityName: "Mascotas")
    }
    @NSManaged public var id: Int?
}

