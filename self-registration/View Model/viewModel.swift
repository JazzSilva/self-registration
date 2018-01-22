//
//  viewModel.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation

class userViewModel {
    
    weak var dataManger: dataManager?
    var rawPersonalInformation: personalInformation?
    var rawSecurityInformation: securityInformation?
    var rawAddressInformation: addressInformation?
    var rawLibraryCardInformation: libraryCard?
    
}

