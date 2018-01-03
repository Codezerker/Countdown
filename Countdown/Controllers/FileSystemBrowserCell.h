/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A cell that can draw an image/icon and a label color.
 */

@import Cocoa;
@class FileSystemNode;

NS_ASSUME_NONNULL_BEGIN

@interface FileSystemBrowserCell : NSTextFieldCell

@property (strong) NSImage *image;
@property (strong) NSColor *labelColor;

@property (nonatomic, weak, nullable) FileSystemNode *displayingNode;

@end

NS_ASSUME_NONNULL_END
