//
//  extensions.swift
//  self-registration
//
//  Created by Jasmin Silva on 2/18/18.
//  Copyright © 2018 Makina. All rights reserved.
//

import Foundation
import UIKit

extension String {
    //This fuction will parse through the encrypted ID track data and use
    //regular expressions to sort the data into the correct fields
    func capturedGroups(withRegex pattern: String) -> [String] {
        var results = [String]()
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }
        
        let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count))
        guard let match = matches.first else { return results }
        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return results }
        
        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            let matchedString = (self as NSString).substring(with: capturedGroupIndex)
            results.append(matchedString)
        }
        return results
    }
}

extension UIViewController {
    //These extensions will move the keyboard below the active text field
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 50
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 50
            }
        }
    }
}

func generateBarcode(from string: String) -> UIImage? {
    //This function will generate a barcode from a string of text
    
    let data = string.data(using: String.Encoding.ascii)
    
    if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
        filter.setDefaults()
        //Margin
        filter.setValue(7.00, forKey: "inputQuietSpace")
        filter.setValue(data, forKey: "inputMessage")
        //Scaling
        let transform = CGAffineTransform(scaleX: 3, y: 3)
        
        if let output = filter.outputImage?.transformed(by: transform) {
            let context:CIContext = CIContext.init(options: nil)
            let cgImage:CGImage = context.createCGImage(output, from: output.extent)!
            let rawImage:UIImage = UIImage.init(cgImage: cgImage)
            
            //Refinement code to allow conversion to NSData or share UIImage.
            let cgimage: CGImage = (rawImage.cgImage)!
            let cropZone = CGRect(x: 0, y: 0, width: Int(rawImage.size.width), height: Int(rawImage.size.height))
            let cWidth: size_t  = size_t(cropZone.size.width)
            let cHeight: size_t  = size_t(cropZone.size.height)
            let bitsPerComponent: size_t = cgimage.bitsPerComponent
            //THE OPERATIONS ORDER COULD BE FLIPPED, ALTHOUGH, IT DOESN'T AFFECT THE RESULT
            let bytesPerRow = (cgimage.bytesPerRow) / (cgimage.width  * cWidth)
            let context2: CGContext = CGContext(data: nil, width: cWidth, height: cHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: cgimage.bitmapInfo.rawValue)!
            context2.draw(cgimage, in: cropZone)
            let result: CGImage  = context2.makeImage()!
            let finalImage = UIImage(cgImage: result)
            return finalImage
        }
    }
    return nil
}

