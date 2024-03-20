//
//  UpComingMoviesEndPoint.swift
//  Netflix
//
//  Created by Sandra on 03/01/2024.
//

import Foundation
import Alamofire

enum UpComingMoviesEndPoint {
    case getUpComingMovies
}

extension UpComingMoviesEndPoint : EndPointType {
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
        case .getUpComingMovies:
            return AppConstants.movie + AppConstants.upcomingMovies
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUpComingMovies:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUpComingMovies:
            return .requestParam(parameters: ["api_key": AppKeys.APIKey], encoding: URLEncoding.default)
        }
    }
}

