//
//  AppDelegateRouter.swift
//  mvvm_demo
//
//  Created by Igor Vedeneev on 3/4/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import UIKit

final class AppDelegateRouter {
    private weak var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func setupRootViewController() {
        let vc = FeedViewController()
        let router = FeedRouter(sourceViewController: vc)
        vc.viewModel = FeedViewModel(service: MockFeedService(), router: router)
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.tintColor = Color.navigationBarTint
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
