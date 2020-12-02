//
//  NetworkService.swift
//  DA5-APP
//
//  Created by Jojo on 11/26/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
 
struct StatusList : Codable {
    let status: Int
    let title: String
    let message: String
    let tag : Int?
}
class NetworkService<T:Codable> : NSObject {
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
            
//            URLSession.shared.uploadTask(with: URLRequest(, from: <#T##Data?#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
            
        }
    }
    
//    func uploadFile(_ data : Dictionary<String, Any>, _ image: [[String: Any]],param: String, onProgress: @escaping (Double) -> ()) -> Observable<Response<T>> {
//        if self.hasInternet {
//            return Observable.create { observer in
//                Alamofire.upload(multipartFormData: { (multipartFormData) in
//
//                    for (key, value) in data {
//                        log.info("UPLOADING IMAGES : \(key) : \(value)")
//                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//                    }
//
//                    for x in image {
//                        log.info("DOCUMENT UPLOADING IMAGES DATA : \(x)")
//                        //                        if let dataImage = x["image"] as? Data, let newUrl = x["url"] as? String {
//                        if let dataImage = x["image"] as? UIImage, let newUrl = x["url"] as? String {
//                            let newImage = dataImage
//                            let data = newImage.jpegData(compressionQuality: 0.7)//UIImageJPEGRepresentation(newImage, 0.7)
//                            if let newData = data {
//                                log.info("Debug ---- > image \(newData) \(newImage)")
//                                multipartFormData.append(newData, withName: param, fileName: newUrl, mimeType: "image/png")
//                            }
//                        }
//                        else if let newUrl = x["url"] as? String {
//                            multipartFormData.append(URL(string: newUrl)!, withName: param, fileName: (URL(string: newUrl)?.lastPathComponent)!, mimeType: String(describing: (URL(string: newUrl)?.lastPathComponent)!).checkFileType())
//                        }
//                    }
//
//                }, usingThreshold: UInt64.init(), to: Endpoints.APIEndpoint.api.url, method: .post, headers: nil) { (result) in
//                    switch result {
//                    case .success(let upload, _, _):
//
//                        upload.uploadProgress(closure: { (Progress) in
//                            log.info(Progress.fractionCompleted)
//                            onProgress(Progress.fractionCompleted)
//                        })
//
//                        upload.responseObject(completionHandler: { (response: DataResponse<Response<T>>) in
//                            switch response.result {
//                            case .success(let status):
//                                log.info("DOCUMENT UPLOADING STATUS : \(status.data)")
//                                log.info("DOCUMENT UPLOADING STATUS : dataArray  \(status.dataArray) ")
//                                observer.onNext(status)
//                                observer.onCompleted()
//                            case .failure(let error):
//                                observer.onError(error)
//                            }
//                        })
//                    case .failure(let error):
//                        observer.onError(error)
//                    }
//                }
//                return Disposables.create()
//            }
//        } else {
//            return Observable.error(NSError(domain:"", code:0, userInfo:[NSLocalizedDescriptionKey: "Parsing Error"]))
//        }
//    }
    
    
    func uploadFile(tmpImage: UIImage?) {
        
//         the image in UIImage type
        guard let image = tmpImage else { return  }

        let filename = "avatar.png"

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let fieldName = "reqtype"
        let fieldValue = "fileupload"

        let fieldName2 = "userhash"
        let fieldValue2 = "caa3dce4fcb36cfdf9258ad9c"

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: URL(string: "https://catbox.moe/user/api.php")!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the reqtype field and its value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue)".data(using: .utf8)!)

        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName2)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue2)".data(using: .utf8)!)

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)

        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("uploaded to: \(responseString)")
            }
        }).resume()
        
    }
    
}
