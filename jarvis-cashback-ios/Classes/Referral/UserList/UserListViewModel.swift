//
//  UserListViewModel.swift
//
//
//  Created by Abhishek Tripathi on 25/07/20.
//  Copyright © 2020 Abhishek Tripathi. All rights reserved.
//

import UIKit

enum UserListViewState {
    case loding
    case content
    case reload
    case error(_ message: String)
}

 
protocol UserListViewInput {
    var dataSource: [UserListCellViewModel] {get set}
    var observer: ((_ viewState: UserListViewState) -> Void)  {get set}
    func viewIsReady()
}



class UserListViewModel: UserListViewInput {
    
    var dataSource: [UserListCellViewModel] = []
    var model: [ReferralUser] = []
    var amount: Double = 0.0
    var headerTile: String = ""
    var observer: ((_ viewState: UserListViewState) -> Void) = {_ in }
    
    init(users: [ReferralUser], totalAmount: Double, headerTile: String) {
        self.amount = totalAmount
        self.headerTile = headerTile
        self.model = users
        self.mapDataModelToViewModel()
    }
    
    func mapDataModelToViewModel() {
        self.dataSource = self.model.map({ (user) -> UserListCellViewModel in
            return UserListCellViewModel(name: user.display_name ?? "", initialName: user.display_name_initial ?? "", amount: user.bonus ?? 0, image: user.image_url ?? "", backGroundColor: user.image_bg_color ?? "#51768D")
        })
    }
}

extension UserListViewModel {
    
    func viewIsReady() {
        self.didReciveInformation()
      }
    
     
    func didReciveInformation() {
        self.observer(.reload)
    }
    
}
 
extension UserListViewModel {
    
    var height: CGFloat {
        let height = CGFloat(self.dataSource.count*60 + 104) + 25
        let heightRatio = UIScreen.main.bounds.height*0.8
        return height < heightRatio ? height : heightRatio
    }
    
    var row: Int {
        return self.dataSource.count
    }
    
    func data(forRow atIndexPath: IndexPath) -> UserListCellViewModel {
        return self.dataSource[atIndexPath.row]
    }
}
 

class UserListCellViewModel  {
    var name: String
    var initialName: String
    var amount: Double
    var image: String
    var backGroundColor: String
    var identifier: String = "UserListCell"
    
    init(name: String,initialName: String, amount: Double, image: String,backGroundColor: String) {
        self.name = name
        self.initialName = initialName
        self.amount = amount
        self.image = image
        self.backGroundColor = backGroundColor != "" ? backGroundColor : "51768D"
    }
}
