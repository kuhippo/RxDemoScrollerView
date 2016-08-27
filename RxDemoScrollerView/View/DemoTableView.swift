//
//  DemoTableView.swift
//  RxDemoScrollerView
//
//  Created by mubin on 16/8/19.
//  Copyright © 2016年 Mubin. All rights reserved.
//

import UIKit
import RxSwift

class DemoTableView: UITableView {

    override func awakeFromNib() {
        self.tableFooterView = UIView.init()
        self.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.delegate = self
    }
}

extension DemoTableView:UITableViewDelegate
{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}