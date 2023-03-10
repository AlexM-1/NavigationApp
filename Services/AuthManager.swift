//
//  AuthManager.swift
//  NavigationApp
//
//  Created by Alex M on 09.02.2023.
//

import FirebaseAuth

class AuthManager {
    
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    private var verificationId: String?
    
    public func startAuth(phoneNumber: String, completion: @escaping (Bool, String?) -> Void) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                
                //                let dictionary = error?._userInfo as? NSDictionary
                //                var strError = dictionary?.value(forKey: AuthErrorUserInfoNameKey) as! String
                //                strError += "\n \(error?.localizedDescription ?? "")"
                
                completion(false, error?.localizedDescription)
                return
            }
            self.verificationId = verificationId
            completion(true, nil)
        }
    }
    
    public func verifyCode(smsCode: String, completion: @escaping (Bool, String?) -> Void) {
        
        guard let verificationId = verificationId else {
            completion(false, "Verify phone number failed.")
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
        
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
}
