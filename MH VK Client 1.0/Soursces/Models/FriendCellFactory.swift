//
//  FriendCellFactory.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 19.05.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit


final class FriendViewModelFactory {
    
    func constructSearchViewModels(from friends: [FriendVK]) -> [FriendViewModel] {
        return friends.compactMap(viewModel)
    }
    
    func constructNoSearchViewModels(from friends: [[FriendVK]]) -> [[FriendViewModel]] {
        return friends.compactMap { $0.compactMap(viewModel) }
        //return friends.compactMap { $0.compactMap(self.viewModel).compactMap {$0.self} }
    }
    
    private func viewModel(from friend: FriendVK) -> FriendViewModel {
        let friendName = friend.fullName
        let friendPic = friend.mainPhoto
        return FriendViewModel(friendName: friendName, friendPic: friendPic)
    }
    
}

struct FriendViewModel {
    let friendName: String
    let friendPic: String
}

