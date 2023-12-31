//
//  APIClient.swift
//  Netflix
//
//  Created by Sandra on 16/07/2023.
//

import Foundation
import Alamofire


class APIClient {
    static let shared = APIClient()
    
    private init() {
        // private init
    }
    
    func getData<T: Codable>(url: String , method: HTTPMethod, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, responseClass: T.Type, complition: @escaping (Swift.Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let parameters = parameters {
            let queryItems = parameters.map {
                return URLQueryItem(name: "\($0)", value: "\($1)")
            }
            urlComponents?.queryItems = queryItems
        }
        guard let finalURL = urlComponents?.url else { return }
        print(finalURL)
        AF.request(finalURL, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).response { response in
            guard let statusCode = response.response?.statusCode else { return }
            guard (200...300).contains(statusCode) else {
                complition(.failure(APIError.failedToLoadData))
                return
            }
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                guard let jsonData = try? JSONDecoder().decode(T.self, from: data) else { return }
                complition(.success(jsonData))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
}
