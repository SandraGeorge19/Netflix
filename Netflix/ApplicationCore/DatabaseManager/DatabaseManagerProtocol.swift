//
//  DatabaseManagerProtocol.swift
//  Netflix
//
//  Created by Sandra on 03/01/2024.
//

import Foundation
import CoreData
import Combine

protocol DatabaseManagerProtocol {
    func downloadMovieWith(model: ResultModel) -> AnyPublisher<Void, Error>
    func fetchMovies() -> AnyPublisher<[Movie], Error>
    func deleteMovie(movie: Movie) -> AnyPublisher<Void, Error>
}
