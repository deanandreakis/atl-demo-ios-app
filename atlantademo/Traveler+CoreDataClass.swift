//
//  Traveler+CoreDataClass.swift
//  atlantademo
//
//  Created by Dean Andreakis on 10/8/17.
//  Copyright © 2017 gisi. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Traveler)
public class Traveler: NSManagedObject {

}

extension Traveler
{
    static func loadTravelerData(filename: String)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        do
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            //Each json file we have represents an individual traveler and all of there trips
            if let file = Bundle.main.url(forResource: filename, withExtension: "json")
            {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let resultsJson = json["Traveler"] as! NSDictionary
                let travelerEntity = NSEntityDescription.entity(forEntityName: "Traveler", in: managedContext)!
                let travelerObj = Traveler(entity: travelerEntity, insertInto: managedContext)
                
                travelerObj.name = resultsJson["name"] as? String
                travelerObj.numberOfMiles = resultsJson["numberOfMiles"] as! Int32
                travelerObj.rewardStatus = resultsJson["rewardStatus"] as? String
                travelerObj.rewardCardID = resultsJson["rewardCardID"] as? String
                
                if let tripsJson = resultsJson["Trips"] as? [[String: Any]]
                {
                    for trip in tripsJson
                    {
                        let tripEntity = NSEntityDescription.entity(forEntityName: "Trip", in: managedContext)!
                        let tripObj = Trip(entity: tripEntity, insertInto: managedContext)
                        
                        tripObj.origin = trip["origin"] as? String
                        tripObj.completedTrip = trip["completedTrip"] as! Bool
                        tripObj.departureDate = dateFormatter.date(from: trip["departureDate"] as! String)! as NSDate
                        tripObj.departureFlightAirlineName = trip["departureFlightAirlineName"] as? String
                        tripObj.departureFlightNumber = trip["departureFlightNumber"] as? String
                        tripObj.departureGate = trip["departureGate"] as? String
                        tripObj.finalArrivalDate = dateFormatter.date(from: trip["finalArrivalDate"] as! String)! as NSDate
                        tripObj.finalArrivalGate = trip["finalArrivalGate"] as? String
                        tripObj.finalDestination = trip["finalDestination"] as? String
                        tripObj.departureFlightSeatAssignment = trip["departureFlightSeatAssignment"] as? String
                        tripObj.confirmationNumber = trip["confirmationNumber"] as? String
                        
                        if let intermediateStopsJson = trip["IntermediateStops"] as? [[String: Any]]
                        {
                            for stop in intermediateStopsJson
                            {
                                let stopEntity = NSEntityDescription.entity(forEntityName: "IntermediateStop", in: managedContext)!
                                let stopObj = IntermediateStop(entity: stopEntity, insertInto: managedContext)
                                
                                stopObj.destinationName = stop["destinationName"] as? String
                                stopObj.arrivalDate = dateFormatter.date(from: stop["arrivalDate"] as! String)! as NSDate
                                stopObj.arrivalGate = stop["arrivalGate"] as? String
                                stopObj.arrivalName = stop["arrivalName"] as? String
                                stopObj.departureDate = dateFormatter.date(from: stop["departureDate"] as! String)! as NSDate
                                stopObj.departureFlightAirlineName = stop["departureFlightAirline"] as? String
                                stopObj.departureFlightNumber = stop["departureFlightNumber"] as? String
                                stopObj.departureGate = stop["departureGate"] as? String
                                stopObj.departureFlightSeatAssignment = stop["departureFlightSeatAssignment"] as? String
                                
                                tripObj.addToIntermediateStop(stopObj)
                            }
                        }
                        travelerObj.addToTrips(tripObj)
                    }
                }
                
                try! managedContext.save()
            }
            else
            {
                print("no file")
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
}
