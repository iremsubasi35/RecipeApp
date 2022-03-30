//
//  RecipeListVC.swift
//  RecipeAppNew
//
//  Created by irem subasi on 10.03.2022.
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

class RecipeListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    @IBOutlet weak var tableViewRecipes: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblEmptyScreen: UILabel!

    private let recipeStorage = RecipeStorage()

    private var arrRecipes: [Recipe] = []
    private var filteredRecipes: [Recipe] = []

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)

        self.title = "Tarifler"

        tableViewRecipes.delegate = self
        tableViewRecipes.dataSource = self

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Tarif Arayın"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        let image = UIImage(systemName: "plus")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addOnTap))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)

        fetchRecipes()

        NotificationCenter.default.addObserver(forName: Notification.Name("RecipesShouldReload"), object: nil, queue: .main) { _ in
            self.fetchRecipes()
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        search(for: searchController.searchBar.text)
    }

    private func search(for text: String?) {
        guard let text = text, !text.isEmpty else {
            filteredRecipes = arrRecipes
            self.tableViewRecipes.reloadData()
            return
        }

        let textSearch = text.lowercased()
            .replacingOccurrences(of: "i̇", with: "i")

        filteredRecipes = []
        for index in 0 ..< arrRecipes.count {
            let currentElement = arrRecipes[index]
            let title = currentElement.title
                .lowercased()
                .replacingOccurrences(of: "i̇", with: "i")
            if title.contains(textSearch.lowercased()) {
                filteredRecipes.append(currentElement)
                NSLog("Search Text: \(text.lowercased()), Title: \(currentElement.title.lowercased()), EVET")
            } else {
                NSLog("Search Text: \(text.lowercased()), Title: \(currentElement.title.lowercased()), HAYIR")
            }
        }

        self.tableViewRecipes.reloadData()
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

    private func fetchRecipes() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()

        self.arrRecipes = []
        tableViewRecipes.reloadData()

        updateUI()

        recipeStorage.readRecipesAsync { recipes in
            self.arrRecipes = recipes
            self.tableViewRecipes.reloadData()
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.search(for: nil)
            self.updateUI()
        }
    }

    private func updateUI() {
        self.tableViewRecipes.isHidden = true
        self.lblEmptyScreen.isHidden = true
        guard self.activityIndicator.isHidden == true else {
            return
        }

        if self.filteredRecipes.isEmpty {
            self.tableViewRecipes.isHidden = true
            self.lblEmptyScreen.isHidden = false
        } else {
            self.tableViewRecipes.isHidden = false
            self.lblEmptyScreen.isHidden = true
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }

    private func findIndexOf(element: Recipe, in array: [Recipe]) -> Int {
        var foundIndex: Int = 0
        for index in 0 ..< array.count {
            let currentElement = array[index]
            if currentElement.id == element.id {
                foundIndex = index
            }
        }
        return foundIndex
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let deletingRecipe = filteredRecipes[indexPath.row]
        filteredRecipes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)

        let index = findIndexOf(element: deletingRecipe, in: arrRecipes)
        arrRecipes.remove(at: index)

        recipeStorage.deleteRecipe(deletingRecipe.id)



//        arrRecipes.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//        recipeStorage.deleteRecipe(deletingRecipe.id)
     //   updateUI()
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let currentRecipe = filteredRecipes[indexPath.row]
        cell.lblDescription.text = currentRecipe.description
        let imagePath = currentRecipe.imagePath()
        cell.imViewRecipe.kf.setImage(with: imagePath, placeholder:  UIImage(named: "EmptyRecipe"))
       // cell.imViewRecipe.image =  currentRecipe.image ?? UIImage(named: "EmptyRecipe")
        cell.lblTitle.text = currentRecipe.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("Index Selected: \(indexPath.row)")

        let currentRecipe = filteredRecipes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RecipeDetailVC") as! RecipeDetailVC
        viewController.recipeId = currentRecipe.id
        self.navigationController?.pushViewController(viewController, animated: true)
    }


}
