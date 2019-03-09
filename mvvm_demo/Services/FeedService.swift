//
//  FeedService.swift
//  mvvm_demo
//
//  Created by Igor Vedeneev on 3/5/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import Foundation
import ReactiveSwift


protocol FeedServiceProtocol {
    func loadFeed() -> SignalProducer<[FeedItem], Error>
}

final class MockFeedService: FeedServiceProtocol {
    private let mapper: MapperProtocol
    
    init(mapper: MapperProtocol = Mapper()) {
        self.mapper = mapper
    }
    
    func loadFeed() -> SignalProducer<[FeedItem], Error> {
        guard let url = Bundle(for: type(of: self)).url(forResource: "feed", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return SignalProducer(error: .mapping)
        }
        
        return mapper.map(data: data)
    }
}


