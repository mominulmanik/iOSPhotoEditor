//
//  ViewController.swift
//  PhotoEditor
//
//  Created by Md. Mominul Islam on 6/5/20.
//  Copyright © 2020 Bjit. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        imagePicker.delegate = self
        libraryButton.layer.cornerRadius = libraryButton.frame.width / 2
        cameraButton.layer.cornerRadius = cameraButton.frame.width / 2
        INPreferences.requestSiriAuthorization { (status) in
            
        }
        INVocabulary.shared().setVocabularyStrings(["push up", "sit up", "pull up"], of: .workoutActivityName)
    }

    @IBAction func cameraAction(_ sender: Any) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }

    @IBAction func libraryButtonAction(_ sender: Any) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image = UIImage()
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = pickedImage
        }
        self.dismiss(animated: true) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ImageViewCOntroller") as! ImageViewCOntroller
            controller.image = image
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
