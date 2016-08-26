//
//  HelperFunctions.swift
//  OnTheMap
//
//  Created by felix on 8/12/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import MapKit

struct FunctionsHelper {
    
    static func performUIUpdatesOnMain(updates: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            updates()
        }
    }
    
    static func popupAnOKAlert(viewController: UIViewController,title:String, message:String, handler: ((UIAlertAction) -> Void)?) {
        let controller = UIAlertController()
        controller.title = title
        controller.message = message
        
        let okAction = UIAlertAction (title:"OK", style: UIAlertActionStyle.Default, handler: handler)
        controller.addAction(okAction)
        viewController.presentViewController(controller, animated: true, completion:nil)
    }
}
