//
//  FeedViewModel.swift
//  mvvm_demo
//
//  Created by Igor Vedeneev on 3/4/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import Foundation
import ReactiveSwift


protocol FeedViewModelProtocol {
    func loadFeed() -> SignalProducer<[FeedCellViewModel], Error>
    func showDetail(at index: Int)
    func shuffleFeeds() -> [FeedCellViewModel]
}

final class FeedViewModel : FeedViewModelProtocol {
    private let service: FeedServiceProtocol
    private let router: FeedRouter
    private var feeds: [FeedItem] = []
    
    init(service: FeedServiceProtocol, router: FeedRouter) {
        self.service = service
        self.router = router
    }
    
    func loadFeed() -> SignalProducer<[FeedCellViewModel], Error> {
        return service.loadFeed()
            .on(error: {error in
                //error handling
            }, value: { [weak self] (items) in
                self?.feeds = items
            })
            .map { $0.map { FeedCellViewModel(feed: $0) } }
            .delay(1, on: QueueScheduler.main)
    }
    
    func showDetail(at index: Int) {
        let vm = FeedDetailViewModel(feedItem: feeds[index])
        router.showDetail(viewModel: vm)
    }
    
    func shuffleFeeds() -> [FeedCellViewModel] {
        feeds = feeds.shuffled()
        return feeds.map { FeedCellViewModel(feed: $0) }
    }
}
