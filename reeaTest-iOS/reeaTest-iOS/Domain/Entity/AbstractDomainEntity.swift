//
//  AbstractDomainEntity.swift
//  ReeaTest-iOS
//
//  Created by AGM Tazim on 10/9/22.
//

import Foundation

protocol AbstractDomainEntity {
    var id: Int? {get}
    
    //dictionary representation of this model
    var asDictionary : [String: Any] {get}
    var asCellViewModel: AbstractCellViewModel {get}
    var asCellConfigurator: CellConfigurator {get}
}
