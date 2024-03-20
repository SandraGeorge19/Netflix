//
//  PopularMoviesEndPoint.swift
//  Netflix
//
//  Created by Sandra on 03/01/2024.
//

import Foundation
import Alamofire

enum PopularMoviesEndPoint {
    case getPopularMovies
}

extension PopularMoviesEndPoint : EndPointType {
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
        case .getPopularMovies:
            return AppConstants.movie + AppConstants.popularMovies
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPopularMovies:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPopularMovies:
            return .requestParam(parameters: ["api_key": AppKeys.APIKey], encoding: URLEncoding.default)
        }
    }
}
