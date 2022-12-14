//
//  GithubUserParams.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation


struct MoviewSearchParams: Parameterizable{
    let apiKey: String = AppConfig.shared.getServerConfig().setAuthCredential().apiKey ?? ""
    let query: String
    let year: Int
    let page: Int

    public init(query: String, year: Int, page: Int) {
        self.query = query
        self.year = year
        self.page = page
    }

    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case query = "query"
        case year = "year"
        case page = "page"
    }

    public var asRequestParam: [String: Any] {
        let param: [String: Any] = [CodingKeys.apiKey.rawValue: apiKey, CodingKeys.query.rawValue: query, CodingKeys.year.rawValue: year, CodingKeys.page.rawValue: page]
        return param.compactMapValues { $0 }
    }
}
