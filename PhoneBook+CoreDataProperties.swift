//
//  PhoneBook+CoreDataProperties.swift
//  PoketmonAdress
//
//  Created by mac on 7/15/24.
//
//

import Foundation
import CoreData


extension PhoneBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneBook> {
        return NSFetchRequest<PhoneBook>(entityName: "PhoneBook")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var image: String?
}

extension PhoneBook : Identifiable {

}
