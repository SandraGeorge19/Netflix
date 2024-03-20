//
//  HomeViewModel.swift
//  Netflix
//
//  Created by Sandra on 02/01/2024.
//

import Foundation
import Combine

class HomeViewModel: HomeViewModelProtocol {
    // MARK: - Properties
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular","Upcoming Movies", "Top Rated"]
    var trendingMoviesSubject: CurrentValueSubject<[ResultModel]?, Never>
    var trendingTvSubject: CurrentValueSubject<[ResultModel]?, Never>
    var popularMoviesSubject: CurrentValueSubject<[ResultModel]?, Never>
    var upComingMoviesSubject: CurrentValueSubject<[ResultModel]?, Never>
    var topRatedMoviesSubject: CurrentValueSubject<[ResultModel]?, Never>
    var youtubeResultsSubject: CurrentValueSubject<[Item]?, Never>
    var errorSubject: PassthroughSubject<String, Never>
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer(s)
    init() {
        trendingMoviesSubject = CurrentValueSubject(nil)
        trendingTvSubject = CurrentValueSubject(nil)
        popularMoviesSubject = CurrentValueSubject(nil)
        upComingMoviesSubject = CurrentValueSubject(nil)
        topRatedMoviesSubject = CurrentValueSubject(nil)
        youtubeResultsSubject = CurrentValueSubject(nil)
        errorSubject = PassthroughSubject()
        self.getTrendingMovies()
        self.getTrendingTv()
        self.getPopularMovies()
        self.getUpComingMovies()
        self.getTopRatedMovies()
    }
    // MARK: - Function(s)
    private func getTrendingMovies() {
        APIClient.shared.getDataa(fromEndPoint: TrendingMoviesEndPoint.getAllTrendingMovies, responseClass: TrendingMoviesModel.self).sink {[weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                self.trendingMoviesSubject.send(data.results)
            case .failure(let error):
                self.errorSubject.send(error.localizedDescription)
                print(error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
    private func getTrendingTv() {
        APIClient.shared.getDataa(fromEndPoint: TrendingTvEndPoint.getAllTrendingTv, responseClass: TrendingMoviesModel.self).sink {[weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                self.trendingTvSubject.send(data.results)
            case .failure(let error):
                self.errorSubject.send(error.localizedDescription)
                print(error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
    private func getPopularMovies() {
        APIClient.shared.getDataa(fromEndPoint: PopularMoviesEndPoint.getPopularMovies, responseClass: TrendingMoviesModel.self).sink {[weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                self.popularMoviesSubject.send(data.results)
            case .failure(let error):
                self.errorSubject.send(error.localizedDescription)
                print(error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
    private func getUpComingMovies() {
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
    private func getTopRatedMovies() {
        APIClient.shared.getDataa(fromEndPoint: TopRatedMoviesEndPoint.getTopRatedMovies, responseClass: TrendingMoviesModel.self).sink {[weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                self.topRatedMoviesSubject.send(data.results)
            case .failure(let error):
                self.errorSubject.send(error.localizedDescription)
                print(error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
    func getYoutubeResults(for movie: String) {
        guard let queryValue = movie.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        APIClient.shared.getDataa(fromEndPoint: YoutubeEndPoint.getYoutubeResults(queryValue: queryValue), responseClass: YoutubeSearchModel.self).sink {[weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                self.youtubeResultsSubject.send(data.items)
            case .failure(let error):
                self.errorSubject.send(error.localizedDescription)
                print(error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
    func downloadMovieWith(model: ResultModel) {
        DatabaseManager.shared.downloadMovieWith(model: model).sink {completion in
            switch completion {
            case .finished:
                NotificationCenter.default.post(name: Notification.Name(rawValue: "downloads"), object: nil)
            case .failure(let error):
                print("Error: \(error)")
            }
        } receiveValue: { _ in
            print("\(model.originalTitle ?? "") Saved successfully")
        }.store(in: &cancellables)

    }
}
