//
//  ChooseCategorySubjectsCommand.swift
//  Kanopy
//
//  Created by Boris Esanu on 7/31/17.
//
//

import UIKit

class ChooseCategorySubjectsCommand: SubjectsCommand {

    open func execute(categoryModel: CategoryModel!) {
        self.delegate.didChooseCategoryModel(categoryModel: categoryModel)
    }
}
