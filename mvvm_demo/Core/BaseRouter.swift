//
//  BaseRouter.swift
//  Pyaterochka
//
//  Created by Igor Vedeneev on 09.07.2018.
//  Copyright © 2019 AGIMA. All rights reserved.
//

import UIKit

class BaseRouter: NSObject {
    @objc init(sourceViewController: UIViewController) {
        self.sourceViewController = sourceViewController
    }
    
    weak var sourceViewController: UIViewController?
}
