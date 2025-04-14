import UIKit
import RealmSwift
import CoreImage

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!

    var person: Person!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Kişi bilgilerini göster
        nameLabel.text = person.name
        phoneLabel.text = person.phone
        emailLabel.text = person.email

        // Profil görselini hazırla
        setupProfileImage()

        // vCard formatlı QR kod oluştur
        let vCardString = """
        BEGIN:VCARD
        VERSION:3.0
        N:\(person.name)
        FN:\(person.name)
        TEL;TYPE=CELL:\(person.phone)
        EMAIL:\(person.email)
        END:VCARD
        """

        if let qrCodeImage = generateQRCode(from: vCardString) {
            qrImageView.image = qrCodeImage
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
    }

    
    func setupProfileImage() {
        // Eğer profil resmi varsa
        if let profileImageData = person.profileImage, let image = UIImage(data: profileImageData) {
            profileImageView.image = image
        } else {
            // Profil resmi yoksa, baş harfi göster
            let initialLabel = UILabel()
            initialLabel.text = String(person.name.prefix(1)) // Baş harfi al
            initialLabel.font = UIFont.boldSystemFont(ofSize: 50) // Font büyüklüğünü ayarla
            initialLabel.textColor = .white // Harf rengi
            initialLabel.textAlignment = .center // Harf hizalaması
            initialLabel.frame = profileImageView.bounds // Label'in boyutları profil image view ile aynı

            // Harfi yuvarlak bir arka planda göstermek için
            initialLabel.layer.cornerRadius = initialLabel.frame.width / 2
            initialLabel.clipsToBounds = true
            initialLabel.backgroundColor = UIColor.systemBlue // Arka plan rengi

            profileImageView.addSubview(initialLabel) // Profil image view üzerine ekle
        }

        // Profil resmini yuvarlak yapmak
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    
    @objc func selectProfileImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
   
    // Kullanıcı seçim iptal ederse buraya gelir
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Fotoğraf Seçimi Sonrası
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            
            // ✅ Görseli yeniden boyutlandır
            if let resizedImage = resizeImage(selectedImage, targetSize: CGSize(width: 300, height: 300)) {
                
                // ✅ Yuvarlak yapmak için görseli profilImageView'a ata
                profileImageView.image = resizedImage
                
                // ✅ JPEG formatında, sıkıştırılmış olarak kaydet
                if let imageData = resizedImage.jpegData(compressionQuality: 0.5) {
                    do {
                        let realm = try Realm()
                        try realm.write {
                            person.profileImage = imageData
                        }
                        
                        // ✅ Başarı mesajını göster
                        let alert = UIAlertController(title: "Başarı", message: "Profil resmi başarıyla kaydedildi.", preferredStyle: .alert)
                        
                        // OK butonunu ekle
                        let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
                            // Resmi güncelle
                            self.setupProfileImage() // Profil resmini güncelle
                        }
                        alert.addAction(okAction)
                        
                        // Alert'i göster
                        self.present(alert, animated: true, completion: nil)
                        
                    } catch {
                        print("Resim kaydedilemedi: \(error)")
                    }
                }
            }
        }
        
        // ✅ Picker’ı kapat
        dismiss(animated: true, completion: nil)
    }
    
    
    

    // MARK: - Görseli Yeniden Boyutlandıran Fonksiyon
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        // Resmi yuvarlak hale getirebilmek için en küçük boyutu seçiyoruz.
        let squareSide = min(size.width, size.height)
        
        // Yeni boyutları, küçük olan kenara göre belirliyoruz.
        let newSize = CGSize(width: squareSide, height: squareSide)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        // Yeni boyutta resmi çiziyoruz.
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return resizedImage
    }


    // QR kod oluşturma fonksiyonu
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .utf8)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")

            if let outputImage = filter.outputImage {
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledImage = outputImage.transformed(by: transform)
                let context = CIContext()
                if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }

    
    
    
    // Silme butonuna tıklanınca çalışacak fonksiyon
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Emin misiniz?", message: "Bu kişiyi silmek istediğinize emin misiniz?", preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "Evet", style: .destructive) { _ in
            self.deletePerson()
        }

        let noAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)

        alert.addAction(yesAction)
        alert.addAction(noAction)

        present(alert, animated: true, completion: nil)
    }

    // Kişiyi silme fonksiyonu
    func deletePerson() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(person)
            }
            self.navigationController?.popViewController(animated: true)
        } catch {
            let alert = UIAlertController(title: "Hata", message: "Kişi silinirken bir hata oluştu.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

