//
//  ModelType.swift
//  RxDemoScrollerView
//
//  Created by mubin on 16/8/23.
//  Copyright © 2016年 Mubin. All rights reserved.
//



protocol Identifiable {
    associatedtype Identifier: Equatable
    var id: Identifier { get }
}
extension CollectionType where Generator.Element: Identifiable {
    
    func indexOf(element: Self.Generator.Element) -> Self.Index? {
        return self.indexOf { $0.id == element.id }
    }
    
}