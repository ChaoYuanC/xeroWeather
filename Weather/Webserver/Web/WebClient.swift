//
//  WebClient.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation
import Alamofire

struct CurrentWeatherService: Service {
    let host = WebConstants.host
    
    func send<T: Request>(_ r: T, _ handler: @escaping (WebResponse<T.Response>) -> Void) {
        
        Alamofire.request(host+r.path, method: .get, parameters: r.parameter).validate().responseJSON { (response) in
            switch response.result {
            case .success(let json):
                if let weather = T.Response.parse(json) {
                    handler(.success(result: weather))
                } else {
                    handler(.failure(error: "Parse Current Weather error"))
                }
            case .failure(let error):
                handler(.failure(error: error.localizedDescription))
            }

        }
    }
}
