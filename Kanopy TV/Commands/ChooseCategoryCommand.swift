//
//  ChooseCategoryCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/20/17.
//
//

import UIKit

class ChooseCategoryCommand: HomeCommand {

    func execute(category: CategoryModel!) {
        self.delegate.didPressToCategory(category: category)
    }
}
