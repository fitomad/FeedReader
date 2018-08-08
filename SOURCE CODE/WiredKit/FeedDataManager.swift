//
//  FeedDataManager.swift
//  WiredKit
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import CoreData
import Foundation

import FeedKit


//
// Soporte en local del Feed
//
public class FeedDataManager
{
    /// Singleton
    public static let shared = FeedDataManager()
    /// Nombre del modelo Core Data
    private let modelName: String
    
    //
    // MARK: - Core Data stack
    //
    
    /// donde guardamos el modelo
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first!
        
    }()
    
    /// Por si hubiera que hacer migraciones...
    lazy var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel.mergedModel(from: nil)!
    }()
    
    /// La madre del cordero Core Data...
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.modelName)
        var failureReason = "No se pueden recuperar los datos guardados"
        
        do
        {
            // Para la migración de modelo
            let options: [String: Any] = [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true
            ]
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: url,
                                               options: options)
        }
        catch
        {
            print("Esto no tira :-(")
            
            abort()
        }
        
        return coordinator
    }()
    
    /// El que hace todo
    internal lazy var managedContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()
    
    //
    // MARK: - Inicializamos
    //
    
    /**
 
    */
    private init()
    {
        self.modelName = "FeedData.model"
    }
    
    //
    // MARK: - Core Data Saving support
    //
    
    /**
     
     */
    internal func saveContext ()
    {
        if self.managedContext.hasChanges
        {
            do
            {
                // Guardamos en Core Data...
                try self.managedContext.save()
            }
            catch
            {
                print("err @ CORE DATA CONTEXT saveContext()")
            }
            
        }
    }
}
