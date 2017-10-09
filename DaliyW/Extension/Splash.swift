//
//  Splash.swift
//  DaliyW
//
//  Created by Mammademin Muzaffarli on 10/5/17.
//  Copyright © 2017 Mammademin Muzaffarli. All rights reserved.
//

import Foundation
import UIKit

/**
 A lightweight wrapper around source.unsplash.com for faster prototyping in Swift
 
 ```
 // Initialize a new instance with
 let splash = Splash()
 
 // Download a new image
 splash.get { image in
 imageView.image = image
 }
 ```
 */
public class Splash {
    
    public typealias ID = String
    public typealias Username = String
    public typealias Size = (Int, Int)
    
    let base = URL(string: "https://source.unsplash.com")
    let url: URL!
    
    /**
     Initializes a new Splash that returns random images with varying sizes.
     */
    public init() {
        url = URL(string: "random", relativeTo: base)
    }
    
    /**
     Initializes a new Splash that returns random images in the given size.
     
     - Parameters:
     - size: A tuple `(Int, Int)` that specifies the size of the image
     */
    public init(size: Size) {
        url = URL(string: "random/\(size.0)x\(size.1)", relativeTo: base)
    }
    
    /**
     Initializes a new Splash that returns a specific image.
     
     - Parameters:
     - id: ID of a specific image
     */
    public init(id: ID) {
        url = URL(string: "\(id)", relativeTo: base)
    }
    
    /**
     Initializes a new Splash that returns a specific image in the given size.
     
     - Parameters:
     - id: ID of a specific image
     - size: A tuple `(Int, Int)` that specifies the size of the image
     */
    public init(id: ID, size: Size) {
        url = URL(string: "\(id)/\(size.0)x\(size.1)", relativeTo: base)
    }
    
    /**
     Initializes a new Splash that returns random images from a specific user.
     
     - Parameters:
     - user: Unsplash username to select images from
     */
    public init(user: Username) {
        url = URL(string: "user/\(user)", relativeTo: base)
    }
    
    /**
     Initializes a new Splash that returns random images from a specific user in the given size.
     
     - Parameters:
     - user: Unsplash username to select images from
     - size: A tuple `(Int, Int)` that specifies the size of the image
     */
    public init(user: Username, size: Size) {
        url = URL(string: "user/\(user)/\(size.0)x\(size.1)", relativeTo: base)
    }
    
    /**
     Initializes a new Splash that returns random images from a specific collection.
     
     - Parameters:
     - collection: ID of the collection to select images from
     */
    public init(collection: ID) {
        url = URL(string: "collection/\(collection)", relativeTo: base)
    }
    
    /**
     Initializes a new Splash that returns random images from a specific collection in the given size.
     
     - Parameters:
     - collection: ID of the collection to select images from
     - size: A tuple `(Int, Int)` that specifies the size of the image
     */
    public init(collection: ID, size: Size) {
        url = URL(string: "collection/\(collection)/\(size.0)x\(size.1)", relativeTo: base)
    }
    
    /**
     Downloads a new image from unsplash.com and calls the provided completion handler with the received `UIImage?`.
     
     - Parameters:
     - completion: Completion handler of type `(UIImage?) -> ()`
     */
    public func get(completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, res, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async { completion(image) }
            } else {
                DispatchQueue.main.async { completion(nil) }
            }
            }.resume()
    }
}
