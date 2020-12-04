//
//  NetworkService.swift
//  DA5-APP
//
//  Created by Jojo on 11/26/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
 

typealias Parameter = [String: String]

struct StatusList : Codable {
    let status: Int
    let title: String
    let message: String
    let tag : Int?
}
struct StatusMessage : Codable {
    let message: String
}
class NetworkService<T:Codable> : NSObject { // URLSessionTaskDelegate{
    var hasInternet : Bool = false

    override init() {
      self.hasInternet = true
    }
    
    func networkRequest(_ param : [String: Any],jsonUrlString: String,completionHandler: @escaping (T?,StatusList?) -> () ) {
       
        if let url = URL(string: jsonUrlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Active")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: param, options: []) else { return }
            request.httpBody = httpBody
            print("REQUEST : \(request) \n PARAMETERES : \(param)")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                print("RESPONSE : \(data) === \(response) == \(error)")
                if error == nil {
                    if let receivedData = data {
                        do {
                            let data = try JSONDecoder().decode(T.self, from: receivedData)
//                            print("DATA GET ON REQUEST :" ,data)
                                completionHandler(data,nil)
                        } catch let jsonErr {
                            print("Error serializing json:", jsonErr)
                            completionHandler(nil,StatusList(status: 0, title: "", message: "Something went wrong", tag: nil))
                        }
                        return
                    }
                }
                completionHandler(nil,StatusList(status: 0, title: "", message: "Something went wrong. Please try again.", tag: nil))
            }.resume()
        }
    }
        
    func uploadFile(_ image: [Media], _ param : Parameter?,jsonUrlString: String, session: URLSession ,completionHandler: @escaping (T?,StatusList?) -> ()) {
        
//        let parameters = ["name": "TestFile123",
//                          "description": "Sample Test Image Upload"]
//        guard let mediaImage = Media(withImage: UIImage(named: "user")!, forKey: "file") else {
//            return
//        }
//         let jsonUrlString = "\(ApiConfig().getUrl())/upload/image"
//        "https://api.imgur.com/3/image"
        
        guard let url = URL(string: jsonUrlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let dataBody = createDataBody(withParameters: param, media: image, boundary: boundary)
        request.httpBody = dataBody
        
        print("REQUEST : \(request) \n PARAMETERES : \(param)")
//        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
//        let session =  URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
//MARK: - FOR TESTING
//                if let response = response {
//                   print(response)
//               }
//
//               if let data = data {
//                   do {
//                       let json = try JSONSerialization.jsonObject(with: data, options: [])
//                       print(json)
//                   } catch {
//                       print(error)
//                   }
//               }
//MARK: - END
              if error == nil {
                if let receivedData = data {
                    do {
                        let data = try JSONDecoder().decode(T.self, from: receivedData)
                        completionHandler(data,nil)
                    } catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                        completionHandler(nil,StatusList(status: 0, title: "", message: "Something went wrong", tag: nil))
                    }
                    return
                }
             }
             completionHandler(nil,StatusList(status: 0, title: "", message: "Something went wrong. Please try again.", tag: nil))
                
        }.resume()
    }
    //MARK: -LOADING PROGRESS OF UPLOAD
//    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
//    {
//        var uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
//        print("Progress : \(uploadProgress)")
//        self.uploadProgress(uploadProgress)
//    }

    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
        
    func createDataBody(withParameters params: Parameter?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}
        
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


// MARK: - SAMPLE
//    func uploadFile(tmpImage: UIImage?) {
//
////         the image in UIImage type
//        guard let image = tmpImage else { return  }
//
//        let filename = "avatar.png"
//
//        // generate boundary string using a unique per-app string
//        let boundary = UUID().uuidString
//
//        let fieldName = "reqtype"
//        let fieldValue = "fileupload"
//
//        let fieldName2 = "userhash"
//        let fieldValue2 = "caa3dce4fcb36cfdf9258ad9c"
//
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//
//        // Set the URLRequest to POST and to the specified URL
//        var urlRequest = URLRequest(url: URL(string: "https://catbox.moe/user/api.php")!)
//        urlRequest.httpMethod = "POST"
//
//        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
//        // And the boundary is also set here
//        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        var data = Data()
//
//        // Add the reqtype field and its value to the raw http request data
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
//        data.append("\(fieldValue)".data(using: .utf8)!)
//
//        // Add the userhash field and its value to the raw http reqyest data
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"\(fieldName2)\"\r\n\r\n".data(using: .utf8)!)
//        data.append("\(fieldValue2)".data(using: .utf8)!)
//
//        // Add the image data to the raw http request data
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//        data.append(image.pngData()!)
//
//        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
//        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
//        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//
//        // Send a POST request to the URL, with the data we created earlier
//        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
//
//            if(error != nil){
//                print("\(error!.localizedDescription)")
//            }
//
//            guard let responseData = responseData else {
//                print("no response data")
//                return
//            }
//
//            if let responseString = String(data: responseData, encoding: .utf8) {
//                print("uploaded to: \(responseString)")
//            }
//        }).resume()
//
//    }
