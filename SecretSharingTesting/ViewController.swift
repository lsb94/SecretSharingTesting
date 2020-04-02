//
//  ViewController.swift
//  SecretSharingTesting
//
//  Created by sungbin on 2020/03/31.
//  Copyright © 2020 coinplug.dave. All rights reserved.
//

import UIKit
import SwiftySSS

class ViewController: UIViewController {
    var my_threshold = 3
    var my_shares = 5
    //outlet
    @IBOutlet weak var secretTextField: UITextField!
    @IBOutlet weak var thresholdTextField: UITextField!
    @IBOutlet weak var ShareNumTextField: UITextField!
    
    @IBOutlet weak var shareTextView: UITextView!
    
    @IBOutlet weak var reconstructLabel: UILabel!
    
    //actons
    @IBAction func shareButtonAction(_ sender: Any) {
        shareTextView.text = ""
        
        guard let threshNum = thresholdTextField.text else {
            let alert = UIAlertController(title: "t값 없음", message: "threshold를 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "확인", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let shareNum = ShareNumTextField.text else {
            let alert = UIAlertController(title: "n값 없음", message: "shares를 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "확인", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        my_threshold = Int(threshNum) ?? 0
        my_shares = Int(shareNum) ?? 0
        
        guard let secretString = secretTextField.text else {
            let alert = UIAlertController(title: "시크릿 없음", message: "시크릿을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "확인", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let message = Data([UInt8](secretString.utf8))
        do {
            let secret = try Secret(data: message, threshold: my_threshold, shares: my_shares)
            let shares = try secret.split()
            
            shares.forEach { share in
                print(share.description)
                shareTextView.text = ("\(shareTextView.text!)\(share) ")
                //            shareStrings.append(share.description)
            }
        }
        catch {
            let alert = UIAlertController(title: "쉐어 생성 실패", message: "쉐어를 생성할 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "확인", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    @IBAction func reconstructButtonAction(_ sender: Any) {
        let shareStrings : [String] = shareTextView.text.components(separatedBy:" ")
        let sharesGether = shareStrings.compactMap{ try? Secret.Share(string: $0) }
        let sharesForThreshold = [Secret.Share](sharesGether[0...my_threshold-1])
        
        do {
            let reconstructedSecretData = try Secret.combine(shares: sharesForThreshold)
            let reconstructedSecret = String(data: reconstructedSecretData, encoding: .utf8)
            reconstructLabel.text = reconstructedSecret
            print(reconstructedSecret)
        } catch {
            let alert = UIAlertController(title: "시크릿 복원 실패", message: "시크릿을 복원 할 수 없습니다", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "확인", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    
}

