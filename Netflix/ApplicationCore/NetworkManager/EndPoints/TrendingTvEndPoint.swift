//
//  TrendingTvEndPoint.swift
//  Netflix
//
//  Created by Sandra on 02/01/2024.
//

import Foundation
import Alamofire

enum TrendingTvEndPoint {
    case getAllTrendingTv
}

extension TrendingTvEndPoint : EndPointType {
    var headers: HTTPHeaders? {
        switch self {
        default:
            return [:]
        }
    }
    
    var baseURL: String {
        switch self {
        default:
            return AppConstants.baseURL
        }
    }
    
    var path: String? {
        switch self {
        case .getAllTrendingTv:
            return AppConstants.trending + AppConstants.trendingTv
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllTrendingTv:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getAllTrendingTv:
            return .requestParam(parameters: ["api_key": AppKeys.APIKey], encoding: URLEncoding.default)
        }
    }
}
