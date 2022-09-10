//
//  SerachViewModel.swift
//  setScheduleTest
//
//  Created by JMC on 30/10/21.
//

import Foundation
import RxSwift
import RxCocoa

/* This is Search viewmodel class implementation of AbstractSearchViewModel. Which will be used to get search related data by search usecase*/
class SearchViewModel: AbstractSearchViewModel {
    
    // This struct will be used get input from viewcontroller
    struct SearchInputModel {
        let query: String
        let year: Int
    }
    
    // This struct will be used get event with data from viewcontroller
    struct SearchInput {
        let searchItemListTrigger: Observable<SearchInputModel>
    }
    
    // This struct will be used send event with observable data/response to viewcontroller 
    struct SearchOutput {
        let searchItems: BehaviorRelay<[SearchApiRequest.ItemType]>
        let errorTracker: BehaviorRelay<NetworkError?>
    }
    
    let usecase: AbstractUsecase
    var currentPage = 0
    var totalDataCount = 0
    
    init(usecase: AbstractSearchUsecase) {
        self.usecase = usecase
    }
    
    func getSearchOutput(input: SearchInput) -> SearchOutput {
        let searchListResponse = BehaviorRelay<[SearchApiRequest.ItemType]>(value: [])
        let errorResponse = BehaviorRelay<NetworkError?>(value: nil) 
        
        input.searchItemListTrigger.flatMapLatest({ [weak self] (inputModel) -> Observable<SearchApiRequest.ResponseType> in
            guard let weakSelf = self else {
                return Observable.just(SearchApiRequest.ResponseType())
            }
            
            //show shimmer
            if weakSelf.currentPage == 0 {
                searchListResponse.accept(Array<SearchApiRequest.ItemType>(repeating: SearchApiRequest.ItemType(), count: 9))
            }
            
            //fetch movie list
            return weakSelf.searchData(query: inputModel.query, year: inputModel.year)
                   .catch({ error in
                       errorResponse.accept(error as? NetworkError)
                    
                       return Observable.just(SearchApiRequest.ResponseType())
                    })
        }).subscribe(onNext: { [weak self] response in
            self?.currentPage += 1 
            var values =  (self?.currentPage).unwrappedValue > 1 ? searchListResponse.value : []
            searchListResponse.accept(values + (response.results ?? []))
            self?.totalDataCount = searchListResponse.value.count
        }, onError: { [weak self] error in
            errorResponse.accept(error as? NetworkError)
        }, onCompleted: nil, onDisposed: nil)
        
        return SearchOutput.init(searchItems: searchListResponse, errorTracker: errorResponse)
    }
    
    func searchData(query: String, year: Int) -> Observable<SearchApiRequest.ResponseType> {
        return (usecase as! AbstractSearchUsecase).search(query: query, year: year)
    }
}
