//
//  requestFunctions.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/21/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import Firebase

/*
func postBarcodeToFirebase(barcode: UIImage) -> String {
    //Store Barcode image
    let barimage = convert(cmage: (barcode.ciImage)!)
    let PNG: Data = UIImagePNGRepresentation(barimage)! as Data
    let imgName = NSUUID().uuidString
    let storageRef = Storage.storage().reference(forURL: "gs://hcpl-library-card.appspot.com/")
    let barRef = storageRef.child("barcodes").child("\(imgName).png")
    
    barRef.putData(PNG, metadata: nil, completion: { (metadata, error) in
        if error != nil {
            print(error)
            return
        }
        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
            print("Sucessfully stored barcode at path \(profileImageURL)")
            return profileImageUrl
        }
    })
}

private func generateBarcodeForUser(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.ascii)
    
    if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)
        
        if let output = filter.outputImage?.transformed(by: transform) {
            return UIImage(ciImage: output)
        }
    }
    
    return nil
}*/

