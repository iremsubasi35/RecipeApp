//
//  RecipeDetailVC.swift
//  RecipeAppNew
//
//  Created by aybek can kaya on 11.03.2022.
//

import Foundation
import UIKit

class RecipeDetailImageCell: UITableViewCell {
    @IBOutlet weak var imView: UIImageView!
}

class RecipeDetailTitleCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
}


class RecipeDetailDescriptionCell: UITableViewCell {
    @IBOutlet weak var lblDescription: UILabel!
}


class RecipeDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableViewRecipeDetail: UITableView!

    var recipe: Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewRecipeDetail.delegate = self
        tableViewRecipeDetail.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailImageCell", for: indexPath) as! RecipeDetailImageCell
            cell.imView.image = recipe.image
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailTitleCell", for: indexPath) as! RecipeDetailTitleCell
            cell.lblTitle.text = recipe.title
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailDescriptionCell", for: indexPath) as! RecipeDetailDescriptionCell
            cell.lblDescription.text = recipe.description
            return cell
       }

        return .init()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
           return 209
        } else if indexPath.row == 1 {
            return 50
        } else if indexPath.row == 2 {
            return UITableView.automaticDimension
       }
        return 0
    }

}
