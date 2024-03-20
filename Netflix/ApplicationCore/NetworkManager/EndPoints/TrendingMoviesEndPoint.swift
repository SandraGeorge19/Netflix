//
//  TrendingMoviesEndPoint.swift
//  Netflix
//
//  Created by Sandra on 02/01/2024.
//

import Foundation
import Alamofire

enum TrendingMoviesEndPoint {
    case getAllTrendingMovies
}

extension TrendingMoviesEndPoint : EndPointType {
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
        case .getAllTrendingMovies:
            return AppConstants.trending + AppConstants.trendingMovie
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllTrendingMovies:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getAllTrendingMovies:
            return .requestParam(parameters: ["api_key": AppKeys.APIKey], encoding: URLEncoding.default)
        }
    }
}
