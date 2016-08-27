//
//  TableViewModel.swift
//  RxDemoScrollerView
//
//  Created by mubin on 16/8/20.
//  Copyright © 2016年 Mubin. All rights reserved.
//

import Foundation
import RxSwift


struct TableViewModel:BaseViewController {
    
    var dataSource: Variable<[Model]>
    //input
    
    let selectPublic = PublishSubject<NSIndexPath>()
    
    let deletePublic = PublishSubject<NSIndexPath>()
    
    let insertPublic = PublishSubject<Void>()
    
    //output
    let itemSeleted:Observable<AlterViewModel>
    

    init() {
        //初始化数据源
        var arr = [Model]()
       
        for _ in 0...2 {
            let date = NSDate()
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss.SSS"
            let strNowTime = timeFormatter.stringFromDate(date) as String
            let model = Model.init(text: strNowTime)
            arr.append(model)
        }
        
        let tempDataSource = Variable<[Model]>(arr)
        
        self.dataSource = tempDataSource
        
        
        itemSeleted = selectPublic.asObservable()
            .map{ AlterViewModel.init(model: tempDataSource.value[$0.row])
        }
        
        self.deletePublic.subscribeNext{ value in
            ModelServer.delete().onNext((value.row))
            }
        .addDisposableTo(mb_disposeBag)
        
        insertPublic.subscribeNext{
            ModelServer.insert().onNext(Model.init(text: self.getLocationTime()))
        }.addDisposableTo(mb_disposeBag)
        
        self.modelServer()
    }
    
    
    func getLocationTime() -> String {
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss.SSS"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        return strNowTime
    }

    
    
    func modelServer() -> Void {
        
        
        ModelServer.update().subscribeNext{ value in
            if let index = self.dataSource.value.indexOf(value) {
                self.dataSource.value[index] = value
                }
            }
            .addDisposableTo(mb_disposeBag)
        
        ModelServer.delete().subscribeNext{
            self.dataSource.value.removeAtIndex($0)
            }
            .addDisposableTo(mb_disposeBag)
        
        
        ModelServer.insert().subscribeNext{ value in
            self.dataSource.value.insert(value, atIndex: 0)
            }
            .addDisposableTo(mb_disposeBag)
        
    }
    
}



