//
//  IntermediateStop+CoreDataProperties.swift
//  atlantademo
//
//  Created by Dean Andreakis on 10/25/17.
//  Copyright © 2017 gisi. All rights reserved.
//
//

import Foundation
import CoreData


extension IntermediateStop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IntermediateStop> {
        return NSFetchRequest<IntermediateStop>(entityName: "IntermediateStop")
    }

    @NSManaged public var arrivalDate: NSDate?
    @NSManaged public var arrivalGate: String?
    @NSManaged public var arrivalName: String?
    @NSManaged public var departureDate: NSDate?
    @NSManaged public var departureFlightAirlineName: String?
    @NSManaged public var departureFlightNumber: String?
    @NSManaged public var departureGate: String?
    @NSManaged public var destinationName: String?
    @NSManaged public var departureFlightSeatAssignment: String?
    @NSManaged public var trip: Trip?

}
