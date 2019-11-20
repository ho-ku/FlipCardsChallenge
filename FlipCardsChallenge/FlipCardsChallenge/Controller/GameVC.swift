//
//  GameVC.swift
//  FlipCardsChallenge
//
//  Created by Денис Андриевский on 11/20/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK:- End Game Screen
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            menuView = UIView(frame: CGRect(x: Double(self.view.layer.frame.size.width)/6, y: Double(self.view.layer.frame.size.height)/6, width: Double(self.view.layer.frame.size.width)/1.5, height: Double(self.view.layer.frame.size.height)*2/3))
            
            titleLabel = UILabel(frame: CGRect(x: menuView.frame.size.width/2-250, y: 10, width: 500, height: 40))
            titleLabel.font = UIFont(name: "Chalkboard SE", size: 34)?.bold()
            backToMainMenuBtn = UIButton(frame: CGRect(x: 30, y: 110, width: menuView.frame.size.width-60, height: 40))
            newGameBtn = UIButton(frame: CGRect(x: 30, y: 160, width: menuView.frame.size.width-60, height: 40))
            newGameBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 26)
            backToMainMenuBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 26)
        case .pad:
            menuView = UIView(frame: CGRect(x: Double(self.view.layer.frame.size.width)/6, y: Double(self.view.layer.frame.size.height)/6, width: Double(self.view.layer.frame.size.width)*2/3, height: Double(self.view.layer.frame.size.height)/1.5))
            titleLabel = UILabel(frame: CGRect(x: menuView.frame.size.width/2-400, y: 10, width: 800, height: 150))
            titleLabel.font = UIFont(name: "Chalkboard SE", size: 60)?.bold()
            backToMainMenuBtn = UIButton(frame: CGRect(x: 30, y: 230, width: menuView.frame.size.width-60, height: 90))
            newGameBtn = UIButton(frame: CGRect(x: 30, y: 340, width: menuView.frame.size.width-60, height: 90))
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
    

    @IBAction func cardBtnPressed(_ sender: Any) {
        
        let tag = (sender as AnyObject).tag!
        
        
        if tag >= 1 && tag <= 4 {
            if rotated.count == 1 {
                gameField.rotateWithoutCheck(at: (0, tag-1))
            } else {
               gameField.rotate(at: (0, tag-1))
            }
            rotated.append(gameField[0][tag-1])
        } else if tag >= 5 && tag <= 8 {
            if rotated.count == 1 {
                gameField.rotateWithoutCheck(at: (1, tag-5))
            } else {
                gameField.rotate(at: (1, tag-5))
            }
            rotated.append(gameField[1][tag-5])
        } else {
            if rotated.count == 1 {
                gameField.rotateWithoutCheck(at: (2, tag-9))
            } else {
                gameField.rotate(at: (2, tag-9))
            }
            rotated.append(gameField[2][tag-9])
        }
        
        if let btn = view.viewWithTag(tag) as? UIButton {
           
            btn.isUserInteractionEnabled = false
            disabled.append(btn)
        }
        
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
                    btn.isUserInteractionEnabled = true
                }
            }
            disabled = []
            rotated = []
        }
        updateUI()
        
        // MARK:- Win display
        if score == 60 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.titleLabel.text = "Game Over".localized
                UIView.animate(withDuration: 1) {
                    self.menuView.alpha = 1
                    self.menuView.transform = .identity
                }
                
            }
            
        }
        
    }
    
    // MARK:- Update UI
    func updateUI() {
        
        var tag = 1
        
        for cardArr in gameField {
            for card in cardArr {
                switch card.status {
                case .normal:
                    (view.viewWithTag(tag) as! UIButton).setImage(UIImage(named: "cardBack"), for: .normal)
                case .rotated, .done:
                    (view.viewWithTag(tag) as! UIButton).setImage(UIImage(named: "\(card.image.rawValue)Card"), for: .normal)
                }
                
                tag += 1
            }
        }
        
        scoreLabel.text = "Score".localized+": \(score), "+"Steps".localized+": \(stepsCount)"
    
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func backToMenu() {
        self.performSegue(withIdentifier: "backToMenu", sender: self)
    }
    
    @objc func restartGame() {
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.menuView.alpha = 0
            self.menuView.transform = CGAffineTransform.init(translationX: 0, y: 800)
        }, completion: nil)
        self.gameField.generateRandomGameField()
        score = 0
        stepsCount = 0
        updateUI()
        enableAll()
    }
    
    @IBAction func pauseBtnPressed(_ sender: Any) {
        titleLabel.text = "Pause".localized
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            
            resumeBtn = UIButton(frame: CGRect(x: 30, y: 210, width: menuView.frame.size.width-60, height: 40))
            resumeBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 26)
        case .pad:
            resumeBtn = UIButton(frame: CGRect(x: 30, y: 450, width: menuView.frame.size.width-60, height: 90))
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
        
        UIView.animate(withDuration: 1) {
            self.menuView.alpha = 1
            self.menuView.transform = .identity
        }
    }
    
    @objc func resume() {
        self.resumeBtn.removeFromSuperview()
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.menuView.alpha = 0
            self.menuView.transform = CGAffineTransform.init(translationX: 0, y: 800)
        }, completion: nil)
    }
    
    func enableAll() {
        for tag in 1...13 {
            if let btn = view.viewWithTag(tag) as? UIButton {
                btn.isUserInteractionEnabled = true
            }
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "backToMenu", sender: self)
        
    }
    
    
}

