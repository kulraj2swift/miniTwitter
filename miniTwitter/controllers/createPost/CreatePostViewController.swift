//
//  CreatePostViewController.swift
//  miniTwitter
//
//  Created by kulraj singh on 21/01/23.
//

import UIKit
import PhotosUI

class CreatePostViewController: BaseViewController {
    
    var viewModel: CreatePostViewModel?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postButton: CustomButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imagePicker: UIImagePickerController!
    var phPicker: PHPickerViewController!
    var isImagePicked: Bool = false {
        didSet {
            checkAndEnablePostButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        imageView.addTapGesture(target: self, selector: #selector(imageTapped))
        textView.text = ""
        createImagePicker()
        viewModel?.initializeSwifter()
        navigationItem.title = "Create a post"
        textView.addToolbarWithDoneButton(target: self, selector: #selector(resignKeyboard))
    }
    
    @objc func resignKeyboard() {
        view.endEditing(true)
    }
    
    func showPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .livePhotos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func createImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        phPicker = PHPickerViewController(configuration: PHPickerConfiguration())
    }
    
    @objc func imageTapped() {
        let actionSheet = UIAlertController(title: nil, message: "Pick image from:", preferredStyle: .actionSheet)
        let pickFromCameraAction = UIAlertAction(title: "Camera", style: .default, handler:  { [weak self] _ in
            self?.dismissAndShowImagePicker()
        })
        actionSheet.addAction(pickFromCameraAction)
        let pickFromLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
            self?.showPicker()
        })
        actionSheet.addAction(pickFromLibraryAction)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        })
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true)
    }
    
    func dismissAndShowImagePicker() {
        dismiss(animated: true, completion: { [weak self] in
            self?.showImagePicker()
        })
    }
    
    func showImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //the image picker is not working on simulator and i do not have real device so this is untested. you can use photo library and PHPicker to test
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        } else {
            UIAlertController.showAlert(title: "sorry", message: "camera not available", controller: self)
        }
    }
    
    @IBAction func postTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        var rawData: Data?
        if isImagePicked {
            rawData = imageView.image?.jpegData(compressionQuality: 0.2)
        }
        viewModel?.post(message: textView.text.trim(), imageData: rawData)
    }
}

extension CreatePostViewController: PHPickerViewControllerDelegate {
    
    //red flower(aka hana) cant be picked on phpicker from simulator. known issue with apple.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard let result = results.first else { return }
        let item = result.itemProvider
        if item.canLoadObject(ofClass: UIImage.self) {
            item.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] (image, error) in
                if let image = image as? UIImage {
                    DispatchQueue.main.async { [weak self] in
                        self?.imageView.image = image
                        self?.isImagePicked = true
                    }
                } else if let error = error {
                    print("image picking error: " + error.localizedDescription)
                }
            })
        }
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageView.image = image
        isImagePicked = true
    }
}

extension CreatePostViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        checkAndEnablePostButton()
    }
    
    func checkAndEnablePostButton() {
        if textView.text.trim().count > 0 ||
           isImagePicked {
            postButton.isUserInteractionEnabled = true
        } else {
            postButton.isUserInteractionEnabled = false
        }
    }
}

extension CreatePostViewController: CreatePostViewModelDelegate {
    
    func postSuccess() {
        activityIndicator.stopAnimating()
        let alertController = UIAlertController(title: "Success", message: "post was created", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
        })
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func failedToPost(_ error: Error) {
        activityIndicator.stopAnimating()
        UIAlertController.showAlert(title: "Error", message: "failed to post", controller: self)
        print(#function + " " + error.localizedDescription)
    }
    
    
}
