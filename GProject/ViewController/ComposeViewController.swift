//
//  ComposeViewController.swift
//  GProject
//
//  Created by 서정 on 2021/07/19.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class ComposeViewController: UIViewController {
    
    var imageView = UIImageView()
    var uploadButton = UIButton()
    var imagePicker = UIImagePickerController()
    
    var indicator = UIActivityIndicatorView()
    
    var capturedImage: UIImage!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        setView()
    }

    private func setView() {
        setImageView()
        setUploadButton()
    }
    
    private func setImageView() {
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setUploadButton() {
        uploadButton.setTitle("upload image", for: .normal)
        uploadButton.backgroundColor = .lightGray
        uploadButton.layer.cornerRadius = 5
        
        view.addSubview(uploadButton)
        
        uploadButton.translatesAutoresizingMaskIntoConstraints = false

        uploadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        uploadButton.rx.tap
            .bind { _ in
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }

}

extension ComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        capturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        capturedImage = capturedImage.resize(newWidth: UIScreen.main.bounds.width*3/4)
        self.imageView.image = capturedImage

        self.dismiss(animated: true, completion: nil)
        
    }
}

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}


