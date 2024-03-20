//
//  DatabaseManager.swift
//  Netflix
//
//  Created by Sandra on 02/01/2024.
//

import Foundation
import UIKit
import CoreData
import Combine

enum DatabaseFailure: Error {
    case failedToSaveMovie
    case failedToFetchMovie
    case failedToDeleteMovie
}
class DatabaseManager: DatabaseManagerProtocol {
    
    static let shared = {
        let sharedInstance = DatabaseManager()
        return sharedInstance
    }()
    
    private var appDelegate: AppDelegate
    private var context: NSManagedObjectContext
    
    private init () {
        // Private init
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func downloadMovieWith(model: ResultModel) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> {[weak self] promise in
            guard let self = self else {
                return promise(.failure(DatabaseFailure.failedToSaveMovie))
            }
            let movieItem = Movie(context: self.context)
            movieItem.id = Int64(model.id ?? 0)
            movieItem.name = model.name
            movieItem.originalTitle = model.originalTitle
            movieItem.adult = model.adult ?? false
            movieItem.backdropPath = model.backdropPath
            movieItem.firstAirDate = model.firstAirDate
            movieItem.mediaType = model.mediaType?.rawValue
            movieItem.originalLanguage = model.originalLanguage
            movieItem.originalName = model.originalName
            movieItem.overview = model.overview
            movieItem.popularity = model.popularity ?? 0.0
            movieItem.posterPath = model.posterPath
            movieItem.releaseDate = model.releaseDate
            movieItem.title = model.title
            movieItem.video = model.video ?? false
            movieItem.voteAverage = model.voteAverage ?? 0.0
            movieItem.voteCount = Int64(model.voteCount ?? 0)
            
            do {
                try self.context.save()
                print("Movie that saved is: \(movieItem)")
                promise(.success(()))
            } catch {
                promise(.failure(error))
                print("Error in Saving Movie \(DatabaseFailure.failedToSaveMovie)")
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchMovies() -> AnyPublisher<[Movie], Error> {
        return Future<[Movie], Error> {[weak self] promise in
            guard let self = self else {
                return promise(.failure(DatabaseFailure.failedToFetchMovie))
            }
            let request: NSFetchRequest<Movie> = Movie.fetchRequest()
            do {
                let movies = try self.context.fetch(request)
                promise(.success(movies))
            } catch {
                promise(.failure(error))
                print("Error in Fetching Movie \(DatabaseFailure.failedToFetchMovie)")
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteMovie(movie: Movie) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> {[weak self] promise in
            guard let self = self else {
                return promise(.failure(DatabaseFailure.failedToDeleteMovie))
            }
            self.context.delete(movie)
            do {
                try self.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
                print("Error in Deleting Movie \(DatabaseFailure.failedToDeleteMovie)")
            }
        }.eraseToAnyPublisher()
    }
}
