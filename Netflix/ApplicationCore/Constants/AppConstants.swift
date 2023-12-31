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
    static let trendingMovie = "movie/day"
    static let trendingTv = "tv/day"
    static let movie = "movie/"
    static let popularMovies = "popular"
    static let upcomingMovies = "upcoming"
    static let topRatedMovies = "top_rated"
    static let discover = "discover/"
    static let movieKey = "movie"
    static let search = "search/"
    static let queryKey = "&query="
    
    // MARK: - Image base URL
    static let imgBaseURL = "https://image.tmdb.org/t/p/w500/"
    
    // MARK: - Youtube API Keys
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search"
    static let youtubeVID = "https://www.youtube.com/embed/"
}
