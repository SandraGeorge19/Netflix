//
//  AppConstants.swift
//  Netflix
//
//  Created by Sandra on 16/07/2023.
//

import Foundation

struct AppConstants {
    // MARK: - Base URL
    static let baseURL = "https://api.themoviedb.org/3/"
    // MARK: - EndPoints
    static let trending = "trending/"
    static let trendingMovie = "movie/day?api_key="
    static let trendingTv = "tv/day?api_key="
    static let movie = "movie/"
    static let popularMovies = "popular?api_key="
    static let upcomingMovies = "upcoming?api_key="
    static let topRatedMovies = "top_rated?api_key="
    static let discover = "discover/"
    static let topSearch = "movie?api_key="
    
    // MARK: - Image base URL
    static let imgBaseURL = "https://image.tmdb.org/t/p/w500/"
}
