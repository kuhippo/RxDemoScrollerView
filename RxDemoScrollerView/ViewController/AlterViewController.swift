//
//  AlterViewController.swift
//  RxDemoScrollerView
//
//  Created by mubin on 16/8/20.
//  Copyright © 2016年 Mubin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class AlterViewController: UIViewController,BaseViewController {

    @IBOutlet weak var textFiled: UITextField!
    
    var viewModel:AlterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNav() -> Void {
        self.addRightBarButton("Done").drive(viewModel.pub).addDisposableTo(mb_disposeBag)
        
    }
    
    func bind() -> Void {
        //双向绑定
        (self.textFiled.rx_text <-> viewModel.textVari).addDisposableTo(mb_disposeBag)
        
        //确定修改
        self.viewModel.doneDrive.driveNext {[unowned self] in
            self.viewModel.modol.text = self.textFiled.text!
            ModelServer.update().onNext(self.viewModel.modol)
            self.navigationController?.popViewControllerAnimated(true)}
        .addDisposableTo(mb_disposeBag)

        
    }
    
    init(viewModel:AlterViewModel,index:Int?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("AlterViewController控制器销毁")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
