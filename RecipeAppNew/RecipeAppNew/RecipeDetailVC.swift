//
//  RecipeDetailVC.swift
//  RecipeAppNew
//
//  Created by irem subasi on 11.03.2022.
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

        let imageEdit = UIImage(systemName: "square.and.pencil")
        let btnItemEdit = UIBarButtonItem(image: imageEdit, style: .plain, target: self, action: #selector(editOnTap))

        let imageDelete = UIImage(systemName: "trash")
        let btnItemDelete = UIBarButtonItem(image: imageDelete, style: .plain, target: self, action: #selector(deleteOnTap))

        self.navigationItem.rightBarButtonItems = [btnItemEdit, btnItemDelete]
    //   self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(editOnTap))


        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)

        NotificationCenter.default.addObserver(forName: Notification.Name("RecipesShouldReload"), object: nil, queue: .main) { _ in
            self.fetchRecipe()
        }
    }

    private func fetchRecipe() {
        guard let currentRecipe = recipeStorage.getRecipeById(id: recipeId) else {
           return
        }
        recipe = currentRecipe
        tableViewRecipeDetail.reloadData()
    }

    @objc private func editOnTap() {
        let viewController: NewRecipeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewRecipeVC") as! NewRecipeVC
        viewController.recipe = recipe
        self.navigationController?.pushViewController(viewController, animated: true)
    }


//    var dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
//    // Create OK button with action handler
//    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//        print("Ok button tapped")
//    })
//    // Create Cancel button with action handlder
//    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
//        print("Cancel button tapped")
//    }
//    //Add OK and Cancel button to an Alert object
//    dialogMessage.addAction(ok)
//    dialogMessage.addAction(cancel)
//    // Present alert message to user
//    self.present(dialogMessage, animated: true, completion: nil)

    @objc private func deleteOnTap() {

        let alertView = UIAlertController(title: "Uyarı", message: "Bu tarifi silmek üzeresiniz. Emin misiniz?", preferredStyle: .alert)

        let confirmButton = UIAlertAction(title: "Evet", style: .default) { _ in
            self.recipeStorage.deleteRecipe(self.recipeId)
            NotificationCenter.default.post(name: Notification.Name("RecipesShouldReload"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }

        let cancelButton = UIAlertAction(title: "Hayır", style: .cancel) { _ in
            NSLog("Silelim")
        }

        alertView.addAction(confirmButton)
        alertView.addAction(cancelButton)

        self.present(alertView, animated: true) {
            NSLog("Alerti gösterdim")
        }
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
