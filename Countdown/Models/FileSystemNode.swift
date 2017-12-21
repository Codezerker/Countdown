//
//  FileSystemNode.swift
//  Countdown
//
//  Created by Yan Li on 17/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

class FileSystemNode: NSObject {
    
    let url: URL
    let isDirectory: Bool
    var fileSize: Int
    weak var parent: FileSystemNode?
    var displayChildren = [FileSystemNode]()
    private var childrenMap = [String: FileSystemNode]()

    init(url: URL) {
        self.url = url
        isDirectory = url.isDirectory
        fileSize = url.fileSize ?? 0
    }
    
    func addNodeToNearestParent(_ node: FileSystemNode) {
        autoreleasepool {
            guard let parentURL = node.url.parentDirectory else {
                fatalError("parent node not found")
            }
            
            if parentURL == url {
                childrenMap[node.url.lastPathComponent] = node
                displayChildren.append(node)
                node.parent = self
            } else {
                let rootPath = url.path
                let nodePath = node.url.path
                guard nodePath.hasPrefix(rootPath) else {
                    fatalError("parent node not found")
                }

                let rootPathComponents = url.pathComponents
                let nodePathComponents = node.url.pathComponents
                let nodeFirstUniquePathComponent = nodePathComponents[rootPathComponents.count]
                guard let validParent = childrenMap[nodeFirstUniquePathComponent] else {
                    fatalError("parent node not found")
                }

                validParent.addNodeToNearestParent(node)
                validParent.fileSize += node.fileSize
            }
        }
    }
        
    override func isEqual(to object: Any?) -> Bool {
        guard let otherNode = object as? FileSystemNode else {
            return false
        }
        return url == otherNode.url
    }
}

import AppKit

extension FileSystemNode {
    
    var displayName: String {
        return url.localizedName ?? url.lastPathComponent
    }
    
    var displayIcon: NSImage {
        return NSWorkspace.shared.icon(forFile: url.path)
    }
    
    func sortDisplayChildrenToRoot(completion: @escaping () -> Void) {
        guard fileSize > 0 else {
            completion()
            return
        }
        Queue.sorting.async {
            var sortingNode: FileSystemNode? = self
            while sortingNode != nil {
                sortingNode?.displayChildren.sort { $0.fileSize > $1.fileSize }
                sortingNode = sortingNode?.parent
            }
            completion()
        }
    }
}
