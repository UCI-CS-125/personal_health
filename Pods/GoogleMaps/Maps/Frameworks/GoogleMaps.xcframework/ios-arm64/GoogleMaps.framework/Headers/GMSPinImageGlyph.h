//
//  GMSPinImageGlyph.h
//  Google Maps SDK for iOS
//
//  Copyright 2023 Google LLC
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://cloud.google.com/maps-platform/terms
//
/**
 *   This product or feature is in pre-GA. Pre-GA products and features might have limited support,
 *   and changes to pre-GA products and features might not be compatible with other pre-GA versions.
 *   Pre-GA Offerings are covered by the Google Maps Platform Service Specific Terms
 *   (https://cloud.google.com/maps-platform/terms/maps-service-terms).
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface GMSPinImageGlyph : NSObject

- (instancetype)init NS_UNAVAILABLE;

@property(nonatomic, nullable, readonly) NSString *text;
@property(nonatomic, nullable, readonly) UIColor *textColor;
@property(nonatomic, nullable, readonly) UIImage *image;
@property(nonatomic, nullable, readonly) UIColor *glyphColor;

/**
 * Returns a glyph model with the given text.
 *
 * @param text A @c NSString object to use as the glyph.
 * @param textColor A @c UIColor object to use to render the text.
 * @return An initialized glyph model.
 */
- (GMSPinImageGlyph *)initWithText:(NSString *)text textColor:(UIColor *)textColor;

/**
 * Returns a glyph model with the given text.
 *
 * @param image A @c UIImage object to use as the glyph.
 * @return An initialized glyph model.
 */
- (GMSPinImageGlyph *)initWithImage:(UIImage *)image;

/**
 * Returns a glyph model with the given glyph color.
 *
 * @param glyphColor A @c UIColor object to use to render the glyph.
 * @return An initialized glyph model.
 */
- (GMSPinImageGlyph *)initWithGlyphColor:(UIColor *)glyphColor;

@end
NS_ASSUME_NONNULL_END
