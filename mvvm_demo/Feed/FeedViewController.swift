//
//  ViewController.swift
//  mvvm_demo
//
//  Created by Igor Vedeneev on 3/4/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

class FeedViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var director = CollectionDirector(colletionView: collectionView)
    private let section = CollectionSection()
    
    var viewModel: FeedViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        navigationController?.navigationBar.barStyle = .black
        title = "Feed"
        
        viewModel.loadFeed().startWithResult { (result) in
            guard let feed = result.value else { return }
            self.configureDirector(feed: feed)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(shuffle))
    }
    
    @objc func shuffle() {
        let items = viewModel.shuffleFeeds()
        configureDirector(feed: items)
    }

    private func setupCollectionView() {
        collectionView.frame = view.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = Color.black
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        director += section
        section.insetForSection = UIEdgeInsetsMake(8, 8, 8, 8)
        section.lineSpacing = 8
        director.reload()
    }
    
    private func configureDirector(feed: [FeedCellViewModel]) {
        section.removeAll()
        section += feed.map { vm -> AbstractCollectionItem in
            CollectionItem<FeedCell>(item: vm)
                .adjustsWidth(true)
                .onSelect({ [weak self] indexPath in
                    self?.viewModel.showDetail(at: indexPath.row)
                })
        }
        director.performUpdates()
    }
}

