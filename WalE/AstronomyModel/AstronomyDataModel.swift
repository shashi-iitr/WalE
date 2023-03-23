//
//  AstronomyDataModel.swift
//  WalE
//
//  Created by Shashi on 23/03/23.
//

import Foundation

class AstronomyDataModel: ObservableObject {
    @Published var astronomyPicture = AstronomyPicture()
    
    func loadPictureOfDay(_ completion:@escaping (AstronomyPicture?) -> ()) {
        var picture: AstronomyPicture?
        guard let url = URL(string: apod_url_string) else { return completion(picture) }
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let data = data, let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? NSDictionary {
                    picture = AstronomyPicture()
                    picture?.explanation = dictionary["explanation"] as? String ?? ""
                    picture?.mediaType = dictionary["media_type"] as? String ?? ""
                    picture?.date = dictionary["date"] as? String ?? ""
                    picture?.hdurl = dictionary["hdurl"] as? String ?? ""
                    picture?.title = dictionary["title"] as? String ?? ""
                    picture?.url = dictionary["url"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        completion(picture)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(picture)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(picture)
                }
            }
       }.resume()
   }
}
