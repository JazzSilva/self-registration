//
//  connectivityFunctions.swift
//  self-registration
//
//  Created by Jasmin Silva on 3/15/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import Alamofire


class Connectivity {
    
    static let shared = Connectivity()
    
    private init() { }
    
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
