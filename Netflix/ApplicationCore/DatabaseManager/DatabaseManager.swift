//
//  DatabaseManager.swift
//  Netflix
//
//  Created by Sandra on 02/01/2024.
//

import Foundation
import UIKit
import CoreData

enum DatabaseFailure: Error {
    case failedToSaveMovie
    case failedToFetchMovie
    case failedToDeleteMovie
}
class DatabaseManager {
    static let shared = {
        let sharedInstance = DatabaseManager()
        return sharedInstance
    }()
    
    private init () {
        // Private init
    }
    
    func downloadMovieWith(model: ResultModel, completion: @escaping ((Result<Void, Error>) -> Void)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let movieItem = Movie(context: context)
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
            try context.save()
            print("Movie that saved is: \(movieItem)")
            completion(.success(()))
        } catch {
            completion(.failure(error))
            print("Error in Saving Movie \(DatabaseFailure.failedToSaveMovie)")
        }
    }
    
    func fetchMovies(completion: @escaping ((Result<[Movie], Error>) -> Void)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(error))
            print("Error in Fetching Movie \(DatabaseFailure.failedToFetchMovie)")
        }
    }
    
    func deleteMovie(movie: Movie, completion: @escaping ((Result<Void, Error>) -> Void)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(movie)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
            print("Error in Deleting Movie \(DatabaseFailure.failedToDeleteMovie)")
        }
    }
}
