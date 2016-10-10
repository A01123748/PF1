//
//  InterfaceController.swift
//  QR_Mapas_Watch Extension
//
//  Created by Eliseo Fuentes on 10/9/16.
//  Copyright © 2016 Eliseo Fuentes. All rights reserved.
//

import CoreData

public class WatchCoreDataProxy: NSObject {
    
    let sharedAppGroup:String = "group.maps.watch"
    
    public class var sharedInstance : WatchCoreDataProxy {
        struct Static {
            static let instance : WatchCoreDataProxy = WatchCoreDataProxy()
        }
        return Static.instance
    }
    
    // MARK: - Core Data stack
    
    public lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
        }()
    
    public lazy var managedObjectModel: NSManagedObjectModel = {
        let proxyBundle = NSBundle(identifier: "com.fkts.QR-Mapas")
        
        let modelURL = proxyBundle?.URLForResource("QR_Mapas", withExtension: "momd")!

        return NSManagedObjectModel(contentsOfURL: modelURL!)!
        }()
    
    public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {

        var error: NSError? = nil
        var coordinator: NSPersistentStoreCoordinator?
        var sharedContainerURL: NSURL? = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(self.sharedAppGroup)
  
        if let sharedContainerURL = sharedContainerURL {
            let storeURL = sharedContainerURL.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
            coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            do{
                try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
                }
                catch{
                    abort()
                }
        }
            return coordinator
        }()
    
    public lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    public func saveContext () {
        if let moc = self.managedObjectContext {
            if moc.hasChanges{
            do{
                try moc.save()
            }
            catch{
                //NSLog("Unresolved error \(error), \(error.userInfo)")
                print("Error en save en WatchCoreDataProxy")
                abort()
            }
        }
        }
    }
    
}
