//
//  PictureManager.swift
//  WalE
//
//  Created by Shashi on 26/03/23.
//

import Foundation

class PictureManager {
    init() {
        
    }
    
    func loadPictureOfDay(_ completion:@escaping (AstronomyPicture?) -> ()) {
        let dateFormatter = pictureDateFormatter()
        let dateStr = dateFormatter.string(from: Date())
        
        var isValidToCallAPI = true
        if let lastFetchedDate = UserDefaults.standard.string(forKey: lastFetchedDate) {
            isValidToCallAPI = lastFetchedDate != dateStr
        }
        
        if isValidToCallAPI {
            guard let url = URL(string: apod_url_string) else { return completion(nil) }
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let strongSelf = self else { return completion(nil) }
                if let data = data {
                    strongSelf.decodePictureData(data) { decodedPicture in
                        if let _ = decodedPicture {
                            UserDefaults.standard.set(data, forKey: lastFetchedData)
                            UserDefaults.standard.set(dateStr, forKey: lastFetchedDate)
                        }
                        DispatchQueue.main.async {
                            completion(decodedPicture)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }.resume()
        } else {
            if let data = UserDefaults.standard.value(forKey: lastFetchedData) as? Data {
                decodePictureData(data) { decodedPicture in
                    DispatchQueue.main.async {
                        completion(decodedPicture)
                    }
                }
            }
        }
    }
    
    func decodePictureData(_ data: Data, _ completion:@escaping (AstronomyPicture?) -> ()) {
        var picture: AstronomyPicture?
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? NSDictionary else { return completion(picture) }
            picture = AstronomyPicture()
            picture?.explanation = dictionary["explanation"] as? String ?? ""
            var media_type = ""
            if let type = dictionary["media_type"] as? String {
                media_type = type
            }
            picture?.mediaType = media_type
            picture?.date = dictionary["date"] as? String ?? ""
            picture?.hdurl = dictionary["hdurl"] as? String ?? ""
            picture?.title = dictionary["title"] as? String ?? ""
            if let url = dictionary["url"] as? String {
                if media_type == "image" {
                    picture?.url = url
                } else if media_type == "video" {
                    if url.contains("https") {
                        picture?.url = url
                    } else {
                        picture?.url = "https:" + url
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(picture)
            }
        } catch {
            DispatchQueue.main.async {
                completion(picture)
            }
        }
    }
}
