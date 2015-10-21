//
//  ViewController.swift
//  M2_UpDownGame
//
//  Created by sdt5 on 2015. 10. 20..
//  Copyright © 2015년 TAcademyBola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //정답
    var answer = 0

    //게임 모드
    var gameMode = 0
    
    //타이머
    var timer : NSTimer!

    //정답 회수
    let maximumCount : Int = 5
    var count = 0
    
    @IBOutlet weak var txtFieldAnswerSheet: UITextField! //정답 입력용 텍스트필드
    @IBOutlet weak var gameState: UIProgressView! //남은 답 제출 회수를 프로그레스 바로
    @IBOutlet weak var gameCount: UILabel! //남은 답 제출 회수
    @IBOutlet weak var upOrDown: UILabel! // 사용자의 답이 정답에 비해 큰지 작은지 설명
    @IBOutlet weak var labelGameMode: UILabel! //게임 모드 설명
    @IBOutlet weak var progressRemainTime: UIProgressView!    //남은 시간을 나타내는 프로그레스

    
    
    
    //세그먼트 컨트롤을 선택해 게임 모드를 바꿀 시 게임을 그에 맞춰 초기화 해준다
    @IBAction func changeGameMode(sender: UISegmentedControl) {
       gameMode = sender.selectedSegmentIndex
       initGame()
    }
    


    //제출 버튼을 눌렀을 때, 사용자의 답 체크하는 함수
    @IBAction func checkAnswer(sender: UIButton) {
     
        //제출시 타이머가 멈춘다.
        if timer != nil
        {
            timer.invalidate()
        }
        //횟수가 5회 초과 시
        if count >= 5
        {
           
            //게임에 졌다는 다이얼로그를 띄운다
            let alert = UIAlertController(title: "실패", message: "게임에서 지셨습니다. 정답은 \(answer) \n게임을 다시 시작합니다.", preferredStyle: UIAlertControllerStyle.Alert)
            
            //버튼을 누르면 게임을 시작하게 해준다.
            let okButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.Default) { (action) -> Void in
                self.initGame()
            }
            
            alert.addAction(okButton)
            self.presentViewController(alert, animated: true) { () -> Void in }
            
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
            
            
            
            //값이 유효범위 내에 있다면, 값이 정답에 비해 큰지 작은지, 아니면 정답인지에 따라 처리를 달리한다.
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
                //정답을 맞추면 게임을 초기화 한다.
                //게임에 이겼다는 다이얼로그를 띄운다
                let alert = UIAlertController(title: "정답", message: "축하합니다. \n 게임을 다시 시작합니다.", preferredStyle: UIAlertControllerStyle.Alert)
                
                //버튼을 누르면 게임을 시작하게 해준다.
                let okButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.Default) { (action) -> Void in
                    self.initGame()
                }
                
                alert.addAction(okButton)
                self.presentViewController(alert, animated: true) { () -> Void in }
                
                return
            }
            
        }
        
    }
        
        //정답 맞추기에 실패할 시, 필요한 처리를 해준다.
        txtFieldAnswerSheet.text = nil
        gameCount.text = "\(count) / \(maximumCount)"
        gameState.setProgress( Float(count) * 0.2 , animated: true)
        setTimer()
    }
    
    
    
    //게임에서 필요한 다이얼로그(알러트뷰)를 만드는 함수
    func makeDialog(title title : String ,message msg : String, buttonText buttontxt : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okButton = UIAlertAction(title: buttontxt, style: UIAlertActionStyle.Default) { (action) -> Void in
            self.setTimer()
        }
        
        alert.addAction(okButton)
        self.presentViewController(alert, animated: true) { () -> Void in }
    }
    
    
    //게임 패배 혹은 승리시 게임을 초기화 하는 함수
    func initGame()
    {
        //화면, 카운트 변수를 초기화한다.
        txtFieldAnswerSheet.text = nil
        upOrDown.text = nil
        
        //정답 제출 회수 초기화
        count = 0
        gameState.setProgress( 0.0 , animated: true)
        gameCount.text = "\(count) / \(maximumCount)"
     
        //타이머 초기화
        setTimer()
        //다시 정답을 만든다.
        makeAnswer()
        //게임 모드 라벨 바꾸기
        setGameModeText(gameMode)
        
    }
    
    
    //타이머 초기화
    func setTimer(){
        //타이머 초기화
        
        if timer != nil
        {
            timer.invalidate()
        }
        progressRemainTime.progress = 1.0
        let ti : NSTimeInterval = 1
        timer = NSTimer.scheduledTimerWithTimeInterval(ti, target: self, selector: "timerExpired:", userInfo: nil, repeats: true)
    }
    
    
    //1초마다 호출되는 함수. 10초가 되면 정답 회수 줄이거나 졌다고 알림.
    func timerExpired(timer : NSTimer)
    {
        //시간이 다 되었을 때, (10초 안에 정답 입력 실패)
        if progressRemainTime.progress <= 0.0
        {
            timer.invalidate()
            
            if count >= 5
            {
                timer.invalidate()
                
                //게임에 졌다는 다이얼로그를 띄운다
                makeDialog(title: "실패", message: "게임에서 지셨습니다. 정답은 \(answer) \n게임을 다시 시작합니다.", buttonText: "확인")
                
                //게임을 초기화한다.
                initGame()
                return
                
            }
            
            //시간이 다 되어서 종료되었다고 알려준다.
            makeDialog(title: "시간 초과!", message: "시간이 초과되어 제출 가능 회수가 1회 줄어들었습니다.", buttonText: "확인")
            
            //카운트 및 정답 제출 가능 회수 설정
            count++
            gameCount.text = "\(count) / \(maximumCount)"
            gameState.setProgress( Float(count) * 0.2 , animated: true)
            
            //다시 타이머용 프로그레스 바를 리셋해준다.
            progressRemainTime.progress = 1.0
        }
        else
        {
            progressRemainTime.progress -= 0.1
        }
        
        
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
    
    
    //게임 모드 설명을 설정한다.
    func setGameModeText(gameMode : Int){
        
        var gameModeText : String = ""
        
        switch gameMode
        {
        case 0 : gameModeText = "1-10"
        case 1 : gameModeText = "1-50"
        case 2 : gameModeText = "1-100"
        default : break
        }
        labelGameMode.text =  gameModeText + "사이의 값을 넣어주세요"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //게임 초기화
        initGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

