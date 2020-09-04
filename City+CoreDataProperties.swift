//
//  City+CoreDataProperties.swift
//  Countries(CoreData)
//
//  Created by Tomas Sukys on 2020-09-04.
//  Copyright © 2020 Tomas Sukys.lt. All rights reserved.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String
    @NSManaged public var visits: Int64
    @NSManaged public var country: Country

}
