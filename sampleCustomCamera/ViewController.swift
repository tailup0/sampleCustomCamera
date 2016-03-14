//
//  ViewController.swift
//  sampleCustomCamera
//
//  Created by Wataru Maeda on 3/14/16.
//  Copyright © 2016 wataru maeda. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initView()
    }
    
    func initView()
    {
        // Button
        let btn: UIButton = UIButton(type: .Custom)
        btn.setImage(UIImage(named: "camera"), forState: .Normal)
        btn.frame = CGRectMake(0, 0, 70, 70)
        btn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
        btn.layer.cornerRadius = 35
        btn.layer.borderWidth = 3
        btn.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.2).CGColor
        btn.addTarget(self, action:"showCustomCamera", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
    }
    
    func showCustomCamera()
    {
        let vc = WMCamera()
        self.presentViewController(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}