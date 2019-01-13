//
//  ViewController.swift
//  FaceDetection
//
//  Created by Tim Ng on 1/13/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let image = UIImage(named: "sample2") else { return }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        imageView.backgroundColor = .blue
        
        view.addSubview(imageView)
        
        let request = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                print("Failed to detect faces: \(error)")
                return
            }
            
            request.results?.forEach({ (result) in
                print(result)
                
                DispatchQueue.main.async {
                    guard let faceObservation = result as? VNFaceObservation else { return }
                    
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    let height = scaledHeight * faceObservation.boundingBox.height
                    
                    let y = scaledHeight * ( 1 - faceObservation.boundingBox.origin.y) - height
                    
                    
                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    self.view.addSubview(redView)
                    
                    print(faceObservation.boundingBox)
                }
            })
        }
        
            guard let cgImage = image.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch let requestError {
                print("Failed to perform request: \(requestError)")
            }
        }
    }
    
   


}

