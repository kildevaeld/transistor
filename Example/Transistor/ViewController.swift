//
//  ViewController.swift
//  Transistor
//
//  Created by Rasmus Kildevæld on 06/04/2016.
//  Copyright (c) 2016 Rasmus Kildevæld. All rights reserved.
//

import UIKit
import Transistor
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let my = segue as? SlideUpSegue {
            my.dimmed = false
        }
    }
    
}

