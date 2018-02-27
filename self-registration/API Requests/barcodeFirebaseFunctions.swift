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

func postBarcodeToFirebase(user: user, completionHandler: @escaping CompletionHandler) {
    guard let number = user.libraryCardNumber else {
        return
    }
    guard let pngData = UIImagePNGRepresentation(generateBarcode(from: number)!) else {
        return
    }
    let imageName = NSUUID().uuidString
    var profileImageURL = ""
    let storageReference = Storage.storage().reference(forURL: "gs://self-registration-5e729.appspot.com")
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
    postBarcodeToFirebase(user: user, completionHandler: { myURL -> Void in
        sendBarcodeToSMS(user: user, mediaURL: myURL)
        print("inside closure now")
        print("closure url: \(myURL)")
        print("closure user: \(user)")
    })
}

