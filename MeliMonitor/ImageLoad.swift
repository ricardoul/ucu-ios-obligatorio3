//
//  ImagesLoad.swift
//  Obligatorio1
//
//  Created by SP28 on 2/5/18.
//  Copyright © 2018 Ricardo Umpierrez. All rights reserved.
//

import Foundation
import UIKit
class ImageLoad {
    
    

    static func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    static func downloadImage(url: URL, image: UIImageView) {
        //print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            //print("Download Finished")
            DispatchQueue.main.async() {
                image.image = UIImage(data: data)
            }
        }
    }
    
    
    static func setImageView(url: URL, view: UIView) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                let viewImage = UIImage(data: data)
                let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                backgroundImage.image = viewImage
                backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
                view.insertSubview(backgroundImage, at: 0)
            }
        }
    }
    
    
    static func setImageButton(url: URL, button: UIButton) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                let buttonImage = UIImage(data: data)
                button.setBackgroundImage(buttonImage, for:UIControlState.normal);
            }
        }
    }
}

