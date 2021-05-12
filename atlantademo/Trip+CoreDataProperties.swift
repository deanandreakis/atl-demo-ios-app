//
//  Trip+CoreDataProperties.swift
//  atlantademo
//
//  Created by Dean Andreakis on 10/25/17.
//  Copyright © 2017 gisi. All rights reserved.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var completedTrip: Bool
    @NSManaged public var departureDate: NSDate?
    @NSManaged public var departureFlightAirlineName: String?
    @NSManaged public var departureFlightNumber: String?
    @NSManaged public var departureGate: String?
    @NSManaged public var finalArrivalDate: NSDate?
    @NSManaged public var finalArrivalGate: String?
    @NSManaged public var finalDestination: String?
    @NSManaged public var origin: String?
    @NSManaged public var departureFlightSeatAssignment: String?
    @NSManaged public var confirmationNumber: String?
    @NSManaged public var intermediateStop: NSSet?
    @NSManaged public var traveler: Traveler?

}

// MARK: Generated accessors for intermediateStop
extension Trip {

    @objc(addIntermediateStopObject:)
    @NSManaged public func addToIntermediateStop(_ value: IntermediateStop)

    @objc(removeIntermediateStopObject:)
    @NSManaged public func removeFromIntermediateStop(_ value: IntermediateStop)

    @objc(addIntermediateStop:)
    @NSManaged public func addToIntermediateStop(_ values: NSSet)

    @objc(removeIntermediateStop:)
    @NSManaged public func removeFromIntermediateStop(_ values: NSSet)

}
