//
//  ViewModel.swift
//  RxDemoScrollerView
//
//  Created by mubin on 16/8/19.
//  Copyright © 2016年 Mubin. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SVProgressHUD


let minimumAccountCount = 7
let minmunPwdNumCount = 7


enum  ErrorEnum:ErrorType{
    case test
}


struct ViewModel:BaseViewController {
    
    //output
    let lastSubject = PublishSubject<Void>()

    let nextSubject = PublishSubject<Void>()
    
    let registerPublic = PublishSubject<String>()
    //账号layer 颜色
    let  accountCheekColor:Driver<UIColor>
    //密码layer 颜色
    let pwdCheekColor:Driver<UIColor>
    //再次输入layer 颜色
    let verifyColor:Driver<UIColor>
    //register enable
    let enableRegister:Driver<Bool>
    
    
    init(input:(account:Driver<String>
                   ,pwd:Driver<String>
                ,verify:Driver<String>
              ,register:Observable<Void>))
    {
        
        
        
        
        accountCheekColor = input.account
            .map{
                $0.characters.count >= minimumAccountCount || $0.characters.count == 0 ? UIColor.clearColor():UIColor.redColor()
        }
        
       pwdCheekColor = input.pwd
            .map{
                $0.characters.count >= minmunPwdNumCount || $0.characters.count == 0 ? UIColor.clearColor():UIColor.redColor()
        }
          
       verifyColor  = Driver.combineLatest(input.pwd, input.verify) { (value1, value2) -> UIColor in
               value2 == value1 || value2.characters.count == 0 ? UIColor.clearColor():UIColor.redColor()
        }
        
        enableRegister = Driver.combineLatest(input.account, input.pwd, input.verify, resultSelector: { value, value1, value2 -> Bool in
            value.characters.count >= minimumAccountCount && value1.characters.count >= minmunPwdNumCount && value1 == value2 ? true : false
        })
        
        
        
        input.register
            .flatMap{
                self.register()
            }
            .bindTo(registerPublic)
            .addDisposableTo(mb_disposeBag)
        
  
        
    }
    
}



extension ViewModel{
    
    func register() -> Observable<(String)> {
        
        return Observable<String>.create({ (subject) -> Disposable in
            SVProgressHUD.showWithStatus("正在加载")
            //请求接口
            self.requestNetWork("www.test.com",dic: ["demo":"test"])
                
                .subscribe(onNext: {  _ in
                        subject.onNext("注册成功")
                        subject.onCompleted()
                    }
                    , onError: { _ in
                        subject.onNext("注册失败")
                        subject.onError(ErrorEnum.test)
                    })
               
                .addDisposableTo(mb_disposeBag)
            
            return NopDisposable.instance
        })
    }
    
}