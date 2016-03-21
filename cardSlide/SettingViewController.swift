//
//  SettingViewController.swift
//  cardSlide
//
//  Created by 大屋雄 on 2016/03/20.
//  Copyright © 2016年 Yu Oya. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    @IBOutlet weak var upperCardDetail: UILabel!
    @IBOutlet weak var lowerCardDetail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewWillAppear(animated: Bool) {
        
    //UserDefaultsに値があったら、表示に反映させる
        
        //Defaultsの準備
        let defaults = NSUserDefaults.standardUserDefaults()
        // Upper:すでに設定でテキストフィールドに入力されている場合
        if defaults.objectForKey("UpperFile") != nil {
            // キーに登録されている文字列を抽出，表示
            let value_string = defaults.objectForKey("UpperFile") as? String
            //detail欄へ入力
            upperCardDetail.text = value_string!
        }
        // Lower:すでに設定でテキストフィールドに入力されている場合
        if defaults.objectForKey("LowerFile") != nil {
            // キーに登録されている文字列を抽出，表示
            let value_string = defaults.objectForKey("LowerFile") as? String
            //detail欄へ入力
            lowerCardDetail.text = value_string!
        }
        
    //選択状態の解除
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushStopButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
