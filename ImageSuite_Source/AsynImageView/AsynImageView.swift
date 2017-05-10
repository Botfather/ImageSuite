//  MIT License
//
//  Copyright (c) 2017 Tushar Mohan
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

//imageManager.png

class AsynImageView: UIImageView {
    var imageURLString: String!                   //url of the image that was requested
    
    @IBInspectable var showsLoader: Bool = false  //true: shows a spinner over placeholder while image is downloaded
    @IBInspectable var placeHolderString: String! // to allow setting up the placeholder string from storyboard
    
    // MARK: - Public Methods
    
    /// Load image to the Image View Asynchronously
    ///
    /// - Parameter imageURL: URL of the image. Omit the base URL if set in the ImageManager
    func loadImage(from imageURL:String) {
        loadImage(from: imageURL, usePlaceHolder: nil, completion:nil)
    }
    
    /// Load image to the Image View asynchronously, showing a placeholder image while it is not loaded
    ///
    /// - Parameters:
    ///   - imageURL: URL of the image. Omit the base URL if set in the ImageManager
    ///   - placeHolderName: name of the placeHolder string. This should be present in Bundle itself
    func loadImage(from imageURL:String, placeHolderName:String) {
        loadImage(from: imageURL, usePlaceHolder: placeHolderName, completion:nil)
    }
    
    /// Load image to the Image View asynchronously, showing a placeholder image while it is not loaded w/ completion
    ///
    /// - Parameters:
    ///   - imageURL: URL of the image. Omit the base URL if set in the ImageManager
    ///   - placeHolderName: name of the placeHolder string. This should be present in Bundle itself
    ///   - completion: completion callback
    func loadImage(from imageURL:String, placeHolderName:String, completion: @escaping SetImageCompletion) {
        loadImage(from: imageURL, usePlaceHolder: placeHolderName, completion:completion)
    }
    
    // MARK: - Private Method
    
    /// Load image on image view asynchronously. Actual image setting happens through this
    ///
    /// - Parameters:
    ///   - imageURL: URL of the image to load
    ///   - placeHolderName: Name of the placeholder image
    ///   - completion: Closure to call on completion of image load.YES: Success/NO;Failed Loading Image
    private func loadImage(from imageURL:String, usePlaceHolder placeHolderName:String?, completion:SetImageCompletion?) {
        imageURLString = imageURL
        
        //set image as placeholder image ... if nil, retreive as set from storyboard else set to empty by default
        let placeHolderImageName = placeHolderName ?? placeHolderString ?? AsynImageViewConstants.emptyPlaceHolderString
        let trimmedPlaceHolderImageName = placeHolderImageName.trimmingCharacters(in: .whitespacesAndNewlines)
        let spinner = getSpinnerOnView()
        
        if !trimmedPlaceHolderImageName.isEmpty, let placeHolderImage = UIImage(named: trimmedPlaceHolderImageName) {
                self.image = placeHolderImage
        }
        
        if showsLoader {
            self.addSubview(spinner)
        }

        ImageManager.sharedInstance.loadImage(from: imageURL,onCompletion: { imagePath in
            let isImageSet: Bool
            
            if let imagePath = imagePath, let requiredImage = UIImage(contentsOfFile:imagePath) {
                //set the image to self
                self.image = requiredImage
                
                isImageSet = true
            }
            else {
                isImageSet = false
            }
            
            //also from here, stop the loading view to be visible as we have tried loading the image by now
            spinner.stopAnimating()
            
            //now let us call the API
            if let completion = completion {
                completion(isImageSet)
            }
            
        })
    }
    
    /// To show an activity indicator over the image view
    ///
    /// - Returns: set activity indicator
    private func getSpinnerOnView () -> UIActivityIndicatorView  {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.alpha = 1.0
        activityIndicator.center = CGPoint(x:self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        activityIndicator.startAnimating()
        
        return activityIndicator
    }

}
