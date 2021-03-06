//
//  StartGameDelegate.swift
//  ColorBall
//
//  Created by Laurens-Art Ramsenthaler on 16.07.17.
//  Copyright © 2017 Laurens-Art Ramsenthaler. All rights reserved.
//

import Foundation

protocol GameOverDelegate {
    func restartGame()
    func unpauseGame()
    func showaltmenu()
    func gameover()
    func handleNextStage()
    func gameoverdesign()
}

protocol GameOverDelegate {
    func launchGame()
    func launchShop()
}

