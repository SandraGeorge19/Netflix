//
//  UpComingViewModel.swift
//  Netflix
//
//  Created by Sandra on 03/01/2024.
//

import Foundation
import Combine

class UpComingViewModel: UpComingViewModelProtocol {
    
    var upComingMoviesSubject: CurrentValueSubject<[ResultModel]?, Never>
    var cancellables = Set<AnyCancellable>()
    var errorSubject: PassthroughSubject<String, Never>
    
    init() {
        upComingMoviesSubject = CurrentValueSubject(nil)
        errorSubject = PassthroughSubject()
    }
    func getUpComingMovies() {
        APIClient.shared.getDataa(fromEndPoint: UpComingMoviesEndPoint.getUpComingMovies, responseClass: UpcomingMoviesModel.self).sink {[weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                self.upComingMoviesSubject.send(data.results)
            case .failure(let error):
                self.errorSubject.send(error.localizedDescription)
                print(error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
}
