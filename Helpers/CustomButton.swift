
import UIKit

class CustomButton: UIButton {
    
    private var buttonTappedAction: (() -> Void)?
    
    init(title: String = "",
         titleColor: UIColor? = StyleGuide.Colors.darkTitleColor,
         font: UIFont? = UIFont.systemFont(ofSize: 14),
         backgroundColor: UIColor? = StyleGuide.Colors.lightBackgroundColor,
         image: UIImage? = nil,
         imageTintColor: UIColor = StyleGuide.Colors.darkTitleColor,
         imagePadding: CGFloat = 0,
         imagePlacement: NSDirectionalRectEdge = .leading,
         buttonTappedAction: (() -> Void)?) {
        
        super.init(frame: .zero)
        
        self.buttonTappedAction = buttonTappedAction
        
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = backgroundColor
        configuration.image = image
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(paletteColors: [StyleGuide.Colors.orangeColor])
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.imagePadding = imagePadding
        
        configuration.imagePlacement = imagePlacement
        self.configuration = configuration
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let attributedText = NSAttributedString(string: title, attributes:[
            NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: titleColor ?? StyleGuide.Colors.darkTitleColor])
        self.setAttributedTitle(attributedText, for: .normal)
        
        self.setImage(image?.withTintColor(titleColor ?? StyleGuide.Colors.darkTitleColor), for: .normal)
        
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        configurationUpdateHandler = { button in
            switch button.state {
            case .normal:
                button.alpha = 1.0
            case .selected, .highlighted, .disabled:
                button.alpha = 0.6
            default:
                button.alpha = 0.6
            }
        }
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        buttonTappedAction?()
    }
    
    
}
