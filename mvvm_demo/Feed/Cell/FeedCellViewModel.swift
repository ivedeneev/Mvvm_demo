//
//  FeedCellViewModel.swift
//  mvvm_demo
//
//  Created by Igor Vedeneev on 3/4/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import Foundation
import UIKit.UIScreen

final class FeedCellViewModel: Hashable {
    static func == (lhs: FeedCellViewModel, rhs: FeedCellViewModel) -> Bool {
        return lhs.feedItemId == rhs.feedItemId
    }
    
    let url: URL?
    let title: TextViewModel
    let subtitle: TextViewModel
    private let feedItemId: Int
    
    var hashValue: Int {
        return feedItemId
    }
    
    init(feed: FeedItem) {
        feedItemId = feed.id
        url = URL(string: feed.imageUrl)
        title = TextViewModel(text: feed.title, style: TextStyle.listTitle, maxWidth: UIScreen.main.bounds.width - 8 * 5 - 40, numberOfLines: 1)
        subtitle = TextViewModel(text: feed.description, style: TextStyle.listSubtitle, maxWidth: UIScreen.main.bounds.width - 8 * 5 - 40, numberOfLines: 3)
    }
}
