//
//  ListTableviewController.swift
//  SwiftBondSample
//
//  Created by NakaharaShun on 10/31/15.
//  Copyright © 2015 NakaharaShun. All rights reserved.
//

import UIKit
import Bond

class ListTableviewController: UITableViewController {
    
    var listTableViewModel: ListTableViewModel!
    var dataSource: ObservableArray<ObservableArray<ListTableViewCellModel>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // set refresh control
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("reloadModelData:"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        // create view model
        self.listTableViewModel = ListTableViewModel(githubApi: "https://api.github.com/repositories")
        self.dataSource = ObservableArray([self.listTableViewModel.repositoryTableViewCellViewModel])
        
        let createCell = { (indexPath: NSIndexPath, dataSource: ObservableArray<ObservableArray<ListTableViewCellModel>>, tableView: UITableView) -> UITableViewCell in
            
            
            guard let cell: ListTableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? ListTableViewCell else {
                return UITableViewCell()
            }
            
            let viewModel: ListTableViewCellModel = dataSource[indexPath.section][indexPath.row]
            
            viewModel.name.bindTo(cell!.titleLabel.bnd_text).disposeIn(cell!.bnd_bag)
            
            viewModel.userName.bindTo(cell!.descriptionLabel.bnd_text).disposeIn(cell!.bnd_bag)
            
            viewModel.photo.bindTo(cell!.iconImageView.bnd_image).disposeIn(cell!.bnd_bag)
            
            viewModel.fetchPhotoIfNeed()
            
            return cell!
        }
        
        dataSource.bindTo(self.tableView, createCell: createCell)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.listTableViewModel.nextPageOfRespositories {
        }
    }
    
    
    internal func reloadModelData(refreshControl: UIRefreshControl) {
        
        self.listTableViewModel.nextPageOfRespositories {
            refreshControl.endRefreshing()
        }
        
    }
}
