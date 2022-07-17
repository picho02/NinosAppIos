//
//  LogInViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 12/07/22.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    var a_i = UIActivityIndicatorView()
    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func btnIniciar(_ sender: Any) {
        a_i.startAnimating()
        Auth.auth().signIn(withEmail: self.eMail.text!,password: self.password.text!) { user, error in
            if error != nil{
                let alert = UIAlertController(title: "", message: "error \(error!.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                DispatchQueue.main.async {
                    self.a_i.stopAnimating()
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                DispatchQueue.main.async {
                    self.a_i.stopAnimating()
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        a_i.style = .large
        a_i.color = .blue
        a_i.hidesWhenStopped = true
        a_i.center = self.view.center
        self.view.addSubview(a_i)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
