import RealmSwift

class Person: Object {
    @Persisted var name: String
    @Persisted var phone: String
    @Persisted var email: String
    @Persisted var history: List<String> // List<String> bir Realm türüdür
    @Persisted dynamic var profileImage: Data?
    
    // Boş constructor ekleyebiliriz
    convenience init(name: String, phone: String, email: String, history: List<String>) {
        self.init()  // Realm Object'ları başlatmak için init() gereklidir
        self.name = name
        self.phone = phone
        self.email = email
        self.history = history
        
    }
}
