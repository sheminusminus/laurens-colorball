
import UIKit
import SpriteKit
import GameplayKit
import GameKit

class StartViewController: UIViewController, GKGameCenterControllerDelegate {
    

    @IBOutlet var moneyLabel: UILabel!
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        authenticateLocalPlayer()
        super.viewDidLoad()
        let scene = StartScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        moneyLabel.text = scoreFormatter(score: DataManager.main.money)
        
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func scoreFormatter(score: Int) -> String {
        if score < 10 {
            return "0\(score)"
        }
        return String(score)
    }
    
    
    @IBOutlet var scoreLabel: UILabel!
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var score = 51
    @IBOutlet var volume: UIButton!
    var tonANAUS = 0
    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "identity"

    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if let err = error { print(err.localizedDescription)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                if let err = error {
                    print(err.localizedDescription)
                }
            }
        }
    }
    @IBAction func addScoreAndSubmitToGC(_ sender: AnyObject) {
        
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
        //open leadboard
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func volumeONOFF(_ sender: AnyObject) {
        tonANAUS = tonANAUS + 2
        if(tonANAUS == 2){
            volume.setBackgroundImage(UIImage(named: "Icon-2.png"), for: UIControlState())
        }else{
            tonANAUS = 0
            volume.setBackgroundImage(UIImage(named: "OFF.png"), for: UIControlState())
        }
    }
    

}
