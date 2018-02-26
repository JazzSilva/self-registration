//
//  requestFunctions.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/21/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import Firebase


func postBarcodeToFirebase(user: user) {
    guard let number = user.libraryCardNumber else {
        return
    }
    guard let pngData = UIImagePNGRepresentation(generateBarcode(from: number)!) else {
        return
    }
    let imageName = NSUUID().uuidString
    let storageReference = Storage.storage().reference(forURL: "gs://self-registration-5e729.appspot.com")
    let barcodeReference = storageReference.child("barcodes").child("\(imageName).png")
    
    barcodeReference.putData(pngData, metadata: nil, completion: { (metadata, error) in
        if error != nil {
            print(error.debugDescription)
        }
        if let profileImageURL = metadata?.downloadURL()?.absoluteString {
            print("Successfully stored barcode at path \(profileImageURL)")
        }
    })
}

