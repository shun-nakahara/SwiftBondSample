//
//  ListTableViewCellModel.swift
//  SwiftBondSample
//
//  Created by NakaharaShun on 10/31/15.
//  Copyright © 2015 NakaharaShun. All rights reserved.
//

import UIKit
import Bond

class ListTableViewCellModel {
    
    let name: Observable<String>
    let userName: Observable<String>
    let photo: Observable<UIImage?> = Observable<UIImage?>(nil)
    let photoUrl: String?
    
    init(name: String, userName: String, photoUrl: String?) {
        self.name = Observable<String>(name)
        self.userName = Observable<String>(userName)
        self.photoUrl = photoUrl
    }
    
    func fetchPhotoIfNeed() {
        
        if self.photo.value != nil || self.photoUrl == nil {
            return
        }
        
        guard let url: NSURL = NSURL(string: self.photoUrl!) else {
            return
        }
        
        let completionHandler: (NSURL?, NSURLResponse?, NSError?) -> Void = { (url: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if (url == nil) {
                return
            }
            
            guard let data: NSData = NSData(contentsOfURL: url!) else {
                return
            }
            
            guard let image: UIImage = UIImage(data: data) else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.photo.value = image
            })
            
        }
        
        let downloadTask: NSURLSessionTask = NSURLSession.sharedSession().downloadTaskWithURL(url, completionHandler: completionHandler)
        downloadTask.resume()
        
    }
    
}
