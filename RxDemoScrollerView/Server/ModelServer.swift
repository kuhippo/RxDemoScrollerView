//
//  ModelServer.swift
//  RxDemoScrollerView
//
//  Created by mubin on 16/8/22.
//  Copyright © 2016年 Mubin. All rights reserved.
//

import Foundation
import RxSwift

struct ModelServer {
    
    static let test = ModelServer.init()
    
    let updataPublic = PublishSubject<Model>()
    
    let deletePublic = PublishSubject<Int>()
    
    let insertPublic = PublishSubject<Model>()
    
    init(){
        
    }
    
    static func update() -> PublishSubject<Model> {
        
        return test.updataPublic
    }
    
    static func insert() -> PublishSubject<Model> {
        
        return test.insertPublic
    }
    
    static func delete() -> PublishSubject<Int> {
        
        return test.deletePublic
    }
    
}