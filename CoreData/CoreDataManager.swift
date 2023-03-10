//
//  CoreDataManager.swift
//  NavigationApp
//
//  Created by Alex M on 13.02.2023.
//


import CoreData

class CoreDataManager {

    static let `default` = CoreDataManager()


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NavigationApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()


    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


    func addPost(post: FeedPostItemInfoProtocol) {

        persistentContainer.performBackgroundTask { context in

            guard self.isUniquePost(by: post.id, context: context) else {return}

            let newPost = Post(context: context)
            newPost.date = post.date
            newPost.id = post.id
            newPost.isAddToBookmarks = post.isAddToBookmarks
            newPost.isLiked = post.isLiked
            newPost.numberOfComments = Int16(post.numberOfComments)
            newPost.numberOfLikes = Int16(post.numberOfLikes)
            newPost.postImage = post.postImage.imageUrl
            newPost.postText = post.postText
            newPost.profession = post.profession
            newPost.userImage = post.userImage
            newPost.username = post.username
            newPost.created_at = Date()

            do {
                try context.save()
            } catch {
                print(error)
            }
        }

    }

    func deletePost(post: Post) {
        persistentContainer.viewContext.delete(post)
        saveContext()
    }

    func deleteAllPosts() {
        let request = Post.fetchRequest()
        let posts = try? persistentContainer.viewContext.fetch(request)
        posts?.forEach { persistentContainer.viewContext.delete($0)
            saveContext()
        }
    }


    private func isUniquePost(by id: String, context: NSManagedObjectContext) -> Bool {
        let request = Post.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let _ = (try? context.fetch(request))?.first {
            return false
        } else {
            return true
        }
    }

}

