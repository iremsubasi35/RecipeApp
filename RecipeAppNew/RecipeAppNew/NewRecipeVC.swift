//
//  NewRecipeVC.swift
//  RecipeAppNew
//
//  Created by aybek can kaya on 11.03.2022.
//

import Foundation
import UIKit

class  NewRecipeVC: UIViewController {

    @IBOutlet weak var textfieldTitle: UITextField!
    @IBOutlet weak var textviewDescription: UITextView!
    @IBOutlet weak var btnSave: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    @IBAction func btnSaveOnTap() {
        NSLog("\(textfieldTitle.text) \n \(textviewDescription.text)")
    }


}
