import 'package:drift/drift.dart';

QueryExecutor openDatabaseConnection() {
  throw UnsupportedError('No database connection for this platform.');
}

QueryExecutor openInMemoryDatabaseConnection() {
  throw UnsupportedError('No in-memory database connection for this platform.');
}
