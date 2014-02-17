// LRBaseModel.h
//
// Copyright (c) 2014 Luis Recuenco
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "LRBaseModelSerializable.h"
#import "LRBaseModelMappings.h"

@interface LRBaseModel : NSObject <LRBaseModelMappings, LRBaseModelSerializable>

/**
 Creates a new object via KVC.
 
 @param dictionary NSDictionary with the correct mappings (@{ key : value }).
 Via KVC, the object must have a property whose name is exactly the same as
 'key'. Thus, 'value' will be attached to that property.
 
 @discussion Forcing the object to have the very same property names
 as the keys in the dictionary may not be the best idea. Some/most keys
 coming from XML/JSON via APIs are not very compliant with cocoa conventions.
 In order to be able to have an object whose property names are different
 from the keys in the dictionary, the 'mappings' property defined in
 LRBaseModelProtocol must be provided.
 
 Example:
 
 dictionary: @{ uglyKey : value }
 
 object: property 'awesomeKey'
 
 The object class (sublcass of LRBaseModel) must have:
 
 - (NSDictionary *)mappings
 {
 return @{ @"uglyKey" : @"awesomeKey" };
 }
 
 Thus, we'll have a property 'awesomeKey' whose value is 'value'.
 
 @return A new LRBaseModel object.
 */

+ (instancetype)baseModelWithDictionary:(NSDictionary *)dictionary;

@end
