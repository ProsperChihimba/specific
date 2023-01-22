import UIKit
import Flutter
import ContactsUI
import Foundation


class ContactPickerDelegate: NSObject, CNContactPickerDelegate {
    public var onSelectContact: (CNContact) -> Void
    public var onCancel: () -> Void

    init(onSelectContact: @escaping (CNContact) -> Void,
         onCancel: @escaping () -> Void) {
        self.onSelectContact = onSelectContact
        self.onCancel = onCancel
        super.init()
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        
        onSelectContact(contact)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        onCancel()
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let batteryChannel = FlutterMethodChannel(name: "com.prosper.specific", binaryMessenger: controller.binaryMessenger)
      
      batteryChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

            guard call.method == "getAContact" else {
              result(FlutterMethodNotImplemented)
              return
            }
            self.getAContact(withResult: result)
        })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    var contactPickerDelegate: ContactPickerDelegate?
    private func getAContact(withResult result: @escaping FlutterResult) {
        let contactPicker = CNContactPickerViewController()
        contactPickerDelegate = ContactPickerDelegate(onSelectContact: { contact in
            result(contact.phoneNumbers[0].value.stringValue)
            self.contactPickerDelegate = nil
        },
        onCancel: {
            result(nil)
            self.contactPickerDelegate = nil
        })
        contactPicker.delegate = contactPickerDelegate
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let rootViewController = keyWindow?.rootViewController
        DispatchQueue.main.async {
            rootViewController?.present(contactPicker, animated: true)
        }
    }
}
