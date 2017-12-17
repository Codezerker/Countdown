//
//  FileSystemNode.swift
//  Countdown
//
//  Created by Yan Li on 17/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

class FileSystemNode {
    
    enum MutatingError: Error {
        case parentNotFound
    }
    
    let url: URL
    var children = Set<FileSystemNode>()
    
    var isDirectory: Bool {
        return url.isDirectory
    }
    
    var fileSize: Int {
        if isDirectory {
            return children.reduce(0) { $0 + $1.fileSize }
        } else {
            return url.fileSize ?? 0
        }
    }
            
    init(url: URL) {
        self.url = url
    }
    
    func addNodeToNearestParent(_ node: FileSystemNode) throws {
        guard let parentURL = node.url.parentDirectory else {
            throw MutatingError.parentNotFound
        }
        
        if parentURL == url {
            children.insert(node)
        } else {
            let rootPath = url.path
            let nodePath = node.url.path
            guard nodePath.hasPrefix(rootPath) else {
                throw MutatingError.parentNotFound
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
                throw MutatingError.parentNotFound
            }
            
            try validParent.addNodeToNearestParent(node)
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
