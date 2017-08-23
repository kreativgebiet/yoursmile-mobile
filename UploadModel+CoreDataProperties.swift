//
//  UploadModel+CoreDataProperties.swift
//  YSCTW
//
//  Created by Max Zimmermann on 16.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation
import CoreData


extension UploadModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UploadModel> {
        return NSFetchRequest<UploadModel>(entityName: "UploadModel");
    }

    @NSManaged public var descriptionText: String?
    @NSManaged public var isStripePayment: Bool
    @NSManaged public var isUploaded: Bool
    @NSManaged public var image: Data?
    @NSManaged public var stripeToken: String?
    @NSManaged public var backendId: String
    @NSManaged public var projectIds: [Int]
    @NSManaged public var projectAmounts: [Int]

}
