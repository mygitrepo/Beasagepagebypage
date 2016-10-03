//
//  instrPageoneViewController.swift
//  baspbp-final
//
//  Created by nikul on 8/8/16.
//  Copyright © 2016 isv. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class instr_page1: BWWalkthroughPageViewController {
    
    fileprivate var firstAppear = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppear {
            do {
                try playVideo()
                firstAppear = false
            } catch AppError.invalidResource(let name, let type) {
                debugPrint("Could not find resource \(name).\(type)")
            } catch {
                debugPrint("Generic error")
            }
            
        }
    }
    
    fileprivate func playVideo() throws {
        guard let path = Bundle.main.path(forResource: "select_books", ofType:"m4v") else {
            throw AppError.invalidResource("select_books", "m4v")
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }
}

enum AppError : Error {
    case invalidResource(String, String)
}
