//
//  YoutubeSearchModel.swift
//  Netflix
//
//  Created by Sandra on 19/07/2023.
//

import Foundation

// MARK: - YoutubeSearchModel
struct YoutubeSearchModel: Codable {
    let kind, etag, nextPageToken, regionCode: String?
    let pageInfo: PageInfo?
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let kind, etag: String?
    let id: ID?
}

// MARK: - ID
struct ID: Codable {
    let kind: String?
    let playlistID, videoID: String?

    enum CodingKeys: String, CodingKey {
        case kind
        case playlistID = "playlistId"
        case videoID = "videoId"
    }
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults, resultsPerPage: Int?
}

