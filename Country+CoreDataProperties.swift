//
//  Country+CoreDataProperties.swift
//  Countries(CoreData)
//
//  Created by Tomas Sukys on 2020-09-04.
//  Copyright © 2020 Tomas Sukys.lt. All rights reserved.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var name: String
    @NSManaged public var cities: NSSet

}

// MARK: Generated accessors for cities
extension Country {

    @objc(addCitiesObject:)
    @NSManaged public func addToCities(_ value: City)

    @objc(removeCitiesObject:)
    @NSManaged public func removeFromCities(_ value: City)

    @objc(addCities:)
    @NSManaged public func addToCities(_ values: NSSet)

    @objc(removeCities:)
    @NSManaged public func removeFromCities(_ values: NSSet)

}
