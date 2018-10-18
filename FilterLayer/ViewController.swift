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
        self.view.backgroundColor = UIColor.white
        
        let collection: [String: [BKFilterType]] = BKFilterType.collection
        categories = collection.keys.reversed()
        filters = collection.values.reversed()
        
        let tableView = UITableView(frame: CGRect(x: 0.0, y: 20.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height-20.0), style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, .flexibleWidth]
        tableView.backgroundColor = UIColor.clear
        self.view.addSubview(tableView)
    }
    
    //MARK:- UITableView
    
    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return filters.count
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters[section].count
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cellIdentifier"
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        cell.textLabel?.text = filters[indexPath.section][indexPath.row].rawValue
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FilterDemonstationViewController()
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true) { () -> Void in
            vc.setFiltertype(type: self.filters[indexPath.section][indexPath.row])
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
}

