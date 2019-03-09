//
//  FeedDetailVIewController.swift
//  mvvm_demo
//
//  Created by Igor Vedeneev on 3/5/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import UIKit
import ReactiveCocoa

final class FeedDetailVIewController : UIViewController {
    var viewModel: FeedDetailViewModelProtocol!
    
    private let imageView = UIImageView()
    private let descriptionLabel = LTLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = viewModel.title
        view.backgroundColor = Color.background
        
        let imageSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        view.addSubview(imageView)
        imageView.contentMode = .center
        imageView.setImage(url: viewModel.imageUrl,
                           placeholder: UIImage.imageWithColor(color: Color.feedImageBackground, size: imageSize),
                           size: imageSize,
                           backgroundColor: Color.feedImageBackground,
                           cornerMask: nil,
                           cornerRadius: nil,
                           takeUntil: reactive.trigger(for: #selector(UIViewController.viewDidDisappear(_:))))
        
        view.addSubview(descriptionLabel)
        descriptionLabel.backgroundColor = Color.background
        descriptionLabel.text = viewModel.descriptionText
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageY = navigationController!.navigationBar.frame.maxY
        imageView.frame = CGRect(x: 0, y: imageY, width: view.bounds.width, height: 200)
        descriptionLabel.frame = CGRect(x: 16,
                                        y: imageView.frame.maxY + 16,
                                        width: view.bounds.width - 16 * 2,
                                        height: viewModel.descriptionText.size.height)
    }
}
