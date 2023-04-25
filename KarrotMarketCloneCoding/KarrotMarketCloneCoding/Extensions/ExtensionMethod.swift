//
//  ExtensionMethod.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/08/02.
//

import Foundation
import UIKit

func jsonDecode<T: Codable>(type: T.Type, data: Data) -> T? {
    
    let jsonDecoder = JSONDecoder()
    let result: Codable?
    
    jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.myDateFormatter)
    
    do {
        result = try jsonDecoder.decode(type, from: data)
        
        return result as? T
    } catch {
        return nil
    }
}

extension Encodable {
    func toJSONData() -> Data? {
        
        let jsonData = try? JSONEncoder().encode(self)
        
        return jsonData
    }
}

extension Data {
    func toDictionary() -> [String: Any] {
        
        guard let dictionaryData = try? JSONSerialization.jsonObject(with: self) as? [String: Any] else { return [:] }
        
        return dictionaryData
    }
}

extension Date {
    
    func formatToString() -> String {
        let dateFormatter = DateFormatter()
        let Today = Calendar.current.component(.day, from: Date())
        dateFormatter.timeStyle = .short
        if Calendar.current.component(.day, from: self) == Today {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "YYYY.MM.dd"
        }
        return dateFormatter.string(from: self)
    }
}

extension CGFloat {
    
    static func getSize(of device: DeviceSize) -> CGFloat {
        switch device {
        case .deviceHeight:
            return UIScreen.main.bounds.height
        case .deviceWidth:
            return UIScreen.main.bounds.width
        }
    }
}

extension String {
    func checkOnlyNumbers() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9]$", options: .caseInsensitive)
            
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) { return true }
        } catch {
            print(error.localizedDescription)
            
            return false
        }
        return false
    }
}

extension UIImage {
    func resize(to targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

extension UIViewController: ErrorPresentable {
    func presentError(error: KarrotError) {
        let alertController = UIAlertController(title: "경고", message: error.description, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension UIView {
    func setGradient(color1:UIColor, color2:UIColor) -> UIView {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = bounds
        self.layer.addSublayer(gradient)
        
        return self
    }
    
    func hideGradient(_ isHidden: Bool) {
        self.layer.sublayers?.first?.isHidden = isHidden
    }
}

