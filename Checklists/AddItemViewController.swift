import UIKit
import UserNotifications

protocol AddItemViewControllerDelegate: AnyObject {
  func addItemViewControllerDidCancel(
    _ controller: AddItemViewController)
  func addItemViewController(
    _ controller: AddItemViewController,
    didFinishAdding item: ChecklistItem
  )
    func addItemViewController(
      _ controller: AddItemViewController,
      didFinishEditing item: ChecklistItem
    )
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
    super.viewDidLoad()

        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            datePicker.date = item.dueDate
          }
  }
    // MARK: - Actions
    @IBAction func cancel() {
      delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
      if let item = itemToEdit {
        item.text = textField.text!
          item.shouldRemind = shouldRemindSwitch.isOn
          item.dueDate = datePicker.date
          item.scheduleNotification()
        delegate?.addItemViewController(
    self,
          didFinishEditing: item)
      } else {
        let item = ChecklistItem()
        item.text = textField.text!
          item.checked=false
          item.shouldRemind = shouldRemindSwitch.isOn
              item.dueDate = datePicker.date
        delegate?.addItemViewController(self, didFinishAdding: item)
    } }
    
    // MARK: - Table View Delegates
    override func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
    return nil
    }
    
    //Give textbox focus
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      textField.becomeFirstResponder()
    }
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: AddItemViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    //Check for changes in text field, make sure not empty
    // MARK: - Text Field Delegates
    func textField(
      _ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String
    ) -> Bool {
      let oldText = textField.text!
      let stringRange = Range(range, in: oldText)!
      let newText = oldText.replacingCharacters(
        in: stringRange,
        with: string)
      if newText.isEmpty {
        doneBarButton.isEnabled = false
      } else {
        doneBarButton.isEnabled = true
      }
    return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      doneBarButton.isEnabled = false
    return true
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
      textField.resignFirstResponder()
      if switchControl.isOn {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {_, _
    in
    } }
    }
}
