//
//  DownloadsViewModel.swift
//  Netflix
//
//  Created by Sandra on 03/01/2024.
//

import Foundation
import Combine

class DownloadsViewModel: DownloadsViewModelProtocol {
    var downloadedMoviesSubject: CurrentValueSubject<[Movie], Never>
    
    private var cancellables = Set<AnyCancellable>()
    init() {
        downloadedMoviesSubject = CurrentValueSubject([])
    }
    
    func getDownloadedMovies() {
        DatabaseManager.shared.fetchMovies().sink { completion in
            switch completion {
            case .finished:
                print("Fetched")
            case .failure(let error):
                print("Error: \(error)")
            }
        } receiveValue: {[weak self] movies in
            guard let self = self else { return }
            self.downloadedMoviesSubject.send(movies)
        }.store(in: &cancellables)
    }
    
    func deleteMovie(movie: Movie) {
        DatabaseManager.shared.deleteMovie(movie: movie).sink { completion in
            switch completion {
            case .finished:
                print("Deleted")
            case .failure(let error):
                print("Error: \(error)")
            }
        } receiveValue: { _ in
            print("Deleted")
        }.store(in: &cancellables)
    }
}
