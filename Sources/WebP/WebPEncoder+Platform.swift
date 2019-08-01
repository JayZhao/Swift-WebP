//
//  WebPEncoder+Platform.swift
//  WebP
//
//  Created by Namai Satoshi on 2016/10/23.
//  Copyright © 2016年 satoshi.namai. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
    import CoreGraphics

    extension WebPEncoder {
        public func encode(_ image: NSImage, config: WebPEncoderConfig, width: Int = 0, height: Int = 0) throws -> Data {
            let data = image.tiffRepresentation!
            let stride = Int(image.size.width) * MemoryLayout<UInt8>.size * 3 // RGB = 3byte
            let bitmap = NSBitmapImageRep(data: data)!
            let webPData = try encode(RGB: bitmap.bitmapData!, config: config,
                                      originWidth: Int(image.size.width), originHeight: Int(image.size.height), stride: stride,
                                      resizeWidth: width, resizeHeight: height)
            return webPData
        }
    }
#endif

#if os(iOS)
    import UIKit
    import CoreGraphics

    extension WebPEncoder {
        public func encode(_ image: UIImage, config: WebPEncoderConfig, width: Int = 0, height: Int = 0) throws -> Data {
            let cgImage = convertUIImageToCGImageWithRGBA(image)
            let stride = cgImage.bytesPerRow
            let dataPtr = CFDataGetMutableBytePtr((cgImage.dataProvider!.data as! CFMutableData))!
            let webPData = try encode(RGBA: dataPtr, config: config,
                                      originWidth: Int(image.size.width), originHeight: Int(image.size.height), stride: stride,
                                      resizeWidth: width, resizeHeight: height)
            return webPData
        }
        
        private func convertUIImageToCGImageWithRGBA(_ image: UIImage) -> CGImage {
            
            let renderer = UIGraphicsImageRenderer(size: image.size)
            
            return renderer.image { (context) in
                image.draw(in: CGRect(origin: .zero, size: size))
            }.cgImage!
        }
    }

#endif
