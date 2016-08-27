//
//  ViewController.swift
//  RxDemoScrollerView
//
//  Created by mubin on 16/8/18.
//  Copyright © 2016年 Mubin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD
class ViewController: UIViewController,BaseViewController {
    
    let screenBound = UIScreen.mainScreen().bounds.size
    
    
    @IBOutlet weak var turnBarButton: UIButton!
    
    @IBOutlet weak var scrollerView: UIScrollView!
    
    @IBOutlet weak var lastButton: UIButton!
    
    @IBOutlet weak var tableView: DemoTableView!
    
    //Register
    @IBOutlet weak var accountTextFiled: UITextField!
    
    @IBOutlet weak var pwdTextFiled: UITextField!
    
    @IBOutlet weak var againTextFiled: UITextField!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    //添加Cell
    var addCellSub:PublishSubject<Void>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountTextFiled.layer.borderWidth = 1
        pwdTextFiled.layer.borderWidth = 1
        againTextFiled.layer.borderWidth = 1
        registerButton.layer.cornerRadius = 6
        
        //导航栏
        navBind()
        //注册
        registerBind()
        //tableView
        tableViewBind()
  
        
    }
    
    func navBind() -> Void {
        
        //添加Cell
        let addCellSubject = PublishSubject<Void>()
    
        self.addCellSub = addCellSubject
    
        //返回上一页
        let pgUpSubject = PublishSubject<CGPoint>()
    
        let last = lastButton.rx_tap.map{CGPointMake(0, 0)}
    
        Observable.of(pgUpSubject,last)
            .merge()
            .subscribeNext{self.scrollerView.setContentOffset($0, animated: true)}
            .addDisposableTo(mb_disposeBag)
    
        turnBarButton.rx_tap
            .flatMap{ self.scrollerView.rx_contentOffset.take(1) }
            .filter{$0.x>=self.view.frame.size.width}
            .map{_ in  }
            .bindTo(addCellSubject)
            .addDisposableTo(mb_disposeBag)
    
    
        turnBarButton.rx_tap
            .flatMap{ self.scrollerView.rx_contentOffset.take(1) }
            .filter{$0.x<self.view.frame.size.width}
            .doOnNext{ _ in self.view.endEditing(true)}
            .map{_ in CGPointMake(self.view.frame.size.width, 0)}
            .bindTo(pgUpSubject)
            .addDisposableTo(mb_disposeBag)

        scrollerView.rx_contentOffset
            .map{ $0.x >= self.view.frame.size.width ? false:true }
            .doOnNext{
                if $0 == true {
                    self.turnBarButton.setTitle("next", forState: .Normal)
                }
                else{ self.turnBarButton.setTitle("add", forState: .Normal)
                }}
            .bindTo(lastButton.rx_hidden)
            .addDisposableTo(mb_disposeBag)
        
        
    }
    
    func registerBind() -> Void {
        
        
        let viewModel = ViewModel.init(input: (
        account: self.accountTextFiled.rx_text.asDriver(),
            pwd: pwdTextFiled.rx_text.asDriver(),
         verify: againTextFiled.rx_text.asDriver(),
       register: registerButton.rx_tap.asObservable()))
        
        //OutPut
        viewModel.accountCheekColor
            .drive(accountTextFiled.rx_layerColor)
            .addDisposableTo(mb_disposeBag)
        
        viewModel.pwdCheekColor
            .drive(pwdTextFiled.rx_layerColor)
            .addDisposableTo(mb_disposeBag)
        
        viewModel.verifyColor
            .drive(againTextFiled.rx_layerColor)
            .addDisposableTo(mb_disposeBag)
        
        viewModel.enableRegister
            .drive(registerButton.rx_enabled)
            .addDisposableTo(mb_disposeBag)
        
        viewModel.enableRegister
            .drive(registerButton.rx_backGroundColor)
            .addDisposableTo(mb_disposeBag)
        
        viewModel.registerPublic
            .catchErrorJustReturn("注册失败")
            .subscribe(onNext: { string in
                
            SVProgressHUD.showSuccessWithStatus(string)
            SVProgressHUD.dismissWithDelay(1)})
            
            .addDisposableTo(mb_disposeBag)
    }
    
    func tableViewBind() -> Void {
        
        let viewModel = TableViewModel.init()

        
        //Input
        tableView.rx_itemSelected
            .bindTo(viewModel.selectPublic)
            .addDisposableTo(mb_disposeBag)
        
        tableView.rx_itemDeleted
            .bindTo(viewModel.deletePublic)
            .addDisposableTo(mb_disposeBag)
        
        //Output
        viewModel.dataSource.asObservable().bindTo(tableView.rx_itemsWithCellIdentifier("cell", cellType: UITableViewCell.self)){
            (row, rowName, cell) in
            
            cell.textLabel?.text = viewModel.dataSource.value[row].text }
            
            .addDisposableTo(mb_disposeBag)
        
        viewModel.itemSeleted.subscribeNext {[unowned self] viewModel in
            let vc = AlterViewController.init(viewModel: viewModel, index: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            }
            .addDisposableTo(mb_disposeBag)
        
        // addCellSubject
        self.addCellSub.bindTo(viewModel.insertPublic)
            .addDisposableTo(mb_disposeBag)
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.automaticallyAdjustsScrollViewInsets = false
    }
 

}

private extension UITextField{
    
    var rx_layerColor: AnyObserver<UIColor> {
        return UIBindingObserver(UIElement: self, binding: { (button, color) in
            button.layer.borderColor = color.CGColor
        }).asObserver()
    }

}


private extension UIButton{
    
    var rx_backGroundColor: AnyObserver<Bool> {
        return UIBindingObserver(UIElement: self, binding: { (button, enable) in
            if enable == true {
                button.backgroundColor = UIColor.greenColor()
            }else{
                button.backgroundColor = UIColor.init(colorLiteralRed: 0.9, green: 0.3, blue: 0.3, alpha: 0.5)
            }
        }).asObserver()
    }
    
}

