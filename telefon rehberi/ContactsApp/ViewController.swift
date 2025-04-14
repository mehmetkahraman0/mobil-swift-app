import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var people: [Person] = [] // Kişiler listesi
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        people = [
            Person(name: "Ali", phone: "123456789", email: "ali@example.com", history: List<String>()),
            Person(name: "Veli", phone: "987654321", email: "veli@example.com", history: List<String>())
        ]
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = person.name
        return cell
    }
    
    // Kişi seçildiğinde DetailViewController'a geçiş
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPerson = people[indexPath.row]
        performSegue(withIdentifier: "goToDetails", sender: selectedPerson)
    }
    
    // Segue işlemi: Veriyi DetailViewController'a gönder
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            if let detailVC = segue.destination as? DetailViewController {
                if let person = sender as? Person {
                    detailVC.person = person
                }
            }
        }
    }
}
