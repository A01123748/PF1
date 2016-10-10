//
//  InterfaceController.swift
//  QR_Mapas_Watch Extension
//
//  Created by Eliseo Fuentes on 10/9/16.
//  Copyright © 2016 Eliseo Fuentes. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var map: WKInterfaceMap!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
