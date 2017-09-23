//
//  WebProtocol.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation


enum WebResponse<T> {
    case success(result: T)
    case failure(error: String)
}

protocol Request {
    var path: String { get }
    var parameter: [String: Any] { get }
    
    associatedtype Response: Parser
}

protocol Client {
    func send<T: Request>(_ r: T, _ handler: @escaping (WebResponse<T.Response>) -> Void)
    var host: String { get }
}

protocol Parser {
    static func parse(_ data: Any) -> Self?
}
