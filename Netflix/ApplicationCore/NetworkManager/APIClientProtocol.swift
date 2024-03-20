//
//  APIClientProtocol.swift
//  Netflix
//
//  Created by Sandra on 02/01/2024.
//

import Foundation
import Alamofire
import Combine

protocol APIClientProtocol {
    func getDataa<T: Codable, M: EndPointType>(fromEndPoint: M, responseClass: T.Type) -> AnyPublisher<DataResponse<T, NetworkError>, Never>
}
