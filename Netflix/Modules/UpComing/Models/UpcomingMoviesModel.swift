//
//  UpcomingMoviesModel.swift
//  Netflix
//
//  Created by Sandra on 17/07/2023.
//

import Foundation

struct UpcomingMoviesModel: Codable {
    let dates: Dates
    let page: Int
    let results: [ResultModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String
}
