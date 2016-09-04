//
//  ViewController.swift
//  tictactoe
//
//  Created by 村井謙太 on 2016/09/04.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit

enum Player: String {
    case NONE
    case ME
    case YOU
    
    func image() -> String? {
        switch self {
        case .NONE:
            return nil
        case .ME:
            return "nought.png"
        case .YOU:
            return "cross.png"
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var boardImageView: UIImageView!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    var player: Player = .ME
    var cellValues = [Player](count: 9, repeatedValue: Player.NONE)
    var buttons = [UIButton](count: 9, repeatedValue: UIButton())
    var isGameOver = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.winnerLabel.text = ""
        self.playAgainButton.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initButtons()
    }
    
    func initButtons() {
        let containerWidth = self.boardImageView.frame.width
        let containerPosX = self.boardImageView.frame.minX
        
        let containerHeight = self.boardImageView.frame.height
        let containerPosY = self.boardImageView.frame.minY
        
        let cellWidth = containerWidth / 3
        let cellHeight = containerHeight / 3
        
        for i in 0..<9 {
            let cellIndexForX: Int = i % 3
            let cellIndexForY: Int = i / 3
            
            let x = containerPosX + (cellWidth * CGFloat(cellIndexForX))
            let y = containerPosY + (cellHeight * CGFloat(cellIndexForY))
            
            let btn = UIButton(frame: CGRectMake(x + 10, y + 10, cellWidth - 20, cellHeight - 20))
            btn.addTarget(self, action: #selector(ViewController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
            btn.tag = i
            
            buttons[i] = btn
            
            self.view.addSubview(btn)
        }
    }
    
    func buttonTapped(sender: UIButton) {
        if self.cellValues[sender.tag] != .NONE || self.isGameOver { return }
        
        if player == .ME {
            self.cellValues[sender.tag] = .ME
        } else {
            self.cellValues[sender.tag] = .YOU
        }
        
        self.updateBoard()
        
        if let winner: Player = self.winner() {
            self.winnerLabel.text = "\(winner.rawValue) WIN!!!"
            self.isGameOver = true
            self.playAgainButton.hidden = false
            
        }
        
        self.player = self.player == .ME ? .YOU : .ME
    }
    
    func updateBoard() {
        for (index, player) in self.cellValues.enumerate() {
            if let image = player.image() {
                self.buttons[index].setImage(UIImage(named: image), forState: .Normal)
            } else {
                self.buttons[index].setImage(nil, forState: .Normal)
            }
        }
    }
    
    func winner() -> Player? {
        let players: [Player] = [.ME, .YOU]
        for player: Player in players {
            let playerArray = [player, player, player]
            if self.winPatterns().contains({ $0 == playerArray}) {
                return player
            }
        }
        
        return nil
    }
    
    @IBAction func onPlayAgainClick(sender: UIButton) {
        for i in 0..<9 {
            self.cellValues[i] = .NONE
        }
        self.updateBoard()
        
        self.player = .ME
        self.isGameOver = false
        self.winnerLabel.text = ""
        self.playAgainButton.hidden = true
    }
    
    func winPatterns() -> [[Player]] {
        return [
            // horizontal
            Array(self.cellValues[0...2]),
            Array(self.cellValues[3...5]),
            Array(self.cellValues[6...7]),
            // vertical
            [self.cellValues[0], self.cellValues[3], self.cellValues[6]],
            [self.cellValues[1], self.cellValues[4], self.cellValues[7]],
            [self.cellValues[2], self.cellValues[5], self.cellValues[8]],
            // diagonally
            [self.cellValues[0], self.cellValues[4], self.cellValues[8]],
            [self.cellValues[2], self.cellValues[4], self.cellValues[6]],
        ]
    }

}

