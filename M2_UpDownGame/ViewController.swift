//
//  ViewController.swift
//  M2_UpDownGame
//
//  Created by sdt5 on 2015. 10. 20..
//  Copyright © 2015년 TAcademyBola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var answer =  random() % 10
    var count = 0
    var gameMode = 0
    let maximumCount = 5
    
    @IBOutlet weak var txtFieldAnswerSheet: UITextField!
    @IBOutlet weak var gameState: UIProgressView!
    @IBOutlet weak var gameCount: UILabel!
    @IBOutlet weak var upOrDown: UILabel!

    //세그먼트 컨트롤을 선택해 게임 모드를 바꿀 시
    @IBAction func changeGameMode(sender: UISegmentedControl) {
       gameMode = sender.selectedSegmentIndex
       initGame()
    }

    @IBAction func checkAnswer(sender: UIButton) {
     
        //횟수가 5회 초과 시
        if count >= 5
        {
            //게임에 졌다는 다이얼로그를 띄운다
            makeDialog(title: "실패", message: "게임에서 지셨습니다. 정답은 \(answer) \n게임을 다시 시작합니다.", buttonText: "확인")
            
            //게임을 초기화한다.
            initGame()
            
            return
        }
    
        
    if  let userAnswer = txtFieldAnswerSheet.text
    {
        if  let uAnswer : Int = Int(userAnswer) ?? 0
        {
            
            //값이 유효범위 내에 있는지 체크한다.
            switch gameMode
            {
            case 0 :
                if (uAnswer >= 10 || uAnswer <= 0)
                {
                    makeDialog(title: "오류", message: "1-10사이 값을 넣어주세요!",buttonText: "확인")
                    txtFieldAnswerSheet.text = nil
                    return
                }
            case 1 :if (uAnswer >= 50 || uAnswer <= 0)            {
                makeDialog(title: "오류", message: "1-50사이 값을 넣어주세요!", buttonText: "확인")
                 txtFieldAnswerSheet.text = nil
                return
                }
            case 2 : if (uAnswer >= 100 || uAnswer <= 0)
            {
                makeDialog(title: "오류", message: "1-100사이 값을 넣어주세요!", buttonText: "확인")
                 txtFieldAnswerSheet.text = nil
                return
            }
            default : break
            }
            
            
            
            
            if uAnswer > answer
            {
            
            upOrDown.text = "\(uAnswer) 보다 작아요!"
            count++
            }
            else if uAnswer < answer
            {
            upOrDown.text = "\(uAnswer) 보다 커요!"
            count++
            }
                
            else
            {
                makeDialog(title: "정답", message: "축하합니다. \n 게임을 다시 시작합니다.", buttonText : "확인")
                initGame()
            }
            
        }
        
    }
        
        txtFieldAnswerSheet.text = nil
        gameCount.text = "\(count) / \(maximumCount)"
        gameState.setProgress( Float(count) * 0.2 , animated: true)

    }
    
    
    
    //게임에서 필요한 다이얼로그(알러트뷰)를 만드는 함수
    func makeDialog(title title : String ,message msg : String, buttonText buttontxt : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okButton = UIAlertAction(title: buttontxt, style: UIAlertActionStyle.Default) { (action) -> Void in
        }
        
        alert.addAction(okButton)
        self.presentViewController(alert, animated: true) { () -> Void in
            
        }
        
    }
    
    //게임 패배 혹은 승리시 게임을 초기화 하는 함수
    func initGame()
    {
        //화면, 카운트 변수를 초기화한다.
        txtFieldAnswerSheet.text = nil
        upOrDown.text = nil
        count = 0
        gameState.setProgress( 0.0 , animated: true)
        gameCount.text = "\(count) / \(maximumCount)"
        
        //다시 정답을 만든다.
        makeAnswer()
        
    }
    
    //게임 모드에 따라 정답을 만드는 함수
    func makeAnswer()
    {
        switch gameMode
        {
        case 0 : answer = random() % 9 + 1
        case 1 : answer = random() % 49 + 1
        case 2 : answer = random() % 99 + 1
        default : break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

