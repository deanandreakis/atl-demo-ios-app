//
//  AirportEmployee+CoreDataProperties.swift
//  atlantademo
//
//  Created by Dean Andreakis on 10/9/17.
//  Copyright © 2017 gisi. All rights reserved.
//
//

import Foundation
import CoreData


extension AirportEmployee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirportEmployee> {
        return NSFetchRequest<AirportEmployee>(entityName: "AirportEmployee")
    }

    @NSManaged public var name: String?

}
