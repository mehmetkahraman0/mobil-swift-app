import UIKit
import RealmSwift

class TableViewController: UITableViewController {

    var personsBySection = [String: [Person]]()
    var sectionTitles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        print("TableViewController yüklendi")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPersonsGroupedByFirstLetter()
    }

    func loadPersonsGroupedByFirstLetter() {
        let realm = try! Realm()
        let sortedPersons = realm.objects(Person.self).sorted(byKeyPath: "name", ascending: true)

        var grouped = [String: [Person]]()

        for person in sortedPersons {
            guard let firstChar = person.name.first else { continue }
            let key = String(firstChar).uppercased()
            grouped[key, default: []].append(person)
        }

        sectionTitles = grouped.keys.sorted()
        personsBySection = grouped
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sectionTitles[section]
        return personsBySection[key]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let key = sectionTitles[indexPath.section]
        if let person = personsBySection[key]?[indexPath.row] {
            cell.textLabel?.text = person.name
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let destinationVC = segue.destination as? DetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let key = sectionTitles[indexPath.section]
            if let person = personsBySection[key]?[indexPath.row] {
                destinationVC.person = person
            }
        }
    }

    // Kişi silindiğinde verileri yeniden yükle
    @objc func reloadData() {
        loadPersonsGroupedByFirstLetter()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("personDeleted"), object: nil)
    }
}
