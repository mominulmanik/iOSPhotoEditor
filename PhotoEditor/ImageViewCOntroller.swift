//
//  ImageViewCOntroller.swift
//  PhotoEditor
//
//  Created by Md. Mominul Islam on 6/5/20.
//  Copyright © 2020 Bjit. All rights reserved.
//

import UIKit

class ImageViewCOntroller: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var splitButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        imageView.image = image
        splitButton.layer.cornerRadius = splitButton.frame.width/2
        saveButton.layer.cornerRadius = saveButton.frame.width/2
    }

    @IBAction func splitButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SplitViewController") as! SplitViewController
        controller.image = image
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

