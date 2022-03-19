//
//  ViewController.swift
//  MainTabView
//
//  Created by mozead1996 on 03/19/2022.
//  Copyright (c) 2022 mozead1996. All rights reserved.
//

import UIKit
import MainTabView

class ViewController: UIViewController  {
    @IBOutlet weak var mainTabView: MainTabView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainTabView?.dataSource = self
        mainTabView?.delegate = self
    }
    
    
}


extension ViewController: MainTabViewDataSource, MainTabDelegate {
    
    func viewControllersToBeHosted(in MainTabView: MainTabView) -> [TabItem] {
        let firstVC = instance(FirstViewController.self)//FirstViewController.instance()
        let secondVC = instance(SecondViewController.self)
        let thirdVC = instance(ThirdViewController.self)
        
        return [firstVC,secondVC,thirdVC]
    }
    
    func didSelectItemAt(index: Int) {
        print(index)
    }
    
}



extension UIViewController{
    
   
    
    
    func instance<T: UIViewController>(_ type : T.Type)->T{
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier(type: T.self))
        return vc as! T
    }
    
    func identifier(type : UIViewController.Type)->String{
        return String(describing: type)
    }
}
