//
//  EndPointType.swift
//  Netflix
//
//  Created by Sandra on 02/01/2024.
//

import Foundation
import Alamofire

protocol EndPointType {
    var baseURL : String { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    var headers: HTTPHeaders? { get }
}

enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Task {
    case requestPlain
    case requestParam(parameters: QueryParams, encoding: ParameterEncoding)
}

typealias HTTPheaders = [String : Any]
typealias QueryParams = [String : Any]
