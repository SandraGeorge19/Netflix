//
//  DownloadsProtocol.swift
//  Netflix
//
//  Created by Sandra on 03/01/2024.
//

import Foundation
import CoreData
import Combine

protocol DownloadsViewModelProtocol {
    var downloadedMoviesSubject: CurrentValueSubject<[Movie], Never> { get }
    func getDownloadedMovies()
    func deleteMovie(movie: Movie)
}
