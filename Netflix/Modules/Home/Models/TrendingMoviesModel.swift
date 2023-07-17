//
//  TrendingMovies.swift
//  Netflix
//
//  Created by Sandra on 16/07/2023.
//

import Foundation

// MARK: - TrendingMovies
struct TrendingMoviesModel: Codable {
    let page: Int
    let results: [ResultModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
