//
//  ViewController.swift
//  UIBezierPathFromString
//
//  Created by Johnny Wang on 2018/6/8.
//  Copyright © 2018年 Johnny Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for names in UIFont.familyNames {
            print("(\(names))")
            for name in UIFont.fontNames(forFamilyName: names) { print(name) }
            print(" ")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

