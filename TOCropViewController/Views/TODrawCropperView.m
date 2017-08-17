//
//  TODrawCropperView.m
//  Pods
//
//  Created by Jayaraj on 18/07/17.
//
//

#import "TODrawCropperView.h"

@interface TODrawCropperView()

@property (nonatomic, strong, readwrite) UIImage *image;

@property (nonatomic, strong) UIImageView *tempImageView;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIImage *croppedImage;

@end

@implementation TODrawCropperView

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        _image = image;
    }
    
    return self;
}

- (void)setup {
    __weak typeof(self) weakSelf = self;
    
    //Update this for path line color
    _strokeColor = [UIColor blueColor];
    
    //Update this for path line width
    _lineWidth = 2.0;
    
    _path = [[UIBezierPath  alloc] init];
    _shapeLayer = [[CAShapeLayer alloc] init];
    _croppedImage = [[UIImage alloc] init];
    
    _tempImageView = [[UIImageView alloc] initWithImage:_image];
    _tempImageView.frame = self.bounds;
    _tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    _tempImageView.clipsToBounds = YES;
    [self addSubview:_tempImageView];
    self.backgroundColor = [UIColor blackColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint touchPoint = [touch locationInView:_tempImageView];
    [_path moveToPoint:touchPoint];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint touchPoint = [touch locationInView:_tempImageView];
    [_path addLineToPoint:touchPoint];
    [self addNewPathToImage];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint touchPoint = [touch locationInView:_tempImageView];
    [_path addLineToPoint:touchPoint];
    [self addNewPathToImage];
    [_path closePath];
    [self.delegate cropViewDidBecomeResettable];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_path closePath];
}

- (void) addNewPathToImage {
    _shapeLayer.path = _path.CGPath;
    _shapeLayer.strokeColor = _strokeColor.CGColor;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineWidth = _lineWidth;
    [_tempImageView.layer addSublayer:_shapeLayer];
}

- (UIImage *)cropImage {
    return [self cropImageForImage:_tempImageView];
}

- (void)resetCroping {
    _shapeLayer.removeFromSuperlayer;
    _path = [[UIBezierPath  alloc] init];
    _shapeLayer = [[CAShapeLayer alloc] init];
    [self.delegate cropViewDidBecomeNonResettable];
}

- (UIImage *)cropImageForImage:(UIImageView *)ofImageView {
    
    
    CGPoint point = CGPointZero;
    
    
    CGRect rect = CGPathGetPathBoundingBox(_shapeLayer.path);
    CGPoint point1 = rect.origin;
    CGPoint point2 = CGPointMake(point1.x + rect.size.width, point1.y);
    CGPoint point3 = CGPointMake(point1.x + rect.size.width, point1.y + rect.size.height);
    CGPoint point4 = CGPointMake(point1.x, point1.y + rect.size.height);

    
    UIBezierPath *mpath = [[UIBezierPath  alloc] init];
    CAShapeLayer *mshapeLayer = [[CAShapeLayer alloc] init];
    mshapeLayer.fillColor = [UIColor clearColor].CGColor;
    mshapeLayer.lineWidth = 2.0;
    UIImage *mcroppedImage;
    
    for (int index = 0; index < 4; index++) {
        switch (index) {
            case 0:
                point = point1;
                break;
            case 1:
                point = point2;
                break;
            case 2:
                point = point3;
                break;
                
            default:
                point = point4;
                break;
        }
        if (index == 0) {
            [mpath moveToPoint:point];
        } else if (index == 4 - 1) {
            [mpath addLineToPoint:point];
            mpath.closePath;
            mshapeLayer.path = mpath.CGPath;
            
            [ofImageView.layer addSublayer:mshapeLayer];
//            mshapeLayer.fillColor = [UIColor blackColor].CGColor;
//            ofImageView.layer.mask = mshapeLayer;
            
            _shapeLayer.fillColor = [UIColor blackColor].CGColor;
            ofImageView.layer.mask = _shapeLayer;

            
            UIGraphicsBeginImageContextWithOptions(ofImageView.frame.size, false, 1);
            
            struct CGContext *currentContext = UIGraphicsGetCurrentContext();
            [ofImageView.layer renderInContext:currentContext];
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndPDFContext();
            mcroppedImage = newImage;
            
        } else {
            [mpath addLineToPoint:point];
        }
    }
    CGImageRef imageref = CGImageCreateWithImageInRect(mcroppedImage.CGImage, rect);
    return [UIImage imageWithCGImage:imageref];
    
    
//    if points.count >= 2{
//        let path = UIBezierPath()
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.lineWidth = 2
//        var croppedImage:UIImage?
//        
//        for (index,point) in points.enumerated(){
//            
//            //Origin
//            if index == 0{
//                path.move(to: point)
//                
//                //Endpoint
//            }else if index == points.count-1{
//                path.addLine(to: point)
//                path.close()
//                shapeLayer.path = path.cgPath
//                
//                ofImageView.layer.addSublayer(shapeLayer)
//                shapeLayer.fillColor = UIColor.black.cgColor
//                ofImageView.layer.mask = shapeLayer
//                UIGraphicsBeginImageContextWithOptions(ofImageView.frame.size, false, 1)
//                
//                if let currentContext = UIGraphicsGetCurrentContext(){
//                    ofImageView.layer.render(in: currentContext)
//                }
//                
//                
//                let newImage = UIGraphicsGetImageFromCurrentImageContext()
//                
//                UIGraphicsEndImageContext()
//                
//                croppedImage = newImage
//                
//                //Move points
//            }else{
//                path.addLine(to: point)
//            }
//        }
//        
//        return croppedImage
//    }else{
//        return nil
//    }
}


//@IBAction func IBActionCropImage(_ sender: UIButton) {
//    shapeLayer.fillColor = UIColor.black.cgColor
//    tempImageView.layer.mask = shapeLayer
//}

@end
