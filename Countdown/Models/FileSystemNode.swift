//
//  FileSystemNode.swift
//  Countdown
//
//  Created by Yan Li on 17/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

class FileSystemNode {
    
    let url: URL
    let isDirectory: Bool
    var fileSize: Int
    var children = [FileSystemNode]()

    init(url: URL) {
        self.url = url
        isDirectory = url.isDirectory
        fileSize = url.fileSize ?? 0
    }
    
    func addNodeToNearestParent(_ node: FileSystemNode) {
        autoreleasepool {
            guard let parentURL = node.url.parentDirectory else {
                return
            }
            
            if parentURL == url {
                children.append(node)
            } else {
                let rootPath = url.path
                let nodePath = node.url.path
                guard nodePath.hasPrefix(rootPath) else {
                    return
                }
                
                let subpath = nodePath.replacingOccurrences(of: rootPath, with: "")
                let subURL = URL(fileURLWithPath: subpath)
                // assuming the first path component is always "/"
                let nodeFirstPathComponent = subURL.pathComponents[1]
                
                var parent: FileSystemNode?
                for child in children {
                    guard let childLastPathComponent = child.url.pathComponents.last,
                          childLastPathComponent == nodeFirstPathComponent else {
                        continue
                    }
                    parent = child
                    break
                }
                guard let validParent = parent else {
                    return
                }
                
                validParent.addNodeToNearestParent(node)
                validParent.fileSize += node.fileSize
            }
        }
    }
}

extension FileSystemNode: Hashable {
    
    var hashValue: Int {
        return url.hashValue
    }
    
    static func ==(lhs: FileSystemNode, rhs: FileSystemNode) -> Bool {
        return lhs.url == rhs.url
    }
}

extension FileSystemNode: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "\n\(url.path) \(fileSize)"
    }
}
