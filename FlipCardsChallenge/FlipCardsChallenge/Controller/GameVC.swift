//
//  GameVC.swift
//  FlipCardsChallenge
//
//  Created by Денис Андриевский on 11/20/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import CDFlipView

class GameVC: UIViewController {

    @IBOutlet weak var card1: UIButton!
    @IBOutlet weak var card2: UIButton!
    @IBOutlet weak var card3: UIButton!
    @IBOutlet weak var card4: UIButton!
    @IBOutlet weak var card5: UIButton!
    @IBOutlet weak var card6: UIButton!
    @IBOutlet weak var card7: UIButton!
    @IBOutlet weak var card8: UIButton!
    @IBOutlet weak var card9: UIButton!
    @IBOutlet weak var card10: UIButton!
    @IBOutlet weak var card11: UIButton!
    @IBOutlet weak var card12: UIButton!
    
    @IBOutlet weak var tigerImg: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var screenshotView: UIView!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var stack: UIStackView!
    
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK:- Notification constant
    let notification = NotificationCenter.default
    
    private var gameField = Field()
    private var rotated = [Card]()
    private var stepsCount = 0
    private var score = 0
    private var disabled = [UIButton]()
    
    // MARK:- Game Over UI
    private var menuView = UIView()
    private var backToMainMenuBtn = UIButton()
    private var newGameBtn = UIButton()
    private var titleLabel = UILabel()
    private var resumeBtn = UIButton()
    private var musicBtn = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK:- End Game Screen
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            menuView = UIView(frame: CGRect(x: Double(self.view.layer.frame.size.width)/6, y: Double(self.view.layer.frame.size.height)/6, width: Double(self.view.layer.frame.size.width)/1.5, height: Double(self.view.layer.frame.size.height)*2/3))
            
            titleLabel = UILabel(frame: CGRect(x: menuView.frame.size.width/2-250, y: 10, width: 500, height: 40))
            titleLabel.font = UIFont(name: "Chalkboard SE", size: 34)?.bold()
            backToMainMenuBtn = UIButton(frame: CGRect(x: 30, y: 90, width: menuView.frame.size.width-60, height: 40))
            newGameBtn = UIButton(frame: CGRect(x: 30, y: 140, width: menuView.frame.size.width-60, height: 40))
            newGameBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 26)
            musicBtn = UIButton(frame: CGRect(x: menuView.frame.size.width-68, y: 15, width: 54, height: 31))
            backToMainMenuBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 26)
        case .pad:
            menuView = UIView(frame: CGRect(x: Double(self.view.layer.frame.size.width)/6, y: Double(self.view.layer.frame.size.height)/6, width: Double(self.view.layer.frame.size.width)*2/3, height: Double(self.view.layer.frame.size.height)/1.5))
            titleLabel = UILabel(frame: CGRect(x: menuView.frame.size.width/2-400, y: 10, width: 800, height: 100))
            titleLabel.font = UIFont(name: "Chalkboard SE", size: 60)?.bold()
            backToMainMenuBtn = UIButton(frame: CGRect(x: 30, y: 180, width: menuView.frame.size.width-60, height: 90))
            newGameBtn = UIButton(frame: CGRect(x: 30, y: 290, width: menuView.frame.size.width-60, height: 90))
            musicBtn = UIButton(frame: CGRect(x: menuView.frame.size.width-136, y: 40, width: 108, height: 62))
            newGameBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 36)
            backToMainMenuBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 36)
            
        default:
            fatalError("Unsupported device")
        }
        
        // MARK:- Configuring title label
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleLabel.text = "Game Over".localized
        titleLabel.textAlignment = .center
        menuView.addSubview(titleLabel)
        
        
        // MARK:- Configuring menu view
        menuView.backgroundColor = #colorLiteral(red: 0.4980392157, green: 0.4117647059, blue: 0.3333333333, alpha: 1)
        menuView.layer.cornerRadius = 20.0
        
        // MARK:- Configuring buttons
        backToMainMenuBtn.setTitle("Back to Menu".localized, for: .normal)
        backToMainMenuBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        backToMainMenuBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backToMainMenuBtn.layer.borderWidth = 2.0
        backToMainMenuBtn.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
        menuView.addSubview(backToMainMenuBtn)
               
        newGameBtn.setTitle("Restart Game".localized, for: .normal)
        newGameBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        newGameBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        newGameBtn.layer.borderWidth = 2.0
        newGameBtn.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        menuView.addSubview(newGameBtn)
        
        musicBtn.setTitle("", for: .normal)
        if let _ = UserDefaults.standard.value(forKey: "playerState") {
            musicBtn.setImage(UIImage(named: "soundOn"), for: .normal)
        } else {
            musicBtn.setImage(UIImage(named: "soundOff"), for: .normal)
        }
        musicBtn.addTarget(self, action: #selector(musicBtnPressed), for: .touchUpInside)
        
        
        
        let moveUpTransform = CGAffineTransform.init(translationX: 0, y: 800)
        menuView.transform = moveUpTransform
        menuView.alpha = 0
        
        self.view.addSubview(menuView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameField.generateRandomGameField()
        updateUI()
        enableAll()
        
        
    }
    
    // MARK:- Card Pressed
    @IBAction func cardBtnPressed(_ sender: Any) {
        
        
        let tag = (sender as AnyObject).tag!
    
        animate(tag: tag)
        
        var coors = (0, 0)
        
        if tag >= 1 && tag <= 4 {
            if rotated.count == 1 {
                gameField.rotateWithoutCheck(at: (0, tag-1))
            } else {
               gameField.rotate(at: (0, tag-1))
            }
            coors = (0, tag-1)
            rotated.append(gameField[0][tag-1])
        } else if tag >= 5 && tag <= 8 {
            if rotated.count == 1 {
                gameField.rotateWithoutCheck(at: (1, tag-5))
            } else {
                gameField.rotate(at: (1, tag-5))
            }
            rotated.append(gameField[1][tag-5])
            coors = (1, tag-5)
        } else {
            if rotated.count == 1 {
                gameField.rotateWithoutCheck(at: (2, tag-9))
            } else {
                gameField.rotate(at: (2, tag-9))
            }
            rotated.append(gameField[2][tag-9])
            coors = (2, tag-9)
        }
        disableAll()
        if let btn = view.viewWithTag(tag) as? UIButton {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                btn.setImage(UIImage(named: "\(self.gameField[coors.0][coors.1].image.rawValue)Card"), for: .normal)
            }
            
            btn.isUserInteractionEnabled = false
            disabled.append(btn)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.updateUI()
            self.enableAllExceptDone()
        }
        
    }
    
    // MARK:- Update UI
    func updateUI() {
        
        if rotated.count == 2 {
            stepsCount += 1
            if rotated[0].image == rotated[1].image {
                tigerImg.image = UIImage(named: "tiger2")
                
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    self.tigerImg.image = UIImage(named: "tiger3")
                }
                
                score += 10
                
                for (in1, cardArr) in gameField.enumerated() {
                    for (in2, card) in cardArr.enumerated() {
                        if card.image == rotated[0].image || card.image == rotated[1].image {
                            gameField[in1][in2].status = .done
                        }
                    }
                }
            } else {
                disabled.forEach {btn in
                    animate(tag: btn.tag)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.001) {
                        btn.setImage(UIImage(named: "cardBack"), for: .normal)
                        btn.isUserInteractionEnabled = true
                    }
                }
            }
            disabled = []
            rotated = []
            
            // MARK:- Win display
            if score == 60 {
                       
                musicBtn.removeFromSuperview()
                resumeBtn.removeFromSuperview()
                       
                let img = UIImage(view: screenshotView)
                let text = self.scoreLabel.text
                       
                DispatchQueue.global(qos: .utility).async {
                               
                    let newGame = Game(entity: Game.entity(), insertInto: self.context)
                    newGame.image = img.pngData()!
                    newGame.title = text
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                    newGame.date = dateFormatter.string(from: date)
                               
                    DispatchQueue.main.async {
                        self.appDelegate.saveContext()
                    }
                               
                }
                       
                       self.backBtn.isEnabled = false
                       self.pauseBtn.isEnabled = false
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           self.titleLabel.text = "Game Over".localized
                           
                           UIView.animate(withDuration: 1) {
                               self.menuView.alpha = 1
                               self.menuView.transform = .identity
                           }
                           
                       }
                       
                   }
        }
        
        scoreLabel.text = "Score".localized+": \(score), "+"Steps".localized+": \(stepsCount)"
    
    }
    
    func flipAll() {
        for tag in 1...12 {
            animate(tag: tag)
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                (self.view.viewWithTag(tag) as! UIButton).setImage(UIImage(named: "cardBack"), for: .normal)
            }
            
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func backToMenu() {
        self.performSegue(withIdentifier: "backToMenu", sender: self)
    }
    
    // MARK:- Restart Game
    @objc func restartGame() {
        self.pauseBtn.isEnabled = true
        self.backBtn.isEnabled = true
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.menuView.alpha = 0
            self.menuView.transform = CGAffineTransform.init(translationX: 0, y: 800)
        }, completion: nil)
        self.gameField.generateRandomGameField()
        score = 0
        stepsCount = 0
        updateUI()
        flipAll()
        enableAll()
    }
    
    // MARK:- Pause
    @IBAction func pauseBtnPressed(_ sender: Any) {
        titleLabel.text = "Pause".localized
        self.pauseBtn.isEnabled = false
        self.backBtn.isEnabled = false
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            
            resumeBtn = UIButton(frame: CGRect(x: 30, y: 190, width: menuView.frame.size.width-60, height: 40))
            resumeBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 26)
        case .pad:
            resumeBtn = UIButton(frame: CGRect(x: 30, y: 400, width: menuView.frame.size.width-60, height: 90))
            resumeBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 36)
        default:
            fatalError("Unsupported device")
        }
        
        resumeBtn.setTitle("Resume Game".localized, for: .normal)
        resumeBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        resumeBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        resumeBtn.layer.borderWidth = 2.0
        resumeBtn.addTarget(self, action: #selector(resume), for: .touchUpInside)
        menuView.addSubview(resumeBtn)
        
        menuView.addSubview(musicBtn)
        
        UIView.animate(withDuration: 1) {
            self.menuView.alpha = 1
            self.menuView.transform = .identity
        }
    }
    
    // MARK:- Resume Game
    @objc func resume() {
        self.pauseBtn.isEnabled = true
        self.backBtn.isEnabled = true
        self.resumeBtn.removeFromSuperview()
        self.musicBtn.removeFromSuperview()
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.menuView.alpha = 0
            self.menuView.transform = CGAffineTransform.init(translationX: 0, y: 800)
        }, completion: nil)
    }
    
    func enableAllExceptDone() {
        
        for tag in 1...12 {
            
            var coors = (0, 0)
            
            if tag >= 1 && tag <= 4 {
                coors = (0, tag-1)
            } else if tag >= 5 && tag <= 8 {
                coors = (1, tag-5)
            } else {
                coors = (2, tag-9)
            }
     
            let card = gameField[coors.0][coors.1]
            
            if let btn = view.viewWithTag(tag) as? UIButton {
                if card.status != .done {
                     btn.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func enableAll() {
        for tag in 1...13 {
            if let btn = view.viewWithTag(tag) as? UIButton {
                btn.isUserInteractionEnabled = true
            }
        }
    }
    
    func disableAll() {
        for tag in 1...13 {
            if let btn = view.viewWithTag(tag) as? UIButton {
                btn.isUserInteractionEnabled = false
            }
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
    
        self.performSegue(withIdentifier: "backToMenu", sender: self)
        
    }
    
    @objc func musicBtnPressed() {
        
        if musicBtn.imageView?.image!.pngData() == UIImage(named: "soundOn")?.pngData() {
            notification.post(name: Notification.Name("StopMusic"), object: nil)
            musicBtn.setImage(UIImage(named: "soundOff"), for: .normal)
            
        } else {
        
            notification.post(name: Notification.Name("PlayMusic"), object: nil)
            musicBtn.setImage(UIImage(named: "soundOn"), for: .normal)
        }
        
    }
    
    // MARK:- Animation
    func animate(tag: Int) {
        let btn = view.viewWithTag(tag) as! UIButton
        var coors = (0, 0)
        var y: CGFloat = 0
        
        if tag >= 1 && tag <= 4 {
            coors = (0, tag-1)
            y = screenshotView.layer.frame.origin.y
            
        } else if tag >= 5 && tag <= 8 {
            coors = (1, tag-5)
            y = screenshotView.layer.frame.origin.y + stack.spacing + (stack.frame.size.height-2*stack.spacing)/3
        } else {
            coors = (2, tag-9)
            y = screenshotView.layer.frame.origin.y + 2*stack.spacing
            y += 2*(stack.frame.size.height-2*stack.spacing)/3
        }
        
        let card = gameField[coors.0][coors.1]
        var imageSet = [UIImageView]()
        
        if btn.imageView?.image?.pngData() == UIImage(named: "cardBack")?.pngData() {
            let imgView = UIImageView(image: UIImage(named: "\(card.image.rawValue)Card"))
            imgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            imgView.layer.cornerRadius = 10.0
            imageSet = [UIImageView(image: UIImage(named: "cardBack")), imgView]
        } else {
            let imgView = UIImageView(image: UIImage(named: "\(card.image.rawValue)Card"))
            let secImg = UIImageView(image: UIImage(named: "cardBack"))
            secImg.transform = CGAffineTransform(scaleX: -1, y: 1)
            imageSet = [imgView, secImg]
        }
        
        let flipView = CDFlipView(frame: CGRect(x: btn.frame.origin.x + screenshotView.layer.frame.origin.x, y: y, width: btn.frame.size.width, height: btn.frame.size.height))
        flipView.layer.zPosition = 100
        flipView.durationForOneTurnOver = 1
        flipView.setUp(imageSet)
        flipView.layer.cornerRadius = 10.0
        
        view.addSubview(flipView)
        flipView.startAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            flipView.stopAnimation()
            flipView.removeFromSuperview()
        }
    }
    
    
    
    
    
}

