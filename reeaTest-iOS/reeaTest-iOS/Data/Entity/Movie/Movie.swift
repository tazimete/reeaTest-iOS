//
//  Movie.swift
//  setScheduleTest
//
//  Created by JMC on 31/10/21.
//

import Foundation

/* Movie entity of search response */
struct Movie: Codable, AbstractDataEntity {
    let id: Int?
    let originalTitle: String?
    let overview: String?
    let popularity: Float?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let voteAverage: Float?
    let voteCount: Int?
    
    init(id: Int? = nil, originalTitle: String? = nil, overview: String? = nil, popularity: Float? = nil, posterPath: String? = nil, releaseDate: String? = nil, title: String? = nil, voteAverage: Float? = nil, voteCount: Int? = nil) {
        self.id = id
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    var asDomain: AbstractDomainEntity? {
        return MoviePresentation(id: id, originalTitle: originalTitle, overview: overview, popularity: popularity, posterPath: posterPath, releaseDate: releaseDate, title: title, voteAverage: voteAverage, voteCount: voteCount)
    }
}


