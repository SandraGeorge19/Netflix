//
//  APIClient.swift
//  Netflix
//
//  Created by Sandra on 16/07/2023.
//

import Foundation
import Alamofire
import Combine


class APIClient: APIClientProtocol {
    static let shared = APIClient()
    
    private init() {
        // private init
    }
    
    func getDataa<T: Codable, M: EndPointType>(fromEndPoint: M, responseClass: T.Type) -> AnyPublisher<DataResponse<T, NetworkError>, Never> {
        let url = fromEndPoint.path == nil ? URL(string: fromEndPoint.baseURL)! : URL(string: fromEndPoint.baseURL + (fromEndPoint.path ?? ""))!
        let method = Alamofire.HTTPMethod(rawValue: fromEndPoint.method.rawValue)
        let headers = fromEndPoint.headers
        let params = buildParams(task: fromEndPoint.task)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let parameters = params.0 {
            let queryItems = parameters.map {
                return URLQueryItem(name: "\($0)", value: "\($1)")
            }
            urlComponents?.queryItems = queryItems
        }
        let finalURL = urlComponents?.url
        print(finalURL!)
        return AF.request(url,
                   method: method,
                   parameters: params.0,
                   encoding: params.1,
                   headers: headers
        ).validate()
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { error -> NetworkError in
                    if let receivedError = error as Error? as? NetworkError {
                        return receivedError
                    } else if error as Error? is DecodingError {
                        return NetworkError.unableToDecode
                    } else {
                        return NetworkError.unacceptableStatusCode
                    }
                }
            }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func buildParams(task: Task) -> ([String : Any]?, ParameterEncoding){
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParam(parameters: let parameters , encoding: let encoding):
            return (parameters, encoding)
        }
    }
}
