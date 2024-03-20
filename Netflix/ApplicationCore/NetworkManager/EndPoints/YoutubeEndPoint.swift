//
//  YoutubeEndPoint.swift
//  Netflix
//
//  Created by Sandra on 03/01/2024.
//

import Foundation
import Alamofire

enum YoutubeEndPoint {
    case getYoutubeResults(queryValue: String)
}

extension YoutubeEndPoint : EndPointType {
    var headers: HTTPHeaders? {
        switch self {
        default:
            return [:]
        }
    }
    
    var baseURL: String {
        switch self {
        default:
            return AppConstants.youtubeBaseURL
        }
    }
    
    var path: String? {
        switch self {
        case .getYoutubeResults:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getYoutubeResults:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getYoutubeResults(let queryValue):
            return .requestParam(parameters: ["q": queryValue, "key": AppKeys.youtubeKey], encoding: URLEncoding.default)
        }
    }
}

