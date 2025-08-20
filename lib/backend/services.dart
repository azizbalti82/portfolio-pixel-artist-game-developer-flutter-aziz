import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Send a message
  Future<bool> sendMessage({
    required String name,
    required String email,
    required String source,
    required String message,
  }) async {
    try {
      // Insert data
      final data = await _client.from('messages').insert({
        'name': name,
        'email': email,
        'source': source,
        'message': message,
        'created_at': DateTime.now().toIso8601String(),
      });

      // If it reaches here, insert succeeded
      print("Inserted message: $data");
      return true;
    } on PostgrestException catch (e) {
      // Handles Supabase/Postgrest errors
      print("Supabase error: ${e.message}");
      return false;
    } catch (e) {
      // Handles any other errors
      print("Unexpected error: $e");
      return false;
    }
  }

  /// Get all messages
  Future<List<Map<String, dynamic>>> getMessages() async {
    try {
      final data = await _client
          .from('messages')
          .select()
          .order('created_at', ascending: false);
      return (data as List).cast<Map<String, dynamic>>();
    } on PostgrestException catch (e) {
      print("Supabase error: ${e.message}");
      return [];
    } catch (e) {
      print("Unexpected error: $e");
      return [];
    }
  }
}
