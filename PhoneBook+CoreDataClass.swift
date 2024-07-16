//
//  PhoneBook+CoreDataClass.swift
//  PoketmonAdress
//
//  Created by mac on 7/15/24.
//
//

import Foundation
import CoreData

@objc(PhoneBook)
public class PhoneBook: NSManagedObject {
    
    public static let className = "PhoneBook"
    
    public enum Key {
        static let name = "name"
        static let phoneNumber = "phoneNumber"
        static let image = "image"
    }

}
