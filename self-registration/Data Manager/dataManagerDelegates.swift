//
//  dataManagerDelegates.swift
//  self-registration
//
//  Created by Jasmin Silva on 1/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation

// MARK: Each dataManager delegate will send and recieve data

protocol relayData {
    func sendData()
    func recieveData()
}

// MARK: The dataManager delegates conform to relayData to communicate w/ Twilio, Firebase, and an ILS

struct twilioDelegate: relayData {
    func sendData() {
    }
    func recieveData() {
    }
}

struct integratedLibrarySystemDelegate: relayData {
    func sendData() {
    }
    func recieveData() {
    }
}

struct firebaseDelegate: relayData {
    func sendData() {
    }
    func recieveData() {
    }
}
