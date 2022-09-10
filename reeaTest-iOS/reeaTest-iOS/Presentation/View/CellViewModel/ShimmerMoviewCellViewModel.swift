//
//  ShimmerMoviewCellViewModel.swift
//  ReeaTest-iOS
//
//  Created by AGM Tazim on 10/9/22.
//

import Foundation

class ShimmerMoviewCellViewModel: AbstractCellViewModel {
    var id: Int?
    var thumbnail: String?
    var title: String?
    var overview: String?
    
    init(id: Int? = nil, thumbnail: String? = nil, title: String? = nil, overview: String? = nil) {
        self.id = id
        self.thumbnail = thumbnail
        self.title = title
        self.overview = overview
    }
}
