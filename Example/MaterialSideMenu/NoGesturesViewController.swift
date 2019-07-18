//
//  NoGesturesViewController.swift
//  MaterialSideMenu
//
//  Created by Logomorph on 17/07/2019.
//  Copyright © 2019 Logomorph. All rights reserved.
//

import UIKit
import MaterialSideMenu

class NoGesturesViewController: UIViewController, MaterialSideMenuNeedsGestures {
    var needsGestures: Bool { return false }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "No side gestures"
    }

}
