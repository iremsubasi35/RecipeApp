//
//  RecipeStorage.swift
//  RecipeAppNew
//
//  Created by aybek can kaya on 17.03.2022.
//

import Foundation
import UIKit


class RecipeStorage {

    func getImage(with id: String) -> UIImage? {

        NSLog("Current Thread: \(Thread.current)")
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let filePath = documentsDirectory.appendingPathComponent(id).appendingPathExtension("jpg")
        guard let imageData = try? Data(contentsOf: filePath), let image = UIImage(data: imageData) else {

            return nil
        }
        return image
    }

    func readRecipes() -> [Recipe] {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let filePath = documentsDirectory.appendingPathComponent("RecipeList").appendingPathExtension("json")

        guard FileManager.default.fileExists(atPath: filePath.path),
            let data = try? Data(contentsOf: filePath),
                let recipes = try? JSONDecoder().decode([Recipe].self, from: data) else {
            return []
        }

        return recipes
    }

    func readRecipesAsync(_ callback: @escaping ([Recipe])->()) {
        DispatchQueue.global().async {
            var newRecipes: [Recipe] = []
            let recipes = self.readRecipes()

            recipes.forEach { recipe in
                let image = self.getImage(with: recipe.id)
                let newRecipe = Recipe(id: recipe.id, title: recipe.title, description: recipe.description, image: image)
                newRecipes.append(newRecipe)
            }
            DispatchQueue.main.async {
                callback(newRecipes)
            }
        }
    }

    func saveRecipe(title: String, description: String, image: UIImage?) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let filePath = documentsDirectory.appendingPathComponent("RecipeList").appendingPathExtension("json")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
        }

        var currentRecipes = readRecipes()
        let id = UUID().uuidString
        let newRecipe = Recipe(id: id, title: title, description: description)
        currentRecipes.append(newRecipe)

        guard let jsonData = try? JSONEncoder().encode(currentRecipes)
        else { return }

        do {
            try jsonData.write(to: filePath)
            if let image = image {
                let imageData =  image.jpegData(compressionQuality: 1.0)
                let imageURL = documentsDirectory.appendingPathComponent(id).appendingPathExtension("jpg")
                try imageData?.write(to: imageURL)
            }

        } catch let error {
            NSLog("Hata : \(error)")
        }

    }


}
