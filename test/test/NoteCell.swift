import UIKit
import CoreData

class NoteCell: UITableViewCell {
    
    
    @IBOutlet weak var txtDetails: UITextView!
    @IBOutlet weak var txtTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func SetCell(note:MyNotes )  {
        txtTitle.text=note.title
        txtDetails.text=note.details
        print(txtTitle.text!)
        print(txtDetails.text!)
        // Convert Date to String ( read date_save filed and convert it to string)
        // let dateformatter = DateFormatter()
        //dateformatter.dateFormat = "MM/dd/yy h:mm a"
        //dateformatter.string(from: note.date_save as! Date)
    }
    
}

