//
//  Mapper.swift
//  Pyaterochka
//
//  Created by Igor Vedeneev on 14.08.2018.
//  Copyright © 2018 Zeno Inc. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol MapperProtocol {
    func map<MappingResult: Codable>(data: Data, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy, rootKey: String?) -> SignalProducer<MappingResult, Error>
}

extension MapperProtocol {
    func map<MappingResult: Codable>(data: Data) -> SignalProducer<MappingResult, Error> {
        return map(data: data, dateDecodingStrategy: .deferredToDate, rootKey: nil)
    }
}


final class Mapper : MapperProtocol {
    func map<MappingResult>(data: Data, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy, rootKey: String?) -> SignalProducer<MappingResult, Error> where MappingResult : Decodable, MappingResult : Encodable {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            let result = try decoder.decode(MappingResult.self, from: data)
            return SignalProducer(value: result)
        } catch {
            return SignalProducer(error: .mapping)
        }
    }
}
