//
//  AbstractDataModel.swift
//  tawktestios
//
//  Created by JMC on 5/8/21.
//

import Foundation


/*
 Base class for our server response
 */

protocol AbstractDataEntity {
    var id: Int? {get}
    
    //dictionary representation of this model 
    var asDictionary : [String: Any]? {get}
    
    //domain representation of this model
    var asDomain : AbstractDomainEntity? {get}
}

