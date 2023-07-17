//
//  AppConstants.swift
//  Netflix
//
//  Created by Sandra on 16/07/2023.
//

import Foundation

struct AppConstants {
    // Base URL
    static let baseURL = "https://api.themoviedb.org/3/"
    // EndPoints
    static let trending = "trending/"
    static let trendingMovie = "movie/day?api_key="
    static let trendingTv = "tv/day?api_key="
    static let movie = "movie/"
    static let popularMovies = "popular?api_key="
    static let upcomingMovies = "upcoming?api_key="
    static let topRatedMovies = "top_rated?api_key="
}
