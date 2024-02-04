//
//  SplashController.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/04.
//

import UIKit

class SplashController: UIViewController {

    /// Outlets
    @IBOutlet weak var pocketLabel: UILabel!
    @IBOutlet weak var pokeLabel: UILabel!
    @IBOutlet var pokemonImage: UIImageView!
    
    // MARK: Lifecycle Functions
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Perform animation
        animateView(desiredView: pocketLabel)
        animateView(desiredView: pokeLabel)
        animateView(desiredView: pokemonImage)
    }
    
    // MARK: Functions
    
    /// Present Home Screen
    func presentHome() {
        
        guard let storyboard = storyboard else {
            return
        }
        
        let vc = storyboard.instantiateViewController(withIdentifier: "NavController")
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func animateView(desiredView: UIView) {
        UIView.animate(withDuration: 1.5, animations: {
            desiredView.alpha = 0
        }) { _ in
            self.presentHome()
        }
    }
}
