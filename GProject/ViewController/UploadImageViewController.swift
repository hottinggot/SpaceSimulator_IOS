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

class UploadImageViewController: UIViewController {
    
    var imageView = UIImageView()
    var uploadButton = UIButton()
    var nextButton = UIButton()
    var imagePicker = UIImagePickerController()
    
    var indicator = UIActivityIndicatorView()
    
    var capturedImage: UIImage!
    let viewModel = UploadImageViewModel()

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
        setIndicator()
        setNextButton()
        setUploadButton()
    }
    
    private func setImageView() {
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setIndicator() {
        indicator.hidesWhenStopped = true
        indicator.style = .large
        view.addSubview(indicator)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setUploadButton() {
        uploadButton.setTitle("select image", for: .normal)
        uploadButton.backgroundColor = .lightGray
        uploadButton.layer.cornerRadius = 5
        uploadButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        view.addSubview(uploadButton)
        
        uploadButton.translatesAutoresizingMaskIntoConstraints = false

        uploadButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20).isActive = true
        uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        uploadButton.rx.tap
            .bind { _ in
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func setNextButton() {
        nextButton.setTitle("next", for: .normal)
        nextButton.backgroundColor = .lightGray
        nextButton.layer.cornerRadius = 5
        nextButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        view.addSubview(nextButton)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        
        nextButton.rx.tap
            .bind { _ in
                self.indicator.startAnimating()
                self.viewModel.postImageToServer(image: self.capturedImage)
                    .bind { id in
                        self.indicator.stopAnimating()
                        self.navigationController?.popViewController(animated: true)
//                        self.moveToMakeProjectViewController(id: id)
                    }
                    .disposed(by: self.disposeBag)

            }
            .disposed(by: disposeBag)
    }
    
    private func moveToMakeProjectViewController(id: Int) {
        let makeProjectPage = MakeProjectViewController()
        makeProjectPage.modalPresentationStyle = .fullScreen
        makeProjectPage.id = id
        
        self.navigationController?.pushViewController(makeProjectPage, animated: true)
    }

}

extension UploadImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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


