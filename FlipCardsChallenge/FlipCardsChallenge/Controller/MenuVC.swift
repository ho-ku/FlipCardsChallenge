//
//  ViewController.swift
//  FlipCardsChallenge
//
//  Created by Денис Андриевский on 11/16/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    
    // MARK:- Rules View UI
    private var rulesView = UIView()
    private var closeBtn = UIButton()
    private var titleLabel = UILabel()
    private var rulesLabel = UILabel()
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var gameRulesBtn: UIButton!
    @IBOutlet weak var startGameBtn: MenuButton!
    @IBOutlet weak var historyBtn: MenuButton!
    @IBOutlet weak var menuLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameRulesBtn.setTitle("Game Rules".localized, for: .normal)
        startGameBtn.setTitle("Start Game".localized, for: .normal)
        historyBtn.setTitle("History".localized, for: .normal)
        menuLabel.text = "Menu".localized
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK:- Rules
               
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            rulesView = UIView(frame: CGRect(x: Double(view.layer.frame.size.width)/6, y: Double(view.layer.frame.size.height)/6, width: Double(view.layer.frame.size.width)/1.5, height: Double(view.layer.frame.size.height)*2/3))
            closeBtn = UIButton(frame: CGRect(x: rulesView.frame.size.width-50, y: 20, width: 30, height: 30))
            titleLabel = UILabel(frame: CGRect(x: rulesView.frame.size.width/2-250, y: 10, width: 500, height: 40))
            titleLabel.font = UIFont(name: "Chalkboard SE", size: 34)?.bold()
            rulesLabel = UILabel(frame: CGRect(x: 30, y: 40, width: rulesView.frame.size.width-60, height: rulesView.frame.size.height-60))
            rulesLabel.font = UIFont(name: "Chalkboard SE", size: 18)
            
        case .pad:
            rulesView = UIView(frame: CGRect(x: Double(view.layer.frame.size.width)/6, y: Double(view.layer.frame.size.height)/6, width: Double(view.layer.frame.size.width)*2/3, height: Double(view.layer.frame.size.height)/1.5))
            closeBtn = UIButton(frame: CGRect(x: rulesView.frame.size.width-75, y: 20, width: 45, height: 45))
            titleLabel = UILabel(frame: CGRect(x: rulesView.frame.size.width/2-400, y: 10, width: 800, height: 150))
            titleLabel.font = UIFont(name: "Chalkboard SE", size: 60)?.bold()
            rulesLabel = UILabel(frame: CGRect(x: 60, y: 40, width: rulesView.frame.size.width-120, height: rulesView.frame.size.height-60))
            rulesLabel.font = UIFont(name: "Chalkboard SE", size: 36)
            
        default:
            fatalError("Unsupported device")
        }
        
        // MARK:- Configuring close button
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        rulesView.addSubview(closeBtn)
        
        // MARK:- Configuring title label
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleLabel.text = "Game Rules".localized
        titleLabel.textAlignment = .center
        rulesView.addSubview(titleLabel)
        
        // MARK:- Configuring rules label
        rulesLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        rulesLabel.text = "Your goal is to find pair to each card. At the beginning you \'ll be given a field of cards which are laid back and you should turn them over two. You win when all pairs are matched.".localized
        rulesLabel.numberOfLines = 0
        rulesView.addSubview(rulesLabel)
        
        // MARK:- Configuring rules view
        rulesView.backgroundColor = #colorLiteral(red: 0.4980392157, green: 0.4117647059, blue: 0.3333333333, alpha: 1)
        rulesView.layer.cornerRadius = 20.0
               
        let moveUpTransform = CGAffineTransform.init(translationX: 0, y: 800)
        rulesView.transform = moveUpTransform
        rulesView.alpha = 0
        
        

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func startGameBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "startGame", sender: self)
        
    }
    
    @IBAction func historyBtnPressed(_ sender: Any) {
    }
    
    @IBAction func showRulesBtnPressed(_ sender: Any) {
        
        blurEffectView.frame = self.view.bounds
        self.view.addSubview(blurEffectView)
        self.view.addSubview(rulesView)
        
        UIView.animate(withDuration: 1) {
            self.rulesView.alpha = 1
            self.rulesView.transform = .identity
        }
    }
    
    @objc func closeBtnPressed() {
        self.blurEffectView.removeFromSuperview()
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.rulesView.alpha = 0
            self.rulesView.transform = CGAffineTransform.init(translationX: 0, y: 800)
        }, completion: nil)
    }
}



