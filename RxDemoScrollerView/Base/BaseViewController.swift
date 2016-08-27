//
//  BaseViewModel.swift
//  RxDemoScrollerView
//
//  Created by mubin on 16/8/20.
//  Copyright © 2016年 Mubin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

var mb_disposeBag:DisposeBag = DisposeBag()

protocol BaseViewController {
    
}

extension BaseViewController {
    
    func requestNetWork(url:String,dic:[String:AnyObject]) -> Observable<[String:AnyObject]> {
        return Observable.create({ subject -> Disposable in
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.4 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                
                subject.onNext(["test":"testData"])
                subject.onCompleted()
                
            }
            return NopDisposable.instance
        })
    }
    
    
}

extension BaseViewController where Self:UIViewController{
    
    
    func addRightBarButton(title:String) -> Driver<Void> {
        let button = UIButton.init(type: UIButtonType.System)
        button.titleLabel?.textAlignment = .Left
        button.setTitle(title, forState: .Normal)
        button.frame = CGRectMake(0, 0, 40, 40)
        button.titleLabel?.sizeToFit()
        let barButton = UIBarButtonItem.init(customView: button)
        
        self.navigationItem.rightBarButtonItem = barButton
        return button.rx_tap.asDriver()
    }

}