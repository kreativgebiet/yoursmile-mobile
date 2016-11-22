//
//  HelperFunctions.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import Photos
import Locksmith

class HelperFunctions: NSObject {
    
    class func presentAlertViewfor(error: String, presenter: UIViewController) {
        let alertController = UIAlertController(title: "ERROR".localized, message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        presenter.present(alertController, animated: true, completion: nil)
    }
    
    //Information
    
    class func presentAlertViewfor(information: String, presenter: UIViewController) {
        let alertController = UIAlertController(title: "INFORMATION".localized, message: information, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        presenter.present(alertController, animated: true, completion: nil)
    }
    
    //http://stackoverflow.com/questions/28259961/swift-how-to-get-last-taken-3-photos-from-photo-library
    var images: [UIImage] = [UIImage]()
    
    public func fetchLastPhoto(targetSize: CGSize) -> UIImage? {
        self.fetchPhotoAtIndexFromEnd(targetSize: targetSize, 0)
        
        return images.last
    }
    
    func fetchPhotoAtIndexFromEnd(targetSize: CGSize, _ index:Int) {
        
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        // Sort the images by creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions) {
            
            // If the fetch result isn't empty,
            // proceed with the image request
            if fetchResult.count > 0 {
                // Perform the image request
                imgManager.requestImage(for: fetchResult.object(at: fetchResult.count - 1 - index) as PHAsset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    // Add the returned image to your array
                    self.images.append(image!)
                    
                    // If you haven't already reached the first
                    // index of the fetch result and if you haven't
                    // already stored all of the images you need,
                    // perform the fetch request again with an
                    // incremented index
                    if index + 1 < fetchResult.count && self.images.count < 1 {
                        self.fetchPhotoAtIndexFromEnd(targetSize: targetSize, index + 1)
                    } else {
                        // Else you have completed creating your array
                        print("Completed array: \(self.images)")
                    }
                })
            }
        }
    }

}
