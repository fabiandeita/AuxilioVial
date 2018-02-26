//
//  ImageViewController.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 25/02/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import UIKit
import MobileCoreServices

private extension Selector {
    static let openPickerButtonTapped = #selector(ImageViewController.openPickerButtonTapped)
}

class ImageViewController: UIViewController {
    private lazy var openPickerButton: UIBarButtonItem = {
        let b = UIBarButtonItem(
            title: "Biblioteca de fotografias",
            style: .done,
            target: self,
            action: .openPickerButtonTapped
        )
        return b
    }()
    
    fileprivate lazy var imageView: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFill
        return i
    }()
    
    fileprivate lazy var imagePicker: UIImagePickerController = {
        let i = UIImagePickerController()
        i.delegate = self
        return i
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = openPickerButton
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate(
            [
                imageView.topAnchor.constraint(equalTo: view.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
}


//MARK: - Objc Functions
extension ImageViewController {
    @objc
    fileprivate func openPickerButtonTapped() {
        let sheet = UIAlertController(
            title: "Open ImagePicker",
            message: "Select one...",
            preferredStyle: .actionSheet
        )
        sheet.addAction(UIAlertAction(title: "Rollo fotográfico", style: .default, handler: { action in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { action in
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
        }
        sheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(sheet, animated: true, completion: nil)
    }
}


//MARK: - Image Picker Delegate
extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        imageView.image = image
    }
}

