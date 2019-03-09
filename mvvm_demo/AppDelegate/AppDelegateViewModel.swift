//
//  AppDelegateViewModel.swift
//  mvvm_demo
//
//  Created by Igor Vedeneev on 3/4/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import Foundation
import UIKit.UIApplication

protocol AppDelegateViewModelProtocol {
    func didFinishLaunching(options: [UIApplication.LaunchOptionsKey: Any]?)
}

final class AppDelegateViewModel : AppDelegateViewModelProtocol {
    private let router: AppDelegateRouter
    private weak var appDelegate: UIApplicationDelegate?
    
    init(router: AppDelegateRouter, appDelegate: UIApplicationDelegate) {
        self.router = router
        self.appDelegate = appDelegate
    }
    
    func didFinishLaunching(options: [UIApplication.LaunchOptionsKey: Any]?) {
        router.setupRootViewController()
    }
}
