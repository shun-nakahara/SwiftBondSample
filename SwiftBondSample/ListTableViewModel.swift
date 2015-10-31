//
//  ListTableViewModel.swift
//  SwiftBondSample
//
//  Created by NakaharaShun on 10/31/15.
//  Copyright © 2015 NakaharaShun. All rights reserved.
//

import UIKit
import Bond

class ListTableViewModel {
    
    let repositoryTableViewCellViewModel: ObservableArray<ListTableViewCellModel> = ObservableArray<ListTableViewCellModel>([])
    
    private let apiURL: String
    private var since = 0
    
    init(githubApi: String) {
        self.apiURL = githubApi
    }
    
    func nextPageOfRespositories(completion: (Void) -> Void) {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {

            guard let url: NSURL = NSURL(string: "\(self.apiURL)?since=\(self.since)") else {
                return
            }
            
            guard let data: NSData = NSData(contentsOfURL: url) else {
                return
            }
            
            var jsonResult: NSArray?
            do {
                jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? NSArray
            } catch  {
                return
            }

            dispatch_async(dispatch_get_main_queue(), {
                
                var newRepos: [ListTableViewCellModel] = []
                
                for repo in jsonResult! {
                    
                    guard let report: NSDictionary = repo as? NSDictionary else {
                        continue
                    }
                    
                    let id: Int = report["id"] as? Int ?? 0
                    let name: String = report["name"] as? String ?? ""

                    var userName: String = ""
                    var photoUrl: String? = nil
                    if let owner: NSDictionary = report["owner"] as? NSDictionary {
                        userName = owner["login"] as? String ?? ""
                        photoUrl = owner["avatar_url"] as? String
                    }
                    
                    self.since = max(self.since, id)
                    
                    let tableViewCellModel: ListTableViewCellModel = ListTableViewCellModel(name: name, userName: userName, photoUrl: photoUrl)
                
                    newRepos.append(tableViewCellModel)
                }
                self.repositoryTableViewCellViewModel.insertContentsOf(newRepos.reverse(), atIndex: 0)
                completion()
            })
        })
    }
}
