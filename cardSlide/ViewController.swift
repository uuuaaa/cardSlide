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
    @IBOutlet weak var upperCVlabelBG: UIView!
    @IBOutlet weak var upperCVlabel1: UILabel!
    @IBOutlet weak var upperCVlabel2: UILabel!
    @IBOutlet weak var upperCVtext: UITextView!
    @IBOutlet weak var upperPage: UIView!
    @IBOutlet weak var upperPageLabel: UILabel!

    @IBOutlet weak var lowerCardView: UIView!
    @IBOutlet weak var lowerCVlabelBG: UIView!
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
    var pageWidth :CGFloat = 0
    let pageMargin :Float = 20
    
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

        //ScrollViewサイズ設定
        settingScrollView()
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
                    lineIndex += 1
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

    //ScrollViewの設定
    func settingScrollView () {
        //Page幅の設定
        //let pageWidth = self.view.frame.size.width
        pageWidth = upperCardView.frame.size.width + CGFloat(pageMargin)
        
        //ScrollViewのサイズ設定
        upperScrollView.bounds = CGRectMake(0, 0, pageWidth, upperScrollView.frame.height)
        lowerScrollView.bounds = CGRectMake(0, 0, pageWidth, lowerScrollView.frame.height)
        upperScrollView.frame.size.width = pageWidth
        
        //はみ出したカードも表示
        upperScrollView.clipsToBounds = false
        lowerScrollView.clipsToBounds = false
        
    }
    //ScrollViewの中のPage生成
    func generateView () {
        
        //コンテンツ量に合わせてScrollViewのサイズを確保
        upperScrollView.contentSize = CGSizeMake(pageWidth * CGFloat(upperCardString.count), upperScrollView.frame.height)
        lowerScrollView.contentSize = CGSizeMake(pageWidth * CGFloat(lowerCardString.count), lowerScrollView.frame.height)


        //pageControl
//        let pageControl = UIPageControl()
//        self.navigationItem.titleView = pageControl
//        upperPage = pageControl
        
        //viewの生成(Upper)
        
        for i in 0 ..< upperCardString.count {

            //CardViewを複製
            let genCardView = duplicateCardView(upperCardView, index: i)
            upperScrollView.addSubview(genCardView)
            
            //ラベルの裏ビューを複製
            let genLabelBG = duplicateBGView(upperCVlabelBG)
            genCardView.addSubview(genLabelBG)
            
            //ラベルView1を設定
            let genLabel1 = duplicateLabel(upperCVlabel1)
            genCardView.addSubview(genLabel1)
            //ラベルView2を設定
            let genLabel2 = duplicateLabel(upperCVlabel2)
            genCardView.addSubview(genLabel2)
            
            //テキストViewを設定
            let cardText = duplicateTextView(upperCVtext)
            genCardView.addSubview(cardText)
            
            //ラベルとテキストの中身を設定
            genLabel1.text = upperCardString[i][0]
            genLabel2.text = upperCardString[i][1]
            cardText.text = upperCardString[i][2]
        }

        
        //viewの生成(lower)
        for i in 0 ..< lowerCardString.count {
//        for var i = 0; i < lowerCardString.count; i++ {

            //CardViewを複製
            let genCardView = duplicateCardView(lowerCardView, index: i)
            lowerScrollView.addSubview(genCardView)
            
            //ラベルの裏ビューを複製
            let genLabelBG = duplicateBGView(lowerCVlabelBG)
            genCardView.addSubview(genLabelBG)

            //ラベルView1を設定
            let genLabel1 = duplicateLabel(lowerCVlabel1)
            genCardView.addSubview(genLabel1)
            //ラベルView2を設定
            let genLabel2 = duplicateLabel(lowerCVlabel2)
            genCardView.addSubview(genLabel2)
            
            //テキストViewを設定
            let cardText = duplicateTextView(lowerCVtext)
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
    
    ///////////部品////////////////////////
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
    ///////Viewの複製/////////
    //CardViewの複製
    func duplicateCardView (originalView: UIView, index i :Int) -> UIView {
        //複製用のViewを定義
        let genCardView = UIView(frame: originalView.frame)
        //位置の設定
        genCardView.frame.origin.x = genCardView.frame.origin.x + pageWidth * CGFloat(i)
        //スタイルの設定いろいろ
        genCardView.layer.borderWidth = originalView.layer.borderWidth
        genCardView.layer.backgroundColor = originalView.layer.backgroundColor
        genCardView.layer.borderColor = originalView.layer.borderColor
        genCardView.layer.shadowColor = originalView.layer.shadowColor
        genCardView.layer.shadowOpacity = originalView.layer.shadowOpacity
        genCardView.layer.shadowOffset = originalView.layer.shadowOffset
        
        return genCardView
    }
    //LabelBGの複製
    func duplicateBGView (originalView: UIView) -> UIView {
        let genView = UIView(frame: originalView.frame)
        genView.backgroundColor = originalView.backgroundColor
        genView.alpha = originalView.alpha
        return genView
    }
    //Labelの複製
    func duplicateLabel (originalLabel: UILabel) -> UILabel {
        let genLabel = UILabel(frame: originalLabel.frame)
        genLabel.font = originalLabel.font
        genLabel.textAlignment = originalLabel.textAlignment
        genLabel.textColor = originalLabel.textColor

        return genLabel
    }
    //TextViewの複製
    func duplicateTextView (orgTextView: UITextView) -> UITextView {
        let cardText = UITextView(frame: orgTextView.frame)
        cardText.scrollEnabled = true
        cardText.editable = false
        return cardText
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

