//
//  ErrorHandler.swift
//  Netflix
//
//  Created by Sandra on 16/07/2023.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidUrl
    case noInternet
    case unableToDecode
    case unacceptableStatusCode
    case failedToLoadData
}
