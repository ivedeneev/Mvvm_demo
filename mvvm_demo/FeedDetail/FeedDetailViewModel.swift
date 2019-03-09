//
//  FeedDetailViewModel.swift
//  mvvm_demo
//
//  Created by Igor Vedeneev on 3/5/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import Foundation
import UIKit

protocol FeedDetailViewModelProtocol {
    var title: String { get }
    var imageUrl: URL? { get }
    var descriptionText: TextViewModel  { get }
}

final class FeedDetailViewModel: FeedDetailViewModelProtocol {
    let title: String
    let imageUrl: URL?
    let descriptionText: TextViewModel
    
    init(feedItem: FeedItem) {
        self.title = feedItem.title
        self.imageUrl = URL(string: feedItem.imageUrl)
        self.descriptionText = TextViewModel(text: feedItem.description, style: TextStyle.listSubtitle, maxWidth: UIScreen.main.bounds.width - 16 * 2)
    }
}
