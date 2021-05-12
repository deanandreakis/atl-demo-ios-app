//
//  AirportEmployee+CoreDataClass.swift
//  atlantademo
//
//  Created by Dean Andreakis on 10/9/17.
//  Copyright © 2017 gisi. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(AirportEmployee)
public class AirportEmployee: NSManagedObject {

}

extension AirportEmployee
{
    static func loadAirportEmployeeData(filename: String)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        do
        {
            if let file = Bundle.main.url(forResource: filename, withExtension: "json")
            {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let resultsJson = json["AirportEmployee"] as! NSDictionary
                let employeeEntity = NSEntityDescription.entity(forEntityName: "AirportEmployee", in: managedContext)!
                let employeeObj = AirportEmployee(entity: employeeEntity, insertInto: managedContext)
                employeeObj.name = resultsJson["name"] as? String
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
