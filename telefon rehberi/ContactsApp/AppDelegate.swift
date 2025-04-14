import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Migration işlemi burada başlatılır
        let config = Realm.Configuration(
            // Veritabanı şema sürümünü ayarlayın
            schemaVersion: 2, // Şema versiyonunu artırdık
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // Person modeline 'profileImage' alanı eklendiği için varsayılan olarak nil atıyoruz
                    migration.enumerateObjects(ofType: Person.className()) { _, newObject in
                        // 'profileImage' alanına varsayılan olarak nil değerini veriyoruz
                        newObject?["profileImage"] = nil
                    }
                }
            }
        )
        
        // Yeni config ile Realm'i kullanmaya başla
        Realm.Configuration.defaultConfiguration = config
        
        do {
            // Realm'i başlat
            let _ = try Realm()
        } catch {
            print("Error initializing Realm: \(error.localizedDescription)")
        }
        
        return true
    }
}
