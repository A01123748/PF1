//
//  InterfaceController.swift
//  QR_Mapas_Watch Extension
//
//  Created by Eliseo Fuentes on 10/9/16.
//  Copyright © 2016 Eliseo Fuentes. All rights reserved.
//

import CoreData

public class DataManager: NSObject {
    
    public class func getContext() -> NSManagedObjectContext {
        return WatchCoreDataProxy.sharedInstance.managedObjectContext!
    }
    
    public class func deleteManagedObject(object:NSManagedObject) {
        getContext().deleteObject(object)
        saveManagedContext()
    }
    
    public class func saveManagedContext() {
        do{
            try getContext().save()
        }
        catch{
            print("Error en el save")
            abort()
        }
    }

}
