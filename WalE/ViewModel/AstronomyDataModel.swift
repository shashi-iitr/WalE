//
//  AstronomyDataModel.swift
//  WalE
//
//  Created by Shashi on 23/03/23.
//

import Foundation
import Network

class AstronomyDataModel: ObservableObject {
    init() {
        checkConnection()
    }
    
    @Published var astronomyPicture = AstronomyPicture()
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published private(set) var connected: Bool = true

    var pictureManager = PictureManager()
    
    //MARK: - API CALL
    func loadPictureOfDay() {
        pictureManager.loadPictureOfDay { [weak self] loadedPicture in
            guard let strongSelf = self else { return }
            guard let loadedPicture = loadedPicture else { return }
            DispatchQueue.main.async {
                strongSelf.astronomyPicture = loadedPicture
            }
        }
   }
    
    //MARK: - NETWORK CHECKER CALL
    func checkConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.connected = true
                }
            } else {
                DispatchQueue.main.async {
                    self.connected = false
                }
            }
        }
        monitor.start(queue: queue)
    }
}
