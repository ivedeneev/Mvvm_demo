//
//  FeedRouter.swift
//  mvvm_demo
//
//  Created by Igor Vedeneev on 3/4/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import UIKit

final class FeedRouter : BaseRouter {
    func showDetail(viewModel: FeedDetailViewModelProtocol) {
        let vc = FeedDetailVIewController()
        vc.viewModel = viewModel
        sourceViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
