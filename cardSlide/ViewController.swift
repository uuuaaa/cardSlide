//
//  ViewController.swift
//  cardSlide
//
//  Created by 大屋雄 on 2016/03/19.
//  Copyright © 2016年 Yu Oya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var upperScrollView: UIScrollView!
    @IBOutlet weak var lowerScrollView: UIScrollView!
    
    @IBOutlet weak var upperCardView: UIView!
    @IBOutlet weak var upperCVlabel1: UILabel!
    @IBOutlet weak var upperCVlabel2: UILabel!
    @IBOutlet weak var upperCVtext: UITextView!
    @IBOutlet weak var upperPage: UIView!
    @IBOutlet weak var upperPageLabel: UILabel!

    @IBOutlet weak var lowerCardView: UIView!
    @IBOutlet weak var lowerCVlabel1: UILabel!
    @IBOutlet weak var lowerCVlabel2: UILabel!
    @IBOutlet weak var lowerCVtext: UITextView!
    @IBOutlet weak var lowerPage: UIView!
    @IBOutlet weak var lowerPageLabel: UILabel!
    
    @IBOutlet weak var toolbar: UIToolbar!

    
    
//    var upperCardNumber : Int = 0
    var upperCardString :[[String]] = []
//    var lowerCardNumber : Int = 0
    var lowerCardString :[[String]] = []
    
    //起動時
    override func viewDidLoad() {
        super.viewDidLoad()

        //NavigationControllerの初期非表示
//        self.navigationController?.navigationBarHidden = true
//        self.navigationController?.toolbarHidden = true
        toolbar.hidden = true
        
        //初期値設定
        upperCardString = [["Label1","Label2","TextData"],
            ["X2","U","aaaaaaaaaaaaaaaaaaaaa"]]
        lowerCardString = [["Label1","Label2","TextData"],["X2","L","aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"]]
        
        //page生成
        generateView()
        
        //StoryBoardで生成したViewを隠す
        upperCardView.hidden = true
        lowerCardView.hidden = true
        
    }
    
    //初回以外にも画面が呼ばれる時
    override func viewWillAppear(animated: Bool) {
        // インスタンス生成
        let defaults = NSUserDefaults.standardUserDefaults()
        var upperFileName : String
        var lowerFileName :String
        
        //delegateの設定
        upperScrollView.delegate = self
        lowerScrollView.delegate = self
        
        //ツールバーを隠す
        toolbar.hidden = true

        
        // Upper:すでに設定でテキストフィールドに入力されている場合
        if defaults.objectForKey("UpperFile") != nil {
            // キーに登録されている文字列を抽出，表示
            let value_string = defaults.objectForKey("UpperFile") as? String
            upperFileName = value_string!
            
            //ファイルを読み込み
            if let retString = readDocument(upperFileName) {
                upperCardString = retString
            }
        }

        
        // Lower:すでに設定でテキストフィールドに入力されている場合
        if defaults.objectForKey("LowerFile") != nil {
            // キーに登録されている文字列を抽出，表示
            let value_string = defaults.objectForKey("LowerFile") as? String
            lowerFileName = value_string!
            //ファイルを読み込み
//            lowerCardString = []
            if let retString2 = readDocument(lowerFileName) {
                lowerCardString = retString2
            }
        }
        

        //SubViewを削除
        removeAllSubviews(upperScrollView, jogaiSubView: upperCardView)
        removeAllSubviews(lowerScrollView, jogaiSubView: lowerCardView)
        
        //Viewの生成
        generateView()
        
        //pageLabelの設定
        upperPageLabel.text = "1 / \(upperCardString.count)"
        lowerPageLabel.text = "1 / \(lowerCardString.count)"
        

        }
    
    ///////ドキュメントフォルダのファイルを読み込む
    func readDocument(fileName :String) -> [[String]]? {
        
        var readString: [[String]] = []
        
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true ).first {
            
            let csvPath = dir.stringByAppendingPathComponent( fileName )
            
            //読み込み用の変数
            var csvString=""
            print("Read!")
            do{
                csvString = try NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding) as String
                
                //１行ごとにカンマで分割し、改行コードを変換する
                var lineIndex = 0
                csvString.enumerateLines { (line, stop) -> () in
                    readString.append(line.componentsSeparatedByString(","))
                    readString[lineIndex][2] = readString[lineIndex][2].stringByReplacingOccurrencesOfString("¥n", withString: "\n")
                    lineIndex++
                    print(lineIndex)
                }
                print(readString)
                return readString

            }
            //読み込み失敗
            catch let error as NSError {
                print(error.localizedDescription)
                //読み込み失敗したらnilを返す
                return nil
            }
        } else {
            //Dirがなかったらnilを返す
            return nil
        }

    }

    //ScrollViewの中のPage生成
    func generateView () {
        
        //Page幅の設定
        let pageWidth = self.view.frame.size.width
        
        //ScrollViewのサイズ設定
        upperScrollView.contentSize = CGSizeMake(pageWidth * CGFloat(upperCardString.count), upperScrollView.frame.height)
        let lowerScrollViewHight = lowerScrollView.frame.height
        lowerScrollView.contentSize = CGSizeMake(pageWidth * CGFloat(lowerCardString.count), lowerScrollViewHight)
        upperScrollView.bounds = upperScrollView.frame
        lowerScrollView.bounds = lowerScrollView.frame
        
        //pageControl
        let pageControl = UIPageControl()
//        self.navigationItem.titleView = pageControl
        upperPage = pageControl
        
        //viewの生成(Upper)
        for var i = 0; i < upperCardString.count; i++ {
            
            let genCardView = UIView(frame: upperCardView.frame)
            genCardView.frame.origin.x = genCardView.frame.origin.x + (self.view.frame.size.width) * CGFloat(i)
            genCardView.layer.borderWidth = upperCardView.layer.borderWidth
            genCardView.layer.backgroundColor = upperCardView.layer.backgroundColor
            genCardView.layer.borderColor = upperCardView.layer.borderColor
            genCardView.layer.shadowColor = upperCardView.layer.shadowColor
            genCardView.layer.shadowOpacity = upperCardView.layer.shadowOpacity
            
            upperScrollView.addSubview(genCardView)
            
            //ラベルView1を設定
            let genLabel1 = UILabel(frame: upperCVlabel1.frame)
            genCardView.addSubview(genLabel1)
            //ラベルView2を設定
            let genLabel2 = UILabel(frame: upperCVlabel2.frame)
            genLabel2.textAlignment = upperCVlabel2.textAlignment
            genLabel2.font = upperCVlabel2.font
            genCardView.addSubview(genLabel2)
            
            //テキストViewを設定
            let cardText = UITextView(frame: upperCVtext.frame)
            cardText.scrollEnabled = true
            cardText.editable = false
            genCardView.addSubview(cardText)
            
            //ラベルとテキストの中身を設定
            genLabel1.text = upperCardString[i][0]
            genLabel2.text = upperCardString[i][1]
            cardText.text = upperCardString[i][2]
        }

        
        //viewの生成(lower)
        for var i = 0; i < lowerCardString.count; i++ {
            
            let genCardView = UIView(frame: lowerCardView.frame)
            genCardView.frame.origin.x = genCardView.frame.origin.x + (self.view.frame.size.width) * CGFloat(i)
            genCardView.layer.borderWidth = lowerCardView.layer.borderWidth
            genCardView.layer.backgroundColor = lowerCardView.layer.backgroundColor
            genCardView.layer.borderColor = lowerCardView.layer.borderColor
            genCardView.layer.shadowColor = lowerCardView.layer.shadowColor
            genCardView.layer.shadowOpacity = lowerCardView.layer.shadowOpacity
            
            lowerScrollView.addSubview(genCardView)
            
            //ラベルView1を設定
            let genLabel1 = UILabel(frame: lowerCVlabel1.frame)
            genCardView.addSubview(genLabel1)
            //ラベルView2を設定
            let genLabel2 = UILabel(frame: lowerCVlabel2.frame)
            genLabel2.textAlignment = lowerCVlabel2.textAlignment
            genLabel2.font = lowerCVlabel2.font
            genCardView.addSubview(genLabel2)
            
            //テキストViewを設定
            let cardText = UITextView(frame: lowerCVtext.frame)
            cardText.scrollEnabled = true
            cardText.editable = false
            genCardView.addSubview(cardText)
            
            //ラベルとテキストの中身を設定
            genLabel1.text = lowerCardString[i][0]
            genLabel2.text = lowerCardString[i][1]
            cardText.text = lowerCardString[i][2]
            
        }
        print("generate view")
        //最初の表示位置の初期化
        upperScrollView.contentOffset = CGPointMake(upperScrollView.contentOffset.x, 0);
        lowerScrollView.contentOffset = CGPointMake(lowerScrollView.contentOffset.x, 0);

    }
    
    //親Viewの中のViewを削除
    func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    //親Viewの中のViewを削除、一部SubViewは除外
    func removeAllSubviews(parentView: UIView, jogaiSubView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            if subview != jogaiSubView {
                subview.removeFromSuperview()
            }
        }
    }
    
    //Windowをタッチしたら、ツールバーの表示・非表示を切り替える
    @IBAction func windowTouch(sender: AnyObject) {

        toolbar.hidden = !toolbar.hidden
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //StatusBarの色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @objc func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
        print("ScrollViewStop")
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //Page数を取得して表示
        let upperPageWidth = upperScrollView.frame.size.width
        let upperCurrentPage = Int(floor((upperScrollView.contentOffset.x - upperPageWidth / 2) / upperPageWidth ) + 2)
        print(upperCurrentPage)
        let lowerPageWidth = lowerScrollView.frame.size.width
        let lowerCurrentPage = Int(floor((lowerScrollView.contentOffset.x - lowerPageWidth / 2) / lowerPageWidth ) + 2)
        print(lowerCurrentPage)
        
        upperPageLabel.text = "\(upperCurrentPage) / \(upperCardString.count)"
        lowerPageLabel.text = "\(lowerCurrentPage) / \(lowerCardString.count)"
    }

}

