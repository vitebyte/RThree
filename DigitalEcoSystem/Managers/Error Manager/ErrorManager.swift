//
//  ErrorManager.swift
//  DigitalEcoSystem
//
//  Created by Shafi Ahmed on 08/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class ErrorManager: NSObject {

    class func handleError(_ error: NSError) {
        
        var errorMessage = error.localizedDescription
         LogManager.logError("\(String(describing: errorMessage))")
        // session expired
        /*
         401: request unauthorized

         400: bad request

         404: not found

         500: internal server error
         */
    }

    class func handleException(_: NSException) {
        // Exception print here
    }
}
