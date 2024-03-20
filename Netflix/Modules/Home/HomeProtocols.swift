//
//  HomeProtocols.swift
//  Netflix
//
//  Created by Sandra on 02/01/2024.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var sectionTitles: [String] { get }
    var trendingMoviesSubject: CurrentValueSubject<[ResultModel]?, Never> { get }
    var trendingTvSubject: CurrentValueSubject<[ResultModel]?, Never> { get }
    var popularMoviesSubject: CurrentValueSubject<[ResultModel]?, Never> { get }
    var upComingMoviesSubject: CurrentValueSubject<[ResultModel]?, Never> { get }
    var topRatedMoviesSubject: CurrentValueSubject<[ResultModel]?, Never> { get }
    var youtubeResultsSubject: CurrentValueSubject<[Item]?, Never> { get }
    var errorSubject: PassthroughSubject<String, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
    func getYoutubeResults(for movie: String)
    func downloadMovieWith(model: ResultModel)
}
