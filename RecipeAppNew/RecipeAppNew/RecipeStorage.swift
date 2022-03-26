//
//  RecipeStorage.swift
//  RecipeAppNew
//
//  Created by aybek can kaya on 17.03.2022.
//

import Foundation
import UIKit



class RecipeStorage {

    func getRecipeById(id: String) -> Recipe? {
        let currentRecipes = readRecipes()
        return currentRecipes.first { $0.id == id }
    }

//    func getImage(with id: String) -> UIImage? {
//
//        NSLog("Current Thread: \(Thread.current)")
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths[0]
//        let filePath = documentsDirectory.appendingPathComponent(id).appendingPathExtension("jpg")
//        guard let imageData = try? Data(contentsOf: filePath), let image = UIImage(data: imageData) else {
//
//            return nil
//        }
//        return image
//    }

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
             //   let image = self.getImage(with: recipe.id)
                let newRecipe = Recipe(id: recipe.id, title: recipe.title, description: recipe.description)
                newRecipes.append(newRecipe)
            }
            DispatchQueue.main.async {
                callback(newRecipes)
            }
        }
    }

    func deleteRecipe(_ recipeId: String) {
        let currentRecipes = readRecipes()
        var newRecipes: [Recipe] = []

        currentRecipes.forEach {
            if $0.id != recipeId {
                newRecipes.append($0)
            } else {
                let imagePath = $0.imagePath()
                try? FileManager.default.removeItem(at: imagePath)
            }
        }

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let filePath = documentsDirectory.appendingPathComponent("RecipeList").appendingPathExtension("json")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
        }

        guard let jsonData = try? JSONEncoder().encode(newRecipes)
        else { return }

        do {
            try jsonData.write(to: filePath)

        } catch let error {
            NSLog("Hata : \(error)")
        }
    }

    func createNewRecipe(title: String, description: String, image: UIImage?) {
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

    func updateRecipe(_ recipe: Recipe, image: UIImage?) {
        var newRecipes: [Recipe] = []
        let currentRecipes = readRecipes()
        currentRecipes.forEach {
            if $0.id == recipe.id {
                newRecipes.append(recipe)
            } else {
                newRecipes.append($0)
            }
        }

        guard let jsonData = try? JSONEncoder().encode(newRecipes)
        else { return }

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let filePath = documentsDirectory.appendingPathComponent("RecipeList").appendingPathExtension("json")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
        }

        do {
            try jsonData.write(to: filePath)
            if let image = image {
                let imageData =  image.jpegData(compressionQuality: 1.0)
                let imageURL = documentsDirectory.appendingPathComponent(recipe.id).appendingPathExtension("jpg")
                try imageData?.write(to: imageURL)
            } else {
                let imageURL = documentsDirectory.appendingPathComponent(recipe.id).appendingPathExtension("jpg")
                try? FileManager.default.removeItem(at: imageURL)
            }

        } catch let error {
            NSLog("Hata : \(error)")
        }

    }


}
