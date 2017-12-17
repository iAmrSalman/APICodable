//
//  APIBase.swift
//  APICodable
//
//  Created by Amr Salman on 12/17/17.
//

import Foundation

public protocol APIBase {
    static var baseURL: String {get}
    static var headers: [String: String]? {get}
}
