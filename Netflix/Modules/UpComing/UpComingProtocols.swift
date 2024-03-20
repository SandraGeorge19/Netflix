//
//  UpComingProtocols.swift
//  Netflix
//
//  Created by Sandra on 03/01/2024.
//

import Foundation
import Combine
 
protocol UpComingViewModelProtocol {
    var upComingMoviesSubject: CurrentValueSubject<[ResultModel]?, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
    var errorSubject: PassthroughSubject<String, Never> { get }
    func getUpComingMovies()
}
