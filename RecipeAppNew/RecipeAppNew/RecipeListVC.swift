//
//  RecipeListVC.swift
//  RecipeAppNew
//
//  Created by aybek can kaya on 10.03.2022.
//

import Foundation
import UIKit
import Kingfisher


struct Recipe: Codable {
    let id: String
    var title: String
    var description: String

    enum CodingKeys: CodingKey {
        case id, title, description
    }

    func imagePath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let filePath = documentsDirectory.appendingPathComponent(id).appendingPathExtension("jpg")
        return filePath
    }
}


class RecipeCell: UITableViewCell {
    @IBOutlet weak var imViewRecipe: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!

}

class RecipeListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableViewRecipes: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblEmptyScreen: UILabel!

    private let recipeStorage = RecipeStorage()
    private var arrRecipes: [Recipe] = []

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tarifler"

        tableViewRecipes.delegate = self
        tableViewRecipes.dataSource = self

        let image = UIImage(systemName: "plus")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addOnTap))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)

        fetchRecipes()

        NotificationCenter.default.addObserver(forName: Notification.Name("RecipesShouldReload"), object: nil, queue: .main) { _ in
            self.fetchRecipes()
        }
    }

    @objc private func addOnTap() {
        NSLog("Add Tapped")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewRecipeVC") as! NewRecipeVC
        self.navigationController?.pushViewController(viewController, animated: true)
      //  self.navigationController?.present(viewController, animated: true, completion: nil)
    }

    func shouldReloadRecipes() {
        fetchRecipes()
    }

    /**
     -------------------------  93,      104
     -------------------------------96-------- Finish


     */

    private func fetchRecipes() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()

        self.arrRecipes = []
        tableViewRecipes.reloadData()

        self.tableViewRecipes.isHidden = true
        self.lblEmptyScreen.isHidden = true
        
        recipeStorage.readRecipesAsync { recipes in
            self.arrRecipes = recipes
            self.tableViewRecipes.reloadData()
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()

            if self.arrRecipes.isEmpty {
                self.tableViewRecipes.isHidden = true
                self.lblEmptyScreen.isHidden = false
            } else {
                self.tableViewRecipes.isHidden = false
                self.lblEmptyScreen.isHidden = true
            }
        }



    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let currentRecipe = arrRecipes[indexPath.row]
        cell.lblDescription.text = currentRecipe.description
        let imagePath = currentRecipe.imagePath()
        cell.imViewRecipe.kf.setImage(with: imagePath, placeholder:  UIImage(named: "EmptyRecipe"))
       // cell.imViewRecipe.image =  currentRecipe.image ?? UIImage(named: "EmptyRecipe")
        cell.lblTitle.text = currentRecipe.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("Index Selected: \(indexPath.row)")

        let currentRecipe = arrRecipes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RecipeDetailVC") as! RecipeDetailVC
        viewController.recipeId = currentRecipe.id
        self.navigationController?.pushViewController(viewController, animated: true)
    }


}
