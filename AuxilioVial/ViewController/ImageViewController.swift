//
//  ImageViewController.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 25/02/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import UIKit
import MobileCoreServices


 class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var deleteImageBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    private let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    var listaImage: Array<UIImage> = []
    var altaVC :AltaVC?
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
    override func viewDidLoad() {
        imagePicker.delegate = self
        deleteImageBtn.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func regresarUIButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "ImagenesToCaptacionSegue", sender: listaImage)
        //prepare(for:   "ImagenesToCaptacionSegue", sender: listaImage)
    }
    
    @IBAction func onBackPressed(){
        altaVC!.listaImage = listaImage
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let AltaVC = segue.destination as? AltaVC {
            AltaVC.listaImage = listaImage
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCells
        cell.imageView.image = listaImage[indexPath.item]
        
        return cell
    }
    
    @IBAction func imagesFromGaleryBtn(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func deleteImage(_ sender: Any) {
    }
    
    @IBAction func imagesFromCamera(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView?.image = img
        listaImage.append(img!)
        deleteImageBtn.isHidden = false
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}
