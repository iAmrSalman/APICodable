//
//  Returnable.swift
//  APICodable
//
//  Created by Amr Salman on 12/17/17.
//

import Foundation

public protocol Returnable {
    init(from: Data) throws
}

public extension Returnable where Self: Decodable {
    
    public init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}
