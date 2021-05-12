//
//  Traveler+CoreDataProperties.swift
//  atlantademo
//
//  Created by Dean Andreakis on 10/8/17.
//  Copyright © 2017 gisi. All rights reserved.
//
//

import Foundation
import CoreData


extension Traveler {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Traveler> {
        return NSFetchRequest<Traveler>(entityName: "Traveler")
    }

    @NSManaged public var name: String?
    @NSManaged public var numberOfMiles: Int32
    @NSManaged public var rewardCardID: String?
    @NSManaged public var rewardStatus: String?
    @NSManaged public var trips: NSSet?

}

// MARK: Generated accessors for trips
extension Traveler {

    @objc(addTripsObject:)
    @NSManaged public func addToTrips(_ value: Trip)

    @objc(removeTripsObject:)
    @NSManaged public func removeFromTrips(_ value: Trip)

    @objc(addTrips:)
    @NSManaged public func addToTrips(_ values: NSSet)

    @objc(removeTrips:)
    @NSManaged public func removeFromTrips(_ values: NSSet)

}
