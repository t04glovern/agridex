# Setup

```bash
npm install
```

## Export database from Firestore

This will help you create a backup of your collection and subcollection from Firestore to a JSON file name **firestore-export.json**

```bash
node export.js <your-collection-name> <sub-collection-name-(optional)>
```

## Import database to Firestore

This will import one collection to Firestore and it will overwrite your current collection if there is a collection with that name in your Firestore

```bash
node import.js sheep_data.json
```

*If you have any recommendation or question, please create an issue. Thanks,*
