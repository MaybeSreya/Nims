import nimongo

var dbClient: MongoClient

proc initDB() =
  dbClient = newMongoClient()
  dbClient.connect(MONGO_URI)

proc getCollection(collectionName: string): MongoCollection =
  result = dbClient.getCollection(DB_NAME, collectionName)

initDB()
