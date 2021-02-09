//
//  NetworkService.swift
//  DA5-APP
//
//  Created by Jojo on 11/26/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
 

typealias Parameter = [String: String]

struct StatusList : Decodable {
    let status: Int
    let title: String
    let message: String
    let tag : Int?
}

struct StatusListData : Decodable {
    let message: String
}

struct ReturReferenceData : Decodable {
    let referenceNo : String
    enum CodingKeys: String, CodingKey {
        case referenceNo = "reference_no"
    }
}
struct StatusListDataError : Decodable {
    let status: String
}

struct StatusMessage : Decodable {
    let message: String
}

enum RequestType {
    case get
    case post
}
class NetworkService<T:Decodable> : NSObject { // URLSessionTaskDelegate{
    var hasInternet : Bool = false

    override init() {
      self.hasInternet = true
    }
    
    func networkRequest(_ param : [String: Any],token: String? = nil,type: RequestType = .post, jsonUrlString: String,completionHandler: @escaping (T?,StatusList?) -> () ) {
       
//        print("URL : \(jsonUrlString)")
        if let url = URL(string: jsonUrlString) {
            var request = URLRequest(url: url)
            request.httpMethod = type == .post ? "POST" : "GET"
            
            if type == .post {
                if let bearer = token {
//                    print("TOKEN :",bearer)
                //                let authorizationKey = "bearer ".appending(bearer)
                    request.addValue(" Bearer \(bearer)", forHTTPHeaderField: "Authorization")
                //                request.addValue( authorizationKey, forHTTPHeaderField: "Authorization")
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Active")

                guard let httpBody = try? JSONSerialization.data(withJSONObject: param, options: []) else { return }
                request.httpBody = httpBody
            }else {
                
            }

//           print("REQUEST : \(request) \n PARAMETERS : \(param)")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
            //MARK: - FOR TESTING
//                print("\n===============================================================\n")
//                self.testJsonResponse(response: response, data: data, error: error)
//                print("\n===============================================================\n")
            //MARK: - END
                if error == nil {
                    let dataRes = response as? HTTPURLResponse
                    if let receivedData = data {
                        do {
                        //MARK: - CHECK STATUS IF NO ERROR
                            if let res = dataRes {
//                                print("DECODING :",T.self, "RESPONSE ",res.statusCode)
                                if res.statusCode != 200 {
                                    let data = try JSONDecoder().decode(StatusMessage.self, from: receivedData)
                                    completionHandler(nil,StatusList(status: 0, title: "", message: data.message, tag: 0))
                                    return
                                }
                            }
                        //MARK: - RETURN IF NO ERROR
                            let data = try JSONDecoder().decode(T.self, from: receivedData)
                            completionHandler(data,nil)
                        } catch let jsonErr {
//                            print("Error serializing json:", jsonErr)
                
                            completionHandler(nil,StatusList(status: 0, title: "", message: "Something went wrong", tag: dataRes?.statusCode == 200 ? 1 : 0))
                        }
                        return
                    }
                }
                completionHandler(nil,StatusList(status: 0, title: "", message: "Something went wrong. Please try again.", tag: nil))
            }.resume()
        }
    }
        
    func uploadFile(_ image: [Media], _ param : Parameter?,jsonUrlString: String, session: URLSession ,completionHandler: @escaping (T?,StatusList?) -> ()) {
        
        guard let url = URL(string: jsonUrlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let dataBody = createDataBody(withParameters: param, media: image, boundary: boundary)
        request.httpBody = dataBody
        
//        print("REQUEST : \(request) \n PARAMETERS : \(param)")

        session.dataTask(with: request) { (data, response, error) in

//MARK: - FOR TESTING
//            self.testJsonResponse(response: response, data: data, error: error)
//MARK: - END
              if error == nil {
                if let receivedData = data {
                    do {
                        let data = try JSONDecoder().decode(T.self, from: receivedData)
                        completionHandler(data,nil)
                    } catch let jsonErr {
//                        print("Error serializing json:", jsonErr)
                        completionHandler(nil,StatusList(status: 0, title: "", message: "Something went wrong", tag: nil))
                    }
                    return
                }
             }
             completionHandler(nil,StatusList(status: 0, title: "", message: "Something went wrong. Please try again.", tag: nil))

        }.resume()
    }
    
    func testJsonResponse(response: URLResponse?, data: Data?, error: Error?) {
//          if let response = response {
//               print(response)
//           }

           if let data = data {
               do {
                   let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("JSON ",json)
               } catch {
                   print("ERROR ",error)
               }
           }
    }

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
