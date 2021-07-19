//
//  ImageLoader.swift
//  MondaySally
//
//  Created by meng on 2021/07/20.
//
import UIKit

class ImageLoader {
    static func loadImage(url: String, completed: @escaping (UIImage?) -> Void) {
        // TODO
        let url = URL(string: url)
        let data = try? Data(contentsOf: url!)
        guard let data = data , let image = UIImage(data: data) else {
            return
        }
        completed(image)
    }
    
    func profileImage(with url: String?) -> UIImage {
        var profile = UIImage()
        guard let url = url else { return #imageLiteral(resourceName: "illustSallyBlank") }
        ImageLoader.loadImage(url: url) { image in
            profile = image ?? #imageLiteral(resourceName: "illustSallyBlank")
        }
        return profile
    }
}
