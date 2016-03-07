//
//  ViewController.swift
//  FilterLayer
//
//  Created by Bastian Kohlbauer on 06.03.16.
//  Copyright © 2016 Bastian Kohlbauer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {    

    private var categories: [String]!
    private var filters: [[BKFilterType]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let collection: [String: [BKFilterType]] = BKFilterType.collection
        categories = Array(collection.keys).reverse()
        filters = Array(collection.values).reverse()
        
        let tableView = UITableView(frame: CGRectMake(0.0, 20.0, self.view.bounds.size.width, self.view.bounds.size.height-20.0), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, .FlexibleWidth]
        tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(tableView)
    }

    //MARK:- UITableView
    
    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return filters.count
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters[section].count
    }
    
    internal func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "cellIdentifier"
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        cell.textLabel?.text = filters[indexPath.section][indexPath.row].rawValue
        return cell
    }
    
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = FilterDemonstationViewController()
        let nc = UINavigationController(rootViewController: vc)
        self.presentViewController(nc, animated: true) { () -> Void in
            vc.setFiltertype(self.filters[indexPath.section][indexPath.row])
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    internal func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
}

