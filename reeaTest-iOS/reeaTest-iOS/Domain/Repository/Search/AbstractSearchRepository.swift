//
//  AbstractSearchRepository.swift
//  setScheduleTest
//
//  Created by JMC on 30/10/21.
//

import Foundation
import RxSwift

/* This is Search repository abstraction extented from AbstractRepository. Which will be used to get search related from api client/server response*/
protocol AbstractSearchRepository: AbstractRepository {
     func get(query: String, year: Int, page: Int) -> Observable<SearchApiRequest.ResponseType>
}
