//
//  main.m
//  CATETiledLayerCutter
//
//  Created by app-01 on 2017/2/8.
//  Copyright © 2017年 EBOOK. All rights reserved.
//
#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //handle incorrect arguments
        NSLog(@"argc = %d %@", argc, [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding]);
        if (argc < 2) {
            NSLog(@"TileCutter arguments:inputfile");
            return 0;
        }
        //input file
        NSString *inputFile = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        //tile size
        CGFloat tileSize = 256;
        //output path
        NSString *outputPath = [inputFile stringByDeletingPathExtension];
        //load image
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:inputFile];
        NSSize size = [image size];
        NSArray *representations = [image representations];
        if ([representations count]) {
            NSBitmapImageRep *representation = representations[0];
            size.width = [representation pixelsWide];
            size.height = [representation pixelsHigh];
        }
        NSRect rect = NSMakeRect(0.0f, 0.0f, size.width, size.height);
        CGImageRef imageRef = [image CGImageForProposedRect:&rect
                                                    context:NULL
                                                      hints:nil];
        //calculate rows and columns
        NSInteger rows = ceil(size.height/tileSize);
        NSInteger columns = ceil(size.width/tileSize);
        //generate tiles
        for (int y=0;y < rows;++y) {
            for (int x=0; x<columns; ++x) {
                //extract tile image
                CGRect tileRect = CGRectMake(x*tileSize, y*tileSize, tileSize, tileSize);
                CGImageRef tileImage = CGImageCreateWithImageInRect(imageRef, tileRect);
                //convert to jpeg data
                NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithCGImage:tileImage];
                NSData *data = [imageRep representationUsingType:NSJPEGFileType properties:nil];
                CGImageRelease(tileImage);
                //save file
                NSString *path = [[outputPath stringByAppendingPathComponent:@"pics"]stringByAppendingFormat:@"_%02i_%02i.jpg",x,y];
                NSLog(@"path %@",path);
                [data writeToFile:path atomically:NO];
            }
        }
    }
    return 0;
}

