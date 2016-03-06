//
//  ViewController.swift
//  FilterLayer
//
//  Created by Bastian Kohlbauer on 06.03.16.
//  Copyright © 2016 Bastian Kohlbauer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let filters: [BKFilterType] = [
        .ColorCrossPolynomial,
        .ColorCube,
        .ColorCubeWithColorSpace,
        .ColorInvert,
        .ColorMap,
        .ColorMonochrome,
        .ColorPosterize,
        .FalseColor,
        .MaskToAlpha,
        .MaximumComponent,
        .MinimumComponent,
        .PhotoEffectChrome,
        .PhotoEffectFade,
        .PhotoEffectInstant,
        .PhotoEffectMono,
        .PhotoEffectNoir,
        .PhotoEffectProcess,
        .PhotoEffectTonal,
        .PhotoEffectTransfer,
        .SepiaTone,
        .Vignette]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let tableView = UITableView(frame: CGRectMake(0.0, 20.0, self.view.bounds.size.width, self.view.bounds.size.height-20.0), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, .FlexibleWidth]
        tableView.separatorColor = UIColor.clearColor()
        tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(tableView)
    }

    //MARK:- UITableView
    
    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    internal func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "cellIdentifier"
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        cell.textLabel?.text = filters[indexPath.row].getCIFilterName()
        return cell
    }
    
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = FilterDemonstationViewController()
        let nc = UINavigationController(rootViewController: vc)
        self.presentViewController(nc, animated: true) { () -> Void in
            vc.setFiltertype(self.filters[indexPath.row])
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

