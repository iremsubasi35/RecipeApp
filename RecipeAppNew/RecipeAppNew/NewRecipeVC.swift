//
//  NewRecipeVC.swift
//  RecipeAppNew
//
//  Created by aybek can kaya on 11.03.2022.
//

import Foundation
import UIKit

class  NewRecipeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    private let recipeStorage = RecipeStorage()
    private var selectedImage: UIImage? = nil

    var recipe: Recipe?

    @IBOutlet weak var imViewRecipe: UIImageView!
    @IBOutlet weak var textfieldTitle: UITextField!
    @IBOutlet weak var textviewDescription: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default
            .addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let keyboardScreenEndFrame = keyboardValue.cgRectValue
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardScreenEndFrame.size.height, right: 0)
        }

        NotificationCenter.default
            .addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { notification in
                guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let keyboardScreenEndFrame = keyboardValue.cgRectValue
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textviewDescription.layer.cornerRadius = 4
        textviewDescription.layer.masksToBounds = true

        btnSave.layer.cornerRadius = 4
        btnSave.layer.masksToBounds = true

        imViewRecipe.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imViewDidTapped))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imViewRecipe.addGestureRecognizer(tapGesture)

        textviewDescription.delegate = self
        fillInputElementsIfNeeded()
        validateFields()

        if let _ = recipe {
            self.title = "Tarif Güncelleme"
        } else {
            self.title = "Yeni Tarif"
        }

    }

    private func fillInputElementsIfNeeded() {
        guard let recipe = self.recipe else { return }
        textfieldTitle.text = recipe.title
        textviewDescription.text = recipe.description
     //   imViewRecipe.image = recipe.image ?? UIImage(named: "EmptyRecipe")
    }

    func textViewDidChange(_ textView: UITextView) {
        validateFields()
    }

    @IBAction func textValueChanged(_ sender: Any?) {
        validateFields()
    }

    private func validateFields() {
        if let textfieldText = textfieldTitle.text,
           let textViewText = textviewDescription.text,
           textfieldText.isEmpty == false,
           textViewText.isEmpty == false  {

            btnSave.isEnabled = true
            btnSave.alpha = 1.0
        } else {
            btnSave.isEnabled = false
            btnSave.alpha = 0.25
        }
    }

    @objc func imViewDidTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        navigationController?.present(picker, animated: true, completion: nil)
    }

    @IBAction func btnSaveOnTap() {
        guard let title = textfieldTitle.text,
                let description = textviewDescription.text else {
            return
        }

        if var recipe = recipe {
            recipe.description = description
            recipe.title = title
            recipeStorage.updateRecipe(recipe, image: selectedImage)
        } else {
            recipeStorage.createNewRecipe(title: title, description: description, image: selectedImage)
        }

        NotificationCenter.default.post(name: Notification.Name("RecipesShouldReload"), object: nil)
        navigationController?.popViewController(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imViewRecipe.image = image
        self.selectedImage = image
        NSLog("Image: \(image)")
    }

}

