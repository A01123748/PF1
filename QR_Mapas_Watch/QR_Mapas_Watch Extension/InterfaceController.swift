//
//  InterfaceController.swift
//  QR_Mapas_Watch Extension
//
//  Created by Eliseo Fuentes on 10/9/16.
//  Copyright © 2016 Eliseo Fuentes. All rights reserved.
//

import WatchKit
import Foundation
import CoreData
import MapKit

class Point: NSManagedObject {
    @NSManaged var image: NSData?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
}

class Route: NSManagedObject {
    @NSManaged var points: [Point]?
    @NSManaged var name: String?
}


class InterfaceController: WKInterfaceController, NSFetchedResultsControllerDelegate{

    var managedObjectContext: NSManagedObjectContext? = nil

    @IBOutlet var map: WKInterfaceMap!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        // Configure interface objects here
        let fetchRequest = NSFetchRequest(entityName: "route")
        
        // Create a sort descriptor object that sorts on the "name"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
         var routes = [Route]()
        do{
        routes = try DataManager.getContext().executeFetchRequest(fetchRequest) as! [Route]
        }
        catch{
            print("error")
        }
        for route in routes{
            print(route.name)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
