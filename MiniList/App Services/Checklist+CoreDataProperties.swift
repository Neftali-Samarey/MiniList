//
//  Checklist+CoreDataProperties.swift
//  MiniList
//
//  Created by Neftali Samarey on 9/4/24.
//
//

import Foundation
import CoreData


extension Checklist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Checklist> {
        return NSFetchRequest<Checklist>(entityName: "Checklist")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var purchased: Bool
    @NSManaged public var category: Int16

}

extension Checklist : Identifiable {

}
