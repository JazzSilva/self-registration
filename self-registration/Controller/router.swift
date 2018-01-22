//
//  router.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit

protocol Router {
    func route(to routeID: String, from context: UIViewController, data: Any)
}


