//
//  UiViewController + Extension.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/02.
//

import UIKit
import Network

extension UIViewController {
    
    //Alert controller displayed to confirmation student post override.
    func showAlert(message: String) {
        let controller = UIAlertController(title: "Something Went Wrong", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        
        controller.addAction(okAction)
        controller.popoverPresentationController?.sourceView = self.view
        self.present(controller, animated: true, completion: nil)
    }
    
    func monitorNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {
            path in
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    self.showAlert(message: "No Internet Connection")
                    }
            } else {
                print("There is an internet connection")
            }
                
        }
        
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    
    func openVibe() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}

extension String {
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
}
