//
//  FeedItem.swift
//  mvvm_demo
//
//  Created by Igor Vedeneev on 3/5/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import Foundation

struct FeedItem: Codable {
    let id: Int
    let imageUrl: String
    let title: String
    let description: String
}
