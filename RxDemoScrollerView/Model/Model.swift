//
//  Model.swift
//  RxDemoScrollerView
//
//  Created by mubin on 16/8/20.
//  Copyright © 2016年 Mubin. All rights reserved.
//

import Foundation

struct Model:Identifiable {
    
    var id: String = NSUUID().UUIDString
    
    var text:String
    
    init(text:String){
        self.text = text
    }
}