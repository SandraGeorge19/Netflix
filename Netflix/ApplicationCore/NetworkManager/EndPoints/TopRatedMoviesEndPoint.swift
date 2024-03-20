//
//  TopRatedMoviesEndPoint.swift
//  Netflix
//
//  Created by Sandra on 03/01/2024.
//

import Foundation
import Alamofire

enum TopRatedMoviesEndPoint {
    case getTopRatedMovies
}

extension TopRatedMoviesEndPoint : EndPointType {
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
        case .getTopRatedMovies:
            return AppConstants.movie + AppConstants.topRatedMovies
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTopRatedMovies:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getTopRatedMovies:
            return .requestParam(parameters: ["api_key": AppKeys.APIKey], encoding: URLEncoding.default)
        }
    }
}

