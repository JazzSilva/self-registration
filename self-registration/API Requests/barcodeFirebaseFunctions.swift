//
//  requestFunctions.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/21/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import Firebase

typealias CompletionHandler = (_ url: String) -> Void

func postBarcodeToFirebase(user: String, completionHandler: @escaping CompletionHandler) {

    guard let pngData = UIImagePNGRepresentation(generateBarcode(from: user)!) else {
        return
    }
    let imageName = NSUUID().uuidString
    var profileImageURL = ""
    let storageReference = Storage.storage().reference(forURL: RCValues.sharedInstance.string(forKey: .firebaseStorageReference))
    let barcodeReference = storageReference.child("barcodes").child("\(imageName).png")
    
    barcodeReference.putData(pngData, metadata: nil, completion: { (metadata, error) in
        if error != nil {
            print(error.debugDescription)
        }
        if let mediaURL = metadata?.downloadURL()?.absoluteString {
            completionHandler(mediaURL)
            profileImageURL = mediaURL
        }
        print("Successfully stored barcode at path \(profileImageURL)")
    })
    return
}

func text(user: user) {
    postBarcodeToFirebase(user: user.libraryCardNumber!, completionHandler: { myURL -> Void in
        sendBarcodeToSMS(toNumber: user.phone!, name: user.firstName!, number: user.libraryCardNumber!, mediaURL: myURL)
        print("inside closure now")
        print("closure url: \(myURL)")
        print("closure user: \(user)")
    })
}

func retext(cardNumber: String, name: String, toNumber: String) {
    postBarcodeToFirebase(user: cardNumber, completionHandler: { myURL -> Void in
        sendBarcodeToSMS(toNumber: toNumber, name: name, number: cardNumber, mediaURL: myURL)
        print("inside closure now")
        print("closure url: \(myURL)")
    })
}

