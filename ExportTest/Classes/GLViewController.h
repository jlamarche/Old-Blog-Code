//
//  GLViewController.h
//  ExportTest
//
//  Created by jeff on 6/24/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"

@class OpenGLTexture3D;
@interface GLViewController : UIViewController <GLViewDelegate>
{
    OpenGLTexture3D *texture;
}
@property (nonatomic, retain) OpenGLTexture3D *texture;
@end
