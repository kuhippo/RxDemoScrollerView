//
//  AlterViewModel.swift
//  RxDemoScrollerView
//
//  Created by mubin on 16/8/20.
//  Copyright © 2016年 Mubin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
struct AlterViewModel {
    
    //Input
    let textVari : Variable<String>
    let doneDrive:Driver<Void>
    
    //Output
    var modol:Model
    let pub = PublishSubject<Void>.init()
    
    
    init(model:Model){
    self.modol = model
        
    textVari = Variable.init(modol.text)
    
    //Driver 不能是观察者(Observe) Subject起到嫁接的效果
    doneDrive = pub.asDriver(onErrorJustReturn: ())
  
        
    }
    
    
}