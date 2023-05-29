//
//  GMSAdvancedMarker.h
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

#import "GMSCollisionBehavior.h"
#import "GMSMarker.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMSAdvancedMarker : GMSMarker

/**
 * The marker's collision behavior, which determines whether or not the marker's visibility can be
 * affected by other markers or labeled content on the map.
 */
@property(nonatomic) GMSCollisionBehavior collisionBehavior;

@end

NS_ASSUME_NONNULL_END
