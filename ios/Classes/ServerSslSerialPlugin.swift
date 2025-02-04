import Flutter
import UIKit
import Security

public class ServerSslSerialPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "server_ssl_serial", binaryMessenger: registrar.messenger())
        let instance = ServerSslSerialPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getServerSerialNumber",
           let args = call.arguments as? [String: Any],
           let serverUrl = args["url"] as? String {
            ServerCertificateHelper.getServerSerialNumber(serverUrl: serverUrl) { serialNumber in
                result(serialNumber)
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}

class ServerCertificateHelper {
    static func getServerSerialNumber(serverUrl: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: serverUrl) else {
            completion(nil)
            return
        }
        
        let session = URLSession(configuration: .ephemeral, delegate: URLSessionDelegateHandler(completion: completion), delegateQueue: nil)
        let task = session.dataTask(with: url)
        task.resume()
    }
}

class URLSessionDelegateHandler: NSObject, URLSessionDelegate {
    private let completion: (String?) -> Void

    init(completion: @escaping (String?) -> Void) {
        self.completion = completion
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
            if let certificate = certificate {
                let serialNumber = extractSerialNumber(from: certificate)
                completion(serialNumber)
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
        completionHandler(.performDefaultHandling, nil)
    }

   private func extractSerialNumber(from certificate: SecCertificate) -> String? {
    var error: Unmanaged<CFError>?
    if let certificateData = SecCertificateCopyData(certificate) as Data? {
        let certificateRef = SecCertificateCreateWithData(nil, certificateData as CFData)
        var trust: SecTrust?
        
        if let certRef = certificateRef,
           SecTrustCreateWithCertificates(certRef, SecPolicyCreateBasicX509(), &trust) == errSecSuccess,
           let trust = trust {
            
            let cert = SecTrustGetCertificateAtIndex(trust, 0)
            
            if let cert = cert {
                let serialNumberData = SecCertificateCopySerialNumberData(cert, &error)
                
                if let serialData = serialNumberData as Data? {
                    return serialData.map { String(format: "%02x", $0) }.joined().uppercased()
                }
            }
        }
    }
    return nil
}
}
