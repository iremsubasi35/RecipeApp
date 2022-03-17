//
//  RecipeListVC.swift
//  RecipeAppNew
//
//  Created by aybek can kaya on 10.03.2022.
//

import Foundation
import UIKit


struct Recipe {
    let id: String
    let image: UIImage
    let title: String
    let description: String
}


class RecipeCell: UITableViewCell {
    @IBOutlet weak var imViewRecipe: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
}


class RecipeListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableViewRecipes: UITableView!

    private var arrRecipes: [Recipe] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tarifler"
        setUpRecipes()
        tableViewRecipes.delegate = self
        tableViewRecipes.dataSource = self

        let image = UIImage(systemName: "plus")


        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addOnTap))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)

    }

    @objc private func addOnTap() {
        NSLog("Add Tapped")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewRecipeVC") as! NewRecipeVC
       self.navigationController?.pushViewController(viewController, animated: true)
      //  self.navigationController?.present(viewController, animated: true, completion: nil)
    }

    private func setUpRecipes() {
        arrRecipes = []

        arrRecipes.append(.init(id: "1", image: UIImage(named: "kokorec")!, title: "Kokoreç", description: "Hazır sarılmış kokoreci sakatat satan kasaplarda veya büyük marketlerde bulabilirsiniz."))
        arrRecipes.append(.init(id: "2", image: UIImage(named: "AdanaKebap")!, title: "Adana", description: "Hazır sarılmış kokoreci sakatat satan kasaplarda veya büyük marketlerde bulabilirsiniz. Hazır sarılmış kokoreci sakatat satan kasaplarda veya büyük marketlerde bulabilirsiniz."))
        arrRecipes.append(.init(id: "3", image: UIImage(named: "kokorec")!, title: "Kokoreç", description: "Hazır sarılmış kokoreci sakatat satan kasaplarda veya büyük marketlerde bulabilirsiniz."))
        arrRecipes.append(.init(id: "4", image: UIImage(named: "kokorec")!, title: "Kokoreç", description: "Hazır sarılmış kokoreci sakatat satan kasaplarda veya büyük marketlerde bulabilirsiniz."))
        arrRecipes.append(.init(id: "5", image: UIImage(named: "kokorec")!, title: "Kokoreç", description: "Hazır sarılmış kokoreci sakatat satan kasaplarda veya büyük marketlerde bulabilirsiniz."))
        tableViewRecipes.reloadData()
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
        cell.imViewRecipe.image = currentRecipe.image
        cell.lblTitle.text = currentRecipe.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("Index Selected: \(indexPath.row)")

        let currentRecipe = arrRecipes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RecipeDetailVC") as! RecipeDetailVC
        viewController.recipe = currentRecipe
        self.navigationController?.pushViewController(viewController, animated: true)
    }


}
