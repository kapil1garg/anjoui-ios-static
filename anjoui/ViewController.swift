//
//  ViewController.swift
//  anjoui
//
//  Copyright (c) 2015 anjoui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let font = UIFont(name: "JosefinSans-Light.ttf", size: 30) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

