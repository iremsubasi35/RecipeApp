//
//  RecipeDetailVC.swift
//  RecipeAppNew
//
//  Created by aybek can kaya on 11.03.2022.
//

import Foundation
import UIKit
import Kingfisher

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

    var recipeId: String = ""

    private let recipeStorage = RecipeStorage()
    private var recipe: Recipe = Recipe(id: "", title: "", description: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRecipe()

        self.title = recipe.title

        tableViewRecipeDetail.delegate = self
        tableViewRecipeDetail.dataSource = self

        let image = UIImage(systemName: "square.and.pencil")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(editOnTap))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)

        NotificationCenter.default.addObserver(forName: Notification.Name("RecipesShouldReload"), object: nil, queue: .main) { _ in
            self.fetchRecipe()
        }
    }

    private func fetchRecipe() {
        guard let currentRecipe = recipeStorage.getRecipeById(id: recipeId) else {
            fatalError("")
        }
        recipe = currentRecipe
        tableViewRecipeDetail.reloadData()
    }

    @objc private func editOnTap() {
        let viewController: NewRecipeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewRecipeVC") as! NewRecipeVC
        viewController.recipe = recipe
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailImageCell", for: indexPath) as! RecipeDetailImageCell
            let imagePath = recipe.imagePath()
            cell.imView.kf.setImage(with: imagePath, placeholder:  UIImage(named: "EmptyRecipe"))
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
