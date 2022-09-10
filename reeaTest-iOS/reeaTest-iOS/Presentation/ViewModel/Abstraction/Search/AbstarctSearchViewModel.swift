//
//  SearchViewModel.swift
//  setScheduleTest
//
//  Created by JMC on 31/10/21.
//


import Foundation
import RxSwift

/* This is Search viewmodel abstraction extented from AbstractViewModel. Which will be used to get search related data by search usecase*/
protocol AbstractSearchViewModel: AbstractViewModel {
    var currentPage: Int {get set}
    var totalDataCount: Int {get set}
    
    // Transform the search input to output observable
    func getSearchOutput(input: SearchViewModel.SearchInput) -> SearchViewModel.SearchOutput
    
    // get search item through api call
    func searchData(query: String, year: Int) -> Observable<SearchApiRequest.ResponseType>
}
