import UIKit
import RealmSwift
class AddPersonViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
            // Kullanıcıdan alınan veriler
            guard let name = nameTextField.text, !name.isEmpty,
                  let email = emailTextField.text, !email.isEmpty,
                  let phone = phoneTextField.text, !phone.isEmpty else {
                // Kullanıcı bir alanı boş bırakmışsa işlemi sonlandır
                showAlert(message: "Lütfen tüm alanları doldurun!")
                return
            }

            // Yeni kişi oluşturma
            let newPerson = Person()
            newPerson.name = name
            newPerson.email = email
            newPerson.phone = phone

            // Realm'e kaydetme işlemi
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(newPerson)  // Yeni kişiyi Realm'e ekle
                }
                
                // Başarı mesajı göster
                showAlert(message: "Kişi başarıyla kaydedildi!")
                
                // Ekranı kapat, navigation stack'ten geri git
                navigationController?.popViewController(animated: true)
                
            } catch {
                // Hata durumu
                showAlert(message: "Bir hata oluştu. Lütfen tekrar deneyin.")
            }
        }
        
        // Basit bir alert gösterme fonksiyonu
        func showAlert(message: String) {
            let alertController = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
