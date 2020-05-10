//
//  SplitViewController.swift
//  PhotoEditor
//
//  Created by Md. Mominul Islam on 6/5/20.
//  Copyright © 2020 Bjit. All rights reserved.
//

import UIKit

class SplitViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageCollectionView: UICollectionView!

    var image: UIImage?
    var imageArray = [UIImage]()
    var noOfSplite = 2
    var longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    private var movingCell: MovingCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        imageView.alpha = 0
        imageArray = slice(image: image!, into: noOfSplite)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.register(UINib(nibName: String(describing: ImageCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ImageCell.self))
        imageCollectionView.addGestureRecognizer(longPressGesture)
        longPressGesture.addTarget(self, action: #selector(self.handleLongGesture(gesture:)))
    }

    override func viewDidLayoutSubviews() {
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = (imageCollectionView.frame.size.width / CGFloat(self.noOfSplite)) - 1
        let height: CGFloat = (imageCollectionView.frame.size.height / CGFloat(self.noOfSplite)) - 1
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = .zero
        let cellWidth = width.rounded(.down)
        let cellHeight = height.rounded(.down)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        //layout.sectionInset = .zero
        imageCollectionView.setCollectionViewLayout(layout, animated: true)
    }

    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        var cell: (UICollectionViewCell?, IndexPath?) {
            guard let indexPath = imageCollectionView.indexPathForItem(at: gesture.location(in: imageCollectionView)),
                let cell = imageCollectionView.cellForItem(at: indexPath) else { return (nil, nil) }
            return (cell, indexPath)
        }

        switch(gesture.state) {

        case .began:
            movingCell = MovingCell(cell: cell.0, originalLocation: cell.0?.center, indexPath: cell.1)
            break
        case .changed:

            /// Make sure moving cell floats above its siblings.
            movingCell?.cell.layer.zPosition = 100
            movingCell?.cell.center = gesture.location(in: gesture.view!)

            break
        case .ended:

            swapMovingCellWith(cell: cell.0, at: cell.1)
            movingCell = nil
        default:
            movingCell?.reset()
            movingCell = nil
        }
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func swapMovingCellWith(cell: UICollectionViewCell?, at indexPath: IndexPath?) {
        guard let cell = cell, let moving = movingCell else {
            movingCell?.reset()
            return
        }

        // update data source
        imageArray.swapAt(moving.indexPath.row, indexPath!.row)

        // swap cells
        animate(moving: moving.cell, to: cell)
    }

    func animate(moving movingCell: UICollectionViewCell, to cell: UICollectionViewCell) {
        longPressGesture.isEnabled = false

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.7, options: .allowUserInteraction, animations: {
            movingCell.center = cell.center
            cell.center = movingCell.center
        }) { _ in
            self.imageCollectionView.reloadData()
            self.longPressGesture.isEnabled = true
        }
    }
    @IBAction func splitButtonAction(_ sender: UIButton) {
        noOfSplite = sender.tag
        imageArray = slice(image: image!, into: noOfSplite)
        imageCollectionView.alpha = 1
        imageView.alpha = 0
        imageCollectionView.reloadData()
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @IBAction func addButtonAction(_ sender: Any) {
        imageCollectionView.alpha = 0
        imageView.alpha = 1
        createNewImage(imgArr: imageArray, noOfImage: noOfSplite)
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

    func slice(image: UIImage, into howMany: Int) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat

        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = image.size.height
            height = image.size.width
        default:
            width = image.size.width
            height = image.size.height
        }

        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))

        let scale = Int(image.scale)
        var images = [UIImage]()

        let cgImage = image.cgImage!

        var adjustedHeight = tileHeight

        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCgImage, scale: image.scale, orientation: image.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }

    func createNewImage(imgArr : [UIImage], noOfImage: Int){
          
          let row = noOfImage
          let column = noOfImage
          let height =  ((imageView.frame.size.height) /  CGFloat (row ))
          let width =  ((imageView.frame.size.width) / CGFloat (column ))

         var imageArray = [[UIImage]]()
          UIGraphicsBeginImageContext(CGSize.init(width: imageView.frame.size.width , height: imageView.frame.size.height))
        var arrayIndex = 0
        for _ in 0..<noOfImage{
            var imageOneDimentionalArray = [UIImage]()
            for _ in 0..<noOfImage{
                imageOneDimentionalArray.append(imgArr[arrayIndex])
                arrayIndex += 1
            }
            imageArray.append(imageOneDimentionalArray)
        }
        
          for y in 0..<row{
              
              for x in 0..<column{
                  
              let newImage = imageArray[y][x]
    
                newImage.draw(in: CGRect.init(x: CGFloat(x) * width, y:  CGFloat(y) * height  , width: width  , height: height))
         
              }
          }
          
          let originalImg = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext();
          imageView.image = originalImg
      }
}

extension SplitViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCell.self), for: indexPath) as! ImageCell
        cell.imageView.image = imageArray[indexPath.row]
        return cell
    }
}

private struct MovingCell {
    let cell: UICollectionViewCell
    let originalLocation: CGPoint
    let indexPath: IndexPath

    init?(cell: UICollectionViewCell?, originalLocation: CGPoint?, indexPath: IndexPath?) {
        guard cell != nil, originalLocation != nil, indexPath != nil else { return nil }
        self.cell = cell!
        self.originalLocation = originalLocation!
        self.indexPath = indexPath!
    }

    func reset() {
        cell.center = originalLocation
    }
}
