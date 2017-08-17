//
//  TODrawCropperView.h
//  Pods
//
//  Created by Jayaraj on 18/07/17.
//
//

#import <UIKit/UIKit.h>

@protocol TODrawCropperViewDelegate <NSObject>
- (void)cropViewDidBecomeResettable;
- (void)cropViewDidBecomeNonResettable;
@end

@interface TODrawCropperView : UIView {
    
}
@property (nullable, nonatomic, weak) id<TODrawCropperViewDelegate> delegate;

- (nonnull instancetype)initWithImage:(nonnull UIImage *)image;
- (void)setup;
- (UIImage *)cropImage;
- (void)resetCroping;

@end
