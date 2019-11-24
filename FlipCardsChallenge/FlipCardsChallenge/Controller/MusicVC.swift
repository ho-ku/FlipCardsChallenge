//
//  MusicVC.swift
//  FlipCardsChallenge
//
//  Created by Денис Андриевский on 11/23/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit
import AVFoundation

class MusicVC: UIViewController {

    var player: AVAudioPlayer?
    let ncObserver = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let _ = UserDefaults.standard.value(forKey: "firstLaunch") {
            if let _ = UserDefaults.standard.value(forKey: "playerState") {
                playMusic()
            } else {
                stopMusic()
            }

        } else {
            UserDefaults.standard.set(true, forKey: "firstLaunch")
            playMusic()
        }
        
        // MARK:- Observers
        ncObserver.addObserver(self, selector: #selector(self.stopMusic), name: Notification.Name("StopMusic"), object: nil)
        ncObserver.addObserver(self, selector: #selector(self.playMusic), name: Notification.Name("PlayMusic"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    @objc func playMusic() {
        
        UserDefaults.standard.set("isPlaying", forKey: "playerState")
        
        do {
            let audioPath = Bundle.main.path(forResource: "song", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            if let pl = player {
                pl.numberOfLoops = -1
                pl.play()
            }
            
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    @objc func stopMusic() {
        
        UserDefaults.standard.removeObject(forKey: "playerState")
        if let pl = player {
            pl.stop()
        }
        
  
    }
    

}
