//
//  AstronomyPicture.swift
//  WalE
//
//  Created by Shashi on 23/03/23.
//

import Foundation

struct AstronomyPicture: Identifiable, Codable {
    var explanation = ""
    var mediaType = ""
    var title = ""
    var url = ""
    var date = ""
    var copyright = ""
    var hdurl = ""
    
    var id = UUID()
    
    init() {
        
    }
}
